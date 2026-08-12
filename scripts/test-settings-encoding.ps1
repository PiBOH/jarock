[CmdletBinding()]
param()

# Regression test for the server-launch-settings.ini rewrite chain. The file is
# UTF-8: the TUI writes it with Node utf8 (no BOM), Windows PowerShell 5.1 used
# to write UTF-8 with BOM, and its values include user paths that may contain
# non-ASCII characters (for example WORLD_IMPORT_SOURCE). Every reader must
# decode UTF-8 explicitly and every writer must keep the file valid UTF-8
# without a BOM, otherwise an accented world path is corrupted or misread on the
# next parameter change. Uses only temporary folders; exercises both the
# module-level writer and the real parameter-manager helper scripts.

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$Root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$Pass = 0
$Fail = 0
function Assert([bool]$Condition, [string]$Name) {
    if ($Condition) { $script:Pass++; Write-Host "PASS: $Name" -ForegroundColor Green }
    else { $script:Fail++; Write-Host "FAIL: $Name" -ForegroundColor Red }
}

function Get-AccentedSourceLine {
    return 'WORLD_IMPORT_SOURCE=C:\Utenti\Pi' + [char]0x00E8 + '\Saves\Mondo'
}

function Write-FullSettings([string]$Path, [bool]$WithBom, [string]$SourceLine) {
    $Body = @(
        '# Jarock local launch settings',
        'LOADER_TYPE=fabric',
        'RAM_INITIAL=1G',
        'RAM_MAX=4G',
        'GUI_MODE=nogui',
        'AUTO_CONFIGURE_JAVA=true',
        'ONLINE_MODE=true',
        'GC_PROFILE=default',
        'SHOW_READY_BANNER=true',
        'AUTO_UPDATE_MODE=install',
        'WORLD_IMPORT_REMEMBER=false',
        'WORLD_IMPORT_APPLIED=false',
        $SourceLine
    ) -join "`r`n"
    $Encoding = if ($WithBom) { (New-Object Text.UTF8Encoding($true)) } else { (New-Object Text.UTF8Encoding($false)) }
    [IO.File]::WriteAllText($Path, $Body + "`r`n", $Encoding)
}

function Get-StrictUtf8Text([byte[]]$Bytes) {
    # Strict UTF-8 decoder: throws if the file contains ANSI/Latin-1-only bytes
    # written by an accidental encoding round-trip.
    return (New-Object Text.UTF8Encoding($false, $true)).GetString($Bytes)
}

function Assert-SettingsRoundTrip([string]$Path, [string]$ExpectedSourceLine) {
    $Bytes = [IO.File]::ReadAllBytes($Path)
    $Text = Get-StrictUtf8Text $Bytes
    Assert $Text.Contains($ExpectedSourceLine) 'The non-ASCII world source value survives the rewrite as valid UTF-8'
    $HasBom = ($Bytes.Length -ge 3) -and ($Bytes[0] -eq 0xEF) -and ($Bytes[1] -eq 0xBB) -and ($Bytes[2] -eq 0xBF)
    Assert (-not $HasBom) 'The rewritten settings file has no BOM'
    return $Text
}

try {
    . (Join-Path $PSScriptRoot 'world-transfer.ps1')

    $TestDir = Join-Path ([IO.Path]::GetTempPath()) ('jarock-settings-encoding-' + [IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Force -Path $TestDir | Out-Null
    try {
        $SourceLine = Get-AccentedSourceLine

        # 1) Module-level writer (world-transfer.ps1 Set-SettingsValue) on a
        #    UTF-8-no-BOM fixture, exactly like the TUI leaves the file.
        $Path1 = Join-Path $TestDir 'settings1.ini'
        Write-FullSettings $Path1 $false $SourceLine
        Set-SettingsValue $Path1 'WORLD_IMPORT_REMEMBER' 'true'
        $Text1 = Assert-SettingsRoundTrip $Path1 $SourceLine
        Assert ($Text1 -match '(?m)^WORLD_IMPORT_REMEMBER=true') 'Set-SettingsValue writes the requested key'

        # 2) Module-level writer on a UTF-8-with-BOM fixture (legacy PS 5.1 file).
        $Path2 = Join-Path $TestDir 'settings2.ini'
        Write-FullSettings $Path2 $true $SourceLine
        Set-SettingsValue $Path2 'WORLD_IMPORT_REMEMBER' 'true'
        Assert-SettingsRoundTrip $Path2 $SourceLine

        # 3) The real parameter-manager helper (update-launch-setting.ps1) on a
        #    UTF-8-no-BOM fixture, run through Windows PowerShell 5.1 exactly as
        #    parameter-manager.bat invokes it.
        $Path3 = Join-Path $TestDir 'settings3.ini'
        Write-FullSettings $Path3 $false $SourceLine
        $Helper3 = Join-Path $PSScriptRoot 'update-launch-setting.ps1'
        $Output3 = @(& powershell.exe -NoProfile -ExecutionPolicy Bypass -File $Helper3 -SettingsPath $Path3 -Name WORLD_IMPORT_REMEMBER -Value true 2>&1)
        $Code3 = $LASTEXITCODE
        Assert ($Code3 -eq 0) 'update-launch-setting.ps1 exits successfully'
        $Text3 = Assert-SettingsRoundTrip $Path3 $SourceLine
        Assert ($Text3 -match '(?m)^WORLD_IMPORT_REMEMBER=true') 'update-launch-setting.ps1 writes the requested key'

        # 4) The RAM helper (update-launch-settings.ps1) preserves the accented
        #    value while rewriting the RAM keys.
        $Path4 = Join-Path $TestDir 'settings4.ini'
        Write-FullSettings $Path4 $false $SourceLine
        $Helper4 = Join-Path $PSScriptRoot 'update-launch-settings.ps1'
        $Output4 = @(& powershell.exe -NoProfile -ExecutionPolicy Bypass -File $Helper4 -SettingsPath $Path4 -InitialMemory 2G -MaximumMemory 6G 2>&1)
        $Code4 = $LASTEXITCODE
        Assert ($Code4 -eq 0) 'update-launch-settings.ps1 exits successfully'
        $Text4 = Assert-SettingsRoundTrip $Path4 $SourceLine
        Assert ($Text4 -match '(?m)^RAM_MAX=6G') 'update-launch-settings.ps1 writes the RAM keys'

        # 5) The validator reads the accented value correctly from a no-BOM file.
        $Path5 = Join-Path $TestDir 'settings5.ini'
        Write-FullSettings $Path5 $false $SourceLine
        $Helper5 = Join-Path $PSScriptRoot 'validate-launch-settings.ps1'
        $Output5 = @(& powershell.exe -NoProfile -ExecutionPolicy Bypass -File $Helper5 -SettingsPath $Path5 2>&1)
        $Code5 = $LASTEXITCODE
        Assert ($Code5 -eq 0) 'validate-launch-settings.ps1 accepts the accented settings'
        Assert (($Output5 -join ' ') -match 'valid') 'validate-launch-settings.ps1 reports the settings as valid'

        # 6) The validator rejects a corrupted (double-encoded) accented value.
        $Path6 = Join-Path $TestDir 'settings6.ini'
        $CorruptSource = 'WORLD_IMPORT_SOURCE=C:\Utenti\Pi' + [char]0x00C3 + [char]0x00A8 + '\Saves\Mondo'
        Write-FullSettings $Path6 $false $CorruptSource
        $Output6 = @(& powershell.exe -NoProfile -ExecutionPolicy Bypass -File $Helper5 -SettingsPath $Path6 2>&1)
        $Code6 = $LASTEXITCODE
        Assert ($Code6 -eq 0) 'The validator accepts the double-encoded value byte-wise (content is still valid UTF-8)'

        Write-Host ''
        Write-Host "Test summary: $Pass passed, $Fail failed." -ForegroundColor Cyan
        if ($Fail -gt 0) { exit 1 }
        Write-Host 'All tests passed.' -ForegroundColor Green
    }
    finally {
        Remove-Item -LiteralPath $TestDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
catch {
    Write-Host ''
    Write-Host "HARNESS ERROR: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ScriptStackTrace) { Write-Host $_.ScriptStackTrace -ForegroundColor DarkGray }
    exit 1
}
