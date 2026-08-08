[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$Root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$BatchPath = Join-Path $Root 'start-server.bat'
$TempRoot = Join-Path ([IO.Path]::GetTempPath()) ('Jarock-startup-update-test-' + [guid]::NewGuid().ToString('N'))
$Pass = 0
$Fail = 0

function Assert([bool]$Condition, [string]$Name) {
    if ($Condition) { $script:Pass++; Write-Host "PASS: $Name" -ForegroundColor Green }
    else { $script:Fail++; Write-Host "FAIL: $Name" -ForegroundColor Red }
}

function Write-Settings([string]$Path, [string]$Mode, [string]$NewLine) {
    $Text = "LOADER_TYPE=fabric${NewLine}AUTO_UPDATE_MODE=$Mode${NewLine}AUTO_UPDATE_CHECK=false${NewLine}"
    [IO.File]::WriteAllText($Path, $Text, (New-Object Text.UTF8Encoding($false)))
}

function Invoke-ModeParser([string]$SettingsPath, [string]$HelperPath) {
    $Command = '"' + $HelperPath + '" "' + $SettingsPath + '"'
    return @(& cmd.exe /d /c $Command 2>&1 | ForEach-Object { [string]$_ })
}

try {
    Assert (Test-Path -LiteralPath $BatchPath -PathType Leaf) 'start-server.bat is present'
    $Batch = Get-Content -LiteralPath $BatchPath -Raw
    Assert ($Batch.Contains('set "STARTUP_UPDATE_MODE="')) 'start-server.bat initializes the startup update mode'
    Assert ($Batch.Contains('tokens=1,* delims==')) 'start-server.bat splits the setting key from its value'
    Assert ($Batch.Contains('AUTO_UPDATE_MODE=" "%SETTINGS%"')) 'start-server.bat reads AUTO_UPDATE_MODE without an end-of-line regex'
    Assert ($Batch.Contains('set "STARTUP_UPDATE_MODE=%%B"')) 'start-server.bat stores the parsed startup update value'
    Assert ($Batch.Contains('if /i "%STARTUP_UPDATE_MODE%"=="install" call :startup_update_install')) 'install mode calls the install updater'
    Assert (-not $Batch.Contains('STARTUP_UPDATE_MODE%"=="auto"')) 'active startup logic no longer uses the auto mode name'
    Assert (-not $Batch.Contains(':startup_update_auto')) 'startup updater label uses the install mode name'
    Assert ($Batch.Contains('if /i "%STARTUP_UPDATE_MODE%"=="check" call :startup_update_check_only')) 'check mode calls the read-only updater'
    Assert ($Batch.Contains('if /i "%STARTUP_UPDATE_MODE%"=="never" call :startup_update_never')) 'never mode calls the disabled-update path'
    Assert ($Batch.Contains('set "LEGACY_AUTO_UPDATE_CHECK="')) 'legacy AUTO_UPDATE_CHECK compatibility remains'
    Assert ($Batch.Contains('set "LEGACY_AUTO_UPDATE_CHECK=%%B"')) 'legacy AUTO_UPDATE_CHECK value is parsed safely'
    Assert ($Batch.Contains('if not defined LEGACY_AUTO_UPDATE_CHECK call :startup_update_install')) 'missing mode uses the install default'
    Assert ($Batch.Contains('Invalid AUTO_UPDATE_MODE')) 'invalid explicit mode is reported'
    Assert (-not $Batch.Contains('^AUTO_UPDATE_MODE=install$')) 'start-server.bat no longer uses the CRLF-sensitive install regex'

    New-Item -ItemType Directory -Force -Path $TempRoot | Out-Null
    $HelperPath = Join-Path $TempRoot 'parse-settings.bat'
    $Helper = @'
@echo off
setlocal EnableExtensions DisableDelayedExpansion
set "SETTINGS=%~1"
set "STARTUP_UPDATE_MODE="
set "LEGACY_AUTO_UPDATE_CHECK="
for /f "tokens=1,* delims==" %%A in ('findstr /i /b /c:"AUTO_UPDATE_MODE=" "%SETTINGS%"') do if /i "%%A"=="AUTO_UPDATE_MODE" set "STARTUP_UPDATE_MODE=%%B"
for /f "tokens=1,* delims==" %%A in ('findstr /i /b /c:"AUTO_UPDATE_CHECK=" "%SETTINGS%"') do if /i "%%A"=="AUTO_UPDATE_CHECK" set "LEGACY_AUTO_UPDATE_CHECK=%%B"
if /i "%STARTUP_UPDATE_MODE%"=="install" echo MODE=install
if /i "%STARTUP_UPDATE_MODE%"=="check" echo MODE=check
if /i "%STARTUP_UPDATE_MODE%"=="never" echo MODE=never
if defined STARTUP_UPDATE_MODE if /i not "%STARTUP_UPDATE_MODE%"=="install" if /i not "%STARTUP_UPDATE_MODE%"=="check" if /i not "%STARTUP_UPDATE_MODE%"=="never" echo MODE=install
if not defined STARTUP_UPDATE_MODE (
    if /i "%LEGACY_AUTO_UPDATE_CHECK%"=="true" echo MODE=legacy-install
    if /i "%LEGACY_AUTO_UPDATE_CHECK%"=="false" echo MODE=legacy-never
    if not defined LEGACY_AUTO_UPDATE_CHECK echo MODE=install
)
'@
    [IO.File]::WriteAllText($HelperPath, $Helper, (New-Object Text.UTF8Encoding($false)))

    foreach ($NewLine in @("`r`n", "`n")) {
        $Label = if ($NewLine -eq "`r`n") { 'CRLF' } else { 'LF' }
        foreach ($Mode in @('install','check','never')) {
            $Path = Join-Path $TempRoot "$Label-$Mode.ini"
            Write-Settings $Path $Mode $NewLine
            $Output = Invoke-ModeParser $Path $HelperPath
            Assert ($Output -contains "MODE=$Mode") "batch parser detects '$Mode' with $Label settings"
            Assert (@($Output | Where-Object { $_ -like 'MODE=*' }).Count -eq 1) "batch parser activates exactly one mode for '$Mode' with $Label settings"
        }
    }

    $LegacyPath = Join-Path $TempRoot 'legacy-crlf.ini'
    [IO.File]::WriteAllText($LegacyPath, "LOADER_TYPE=fabric`r`nAUTO_UPDATE_CHECK=true`r`n", (New-Object Text.UTF8Encoding($false)))
    $LegacyOutput = Invoke-ModeParser $LegacyPath $HelperPath
    Assert ($LegacyOutput -contains 'MODE=legacy-install') 'batch parser detects legacy AUTO_UPDATE_CHECK=true with CRLF'

    $LegacyFalsePath = Join-Path $TempRoot 'legacy-false-crlf.ini'
    [IO.File]::WriteAllText($LegacyFalsePath, "LOADER_TYPE=fabric`r`nAUTO_UPDATE_CHECK=false`r`n", (New-Object Text.UTF8Encoding($false)))
    $LegacyFalseOutput = Invoke-ModeParser $LegacyFalsePath $HelperPath
    Assert ($LegacyFalseOutput -contains 'MODE=legacy-never') 'explicit legacy AUTO_UPDATE_CHECK=false remains disabled'

    $MissingModePath = Join-Path $TempRoot 'missing-mode-crlf.ini'
    [IO.File]::WriteAllText($MissingModePath, "LOADER_TYPE=fabric`r`n", (New-Object Text.UTF8Encoding($false)))
    $MissingModeOutput = Invoke-ModeParser $MissingModePath $HelperPath
    Assert ($MissingModeOutput -contains 'MODE=install') 'missing AUTO_UPDATE_MODE defaults to install'

    $ExplicitNeverPath = Join-Path $TempRoot 'explicit-never-with-legacy-true.ini'
    [IO.File]::WriteAllText($ExplicitNeverPath, "LOADER_TYPE=fabric`r`nAUTO_UPDATE_MODE=never`r`nAUTO_UPDATE_CHECK=true`r`n", (New-Object Text.UTF8Encoding($false)))
    $ExplicitNeverOutput = Invoke-ModeParser $ExplicitNeverPath $HelperPath
    Assert ($ExplicitNeverOutput -contains 'MODE=never') 'explicit never overrides legacy AUTO_UPDATE_CHECK=true'
    Assert (@($ExplicitNeverOutput | Where-Object { $_ -like 'MODE=*' }).Count -eq 1) 'explicit never activates exactly one mode'

    $ExplicitCheckPath = Join-Path $TempRoot 'explicit-check-with-legacy-true.ini'
    [IO.File]::WriteAllText($ExplicitCheckPath, "LOADER_TYPE=fabric`r`nAUTO_UPDATE_MODE=check`r`nAUTO_UPDATE_CHECK=true`r`n", (New-Object Text.UTF8Encoding($false)))
    $ExplicitCheckOutput = Invoke-ModeParser $ExplicitCheckPath $HelperPath
    Assert ($ExplicitCheckOutput -contains 'MODE=check') 'explicit check overrides legacy AUTO_UPDATE_CHECK=true'
    Assert (@($ExplicitCheckOutput | Where-Object { $_ -like 'MODE=*' }).Count -eq 1) 'explicit check activates exactly one mode'

    foreach ($InvalidMode in @('auto','installXYZ','check-extra','never-old')) {
        $InvalidPath = Join-Path $TempRoot "$InvalidMode.ini"
        Write-Settings $InvalidPath $InvalidMode "`r`n"
        $InvalidOutput = Invoke-ModeParser $InvalidPath $HelperPath
        Assert ($InvalidOutput -contains 'MODE=install') "batch parser falls back to install for invalid mode '$InvalidMode'"
    }
    $LegacyAutoPath = Join-Path $TempRoot 'legacy-auto.ini'
    [IO.File]::WriteAllText($LegacyAutoPath, "LOADER_TYPE=fabric`r`nAUTO_UPDATE_MODE=auto`r`n", (New-Object Text.UTF8Encoding($false)))
    $LegacyAutoOutput = Invoke-ModeParser $LegacyAutoPath $HelperPath
    Assert ($LegacyAutoOutput -contains 'MODE=install') 'obsolete auto mode falls back to install'

    Write-Host "Test summary: $Pass passed, $Fail failed." -ForegroundColor Cyan
    if ($Fail -gt 0) { exit 1 }
    Write-Host 'All startup update setting tests passed.' -ForegroundColor Green
}
catch {
    Write-Host "HARNESS ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
finally {
    Remove-Item -LiteralPath $TempRoot -Recurse -Force -ErrorAction SilentlyContinue
}
