[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string]$SettingsPath
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Get-Megabytes([string]$Value) {
    if ($Value -notmatch '^(?<amount>[1-9][0-9]*)(?<unit>[mMgG])$') { throw "Invalid RAM value '$Value'. Use a positive number followed by M or G." }
    $Amount = [int64]$Matches['amount']
    if ($Matches['unit'].ToUpperInvariant() -eq 'G') { return $Amount * 1024 }
    return $Amount
}

try {
    $Values = @{}
    foreach ($Line in (Get-Content -LiteralPath $SettingsPath)) {
        if ($Line -match '^\s*([A-Z_]+)=(.*?)\s*$') { $Values[$Matches[1]] = $Matches[2] }
    }
    foreach ($Name in @('LOADER_TYPE','RAM_INITIAL','RAM_MAX','GUI_MODE','AUTO_CONFIGURE_JAVA','ONLINE_MODE','GC_PROFILE','SHOW_READY_BANNER')) {
        if (-not $Values.ContainsKey($Name)) {
            if ($Name -eq 'ONLINE_MODE') {
                $Values[$Name] = 'true'
                continue
            }
            if ($Name -eq 'LOADER_TYPE') {
                $Values[$Name] = 'none'
                continue
            }
            if ($Name -eq 'SHOW_READY_BANNER') {
                $Values[$Name] = 'true'
                continue
            }
            throw "Missing setting: $Name"
        }
    }
    if ([string]$Values['LOADER_TYPE'] -notin @('none','fabric','forge','neoforge')) { throw 'LOADER_TYPE must be none, fabric, forge or neoforge.' }
    $InitialMb = Get-Megabytes ([string]$Values['RAM_INITIAL'])
    $MaximumMb = Get-Megabytes ([string]$Values['RAM_MAX'])
    if ($InitialMb -lt 1024 -or $MaximumMb -lt 1024) { throw 'RAM values must be at least 1G.' }
    if ($InitialMb -gt $MaximumMb) { throw 'RAM_INITIAL cannot be greater than RAM_MAX.' }
    $ComputerSystem = Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction SilentlyContinue
    if ($null -ne $ComputerSystem -and $null -ne $ComputerSystem.TotalPhysicalMemory) {
        $PhysicalMemoryMb = [int64]($ComputerSystem.TotalPhysicalMemory / 1MB)
        $ReservedMemoryMb = 1024
        $MaximumSafeMemoryMb = $PhysicalMemoryMb - $ReservedMemoryMb
        if ($MaximumSafeMemoryMb -ge 512 -and $MaximumMb -gt $MaximumSafeMemoryMb) {
            throw "RAM_MAX leaves less than ${ReservedMemoryMb}M for Windows and other applications. Detected physical memory: ${PhysicalMemoryMb}M; choose at most ${MaximumSafeMemoryMb}M."
        }
    }
    if ([string]$Values['GUI_MODE'] -notin @('gui','nogui')) { throw 'GUI_MODE must be gui or nogui.' }
    if ([string]$Values['GC_PROFILE'] -notin @('default','low-pause')) { throw 'GC_PROFILE must be default or low-pause.' }
    if ([string]$Values['AUTO_CONFIGURE_JAVA'] -notin @('true','false')) { throw 'AUTO_CONFIGURE_JAVA must be true or false.' }
    if ([string]$Values['ONLINE_MODE'] -notin @('true','false')) { throw 'ONLINE_MODE must be true or false.' }
    if ([string]$Values['SHOW_READY_BANNER'] -notin @('true','false')) { throw 'SHOW_READY_BANNER must be true or false.' }
    Write-Host 'Launch settings are valid.' -ForegroundColor Green
    exit 0
}
catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host 'Suggested fix: choose Reset safe defaults in parameter-manager.bat, then configure the values again.' -ForegroundColor Yellow
    exit 1
}
