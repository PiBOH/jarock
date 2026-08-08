[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string]$ServerDirectory,
    [string]$InitialMemory = '4G',
    [string]$MaximumMemory = '4G',
    [ValidateSet('gui', 'nogui')] [string]$GuiMode = 'nogui',
    [ValidateSet('default', 'low-pause')] [string]$GcProfile = 'default',
    [switch]$ConfigureJavaEnvironment
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$Root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$JavaRuntimeScript = Join-Path $PSScriptRoot 'java-runtime.ps1'
. $JavaRuntimeScript
$CloseProtectionScript = Join-Path $PSScriptRoot 'console-close-protection.ps1'
$CloseProtectionEnabled = $false
$CloseProtectionLoaded = $false

function Show-ErrorGuidance([string]$Message, [string]$Action) {
    Write-Host "ERROR: $Message" -ForegroundColor Red
    Write-Host "Suggested fix: $Action" -ForegroundColor Yellow
    Write-Host 'No router, firewall, port-forwarding, or public-network changes were performed.' -ForegroundColor Yellow
}
function Assert-MemoryValue([string]$Name, [string]$Value) {
    if ($Value -notmatch '^(?<amount>[1-9][0-9]*)(?<unit>[mMgG])$') { throw "$Name has an invalid value '$Value'. Use a positive amount followed by M or G, for example 4G." }
    $Mb = [int64]$Matches['amount']
    if ($Matches['unit'].ToUpperInvariant() -eq 'G') { $Mb *= 1024 }
    if ($Mb -lt 1024) { throw "$Name is too small ('$Value'). Use at least 1G." }
    return $Mb
}
function Set-ServerOnlineMode([string]$Path, [string]$Value) {
    if ($Value -notin @('true','false')) { throw "ONLINE_MODE must be true or false, not '$Value'." }
    $Content = Get-Content -LiteralPath $Path -Raw
    if ($Content -match '(?m)^[ \t]*online-mode[ \t]*=') { $Content = [regex]::Replace($Content,'(?m)^[ \t]*online-mode[ \t]*=[^\r\n]*',"online-mode=$Value") }
    else { $Content = $Content.TrimEnd("`r","`n") + "`r`nonline-mode=$Value`r`n" }
    [IO.File]::WriteAllText($Path,$Content,(New-Object Text.UTF8Encoding($false)))
    if ($Value -eq 'false') { Write-Host 'WARNING: online-mode=false disables normal Mojang authentication.' -ForegroundColor Yellow }
}
function Read-Settings {
    $Values=@{}
    $Path=Join-Path $PSScriptRoot 'server-launch-settings.ini'
    if (Test-Path -LiteralPath $Path -PathType Leaf) { foreach($Line in Get-Content -LiteralPath $Path) { if($Line -match '^\s*([A-Z_]+)=(.*?)\s*$'){$Values[$Matches[1]]=$Matches[2]} } }
    return $Values
}
function Get-LanIPv4 {
    try {
        $Addresses = @([System.Net.Dns]::GetHostAddresses([System.Net.Dns]::GetHostName()) | Where-Object {
            $_.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork -and
            $_.ToString() -notmatch '^127\.' -and
            $_.ToString() -notmatch '^169\.254\.'
        })
        $Private = @($Addresses | Where-Object {
            $_.ToString() -match '^(10\.|192\.168\.|172\.(1[6-9]|2[0-9]|3[0-1])\.)'
        })
        if ($Private.Count -gt 0) { return $Private[0].ToString() }
    } catch { }
    return '127.0.0.1'
}
function Get-ConfiguredServerPort([string]$Path) {
    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        $Content = Get-Content -LiteralPath $Path -Raw
        if ($Content -match '(?m)^\s*server-port\s*=\s*(\d+)\s*(?:#.*)?$') { return $Matches[1] }
    }
    return '25565'
}
function Get-ConfiguredBedrockPort([string]$ServerDirectory, [string]$Loader) {
    $DefaultPort = '19132'
    $ConfigRoot = Join-Path $ServerDirectory 'config'
    if (-not (Test-Path -LiteralPath $ConfigRoot -PathType Container)) { return $DefaultPort }
    $Directories = @(Get-ChildItem -LiteralPath $ConfigRoot -Directory -ErrorAction SilentlyContinue | Where-Object {
        $_.Name -match ('(?i)^Geyser-' + [regex]::Escape($Loader) + '$')
    })
    if ($Directories.Count -eq 0) { return $DefaultPort }
    $ConfigPath = Join-Path $Directories[0].FullName 'config.yml'
    if (-not (Test-Path -LiteralPath $ConfigPath -PathType Leaf)) { return $DefaultPort }
    $InBedrock = $false
    foreach ($ConfigLine in Get-Content -LiteralPath $ConfigPath) {
        if ($ConfigLine -match '^\s*bedrock:\s*$') { $InBedrock = $true; continue }
        if ($InBedrock -and $ConfigLine -match '^\S') { $InBedrock = $false }
        if ($InBedrock -and $ConfigLine -match '^\s+port:\s*(\d+)\s*(?:#.*)?$') { return $Matches[1] }
    }
    return $DefaultPort
}
function Test-GeyserReadyLine([string]$Line) {
    return $Line -match '(?i)(geyser\s+help|geyser.*(?:started|avviato|fatto).*udp|geyser.*udp|udp.*geyser)'
}
function Get-ConfiguredLevelName([string]$PropertiesPath) {
    if (Test-Path -LiteralPath $PropertiesPath -PathType Leaf) {
        $Content = Get-Content -LiteralPath $PropertiesPath -Raw
        if ($Content -match '(?m)^\s*level-name\s*=\s*([^\r\n#]+?)\s*(?:#.*)?$') {
            $Name = $Matches[1].Trim()
            if (-not [string]::IsNullOrWhiteSpace($Name) -and $Name -notmatch '[\\/:*?"<>|]') { return $Name }
        }
    }
    return 'world'
}
function Get-WorldLikeDirectories([string]$ServerDirectory, [string[]]$KnownWorldNames) {
    $Ignored = @('config','crash-reports','libraries','logs','mods','versions')
    return @(Get-ChildItem -LiteralPath $ServerDirectory -Directory -ErrorAction SilentlyContinue | Where-Object {
        $KnownWorldNames -notcontains $_.Name -and
        $Ignored -notcontains $_.Name -and
        ((Test-Path -LiteralPath (Join-Path $_.FullName 'level.dat') -PathType Leaf) -or
         (Test-Path -LiteralPath (Join-Path $_.FullName 'region') -PathType Container))
    })
}
function Assert-WorldDirectoriesConsistent([string]$ServerDirectory, [string]$PropertiesPath) {
    # Java stores the Nether and End inside the configured overworld folder
    # (DIM-1 and DIM1). Do not require sibling folders such as world_nether.
    # If the configured level-name exists, leave it completely untouched and
    # let Minecraft load it or report its own integrity error.
    $LevelName = Get-ConfiguredLevelName $PropertiesPath
    $ConfiguredWorld = Join-Path $ServerDirectory $LevelName

    # Always inspect for old world data first, even when the configured world
    # exists. This prevents a level-name change from silently leaving an old
    # world beside the new one.
    $OrphanWorlds = @(Get-WorldLikeDirectories $ServerDirectory @($LevelName))
    if ($OrphanWorlds.Count -gt 0) {
        $Names = ($OrphanWorlds | ForEach-Object { $_.Name }) -join ', '
        throw "Possible previous world data was found under another name ($Names). Jarock will not silently mix or replace worlds. Restore the intended world or deliberately remove the old world data yourself, then start again."
    }

    # A missing configured world is a legitimate first-run/new-world case only
    # when no other likely world folder remains after a level-name change.
    if (Test-Path -LiteralPath $ConfiguredWorld -PathType Container) { return }
}
function Show-ReadyStatus([bool]$ShowBanner, [object[]]$ReadyBanner) {
    Write-Host ''
    if($ShowBanner -and $ReadyBanner.Count -gt 0){
        foreach($BannerLine in $ReadyBanner){Write-Host $BannerLine -ForegroundColor Green}
    }
    Write-Host 'The Jarock server has finished loading.' -ForegroundColor Green
    Write-Host "  Java Edition (LAN):    $($script:LanIPv4):$($script:JavaPort)" -ForegroundColor Cyan
    if($script:GeyserPresent){
        Write-Host "  Bedrock Edition (LAN): $($script:LanIPv4):$($script:BedrockPort) (UDP)" -ForegroundColor Cyan
    } else {
        Write-Host '  Bedrock Edition:       unavailable (Geyser is not installed)' -ForegroundColor Yellow
    }
    Write-Host '  Public access requires manual router/firewall or tunnel configuration.' -ForegroundColor DarkGray
    Write-Host ''
}
function Set-NeoForgeJvmArgs([string]$Path,[string]$Xms,[string]$Xmx,[string]$Gc) {
    $Lines=@()
    if(Test-Path -LiteralPath $Path -PathType Leaf){$Lines=@(Get-Content -LiteralPath $Path)}
    $Managed=@("-Xms$Xms","-Xmx$Xmx")
    if($Gc -eq 'low-pause'){$Managed+=@('-XX:+UseG1GC','-XX:MaxGCPauseMillis=200')}
    $Filtered=@($Lines | Where-Object {$_ -notmatch '^\s*-Xms' -and $_ -notmatch '^\s*-Xmx' -and $_ -notmatch '^\s*-XX:\+UseG1GC' -and $_ -notmatch '^\s*-XX:MaxGCPauseMillis='})
    $Output=@($Filtered + $Managed)
    [IO.File]::WriteAllLines($Path,$Output,(New-Object Text.UTF8Encoding($false)))
}
try {
    $ServerDirectory=[IO.Path]::GetFullPath($ServerDirectory)
    $Settings=Read-Settings
    if($Settings.ContainsKey('RAM_INITIAL')){$InitialMemory=[string]$Settings['RAM_INITIAL']}
    if($Settings.ContainsKey('RAM_MAX')){$MaximumMemory=[string]$Settings['RAM_MAX']}
    if($Settings.ContainsKey('GUI_MODE')){$GuiMode=[string]$Settings['GUI_MODE'].ToLowerInvariant()}
    if($Settings.ContainsKey('GC_PROFILE')){$GcProfile=[string]$Settings['GC_PROFILE'].ToLowerInvariant()}
    $Loader='fabric'; if($Settings.ContainsKey('LOADER_TYPE')){$Loader=[string]$Settings['LOADER_TYPE'].ToLowerInvariant()}
    $Online='true'; if($Settings.ContainsKey('ONLINE_MODE')){$Online=[string]$Settings['ONLINE_MODE'].ToLowerInvariant()}
    if($Loader -notin @('fabric','neoforge')){throw "The configured loader '$Loader' is not installed or supported. Choose Fabric or NeoForge in parameter-manager.bat."}
    if($GuiMode -notin @('gui','nogui')){throw "GUI_MODE must be gui or nogui, not '$GuiMode'."}
    if($GcProfile -notin @('default','low-pause')){throw "GC_PROFILE must be default or low-pause, not '$GcProfile'."}
    $InitialMb=Assert-MemoryValue 'RAM_INITIAL' $InitialMemory; $MaximumMb=Assert-MemoryValue 'RAM_MAX' $MaximumMemory
    if($InitialMb -gt $MaximumMb){throw 'RAM_INITIAL cannot be greater than RAM_MAX.'}
    $JavaPathFile=Join-Path $ServerDirectory 'java-path.txt'
    if(-not(Test-Path -LiteralPath $JavaPathFile -PathType Leaf)){throw "The selected Java path file was not found: $JavaPathFile"}
    $JavaPath=(Get-Content -LiteralPath $JavaPathFile -Raw).Trim(); $Runtime=Get-JavaRuntimeInfo $JavaPath
    if($null -eq $Runtime -or $Runtime.Major -lt 25 -or -not $Runtime.Is64Bit){throw 'The selected Java runtime is not a usable 64-bit Java 25+ runtime.'}
    if($Settings.ContainsKey('AUTO_CONFIGURE_JAVA') -and [string]$Settings['AUTO_CONFIGURE_JAVA'] -match '^(?i:true|yes|1)$'){
        & powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'configure-java-environment.ps1') -JavaExecutable $Runtime.Path
    }
    $Properties=Join-Path $ServerDirectory 'server.properties'; if(-not(Test-Path -LiteralPath $Properties -PathType Leaf)){throw "The Minecraft properties file was not found: $Properties"}
    Set-ServerOnlineMode $Properties $Online
    Assert-WorldDirectoriesConsistent $ServerDirectory $Properties
    Write-Host "Loader=$Loader; Java=$($Runtime.Version); memory=$InitialMemory/$MaximumMemory; mode=$GuiMode; GC=$GcProfile" -ForegroundColor Green
    $ShowBanner=$true
    if($Settings.ContainsKey('SHOW_READY_BANNER')){$ShowBanner=([string]$Settings['SHOW_READY_BANNER']) -notmatch '^(?i:false|no|0)$'}
    $ReadyBanner=@(); $ReadyBannerPath=Join-Path $PSScriptRoot 'server-ready-banner.txt'
    if($ShowBanner -and (Test-Path -LiteralPath $ReadyBannerPath -PathType Leaf)){$ReadyBanner=@(Get-Content -LiteralPath $ReadyBannerPath)}
    $script:BannerShown=$false
    # A previous save message is not enough to authorize closing. The safe-close
    # state must belong to this shutdown: Minecraft must announce shutdown/saving,
    # complete the world save, and then exit with code 0.
    $script:ShutdownStarted=$false
    $script:WorldSaveComplete=$false
    $script:GeyserPresent=$false
    $GeyserJar=Get-ChildItem -LiteralPath (Join-Path $ServerDirectory 'mods') -Filter 'Geyser-*.jar' -ErrorAction SilentlyContinue | Select-Object -First 1
    if($null -ne $GeyserJar){$script:GeyserPresent=$true}
    $script:LanIPv4 = Get-LanIPv4
    $script:JavaPort = Get-ConfiguredServerPort $Properties
    $script:BedrockPort = Get-ConfiguredBedrockPort $ServerDirectory $Loader
    if (Test-Path -LiteralPath $CloseProtectionScript -PathType Leaf) {
        try {
            . $CloseProtectionScript
            $CloseProtectionLoaded = $true
            $CloseProtectionEnabled = Enable-JarockConsoleCloseProtection
            if ($CloseProtectionEnabled) {
                Write-Host 'Console close protection is active while the server is running.' -ForegroundColor Cyan
                Write-Host 'Use stop (or close the Minecraft GUI normally) and wait for SAFE TO CLOSE before closing this window.' -ForegroundColor Yellow
            } else {
                Write-Host 'WARNING: Console close protection could not be enabled; use stop and wait for SAFE TO CLOSE.' -ForegroundColor Yellow
            }
        } catch {
            Write-Host "WARNING: Console close protection could not be initialized: $($_.Exception.Message)" -ForegroundColor Yellow
            Write-Host 'Use stop and wait for SAFE TO CLOSE before closing this window.' -ForegroundColor Yellow
        }
    }
    Push-Location -LiteralPath $ServerDirectory
    try {
        if($Loader -eq 'fabric') {
            $Launcher=Join-Path $ServerDirectory 'server.jar'
            if(-not(Test-Path -LiteralPath $Launcher -PathType Leaf)){throw 'The generated Fabric server.jar launcher was not found. Run start-server.bat again.'}
            $Args=@("-Xms$InitialMemory","-Xmx$MaximumMemory")
            if($GcProfile -eq 'low-pause'){$Args+=@('-XX:+UseG1GC','-XX:MaxGCPauseMillis=200')}
            $Args+=@('-jar',$Launcher);if($GuiMode -eq 'nogui'){$Args+='nogui'}
            $PreviousEap=$ErrorActionPreference; $ErrorActionPreference='Continue'
            try {
                & $Runtime.Path @Args 2>&1 | ForEach-Object {
                    if($_ -is [System.Management.Automation.ErrorRecord]){
                        $Line=[string]$_.Exception.Message
                        if([string]::IsNullOrWhiteSpace($Line)){return}
                    } else { $Line=[string]$_ }
                    Write-Host $Line
                    if($Line -match '(?i)(Stopping( Minecraft)? server|Server is stopping|Arr\u00eat du serveur|Fermata del server|Deteniendo el servidor|\u041e\u0441\u0442\u0430\u043d\u043e\u0432\u043a\u0430 \u0441\u0435\u0440\u0432\u0435\u0440\u0430|\u30b5\u30fc\u30d0\u30fc\u3092\u505c\u6b62)'){
                        # Only an explicit server-stop message starts the trusted
                        # shutdown sequence. Autosaves/manual saves never authorize
                        # SAFE TO CLOSE.
                        $script:ShutdownStarted=$true
                        $script:WorldSaveComplete=$false
                    }
                    if($script:ShutdownStarted -and $Line -match '(?i)All dimensions are saved'){$script:WorldSaveComplete=$true}
                    if(-not $script:BannerShown){
                        $ReadyLine=$false
                        if($script:GeyserPresent){$ReadyLine=Test-GeyserReadyLine $Line}
                        else{$ReadyLine=$Line -match 'Done \(\d+\.\d+s\)'}
                        if($ReadyLine){
                            $script:BannerShown=$true
                            Show-ReadyStatus $ShowBanner $script:ReadyBanner
                        }
                    }
                }
                $ExitCode=$LASTEXITCODE
            } finally { $ErrorActionPreference=$PreviousEap }
        } else {
            $RunBat=Join-Path $ServerDirectory 'run.bat'; if(-not(Test-Path -LiteralPath $RunBat -PathType Leaf)){throw 'The generated NeoForge run.bat was not found. Run start-server.bat again.'}
            Set-NeoForgeJvmArgs (Join-Path $ServerDirectory 'user_jvm_args.txt') $InitialMemory $MaximumMemory $GcProfile
            $Args=@();if($GuiMode -eq 'nogui'){$Args+='nogui'}
            $Command = 'call "run.bat"'
            if ($Args.Count -gt 0) { $Command += ' ' + ($Args -join ' ') }
            $PreviousEap=$ErrorActionPreference; $ErrorActionPreference='Continue'
            try {
                & cmd.exe /d /c $Command 2>&1 | ForEach-Object {
                    if($_ -is [System.Management.Automation.ErrorRecord]){
                        $Line=[string]$_.Exception.Message
                        if([string]::IsNullOrWhiteSpace($Line)){return}
                    } else { $Line=[string]$_ }
                    Write-Host $Line
                    if($Line -match '(?i)(Stopping( Minecraft)? server|Server is stopping|Arr\u00eat du serveur|Fermata del server|Deteniendo el servidor|\u041e\u0441\u0442\u0430\u043d\u043e\u0432\u043a\u0430 \u0441\u0435\u0440\u0432\u0435\u0440\u0430|\u30b5\u30fc\u30d0\u30fc\u3092\u505c\u6b62)'){
                        # Only an explicit server-stop message starts the trusted
                        # shutdown sequence. Autosaves/manual saves never authorize
                        # SAFE TO CLOSE.
                        $script:ShutdownStarted=$true
                        $script:WorldSaveComplete=$false
                    }
                    if($script:ShutdownStarted -and $Line -match '(?i)All dimensions are saved'){$script:WorldSaveComplete=$true}
                    if(-not $script:BannerShown){
                        $ReadyLine=$false
                        if($script:GeyserPresent){$ReadyLine=Test-GeyserReadyLine $Line}
                        else{$ReadyLine=$Line -match 'Done \(\d+\.\d+s\)'}
                        if($ReadyLine){
                            $script:BannerShown=$true
                            Show-ReadyStatus $ShowBanner $script:ReadyBanner
                        }
                    }
                }
                $ExitCode=$LASTEXITCODE
            } finally { $ErrorActionPreference=$PreviousEap }
        }
    } finally { Pop-Location }
    $FinalExitCode=$ExitCode
    if($ExitCode -eq 0 -and (-not $script:ShutdownStarted -or -not $script:WorldSaveComplete)){
        Write-Host 'WARNING: The server process exited normally, but Jarock did not observe this shutdown complete its world save.' -ForegroundColor Yellow
        Write-Host 'Do not assume it is safe to close or restart; inspect the server log and use a known-good backup if needed.' -ForegroundColor Yellow
        $FinalExitCode=10
    }
    exit $FinalExitCode
} catch { Show-ErrorGuidance $_.Exception.Message 'Open parameter-manager.bat, select a supported loader and valid settings, then run start-server.bat again.'; exit 1 }
finally {
    if ($CloseProtectionLoaded) {
        try { Disable-JarockConsoleCloseProtection } catch { }
    }
}
