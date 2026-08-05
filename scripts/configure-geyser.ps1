[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$Root = [IO.Path]::GetFullPath((Split-Path -Parent $PSScriptRoot))
$ConfigPath = Join-Path $Root 'server\config\Geyser-Fabric\config.yml'

function Show-ErrorGuidance([string]$Message, [string]$Action) {
    Write-Host "ERROR: $Message" -ForegroundColor Red
    Write-Host "Suggested fix: $Action" -ForegroundColor Yellow
    Write-Host 'No router, firewall, port-forwarding, or public-network changes were performed.' -ForegroundColor Yellow
}

try {
    if (-not (Test-Path -LiteralPath $ConfigPath)) {
        Write-Host 'Geyser config does not exist yet. Geyser will generate it on the first server start.' -ForegroundColor Yellow
        exit 0
    }

    $Content = Get-Content -LiteralPath $ConfigPath -Raw
    $Updated = [regex]::Replace(
        $Content,
        '(?m)^(\s*auth-type:\s*).*$' ,
        '${1}floodgate'
    )

    if ($Updated -eq $Content -and $Content -notmatch '(?m)^\s*auth-type:\s*') {
        Show-ErrorGuidance "Could not find auth-type in $ConfigPath." 'Open the generated Geyser config, add auth-type: floodgate at the correct YAML level, save it as UTF-8, and run start-server.bat again.'
        exit 1
    }

    if ($Updated -ne $Content) {
        Set-Content -LiteralPath $ConfigPath -Value $Updated -Encoding UTF8
        Write-Host 'Geyser authentication configured for Floodgate.' -ForegroundColor Green
    }
    else {
        Write-Host 'Geyser authentication is already configured for Floodgate.' -ForegroundColor Green
    }

    Write-Host 'No router, firewall, port-forwarding, or public-network changes were performed.' -ForegroundColor Yellow
    exit 0
}
catch {
    Show-ErrorGuidance $_.Exception.Message 'Check that the repository and generated server folder are writable, close editors using config.yml, and run start-server.bat again.'
    exit 1
}
