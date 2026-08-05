[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$Root = Split-Path -Parent $PSScriptRoot
$ConfigPath = Join-Path $Root 'server\config\Geyser-Fabric\config.yml'

if (-not (Test-Path -LiteralPath $ConfigPath)) {
    Write-Host "Geyser config does not exist yet. Geyser will generate it on the first server start." -ForegroundColor Yellow
    exit 0
}

$Content = Get-Content -LiteralPath $ConfigPath -Raw
$Updated = [regex]::Replace(
    $Content,
    '(?m)^(\s*auth-type:\s*).*$' ,
    '${1}floodgate'
)

if ($Updated -eq $Content -and $Content -notmatch '(?m)^\s*auth-type:\s*') {
    throw "Could not find auth-type in $ConfigPath. Open the generated Geyser config and set auth-type: floodgate manually."
}

if ($Updated -ne $Content) {
    Set-Content -LiteralPath $ConfigPath -Value $Updated -Encoding UTF8
    Write-Host 'Geyser authentication configured for Floodgate.' -ForegroundColor Green
}
else {
    Write-Host 'Geyser authentication is already configured for Floodgate.' -ForegroundColor Green
}

Write-Host 'No router, firewall, port-forwarding, or public-network changes were performed.' -ForegroundColor Yellow
