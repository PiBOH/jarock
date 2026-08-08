[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [int]$ParentProcessId,
    [Parameter(Mandatory = $true)] [string]$PendingPath,
    [Parameter(Mandatory = $true)] [string]$DestinationPath
)

$ErrorActionPreference = 'SilentlyContinue'
Set-StrictMode -Version Latest

try {
    $Deadline = [DateTime]::UtcNow.AddMinutes(10)
    while ($null -ne (Get-Process -Id $ParentProcessId -ErrorAction SilentlyContinue)) {
        if ([DateTime]::UtcNow -ge $Deadline) { exit 2 }
        Start-Sleep -Seconds 1
    }
    if (-not (Test-Path -LiteralPath $PendingPath -PathType Leaf)) { exit 0 }
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $DestinationPath) | Out-Null
    Copy-Item -LiteralPath $PendingPath -Destination $DestinationPath -Force
    Remove-Item -LiteralPath $PendingPath -Force -ErrorAction SilentlyContinue
    exit 0
}
catch {
    exit 1
}
