[CmdletBinding()]
param()

# Regression test for the Welcome Message template update fix:
#   1. Test-ProtectedProjectPath in scripts/update-jarock.ps1 must treat committed
#      server templates and manifests (including the special `.template-jarock`
#      suffix) as updatable project files even when the current installation is an
#      old Git checkout or old package that does not track them yet. Without this,
#      an update from a version created before the template existed leaves the file
#      missing and the next server start fails.
#   2. The bootstrap fallback template embedded in scripts/bootstrap-server.ps1
#      must stay in sync with the tracked server/config/welcomemessage.json5.template-jarock.
# The function is extracted from the updater via the PowerShell AST so the real,
# committed implementation is tested without executing the whole updater script.

$ErrorActionPreference = 'Stop'
$Root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$Pass = 0
$Fail = 0
function Assert-T([bool]$Condition, [string]$Name) {
    if ($Condition) { $script:Pass++; Write-Host "PASS: $Name" -ForegroundColor Green }
    else { $script:Fail++; Write-Host "FAIL: $Name" -ForegroundColor Red }
}

# --- 1. Test-ProtectedProjectPath protection logic ---
$Tokens = $null
$Errors = $null
$Ast = [System.Management.Automation.Language.Parser]::ParseFile((Join-Path $Root 'scripts/update-jarock.ps1'), [ref]$Tokens, [ref]$Errors)
if ($Errors -and $Errors.Count -gt 0) { throw 'scripts/update-jarock.ps1 failed to parse.' }

$Fn = $null
foreach ($Node in $Ast.FindAll({ param($N) $true }, $true)) {
    if ($Node -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $Node.Name -eq 'Test-ProtectedProjectPath') { $Fn = $Node; break }
}
if ($null -eq $Fn) { throw 'Test-ProtectedProjectPath was not found in scripts/update-jarock.ps1.' }

$script:Tracked = @()
function Get-TrackedFiles { return @($script:Tracked) }
$Global:TrackedFilesCache = $null
$Module = New-Module -Name "jarock-protection-$PID" -ScriptBlock ([scriptblock]::Create($Fn.Extent.Text)) -Function 'Test-ProtectedProjectPath'
function Invoke-Protected([string]$Path) {
    $Global:TrackedFilesCache = $null
    return & $Module Test-ProtectedProjectPath $Path
}

# 1a. No-Git install (empty tracked list): template must be updatable.
$script:Tracked = @()
Assert-T (-not (Invoke-Protected 'server/config/welcomemessage.json5.template-jarock')) 'No-Git install: Welcome Message template is updatable'

# 1b. Old Git checkout (pre-0.0.95, template not tracked yet): still updatable.
$script:Tracked = @('scripts/version.txt', 'server/mods-manifest.ps1', 'start-server.bat')
Assert-T (-not (Invoke-Protected 'server/config/welcomemessage.json5.template-jarock')) 'Old Git checkout: Welcome Message template is updatable'

# 1c. Current Git checkout (template tracked): still updatable.
$script:Tracked = @('scripts/version.txt', 'server/config/welcomemessage.json5.template-jarock', 'server/mods-manifest.ps1')
Assert-T (-not (Invoke-Protected 'server/config/welcomemessage.json5.template-jarock')) 'Current Git checkout: Welcome Message template is updatable'

# 1d. Generated runtime configuration must remain protected.
$script:Tracked = @()
Assert-T (Invoke-Protected 'server/config/Geyser-Fabric/config.yml') 'Runtime Geyser config is still protected'
Assert-T (Invoke-Protected 'server/world/level.dat') 'World data is still protected'
Assert-T (Invoke-Protected 'server/server.properties') 'server.properties is still protected'
Assert-T (Invoke-Protected 'server/server.jar') 'The server engine is still protected'

# 1e. Other committed templates below server/ remain updatable.
$script:Tracked = @()
Assert-T (-not (Invoke-Protected 'server/server.properties.template')) 'server.properties.template is updatable'
Assert-T (-not (Invoke-Protected 'server/config/Geyser-Fabric/config.yml.template')) 'Geyser template is updatable'

Remove-Module $Module

# --- 2. Bootstrap fallback must match the tracked template ---
$BootstrapSource = Get-Content -LiteralPath (Join-Path $Root 'scripts/bootstrap-server.ps1') -Raw
$FallbackMatch = [regex]::Match($BootstrapSource, "\$FallbackTemplate = @'\r?\n(?<body>.*?)\r?\n'@", [System.Text.RegularExpressions.RegexOptions]::Singleline)
Assert-T $FallbackMatch.Success 'The bootstrap embeds a FallbackTemplate here-string'
if ($FallbackMatch.Success) {
    $Fallback = $FallbackMatch.Groups['body'].Value
    $Normalize = { param($S) (($S -replace "`r", '') -replace '\s+$', '').Trim() }
    $FallbackNormalized = & $Normalize $Fallback
    $TrackedTemplate = Get-Content -LiteralPath (Join-Path $Root 'server/config/welcomemessage.json5.template-jarock') -Raw
    $TrackedNormalized = & $Normalize $TrackedTemplate
    Assert-T ($FallbackNormalized -eq $TrackedNormalized) 'The bootstrap fallback matches the tracked Welcome Message template'
}

Write-Host ''
Write-Host "Updater protection test summary: $Pass passed, $Fail failed." -ForegroundColor Cyan
if ($Fail -gt 0) { exit 1 }
Write-Host 'All tests passed.' -ForegroundColor Green
