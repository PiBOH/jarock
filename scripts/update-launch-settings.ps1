[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string]$SettingsPath,
    [Parameter(Mandatory = $true)] [string]$InitialMemory,
    [Parameter(Mandatory = $true)] [string]$MaximumMemory
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Get-Megabytes([string]$Value) {
    if ($Value -notmatch '^(?<amount>[1-9][0-9]*)(?<unit>[mMgG])$') { throw "Invalid RAM value '$Value'. Use a positive number followed by M or G, for example 4G." }
    $Amount = [int64]$Matches['amount']
    if ($Matches['unit'].ToUpperInvariant() -eq 'G') { return $Amount * 1024 }
    return $Amount
}

try {
    $InitialMb = Get-Megabytes $InitialMemory
    $MaximumMb = Get-Megabytes $MaximumMemory
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
    $Content = Get-Content -LiteralPath $SettingsPath -Raw
    $Content = [regex]::Replace($Content, '(?m)^RAM_INITIAL=.*$', "RAM_INITIAL=$InitialMemory")
    $Content = [regex]::Replace($Content, '(?m)^RAM_MAX=.*$', "RAM_MAX=$MaximumMemory")
    Set-Content -LiteralPath $SettingsPath -Value $Content -Encoding UTF8
    exit 0
}
catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host 'Suggested fix: enter RAM values such as 4G and 8G, with initial RAM no greater than maximum RAM.' -ForegroundColor Yellow
    exit 1
}
