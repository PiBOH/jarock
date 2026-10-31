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
$WorldTransferScript = Join-Path $PSScriptRoot 'world-transfer.ps1'
. $WorldTransferScript
$ServerPropertiesScript = Join-Path $PSScriptRoot 'server-properties.ps1'
. $ServerPropertiesScript
$ConfigScript = Join-Path $PSScriptRoot 'jarock-config.ps1'
. $ConfigScript
$ConsoleInterpreterScript = Join-Path $PSScriptRoot 'console-interpreter.ps1'
. $ConsoleInterpreterScript
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
function Read-Settings {
    # scripts/jarock.ini is the only settings source; jarock-config.ps1 parses it.
    return Read-JarockConfig
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
function Test-ShutdownStarted([string]$Line) {
    # Matches the explicit server-stop message and its localized variants, plus the
    # "Saving players"/"Saving worlds" lines that appear only in the shutdown path
    # (never for save-all). The save-complete check below still gates SAFE TO CLOSE.
    return $Line -match '(?i)(Stopping( Minecraft)? server|Stopping the server|Server is stopping|Server shutting down|Shutting down server|Saving players|Saving worlds|Arr\u00eat du serveur|Fermata del server|Deteniendo el servidor|\u041e\u0441\u0442\u0430\u043d\u043e\u0432\u043a\u0430 \u0441\u0435\u0440\u0432\u0435\u0440\u0430|\u30b5\u30fc\u30d0\u30fc\u3092\u505c\u6b62)'
}
function Test-WorldSaveComplete([string]$Line) {
    # Minecraft 26.2 and earlier close the save with this explicit line.
    return $Line -match '(?i)All dimensions are saved'
}
function Test-WorldSaveInProgress([string]$Line) {
    # Minecraft 26.3 dropped the "All dimensions are saved" line: it saves each
    # dimension and then exits. These per-dimension lines are the 26.3 evidence
    # that the shutdown is writing the world; the clean exit code still gates the
    # final SAFE TO CLOSE decision below.
    return $Line -match '(?i)Saving chunks for level'
}
function Test-WorldSaveFailed([string]$Line) {
    return $Line -match '(?i)(Exception stopping the server|Error while shutting down|Failed to save)'
}
function Read-NbtUInt16([System.IO.BinaryReader]$Reader) {
    $High = $Reader.ReadByte()
    $Low = $Reader.ReadByte()
    return (($High -shl 8) -bor $Low)
}
function Read-NbtInt32([System.IO.BinaryReader]$Reader) {
    $B1 = $Reader.ReadByte(); $B2 = $Reader.ReadByte(); $B3 = $Reader.ReadByte(); $B4 = $Reader.ReadByte()
    return [int32](($B1 -shl 24) -bor ($B2 -shl 16) -bor ($B3 -shl 8) -bor $B4)
}
function Read-NbtInt64([System.IO.BinaryReader]$Reader) {
    $Bytes = New-Object byte[] 8
    for ($Index = 0; $Index -lt 8; $Index++) { $Bytes[$Index] = $Reader.ReadByte() }
    [Array]::Reverse($Bytes)
    return [BitConverter]::ToInt64($Bytes, 0)
}
function Read-NbtString([System.IO.BinaryReader]$Reader) {
    $Length = Read-NbtUInt16 $Reader
    $Bytes = New-Object byte[] $Length
    $Read = $Reader.Read($Bytes, 0, $Length)
    if ($Read -ne $Length) { throw 'The level.dat NBT string was truncated.' }
    return [Text.Encoding]::UTF8.GetString($Bytes)
}
function Read-NbtPayload([System.IO.BinaryReader]$Reader, [int]$Type, [string[]]$Path) {
    switch ($Type) {
        0 { return }
        1 { [void]$Reader.ReadByte(); return }
        2 { [void](Read-NbtUInt16 $Reader); return }
        3 { [void](Read-NbtInt32 $Reader); return }
        4 {
            $Value = Read-NbtInt64 $Reader
            # Minecraft stores the world seed in world_gen_settings.dat under
            # data.seed; legacy worlds keep it in level.dat under Data.WorldGenSettings.seed.
            if ($Path.Count -gt 0 -and $Path[-1] -ieq 'seed' -and ($Path -contains 'WorldGenSettings' -or $Path[0] -ieq 'data')) {
                $script:DetectedSeed = [string]$Value
            }
            return
        }
        5 { [void]$Reader.ReadBytes(4); return }
        6 { [void]$Reader.ReadBytes(8); return }
        7 { $Length = Read-NbtInt32 $Reader; if ($Length -gt 0) { [void]$Reader.ReadBytes($Length) }; return }
        8 { [void](Read-NbtString $Reader); return }
        9 {
            $ElementType = $Reader.ReadByte()
            $Length = Read-NbtInt32 $Reader
            for ($Index = 0; $Index -lt $Length; $Index++) { [void](Read-NbtPayload $Reader $ElementType $Path) }
            return
        }
        10 {
            while ($true) {
                $ChildType = $Reader.ReadByte()
                if ($ChildType -eq 0) { break }
                $ChildName = Read-NbtString $Reader
                [void](Read-NbtPayload $Reader $ChildType (@($Path + $ChildName)))
            }
            return
        }
        11 { $Length = Read-NbtInt32 $Reader; if ($Length -gt 0) { [void]$Reader.ReadBytes($Length * 4) }; return }
        12 { $Length = Read-NbtInt32 $Reader; if ($Length -gt 0) { [void]$Reader.ReadBytes($Length * 8) }; return }
        default { throw "Unsupported NBT tag type $Type." }
    }
}
function Get-NbtSeedValue([string]$Path) {
    # Reads the world seed from a single NBT file (gzip-compressed). Returns the seed
    # as a string, or $null when the file is missing, unreadable or has no seed.
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $null }
    $FileStream = $null; $Gzip = $null; $Reader = $null
    try {
        $FileStream = [IO.File]::OpenRead($Path)
        $Gzip = New-Object IO.Compression.GzipStream($FileStream, [IO.Compression.CompressionMode]::Decompress)
        $Reader = New-Object IO.BinaryReader($Gzip)
        $script:DetectedSeed = $null
        $RootType = $Reader.ReadByte()
        if ($RootType -ne 10) { return $null }
        [void](Read-NbtString $Reader)
        [void](Read-NbtPayload $Reader 10 @())
        return $script:DetectedSeed
    }
    catch { return $null }
    finally {
        if ($null -ne $Reader) { $Reader.Dispose() }
        elseif ($null -ne $Gzip) { $Gzip.Dispose() }
        elseif ($null -ne $FileStream) { $FileStream.Dispose() }
    }
}
function Get-WorldSeed([string]$ServerDirectory, [string]$LevelName) {
    # Minecraft moved the world generation settings out of level.dat into
    # world/data/minecraft/world_gen_settings.dat (data.seed). Legacy worlds keep
    # the seed in level.dat under Data.WorldGenSettings.seed.
    $LevelDir = Join-Path $ServerDirectory $LevelName
    $Candidates = @(
        (Join-Path (Join-Path (Join-Path $LevelDir 'data') 'minecraft') 'world_gen_settings.dat'),
        (Join-Path $LevelDir 'level.dat')
    )
    foreach ($Candidate in $Candidates) {
        $Value = Get-NbtSeedValue $Candidate
        if ($null -ne $Value -and ([string]$Value) -ne '') { return [string]$Value }
    }
    return 'unavailable'
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
        $_.Name -notmatch '(?i)_originalbkp' -and
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
    Write-Host "  seed:                  $($script:WorldSeed)" -ForegroundColor Cyan
    Write-Host "  Java Edition (LAN):    $($script:LanIPv4):$($script:JavaPort)" -ForegroundColor Cyan
    if($script:GeyserPresent){
        Write-Host "  Bedrock Edition (LAN): $($script:LanIPv4):$($script:BedrockPort) (UDP)" -ForegroundColor Cyan
    } else {
        Write-Host '  Bedrock Edition:       unavailable (Geyser is not installed)' -ForegroundColor Yellow
    }
    Write-Host '  Public access requires manual router/firewall or tunnel configuration.' -ForegroundColor DarkGray
    Write-Host '  Console: type commands without a namespace, for example give @p oak_button (sent as minecraft:oak_button).' -ForegroundColor DarkGray
    if($GuiMode -eq 'gui'){
        Write-Host '  GUI mode: type "stop" in the Minecraft GUI window (or use its Stop button); this console does not read commands in GUI mode.' -ForegroundColor Yellow
    }
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
function Invoke-JarockServerLine([string]$Line) {
    # One place for every server output line: the ready banner, the detected seed
    # and the trusted shutdown sequence all hang off this handler.
    if ([string]::IsNullOrWhiteSpace($Line)) { return }
    Write-Host $Line
    if ($Line -match '(?i)\bseed\s*:\s*\[?(-?\d+)\]?') { $script:WorldSeed = $Matches[1] }
    if (Test-ShutdownStarted $Line) {
        # Only an explicit server-stop message starts the trusted shutdown
        # sequence. Autosaves/manual saves never authorize SAFE TO CLOSE.
        $script:ShutdownStarted = $true
        $script:WorldSaveComplete = $false
        $script:ShutdownChunkSaves = 0
        $script:ShutdownFailed = $false
        if (-not $script:ShutdownNoticeShown) {
            $script:ShutdownNoticeShown = $true
            Write-Host 'Jarock: the server is shutting down and saving the world. Do not close this window until the final SAFE TO CLOSE message.' -ForegroundColor Yellow
        }
    }
    if ($script:ShutdownStarted -and (Test-WorldSaveComplete $Line)) { $script:WorldSaveComplete = $true }
    if ($script:ShutdownStarted -and (Test-WorldSaveInProgress $Line)) { $script:ShutdownChunkSaves++ }
    if ($script:ShutdownStarted -and (Test-WorldSaveFailed $Line)) { $script:ShutdownFailed = $true }
    if (-not $script:BannerShown) {
        $ReadyLine = $false
        if ($script:GeyserPresent) { $ReadyLine = Test-GeyserReadyLine $Line }
        else { $ReadyLine = $Line -match 'Done \(\d+\.\d+s\)' }
        if ($ReadyLine) {
            $NbtSeed = Get-WorldSeed $ServerDirectory (Get-ConfiguredLevelName $Properties)
            if ($NbtSeed -ne 'unavailable') { $script:WorldSeed = $NbtSeed }
            $script:BannerShown = $true
            Show-ReadyStatus $ShowBanner $script:ReadyBanner
        }
    }
}
function ConvertTo-ArgumentLine([string[]]$ArgumentList) {
    # Paths such as C:\Program Files\...\server.jar must reach the process quoted.
    return (($ArgumentList | ForEach-Object {
        $Value = [string]$_
        if ($Value -match '\s') { '"' + ($Value -replace '"', '\"') + '"' } else { $Value }
    }) -join ' ')
}
function Invoke-JarockServerProcess([string]$FilePath, [string]$ArgumentLine) {
    # Start the server with a redirected stdin so a typed command can be rewritten
    # before Minecraft reads it, and pump both directions from this single thread.
    # The console interpreter only adds a namespace to known registry ids; every
    # other character, including the command itself, is passed through untouched.
    $StartInfo = New-Object System.Diagnostics.ProcessStartInfo
    $StartInfo.FileName = $FilePath
    $StartInfo.Arguments = $ArgumentLine
    $StartInfo.WorkingDirectory = (Get-Location).Path
    $StartInfo.UseShellExecute = $false
    $StartInfo.CreateNoWindow = $true
    $StartInfo.RedirectStandardInput = $true
    $StartInfo.RedirectStandardOutput = $true
    $StartInfo.RedirectStandardError = $true

    $Process = New-Object System.Diagnostics.Process
    $Process.StartInfo = $StartInfo
    # Process.StandardInput inherits [Console]::InputEncoding, and Windows PowerShell's
    # default UTF-8 input encoding carries a byte-order mark. The framework writes that
    # BOM before the first typed line, and Java 18+ decodes its console as UTF-8, so the
    # server rejected the whole command as unparsable. A preamble-free encoding keeps the
    # child console byte-for-byte identical to what was typed.
    try { [Console]::InputEncoding = New-Object System.Text.UTF8Encoding($false) } catch { }
    try { [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding($false) } catch { }
    if (-not $Process.Start()) { throw "Could not start the server process: $FilePath" }
    try {
        # Write the encoded bytes straight to the pipe so no StreamWriter preamble can
        # sneak into the server console.
        $InStream = $null
        try { $InStream = $Process.StandardInput.BaseStream } catch { $InStream = $null }
        $OutTask = $Process.StandardOutput.ReadLineAsync()
        $ErrTask = $Process.StandardError.ReadLineAsync()
        # Read the console with a StreamReader over the raw standard input instead of
        # [Console]::In.ReadLineAsync(): the Windows PowerShell console reader runs the
        # read synchronously, so a live stdin pipe (or a console typing nothing yet)
        # blocks this pump, starves the server output, and freezes the whole boot.
        $ConsoleInput = $null
        if ($GuiMode -eq 'nogui') {
            try { $ConsoleInput = New-Object System.IO.StreamReader([Console]::OpenStandardInput(), (New-Object System.Text.UTF8Encoding($false)), $false, 4096, $true) } catch { $ConsoleInput = $null }
        }
        $InTask = $null
        if ($null -ne $ConsoleInput) {
            try { $InTask = $ConsoleInput.ReadLineAsync() } catch { $InTask = $null }
        }
        while ($true) {
            $Progress = $false
            if ($null -ne $OutTask -and $OutTask.IsCompleted) {
                $Line = $null
                try { $Line = $OutTask.Result } catch { $Line = $null }
                if ($null -eq $Line) { $OutTask = $null }
                else { Invoke-JarockServerLine $Line; $OutTask = $Process.StandardOutput.ReadLineAsync() }
                $Progress = $true
            }
            if ($null -ne $ErrTask -and $ErrTask.IsCompleted) {
                $Line = $null
                try { $Line = $ErrTask.Result } catch { $Line = $null }
                if ($null -eq $Line) { $ErrTask = $null }
                else { Invoke-JarockServerLine $Line; $ErrTask = $Process.StandardError.ReadLineAsync() }
                $Progress = $true
            }
            if ($null -ne $InTask -and $InTask.IsCompleted) {
                $Typed = $null
                try { $Typed = $InTask.Result } catch { $Typed = $null }
                if ($null -eq $Typed) { $InTask = $null }
                else {
                    # Drop a byte-order mark or a stray CR that a redirected stdin can
                    # carry; the server would otherwise reject the whole command.
                    $Typed = ([string]$Typed).Replace([string][char]0xFEFF, '').TrimEnd([char]13)
                    $Translated = ConvertTo-NamespacedCommand $Typed
                    if ($Translated -ne $Typed) { Write-Host "Jarock: sent $Translated" -ForegroundColor DarkGray }
                    try {
                        if ($null -ne $InStream) {
                            $Bytes = [System.Text.Encoding]::UTF8.GetBytes($Translated + "`n")
                            $InStream.Write($Bytes, 0, $Bytes.Length)
                            $InStream.Flush()
                        } else {
                            $Process.StandardInput.WriteLine($Translated)
                            $Process.StandardInput.Flush()
                        }
                    } catch { }
                    try { $InTask = $ConsoleInput.ReadLineAsync() } catch { $InTask = $null }
                }
                $Progress = $true
            }
            if ($Process.HasExited -and $null -eq $OutTask -and $null -eq $ErrTask) { break }
            if (-not $Progress) { Start-Sleep -Milliseconds 15 }
        }
        $Process.WaitForExit()
        return $Process.ExitCode
    }
    finally { $Process.Dispose() }
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
    if($ShowBanner -and (Test-Path -LiteralPath $ReadyBannerPath -PathType Leaf)){$ReadyBanner=@(Get-Content -LiteralPath $ReadyBannerPath -Encoding UTF8)}
    $script:BannerShown=$false
    $script:WorldSeed='unavailable'
    # A previous save message is not enough to authorize closing. The safe-close
    # state must belong to this shutdown: Minecraft must announce shutdown/saving,
    # complete the world save, and then exit with code 0.
    $script:ShutdownStarted=$false
    $script:WorldSaveComplete=$false
    $script:ShutdownChunkSaves=0
    $script:ShutdownFailed=$false
    $script:ShutdownNoticeShown=$false
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
            try { $ExitCode = Invoke-JarockServerProcess -FilePath $Runtime.Path -ArgumentLine (ConvertTo-ArgumentLine $Args) }
            finally { $ErrorActionPreference=$PreviousEap }
        } else {
            $RunBat=Join-Path $ServerDirectory 'run.bat'; if(-not(Test-Path -LiteralPath $RunBat -PathType Leaf)){throw 'The generated NeoForge run.bat was not found. Run start-server.bat again.'}
            Set-NeoForgeJvmArgs (Join-Path $ServerDirectory 'user_jvm_args.txt') $InitialMemory $MaximumMemory $GcProfile
            $Args=@();if($GuiMode -eq 'nogui'){$Args+='nogui'}
            $Command = 'call "run.bat"'
            if ($Args.Count -gt 0) { $Command += ' ' + ($Args -join ' ') }
            $PreviousEap=$ErrorActionPreference; $ErrorActionPreference='Continue'
            try { $ExitCode = Invoke-JarockServerProcess -FilePath 'cmd.exe' -ArgumentLine ('/d /c ' + $Command) }
            finally { $ErrorActionPreference=$PreviousEap }
        }
    } finally { Pop-Location }
    $FinalExitCode=$ExitCode
    if($null -eq $FinalExitCode){$FinalExitCode=1} # treat an undetectable exit as abnormal
    $ExitCode=$FinalExitCode
    # Minecraft 26.3 saves every dimension and exits without the older
    # "All dimensions are saved" line. Treat the shutdown save lines followed by a
    # clean exit as a completed save, but never when the server reported a failure
    # while stopping.
    if (-not $script:WorldSaveComplete -and $script:ShutdownStarted -and -not $script:ShutdownFailed -and $script:ShutdownChunkSaves -gt 0 -and $ExitCode -eq 0) {
        $script:WorldSaveComplete = $true
    }
    Write-Host ''
    if($script:ShutdownStarted -and $script:WorldSaveComplete){
        # The completed world save is the authoritative safe-to-close signal: the
        # world data is already on disk even if the process exit code is unusual.
        Write-Host 'The world was saved and the server shut down.' -ForegroundColor Green
        if($ExitCode -eq 0){
            Write-Host 'SAFE TO CLOSE: you may now close this window.' -ForegroundColor Green
        } else {
            Write-Host "SAFE TO CLOSE: the world save completed before the process exited (exit code $ExitCode)." -ForegroundColor Green
            Write-Host 'Review server\logs\latest.log before restarting if this exit code is unexpected.' -ForegroundColor Yellow
        }
        $FinalExitCode=0
        # Export the world after a clean shutdown when the operator configured a destination.
        if($Settings.ContainsKey('WORLD_EXPORT_DEST')){
            $ExportDestination=([string]$Settings['WORLD_EXPORT_DEST']).Trim()
            if(-not [string]::IsNullOrWhiteSpace($ExportDestination)){
                try {
                    Export-WorldFolder -ServerDirectory $ServerDirectory -LevelName (Get-ConfiguredLevelName $Properties) -Destination $ExportDestination
                }
                catch {
                    Write-Host "WARNING: The world could not be exported: $($_.Exception.Message)" -ForegroundColor Yellow
                    Write-Host 'Fix the WORLD_EXPORT_DEST path in parameter-manager.bat and try again after the next clean shutdown.' -ForegroundColor Yellow
                }
            }
        }
    } elseif($ExitCode -eq 0){
        Write-Host 'WARNING: The server process exited normally, but Jarock did not observe this shutdown complete its world save.' -ForegroundColor Yellow
        Write-Host 'NOT SAFE TO CLOSE: do not assume it is safe to close or restart; inspect the server log and use a known-good backup if needed.' -ForegroundColor Yellow
        $FinalExitCode=10
    } else {
        Write-Host "NOT SAFE TO CLOSE: Minecraft exited with code $ExitCode before completing its world save." -ForegroundColor Red
        Write-Host 'Inspect server\logs\latest.log and the newest crash report before restarting.' -ForegroundColor Yellow
    }
    exit $FinalExitCode
} catch { Show-ErrorGuidance $_.Exception.Message 'Open parameter-manager.bat, select a supported loader and valid settings, then run start-server.bat again.'; exit 1 }
finally {
    if ($CloseProtectionLoaded) {
        try { Disable-JarockConsoleCloseProtection } catch { }
    }
}
