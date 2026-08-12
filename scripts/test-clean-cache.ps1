[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$Root = Join-Path ([IO.Path]::GetTempPath()) ('Jarock-clean-cache-test-' + [guid]::NewGuid().ToString('N'))
$Scripts = Join-Path $Root 'scripts'
$Cache = Join-Path $Root '.cache'

try {
    New-Item -ItemType Directory -Force -Path $Scripts, $Cache | Out-Null
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'clean-cache.ps1') -Destination (Join-Path $Scripts 'clean-cache.ps1')
    Set-Content -LiteralPath (Join-Path $Cache 'stale-update.zip') -Value 'stale' -Encoding ascii
    Set-Content -LiteralPath (Join-Path $Cache 'start-server-runner.bat') -Value '@echo off' -Encoding ascii
    Set-Content -LiteralPath (Join-Path $Cache 'parameter-manager-runner.bat') -Value '@echo off' -Encoding ascii
    Set-Content -LiteralPath (Join-Path $Cache 'active-operation.bat') -Value '@echo off' -Encoding ascii

    $PreviousKeep = $env:JAROCK_CACHE_KEEP
    try {
        $env:JAROCK_CACHE_KEEP = 'active-operation.bat'
        & powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File (Join-Path $Scripts 'clean-cache.ps1') -CacheDirectory $Cache
        if ($LASTEXITCODE -ne 0) { throw "clean-cache.ps1 exited with code $LASTEXITCODE" }
    }
    finally {
        $env:JAROCK_CACHE_KEEP = $PreviousKeep
    }

    if (Test-Path -LiteralPath (Join-Path $Cache 'stale-update.zip')) { throw 'The stale cache entry was not removed.' }
    foreach ($Name in @('start-server-runner.bat', 'parameter-manager-runner.bat', 'active-operation.bat')) {
        if (-not (Test-Path -LiteralPath (Join-Path $Cache $Name) -PathType Leaf)) { throw "The active cache entry was removed unexpectedly: $Name" }
    }
    Write-Host 'PASS: inactive cache entries are removed and active runners are preserved.' -ForegroundColor Green
    exit 0
}
catch {
    Write-Host "FAIL: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
finally {
    Remove-Item -LiteralPath $Root -Recurse -Force -ErrorAction SilentlyContinue
}
