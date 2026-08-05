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
    foreach ($Name in @('RAM_INITIAL','RAM_MAX','GUI_MODE','AUTO_CONFIGURE_JAVA','GC_PROFILE')) {
        if (-not $Values.ContainsKey($Name)) { throw "Missing setting: $Name" }
    }
    $InitialMb = Get-Megabytes ([string]$Values['RAM_INITIAL'])
    $MaximumMb = Get-Megabytes ([string]$Values['RAM_MAX'])
    if ($InitialMb -lt 512 -or $MaximumMb -lt 512) { throw 'RAM values must be at least 512M.' }
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
    Write-Host 'Launch settings are valid.' -ForegroundColor Green
    exit 0
}
catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host 'Suggested fix: choose Reset safe defaults in parameter-manager.bat, then configure the values again.' -ForegroundColor Yellow
    exit 1
}
