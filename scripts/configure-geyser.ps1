[CmdletBinding()]
param(
    [string]$Loader = ''
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$Root = [IO.Path]::GetFullPath((Split-Path -Parent $PSScriptRoot))
$ConfigRoot = Join-Path $Root 'server\config'
$LoaderMarkerPath = Join-Path $Root 'server\jarock-loader.txt'
if ([string]::IsNullOrWhiteSpace($Loader) -and (Test-Path -LiteralPath $LoaderMarkerPath -PathType Leaf)) {
    $Loader = (Get-Content -LiteralPath $LoaderMarkerPath -Raw).Trim()
}

function Show-ErrorGuidance([string]$Message, [string]$Action) {
    Write-Host "ERROR: $Message" -ForegroundColor Red
    Write-Host "Suggested fix: $Action" -ForegroundColor Yellow
    Write-Host 'No router, firewall, port-forwarding, or public-network changes were performed.' -ForegroundColor Yellow
}

try {
    if (-not (Test-Path -LiteralPath $ConfigRoot -PathType Container)) {
        Write-Host 'Geyser config does not exist yet. Geyser will generate it on the first server start.' -ForegroundColor Yellow
        exit 0
    }

    $Candidates = @(Get-ChildItem -LiteralPath $ConfigRoot -Directory -ErrorAction Stop | Where-Object { $_.Name -match '^Geyser-(Fabric|NeoForge|Neoforge)$' })
    if ($Loader -match '(?i)^neo') { $Candidates = @($Candidates | Where-Object { $_.Name -match '(?i)neo' }) }
    elseif ($Loader -match '(?i)^fabric') { $Candidates = @($Candidates | Where-Object { $_.Name -match '(?i)fabric' }) }
    if ($Candidates.Count -eq 0) {
        Write-Host 'Geyser config does not exist yet. Geyser will generate it on the first server start.' -ForegroundColor Yellow
        exit 0
    }
    if ($Candidates.Count -gt 1) { throw "More than one Geyser config directory was found under $ConfigRoot. Remove the unused loader config or select one loader." }

    $ConfigPath = Join-Path $Candidates[0].FullName 'config.yml'
    if (-not (Test-Path -LiteralPath $ConfigPath -PathType Leaf)) {
        Write-Host "Geyser directory exists but config.yml is not generated yet: $ConfigPath" -ForegroundColor Yellow
        exit 0
    }

    $Content = Get-Content -LiteralPath $ConfigPath -Raw
    $Updated = [regex]::Replace($Content, '(?m)^(\s*auth-type:\s*).*$', '${1}floodgate')
    if ($Updated -eq $Content -and $Content -notmatch '(?m)^\s*auth-type:\s*') {
        Show-ErrorGuidance "Could not find auth-type in $ConfigPath." 'Open the generated Geyser config, add auth-type: floodgate at the correct YAML level, save it as UTF-8, and run start-server.bat again.'
        exit 1
    }
    if ($Updated -ne $Content) {
        Set-Content -LiteralPath $ConfigPath -Value $Updated -Encoding UTF8
        Write-Host "Geyser authentication configured for Floodgate: $ConfigPath" -ForegroundColor Green
    } else { Write-Host 'Geyser authentication is already configured for Floodgate.' -ForegroundColor Green }
    Write-Host 'No router, firewall, port-forwarding, or public-network changes were performed.' -ForegroundColor Yellow
    exit 0
}
catch {
    Show-ErrorGuidance $_.Exception.Message 'Check that the generated server folder is writable, close editors using the Geyser config, and run start-server.bat again.'
    exit 1
}
