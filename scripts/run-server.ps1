[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ServerDirectory,
    [string]$InitialMemory = '4G',
    [string]$MaximumMemory = '4G',
    [ValidateSet('gui', 'nogui')]
    [string]$GuiMode = 'nogui',
    [ValidateSet('default', 'low-pause')]
    [string]$GcProfile = 'default',
    [switch]$ConfigureJavaEnvironment
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$JavaRuntimeScript = Join-Path (Split-Path -Parent $PSScriptRoot) 'scripts\java-runtime.ps1'
if (-not (Test-Path -LiteralPath $JavaRuntimeScript -PathType Leaf)) {
    Write-Host 'ERROR: The Java runtime helper is missing.' -ForegroundColor Red
    Write-Host 'Suggested fix: restore scripts/java-runtime.ps1 and run start-server.bat again.' -ForegroundColor Yellow
    exit 1
}
. $JavaRuntimeScript

function Show-ErrorGuidance([string]$Message, [string]$Action) {
    Write-Host "ERROR: $Message" -ForegroundColor Red
    Write-Host "Suggested fix: $Action" -ForegroundColor Yellow
    Write-Host 'No router, firewall, port-forwarding, or public-network changes were performed.' -ForegroundColor Yellow
}

function Set-ServerOnlineMode([string]$PropertiesPath, [string]$OnlineMode) {
    if ($OnlineMode -notin @('true', 'false')) {
        throw "ONLINE_MODE must be true or false, not '$OnlineMode'."
    }
    if (-not (Test-Path -LiteralPath $PropertiesPath -PathType Leaf)) {
        throw "The Minecraft properties file was not found: $PropertiesPath"
    }

    $Content = Get-Content -LiteralPath $PropertiesPath -Raw
    $OnlineModePattern = '(?m)^[ \t]*online-mode[ \t]*=[^\r\n]*'
    if ($Content -match $OnlineModePattern) {
        $Content = [regex]::Replace($Content, $OnlineModePattern, "online-mode=$OnlineMode")
    }
    else {
        $Content = $Content.TrimEnd([char[]]"`r`n") + "`r`nonline-mode=$OnlineMode`r`n"
    }
    [IO.File]::WriteAllText($PropertiesPath, $Content, (New-Object Text.UTF8Encoding($false)))

    if ($OnlineMode -eq 'false') {
        Write-Host 'WARNING: online-mode=false disables normal Mojang account authentication.' -ForegroundColor Yellow
        Write-Host 'Use it only with a trusted, correctly configured authentication proxy; it is unsafe for a public server by itself.' -ForegroundColor Yellow
    }
    else {
        Write-Host 'Minecraft online-mode=true is enabled.' -ForegroundColor Green
    }
}

function Assert-MemoryValue([string]$Name, [string]$Value) {
    if ($Value -notmatch '^(?<amount>[1-9][0-9]*)(?<unit>[mMgG])$') {
        throw "$Name has an invalid value '$Value'. Use a positive amount followed by M or G, for example 4G."
    }
    $Amount = [int64]$Matches['amount']
    $Unit = $Matches['unit'].ToUpperInvariant()
    $Megabytes = if ($Unit -eq 'G') { $Amount * 1024 } else { $Amount }
    if ($Megabytes -lt 512) {
        throw "$Name is too small ('$Value'). Use at least 512M."
    }
    return $Megabytes
}

try {
    $ServerDirectory = [IO.Path]::GetFullPath($ServerDirectory)
    $JavaPathFile = Join-Path $ServerDirectory 'java-path.txt'
    $LauncherPath = Join-Path $ServerDirectory 'fabric-server-launch.jar'
    $RootDirectory = Split-Path -Parent $ServerDirectory
    $SettingsPath = Join-Path $RootDirectory 'server-launch-settings.ini'
    $PropertiesPath = Join-Path $ServerDirectory 'server.properties'
    $JavaEnvironmentScript = Join-Path (Split-Path -Parent $PSScriptRoot) 'scripts\configure-java-environment.ps1'
    $Settings = @{}

    if (Test-Path -LiteralPath $SettingsPath -PathType Leaf) {
        foreach ($Line in (Get-Content -LiteralPath $SettingsPath)) {
            if ($Line -match '^\s*([A-Z_]+)=(.*?)\s*$' -and $Matches[1] -notlike '#*') {
                $Settings[$Matches[1]] = $Matches[2]
            }
        }
        if ($Settings.ContainsKey('RAM_INITIAL')) { $InitialMemory = [string]$Settings['RAM_INITIAL'] }
        if ($Settings.ContainsKey('RAM_MAX')) { $MaximumMemory = [string]$Settings['RAM_MAX'] }
        if ($Settings.ContainsKey('GUI_MODE')) { $GuiMode = [string]$Settings['GUI_MODE'].ToLowerInvariant() }
        if ($Settings.ContainsKey('GC_PROFILE')) { $GcProfile = [string]$Settings['GC_PROFILE'].ToLowerInvariant() }
        if ($Settings.ContainsKey('AUTO_CONFIGURE_JAVA') -and ([string]$Settings['AUTO_CONFIGURE_JAVA'] -match '^(?i:true|yes|1)$')) {
            $ConfigureJavaEnvironment = $true
        }
    }
    if ($GuiMode -notin @('gui', 'nogui')) { throw "GUI_MODE must be gui or nogui, not '$GuiMode'." }
    if ($GcProfile -notin @('default', 'low-pause')) { throw "GC_PROFILE must be default or low-pause, not '$GcProfile'." }
    $OnlineMode = 'true'
    if ($Settings.ContainsKey('ONLINE_MODE')) { $OnlineMode = [string]$Settings['ONLINE_MODE'].ToLowerInvariant() }
    if ($OnlineMode -notin @('true', 'false')) { throw "ONLINE_MODE must be true or false, not '$OnlineMode'." }

    $InitialMegabytes = Assert-MemoryValue 'RAM_INITIAL' $InitialMemory
    $MaximumMegabytes = Assert-MemoryValue 'RAM_MAX' $MaximumMemory
    if ($InitialMegabytes -gt $MaximumMegabytes) {
        throw "RAM_INITIAL ($InitialMemory) cannot be greater than RAM_MAX ($MaximumMemory)."
    }
    $ComputerSystem = Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction SilentlyContinue
    $PhysicalMemoryMb = 0
    if ($null -ne $ComputerSystem -and $null -ne $ComputerSystem.TotalPhysicalMemory) {
        $PhysicalMemoryMb = [int64]($ComputerSystem.TotalPhysicalMemory / 1MB)
    }
    $ReservedMemoryMb = 1024
    $MaximumSafeMemoryMb = $PhysicalMemoryMb - $ReservedMemoryMb
    if ($PhysicalMemoryMb -gt 0 -and $MaximumSafeMemoryMb -ge 512 -and $MaximumMegabytes -gt $MaximumSafeMemoryMb) {
        throw "RAM_MAX ($MaximumMemory) leaves less than ${ReservedMemoryMb}M for Windows and other applications. Detected physical memory: ${PhysicalMemoryMb}M; choose at most ${MaximumSafeMemoryMb}M in parameter-manager.bat."
    }

    if (-not (Test-Path -LiteralPath $JavaPathFile -PathType Leaf)) {
        throw "The selected Java path file was not found: $JavaPathFile"
    }
    if (-not (Test-Path -LiteralPath $LauncherPath -PathType Leaf)) {
        throw "The Fabric server launcher was not found: $LauncherPath"
    }

    $JavaPath = (Get-Content -LiteralPath $JavaPathFile -Raw).Trim()
    if ([string]::IsNullOrWhiteSpace($JavaPath) -or -not (Test-Path -LiteralPath $JavaPath -PathType Leaf)) {
        throw "The selected Java executable is missing or invalid: '$JavaPath'"
    }

    $Runtime = Get-JavaRuntimeInfo $JavaPath
    if ($null -eq $Runtime) {
        throw "Could not inspect the selected Java executable: '$JavaPath'."
    }
    if ($Runtime.Major -lt 25 -or -not $Runtime.Is64Bit) {
        throw "The selected Java executable is Java $($Runtime.Major), 64-bit=$($Runtime.Is64Bit); Minecraft 26.2 requires 64-bit Java 25 or newer."
    }

    if ($ConfigureJavaEnvironment) {
        if (-not (Test-Path -LiteralPath $JavaEnvironmentScript -PathType Leaf)) {
            throw "The Java environment helper is missing: $JavaEnvironmentScript"
        }
        & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $JavaEnvironmentScript -JavaExecutable $Runtime.Path
        if ($LASTEXITCODE -ne 0) {
            Write-Host "WARNING: User JAVA_HOME/PATH configuration could not be completed (exit code $LASTEXITCODE)." -ForegroundColor Yellow
            Write-Host 'Suggested fix: close other environment editors and run parameter-manager.bat again. The server will continue with the validated absolute Java executable.' -ForegroundColor Yellow
        }
    }

    Set-ServerOnlineMode -PropertiesPath $PropertiesPath -OnlineMode $OnlineMode
    Write-Host "Using Java executable: $($Runtime.Path) (Java $($Runtime.Version), 64-bit=$($Runtime.Is64Bit))" -ForegroundColor Green
    Write-Host "Memory: initial=$InitialMemory, maximum=$MaximumMemory; mode=$GuiMode; GC profile=$GcProfile; online-mode=$OnlineMode" -ForegroundColor Green

    $JavaArguments = @("-Xms$InitialMemory", "-Xmx$MaximumMemory")
    if ($GcProfile -eq 'low-pause') {
        $JavaArguments += @('-XX:+UseG1GC', '-XX:MaxGCPauseMillis=200')
    }
    $JavaArguments += @('-jar', $LauncherPath)
    if ($GuiMode -eq 'nogui') { $JavaArguments += 'nogui' }

    Push-Location -LiteralPath $ServerDirectory
    try {
        & $Runtime.Path @JavaArguments
        $ExitCode = $LASTEXITCODE
    }
    finally {
        Pop-Location
    }

    exit $ExitCode
}
catch {
    Show-ErrorGuidance $_.Exception.Message 'Open parameter-manager.bat to correct RAM/mode settings, or run start-server.bat again to rediscover Java. No router or firewall changes are needed.'
    exit 1
}
