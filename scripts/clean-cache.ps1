[CmdletBinding()]
param(
    [string]$CacheDirectory
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Show-ErrorGuidance([string]$Message, [string]$Action) {
    Write-Host "ERROR: $Message" -ForegroundColor Red
    Write-Host "Suggested fix: $Action" -ForegroundColor Yellow
    Write-Host 'No router, firewall, port-forwarding, or public-network changes were performed.' -ForegroundColor Yellow
}

try {
    $RepositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..')).TrimEnd('\')
    $ExpectedCache = [IO.Path]::GetFullPath((Join-Path $RepositoryRoot '.cache')).TrimEnd('\')
    if ([string]::IsNullOrWhiteSpace($CacheDirectory)) { $CacheDirectory = $ExpectedCache }
    $CacheDirectory = [IO.Path]::GetFullPath($CacheDirectory).TrimEnd('\')
    if ($CacheDirectory -ine $ExpectedCache) {
        throw "Refusing to clean an unexpected cache directory: $CacheDirectory"
    }

    try {
        $JavaProcesses = @(Get-CimInstance Win32_Process -Filter "Name = 'java.exe' OR Name = 'javaw.exe'" -ErrorAction Stop)
    }
    catch {
        throw "Could not safely check whether Java is running. Cache cleanup was cancelled. $($_.Exception.Message)"
    }
    if ($JavaProcesses.Count -gt 0) {
        $ProcessIds = ($JavaProcesses | ForEach-Object { $_.ProcessId }) -join ', '
        throw "Java process(es) are running (PID: $ProcessIds). Stop the server and close other Java applications, then clean the cache again."
    }

    $ProtectedNames = @(
        'start-server-runner.bat',
        'parameter-manager-runner.bat'
    )
    if (-not [string]::IsNullOrWhiteSpace($env:JAROCK_CACHE_KEEP)) {
        foreach ($Name in ($env:JAROCK_CACHE_KEEP -split ';')) {
            $Leaf = Split-Path -Leaf $Name.Trim()
            if (-not [string]::IsNullOrWhiteSpace($Leaf)) { $ProtectedNames += $Leaf }
        }
    }
    $ProtectedNames = @($ProtectedNames | Select-Object -Unique)

    if (-not (Test-Path -LiteralPath $CacheDirectory -PathType Container)) {
        Write-Host 'Jarock cache directory does not exist; nothing to clean.' -ForegroundColor Cyan
        exit 0
    }

    Write-Host "Cleaning inactive Jarock cache data under: $CacheDirectory" -ForegroundColor Cyan
    Write-Host 'Preserving active launcher runners so this cleanup cannot corrupt the open CLI or TUI session.' -ForegroundColor Green
    $Entries = @(Get-ChildItem -LiteralPath $CacheDirectory -Force -ErrorAction Stop)
    foreach ($Entry in $Entries) {
        if ($ProtectedNames -contains $Entry.Name) {
            Write-Host "Preserved active cache entry: $($Entry.FullName)" -ForegroundColor DarkYellow
            continue
        }
        Remove-Item -LiteralPath $Entry.FullName -Recurse -Force -ErrorAction Stop
        Write-Host "Removed: $($Entry.FullName)" -ForegroundColor DarkYellow
    }

    Write-Host 'Jarock cache cleanup completed successfully.' -ForegroundColor Green
    exit 0
}
catch {
    Show-ErrorGuidance $_.Exception.Message 'Stop Jarock and all other Java applications, then run clean-cache.bat again.'
    exit 1
}
