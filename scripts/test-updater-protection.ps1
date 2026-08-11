[CmdletBinding()]
param()

# Regression test for the Welcome Message template update fix:
#   1. Test-ProtectedProjectPath in scripts/update-jarock.ps1 must treat committed
#      server templates and manifests (including the special `.jarock`
#      suffix) as updatable project files even when the current installation is an
#      old Git checkout or old package that does not track them yet. Without this,
#      an update from a version created before the template existed leaves the file
#      missing and the next server start fails.
#   2. The bootstrap fallback template embedded in scripts/bootstrap-server.ps1
#      must stay in sync with the tracked server/config/welcomemessage.json5.jarock.
# The function is extracted from the updater via the PowerShell AST so the real,
# committed implementation is tested without executing the whole updater script.

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
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
Assert-T (-not (Invoke-Protected 'server/config/welcomemessage.json5.jarock')) 'No-Git install: Welcome Message template is updatable'

# 1b. Old Git checkout (pre-0.0.95, template not tracked yet): still updatable.
$script:Tracked = @('scripts/version.txt', 'server/mods-manifest.ps1', 'start-server.bat')
Assert-T (-not (Invoke-Protected 'server/config/welcomemessage.json5.jarock')) 'Old Git checkout: Welcome Message template is updatable'

# 1c. Current Git checkout (template tracked): still updatable.
$script:Tracked = @('scripts/version.txt', 'server/config/welcomemessage.json5.jarock', 'server/mods-manifest.ps1')
Assert-T (-not (Invoke-Protected 'server/config/welcomemessage.json5.jarock')) 'Current Git checkout: Welcome Message template is updatable'

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
    $TrackedTemplate = Get-Content -LiteralPath (Join-Path $Root 'server/config/welcomemessage.json5.jarock') -Raw
    $TrackedNormalized = & $Normalize $TrackedTemplate
    Assert-T ($FallbackNormalized -eq $TrackedNormalized) 'The bootstrap fallback matches the tracked Welcome Message template'
}

# --- 3. Test-Package must require the Welcome Message template in the package ---
# The version is derived from the real scripts/version.txt so the test stays
# honest across version bumps instead of relying on a magic constant.
$PackageVersionText = (Get-Content -LiteralPath (Join-Path $Root 'scripts/version.txt') -Raw).Trim()
$TokenB = $null
$ErrorB = $null
$AstB = [System.Management.Automation.Language.Parser]::ParseFile((Join-Path $Root 'scripts/update-jarock.ps1'), [ref]$TokenB, [ref]$ErrorB)
if ($ErrorB -and $ErrorB.Count -gt 0) { throw 'scripts/update-jarock.ps1 failed to parse (second pass).' }

$PackageFns = @{}
foreach ($Name in @('Parse-SemVer', 'Compare-SemVer', 'Test-Package')) {
    foreach ($Node in $AstB.FindAll({ param($N) $true }, $true)) {
        if ($Node -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $Node.Name -eq $Name) { $PackageFns[$Name] = $Node.Extent.Text; break }
    }
    if (-not $PackageFns.ContainsKey($Name)) { throw "$Name was not found in scripts/update-jarock.ps1." }
}
$PackageModule = New-Module -Name "jarock-package-$PID" -ScriptBlock ([scriptblock]::Create(($PackageFns.Values -join [Environment]::NewLine))) -Function @('Parse-SemVer', 'Compare-SemVer', 'Test-Package')

function New-TestPackage([string]$Dir, [switch]$WithoutTemplate) {
    $Scripts = Join-Path $Dir 'scripts'
    New-Item -ItemType Directory -Force -Path $Scripts | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $Dir 'server/config') | Out-Null
    Set-Content -LiteralPath (Join-Path $Scripts 'version.txt') -Value $PackageVersionText -NoNewline -Encoding Ascii
    Set-Content -LiteralPath (Join-Path $Dir 'start-server.bat') -Value '@echo off' -Encoding Ascii
    Set-Content -LiteralPath (Join-Path $Scripts 'update-jarock.ps1') -Value '# updater' -Encoding Ascii
    Set-Content -LiteralPath (Join-Path $Scripts 'update-jarock.bat') -Value '@echo off' -Encoding Ascii
    Set-Content -LiteralPath (Join-Path $Scripts 'apply-pending-launcher.ps1') -Value '# launcher' -Encoding Ascii
    Set-Content -LiteralPath (Join-Path $Scripts 'jarock-edition.ini') -Value "JAROCK_INTERFACE=cli`r`nJAROCK_PACKAGE_TIER=lite`r`n" -Encoding Ascii
    if (-not $WithoutTemplate) {
        Copy-Item -LiteralPath (Join-Path $Root 'server/config/welcomemessage.json5.jarock') -Destination (Join-Path $Dir 'server/config/welcomemessage.json5.jarock')
        Copy-Item -LiteralPath (Join-Path $Root 'server/config/welcomemessage.json5.jarock') -Destination (Join-Path $Dir 'server/config/welcomemessage.json5.template-jarock')
    }
    $ZipPath = Join-Path $Dir 'package.zip'
    Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction SilentlyContinue
    $Zip = [IO.Compression.ZipFile]::Open($ZipPath, [IO.Compression.ZipArchiveMode]::Create)
    try {
        foreach ($Rel in @('scripts/version.txt', 'start-server.bat', 'scripts/update-jarock.ps1', 'scripts/update-jarock.bat', 'scripts/apply-pending-launcher.ps1', 'scripts/jarock-edition.ini')) {
            $Entry = $Zip.CreateEntry($Rel)
            $Writer = New-Object IO.StreamWriter($Entry.Open())
            try { $Writer.Write((Get-Content -LiteralPath (Join-Path $Dir $Rel) -Raw)) } finally { $Writer.Dispose() }
        }
        if (-not $WithoutTemplate) {
            $Entry = $Zip.CreateEntry('server/config/welcomemessage.json5.jarock')
            $Writer = New-Object IO.StreamWriter($Entry.Open())
            try { $Writer.Write((Get-Content -LiteralPath (Join-Path $Dir 'server/config/welcomemessage.json5.jarock') -Raw)) } finally { $Writer.Dispose() }
            $Entry = $Zip.CreateEntry('server/config/welcomemessage.json5.template-jarock')
            $Writer = New-Object IO.StreamWriter($Entry.Open())
            try { $Writer.Write((Get-Content -LiteralPath (Join-Path $Dir 'server/config/welcomemessage.json5.template-jarock') -Raw)) } finally { $Writer.Dispose() }
        }
    }
    finally { $Zip.Dispose() }
    return $ZipPath
}

$PackageTestDir = Join-Path $env:TEMP ("jarock-package-test-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $PackageTestDir | Out-Null
try {
    $WithZip = New-TestPackage $PackageTestDir
    $Expected = & $PackageModule Parse-SemVer $PackageVersionText
    $Threw = $false
    $Edition = [pscustomobject]@{ Interface = 'cli'; Tier = 'lite' }
    try { & $PackageModule Test-Package $WithZip $Expected $Edition } catch { $Threw = $true }
    Assert-T (-not $Threw) 'Test-Package accepts a package that contains the Welcome Message template'
    $AcceptedArchive = [IO.Compression.ZipFile]::OpenRead($WithZip)
    try {
        Assert-T ($null -ne $AcceptedArchive.GetEntry('server/config/welcomemessage.json5.template-jarock')) 'The compatibility fixture contains the legacy Welcome Message alias'
    }
    finally { $AcceptedArchive.Dispose() }

    $WithoutDir = Join-Path $PackageTestDir 'without'
    New-Item -ItemType Directory -Force -Path $WithoutDir | Out-Null
    $WithoutZip = New-TestPackage $WithoutDir -WithoutTemplate
    $Threw = $false
    $Message = ''
    try { & $PackageModule Test-Package $WithoutZip $Expected $Edition } catch { $Threw = $true; $Message = $_.Exception.Message }
    Assert-T $Threw 'Test-Package rejects a package without the Welcome Message template'
    Assert-T ($Message -match 'welcomemessage') 'The rejection message mentions the Welcome Message template'
}
finally { Remove-Item -LiteralPath $PackageTestDir -Recurse -Force -ErrorAction SilentlyContinue }
Remove-Module $PackageModule

Write-Host ''
Write-Host "Updater protection test summary: $Pass passed, $Fail failed." -ForegroundColor Cyan
if ($Fail -gt 0) { exit 1 }
Write-Host 'All tests passed.' -ForegroundColor Green
