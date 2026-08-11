[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$Root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$Pass = 0
$Fail = 0
function Assert([bool]$Condition, [string]$Name) {
    if ($Condition) { $script:Pass++; Write-Host "PASS: $Name" -ForegroundColor Green }
    else { $script:Fail++; Write-Host "FAIL: $Name" -ForegroundColor Red }
}

$TestRoot = Join-Path ([IO.Path]::GetTempPath()) ('jarock-cleanup-icons-' + [IO.Path]::GetRandomFileName())
$ServerDirectory = Join-Path $TestRoot 'server'
$ScriptsDirectory = Join-Path $TestRoot 'scripts'

try {
    New-Item -ItemType Directory -Force -Path $ServerDirectory, $ScriptsDirectory | Out-Null
    Copy-Item -LiteralPath (Join-Path $Root 'scripts/clean-server-runtime.ps1') -Destination (Join-Path $ScriptsDirectory 'clean-server-runtime.ps1')
    foreach ($FileName in @('icon.png', 'logo.png')) {
        Set-Content -LiteralPath (Join-Path $TestRoot $FileName) -Value "root preserve $FileName" -NoNewline
    }

    foreach ($FileName in @('.gitkeep', 'README.md', 'mods-manifest.ps1', 'mods-manifest-neoforge.ps1', 'datapacks-manifest.ps1', 'jarock-loader.txt.template', 'eula.txt.template', 'server.properties.template')) {
        Set-Content -LiteralPath (Join-Path $ServerDirectory $FileName) -Value 'repository file' -NoNewline
    }
    New-Item -ItemType Directory -Force -Path (Join-Path $ServerDirectory 'config/Geyser-Fabric'), (Join-Path $ServerDirectory 'config/Geyser-NeoForge') | Out-Null
    Set-Content -LiteralPath (Join-Path $ServerDirectory 'config/Geyser-Fabric/config.yml.template') -Value 'template' -NoNewline
    Set-Content -LiteralPath (Join-Path $ServerDirectory 'config/Geyser-NeoForge/config.yml.template') -Value 'template' -NoNewline
    $WelcomeTemplatePath = Join-Path $ServerDirectory 'config/welcomemessage.json5.jarock'
    Set-Content -LiteralPath $WelcomeTemplatePath -Value 'Jarock welcome template' -NoNewline

    foreach ($FileName in @('icon.png', 'server-icon.png', 'logo.png')) {
        Set-Content -LiteralPath (Join-Path $ServerDirectory $FileName) -Value "preserve $FileName" -NoNewline
    }
    $GeneratedFile = Join-Path $ServerDirectory 'generated-runtime.tmp'
    Set-Content -LiteralPath $GeneratedFile -Value 'remove me' -NoNewline
    $GeneratedDirectory = Join-Path $ServerDirectory 'logs'
    New-Item -ItemType Directory -Force -Path $GeneratedDirectory | Out-Null
    Set-Content -LiteralPath (Join-Path $GeneratedDirectory 'latest.log') -Value 'remove me' -NoNewline

    & powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File (Join-Path $ScriptsDirectory 'clean-server-runtime.ps1') -ServerDirectory $ServerDirectory
    $CleanupCode = $LASTEXITCODE
    Assert ($CleanupCode -eq 0) "Cleanup exits successfully (exit code $CleanupCode)"

    foreach ($FileName in @('icon.png', 'server-icon.png', 'logo.png')) {
        Assert (Test-Path -LiteralPath (Join-Path $ServerDirectory $FileName) -PathType Leaf) "server/$FileName is preserved"
    }
    Assert (Test-Path -LiteralPath $WelcomeTemplatePath -PathType Leaf) 'Jarock Welcome Message template is preserved'
    foreach ($FileName in @('icon.png', 'logo.png')) {
        Assert (Test-Path -LiteralPath (Join-Path $TestRoot $FileName) -PathType Leaf) "root $FileName is preserved"
    }
    Assert (-not (Test-Path -LiteralPath $GeneratedFile -PathType Leaf)) 'Generated runtime file is removed'
    Assert (-not (Test-Path -LiteralPath $GeneratedDirectory -PathType Container)) 'Generated runtime directory is removed'

    Write-Host "Test summary: $Pass passed, $Fail failed." -ForegroundColor Cyan
    if ($Fail -gt 0) { exit 1 }
    Write-Host 'All cleanup icon tests passed.' -ForegroundColor Green
}
catch {
    Write-Host "HARNESS ERROR: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ScriptStackTrace) { Write-Host $_.ScriptStackTrace -ForegroundColor DarkGray }
    exit 1
}
finally {
    Remove-Item -LiteralPath $TestRoot -Recurse -Force -ErrorAction SilentlyContinue
}
