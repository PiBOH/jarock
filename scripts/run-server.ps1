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
    $Path=Join-Path $Root 'server-launch-settings.ini'
    if (Test-Path -LiteralPath $Path -PathType Leaf) { foreach($Line in Get-Content -LiteralPath $Path) { if($Line -match '^\s*([A-Z_]+)=(.*?)\s*$'){$Values[$Matches[1]]=$Matches[2]} } }
    return $Values
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
function Repair-IncompleteWorld([string]$ServerDirectory) {
    # A completed world always has a reasonably large level.dat and the world
    # generation settings data file. An interrupted first generation leaves a
    # tiny level.dat and no world_gen_settings.dat, and Minecraft then refuses
    # to load the world with 'Overworld settings missing'.
    $WorldDir = Join-Path $ServerDirectory 'world'
    $LevelDat = Join-Path $WorldDir 'level.dat'
    if (-not (Test-Path -LiteralPath $LevelDat -PathType Leaf)) { return }
    $Length = (Get-Item -LiteralPath $LevelDat).Length
    $SettingsFile = Join-Path $WorldDir 'data\minecraft\world_gen_settings.dat'
    $HasSettings = Test-Path -LiteralPath $SettingsFile -PathType Leaf
    if ($HasSettings -and $Length -ge 1024) { return }
    $Stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $Backup = Join-Path $ServerDirectory "world-corrupt-$Stamp"
    New-Item -ItemType Directory -Path $Backup -Force | Out-Null
    foreach ($WorldName in @('world','world_nether','world_the_end')) {
        $Source = Join-Path $ServerDirectory $WorldName
        if (Test-Path -LiteralPath $Source) { Move-Item -LiteralPath $Source -Destination (Join-Path $Backup $WorldName) -Force }
    }
    Write-Host ''
    Write-Host 'WARNING: The world data is incomplete (level.dat is too small or world generation settings are missing).' -ForegroundColor Yellow
    Write-Host 'Jarock moved the incomplete world folder aside to keep it safe:' -ForegroundColor Yellow
    Write-Host "  $Backup" -ForegroundColor Cyan
    Write-Host 'A fresh world will be generated during this start. If the moved folder contains data you need, stop the server and restore it from a backup; never re-use a world that Minecraft refuses to load.' -ForegroundColor Yellow
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
    Repair-IncompleteWorld $ServerDirectory
    Write-Host "Loader=$Loader; Java=$($Runtime.Version); memory=$InitialMemory/$MaximumMemory; mode=$GuiMode; GC=$GcProfile" -ForegroundColor Green
    $ReadyBanner=@(); $ReadyBannerPath=Join-Path $PSScriptRoot 'server-ready-banner.txt'
    if(Test-Path -LiteralPath $ReadyBannerPath -PathType Leaf){$ReadyBanner=@(Get-Content -LiteralPath $ReadyBannerPath)}
    $script:BannerShown=$false
    $script:GeyserPresent=$false
    $GeyserJar=Get-ChildItem -LiteralPath (Join-Path $ServerDirectory 'mods') -Filter 'Geyser-*.jar' -ErrorAction SilentlyContinue | Select-Object -First 1
    if($null -ne $GeyserJar){$script:GeyserPresent=$true}
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
                    if(-not $script:BannerShown -and $script:ReadyBanner.Count -gt 0){
                        $ReadyLine=$false
                        if($script:GeyserPresent){$ReadyLine=$Line -match '(?i)geyser help'}
                        else{$ReadyLine=$Line -match 'Done \(\d+\.\d+s\)'}
                        if($ReadyLine){
                            $script:BannerShown=$true
                            Write-Host ''
                            foreach($BannerLine in $script:ReadyBanner){Write-Host $BannerLine -ForegroundColor Green}
                            Write-Host 'The Jarock server has finished loading.' -ForegroundColor Green
                            Write-Host ''
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
                    if(-not $script:BannerShown -and $script:ReadyBanner.Count -gt 0){
                        $ReadyLine=$false
                        if($script:GeyserPresent){$ReadyLine=$Line -match '(?i)geyser help'}
                        else{$ReadyLine=$Line -match 'Done \(\d+\.\d+s\)'}
                        if($ReadyLine){
                            $script:BannerShown=$true
                            Write-Host ''
                            foreach($BannerLine in $script:ReadyBanner){Write-Host $BannerLine -ForegroundColor Green}
                            Write-Host 'The Jarock server has finished loading.' -ForegroundColor Green
                            Write-Host ''
                        }
                    }
                }
                $ExitCode=$LASTEXITCODE
            } finally { $ErrorActionPreference=$PreviousEap }
        }
    } finally { Pop-Location }
    exit $ExitCode
} catch { Show-ErrorGuidance $_.Exception.Message 'Open parameter-manager.bat, select a supported loader and valid settings, then run start-server.bat again.'; exit 1 }
