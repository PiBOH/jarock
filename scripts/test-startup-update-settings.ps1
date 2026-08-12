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
    Assert ($Batch.Contains('_JAROCK_RUNNER_ROOT')) 'start-server.bat isolates execution for safe self-updates'
    Assert ($Batch.Contains('start-server-runner.bat')) 'start-server.bat uses a temporary runner copy'
    Assert ($Batch.Contains('call "%ROOT%\.cache\start-server-runner.bat" %*')) 'start-server.bat calls the isolated runner so control returns safely'
    Assert ($Batch.Contains('The Jarock TUI exited unexpectedly')) 'start-server.bat keeps unexpected TUI exits visible'
    Assert ($Batch.Contains('STATUS_ILLEGAL_INSTRUCTION')) 'start-server.bat explains illegal-instruction TUI failures'
    Assert ($Batch.Contains('0xC000001D')) 'start-server.bat shows the illegal-instruction Windows status code'
    Assert ($Batch.Contains('required native DLL')) 'start-server.bat explains missing native DLL failures'
    $ParameterManager = Get-Content -LiteralPath (Join-Path $Root 'parameter-manager.bat') -Raw
    $TuiEntry = Get-Content -LiteralPath (Join-Path $Root 'tui/index.ts') -Raw
    Assert ($TuiEntry.Contains('JAROCK_TUI_BYPASS: "1"')) 'TUI bypasses the outer interface when opening a classic-console operation'
    Assert ($TuiEntry.Contains('_JAROCK_CLASSIC_CONSOLE: "1"')) 'TUI marks classic-console operations as already inside the classic console'
    Assert ($ParameterManager.Contains('_JAROCK_PARAMETER_MANAGER_ROOT')) 'parameter-manager.bat isolates execution for safe self-updates'
    Assert ($ParameterManager.Contains('The Jarock TUI parameter manager exited unexpectedly')) 'parameter-manager.bat keeps unexpected TUI exits visible'
    Assert ($ParameterManager.Contains('STATUS_ILLEGAL_INSTRUCTION')) 'parameter-manager.bat explains illegal-instruction TUI failures'
    Assert ($ParameterManager.Contains('0xC000001D')) 'parameter-manager.bat shows the illegal-instruction Windows status code'
    Assert ($ParameterManager.Contains('required native DLL')) 'parameter-manager.bat explains missing native DLL failures'
    Assert ($ParameterManager.Contains('parameter-manager-runner.bat')) 'parameter-manager.bat uses a temporary runner copy'
    Assert ($ParameterManager.Contains('call "%ROOT%\.cache\parameter-manager-runner.bat" %*')) 'parameter-manager.bat returns from the isolated runner safely'
    Assert ($ParameterManager.Contains('del /q "%ROOT%\.cache\parameter-manager-runner.bat"')) 'parameter-manager.bat cleans up the isolated runner after exit'
    Assert ($ParameterManager.Contains('U. Check for Jarock updates')) 'parameter-manager.bat exposes the manual update-check option'
    Assert ($ParameterManager.Contains('choice /c 1234567890XYIEU')) 'parameter-manager.bat includes U in the menu choices'
    $ParameterManagerBytes = [IO.File]::ReadAllBytes((Join-Path $Root 'parameter-manager.bat'))
    Assert (($ParameterManagerBytes -contains 13) -and (($ParameterManagerBytes | Where-Object { $_ -eq 13 }).Count -eq (($ParameterManagerBytes | Where-Object { $_ -eq 10 }).Count))) 'parameter-manager.bat keeps CRLF line endings'
    Assert ($ParameterManager.Contains('call "%ROOT%\scripts\classic-console.bat" "Jarock updater" "%ROOT%\scripts\update-jarock.bat"')) 'the manual update option opens the updater batch in a classic console window'
    Assert ($ParameterManager.Contains('if not exist "%ROOT%\scripts\update-jarock.bat"')) 'the manual update option checks that the updater entry point exists'
    Assert ($ParameterManager.Contains('This parameter manager will close now; reopen it after the updater finishes.')) 'the manager closes after launching the separate updater'
    Assert (Test-Path -LiteralPath (Join-Path $Root 'scripts/update-jarock.bat') -PathType Leaf) 'the updater batch entry point is present'
    $ClassicConsoleHelper = Get-Content -LiteralPath (Join-Path $Root 'scripts/classic-console.bat') -Raw
    Assert (Test-Path -LiteralPath (Join-Path $Root 'scripts/classic-console.bat') -PathType Leaf) 'the classic-console helper is present'
    Assert ($ClassicConsoleHelper.Contains('DelegationConsole')) 'the classic-console helper uses the default-terminal registry value'
    Assert ($ClassicConsoleHelper.Contains('{B23D10C0-E52E-411E-9D5B-C09FDF709C7D}')) 'the classic-console helper pins the classic console CLSID'
    Assert ($Batch.Contains('_JAROCK_CLASSIC_CONSOLE')) 'start-server.bat enforces the classic console when launched from Windows Terminal'
    Assert ($Batch.Contains('if not defined WT_SESSION goto :classic_console_ok')) 'start-server.bat skips the relaunch when not running in Windows Terminal'
    Assert ($Batch.Contains('call "%~dp0scripts\classic-console.bat" "Jarock classic console" "%~f0"')) 'start-server.bat relaunches itself through the classic-console helper'
    Assert ($ParameterManager.Contains('_JAROCK_CLASSIC_CONSOLE')) 'parameter-manager.bat enforces the classic console when launched from Windows Terminal'
    $CleanBatch = Get-Content -LiteralPath (Join-Path $Root 'clean-server-runtime.bat') -Raw
    Assert ($CleanBatch.Contains('_JAROCK_CLASSIC_CONSOLE')) 'clean-server-runtime.bat enforces the classic console when launched from Windows Terminal'
    $UpdaterBatch = Get-Content -LiteralPath (Join-Path $Root 'scripts/update-jarock.bat') -Raw
    Assert ($UpdaterBatch.Contains('_JAROCK_CLASSIC_CONSOLE')) 'update-jarock.bat enforces the classic console when launched from Windows Terminal'
    $BootstrapScript = Get-Content -LiteralPath (Join-Path $Root 'scripts/bootstrap-server.ps1') -Raw
    Assert ($BootstrapScript.Contains('Start-InClassicConsole')) 'the bootstrap opens the parameter manager through the classic-console helper'
    Assert ($BootstrapScript.Contains('{B23D10C0-E52E-411E-9D5B-C09FDF709C7D}')) 'the bootstrap pins the classic console CLSID'
    Assert ($Batch.Contains('-NonInteractive -StartupUpdate')) 'startup updates use deferred launcher replacement mode'
    $AutoRelease = Get-Content -LiteralPath (Join-Path $Root '.github/workflows/auto-release.yml') -Raw
    Assert ($AutoRelease.Contains("bun-version: '1.3.14'")) 'auto-release pins the Bun version required by baseline TUI compilation'
    Assert ($AutoRelease.Contains("requires Bun 1.3.14 for baseline Windows compilation")) 'auto-release verifies the installed Bun version before compiling'
    Assert ($AutoRelease.Contains('--target=bun-windows-x64-baseline')) 'auto-release keeps the CPU-compatible Windows baseline target'
    Assert ($AutoRelease.Contains('C:\jarock-tui-build')) 'auto-release builds the baseline runtime on the C drive to avoid cross-volume cache renames'
    Assert ($AutoRelease.Contains('$tuiRoot = Join-Path $buildRoot ''tui''')) 'auto-release creates a dedicated tui subdirectory in the isolated build workspace'
    Assert ($AutoRelease.Contains('Copy-Item -Path (Join-Path $tuiSource ''*'') -Destination $tuiRoot -Recurse -Force')) 'auto-release copies TUI contents into the expected isolated tui directory'
    Assert ($AutoRelease.Contains('package.json is missing from $tuiRoot')) 'auto-release reports an incorrect TUI workspace copy clearly'
    Assert ($AutoRelease.Contains('bun.lock is missing from $tuiRoot')) 'auto-release validates the copied TUI lockfile before installing'
    Assert ($AutoRelease.Contains('JAROCK_TUI_BUILD_ROOT')) 'auto-release shares the isolated C-drive build workspace across TUI steps'
    Assert ($TuiEntry.Contains('renderer.start()')) 'TUI explicitly starts the OpenTUI input and render loop'
    Assert ($TuiEntry.Contains('useKittyKeyboard: null')) 'TUI disables Kitty keyboard sequences for legacy Windows consoles'
    Assert ($TuiEntry.Contains('process.stdin.resume()')) 'TUI resumes stdin explicitly for standalone Windows builds'
    Assert ($TuiEntry.Contains('process.stdin.setRawMode(true)')) 'TUI enables raw stdin mode when the Windows host exposes it'
    Assert ($TuiEntry.Contains('function isSelectConfirmKey')) 'TUI recognizes Enter and line-feed confirmation keys'
    Assert ($TuiEntry.Contains('key?.name === "enter"')) 'TUI recognizes the Windows Enter key name'
    Assert ($TuiEntry.Contains('function selectKeyDown')) 'TUI handles Enter on the focused Select itself'
    Assert ($TuiEntry.Contains('key.stopPropagation()')) 'TUI prevents Select confirmation from being dispatched twice'
    Assert ($TuiEntry.Contains('function createActionSelect')) 'TUI gives every Select a direct activation callback'
    Assert ($TuiEntry.Contains('select.__jarockActivate = activate')) 'TUI stores the action callback on each Select'
    Assert ($TuiEntry.Contains('function selectMouseDown')) 'TUI defines an explicit Select mouse handler'
    Assert ($TuiEntry.Contains('activateBoundSelect(this)')) 'TUI mouse and Enter handlers execute the selected action'
    Assert ($TuiEntry.Contains('const offset = Math.max(0')) 'TUI mouse handler accounts for Select scrolling'
    Assert ($TuiEntry.Contains('onMouseDown: selectMouseDown')) 'TUI menus attach the explicit mouse handler'
    Assert ($TuiEntry.Contains('onKeyDown: selectKeyDown')) 'TUI menus attach the focused Enter handler'
    Assert (-not $TuiEntry.Contains('renderer.keyInput.on("keypress"')) 'TUI does not bypass focused controls through a global key listener'
    Assert (-not $Batch.Contains('set "TUI_EXIT_CODE=%errorlevel%"if not')) 'start-server.bat separates the TUI exit-code assignment from its conditional'
    Assert ($Batch.Contains('classic-console.bat" "Jarock classic console" "%~f0" /wait')) 'start-server.bat waits for the classic-console child and keeps terminal selection stable'
    $TuiSmoke = Get-Content -LiteralPath (Join-Path $Root 'tui/smoke.ts') -Raw
    Assert ($TuiSmoke.Contains('renderer.start()')) 'native OpenTUI smoke test explicitly starts the renderer loop'
    Assert ($TuiSmoke.Contains('useKittyKeyboard: null')) 'native OpenTUI smoke test disables Kitty keyboard sequences'
    Assert ($AutoRelease.Contains('Verify embedded Jarock icon')) 'auto-release verifies that the compiled TUI contains an icon resource'
    Assert ($AutoRelease.Contains('Verify standalone TUI release asset')) 'auto-release validates the standalone TUI executable before publishing'
    Assert ($AutoRelease.Contains("            .tui-artifact/jarock-tui.exe")) 'auto-release publishes jarock-tui.exe as a standalone release asset'
    Assert ($AutoRelease.Contains('tui/icons/icon48.ico')) 'auto-release selects the supplied 48px TUI ICO'
    Assert ($AutoRelease.Contains('Copy-Item -LiteralPath $source -Destination $target -Force')) 'auto-release copies the supplied TUI ICO without modifying it'
    Assert ($AutoRelease.Contains('sourceHash -ne $targetHash')) 'auto-release verifies the supplied TUI ICO byte-for-byte after copying'
    Assert ($AutoRelease.Contains('245a1bb1056c8293921bb7c3af79a277a148917e41e569bb8529593744571ed5')) 'auto-release pins the supplied TUI ICO SHA-256'
    Assert ($AutoRelease.Contains('selected TUI ICO must be 48x48')) 'auto-release validates the supplied TUI ICO dimensions'
    Assert ($AutoRelease.Contains('selected TUI ICO must use its supplied 24-bit legacy DIB')) 'auto-release validates the supplied TUI ICO format'
    Assert (-not $AutoRelease.Contains('scripts/png-to-ico.py')) 'auto-release does not regenerate the supplied TUI ICO'
    $Updater = Get-Content -LiteralPath (Join-Path $Root 'scripts/update-jarock.ps1') -Raw
    Assert ($Updater.Contains('Schedule-DeferredLauncherApply')) 'updater schedules the launcher replacement after startup exits'
    $PendingHelper = Get-Content -LiteralPath (Join-Path $Root 'scripts/apply-pending-launcher.ps1') -Raw
    Assert (Test-Path -LiteralPath (Join-Path $Root 'scripts/apply-pending-launcher.ps1') -PathType Leaf) 'deferred launcher helper is present'
    Assert ($Updater.Contains('apply-pending-launcher.ps1')) 'update packages require the deferred launcher helper'
    Assert ($PendingHelper.Contains('AddMinutes(10)')) 'deferred launcher helper has a bounded wait'
    $RunServer = Get-Content -LiteralPath (Join-Path $Root 'scripts/run-server.ps1') -Raw
    Assert ($RunServer.Contains('Get-Content -LiteralPath $ReadyBannerPath -Encoding UTF8')) 'run-server.ps1 reads the ready banner as UTF-8'
    Assert ($RunServer.Contains('function Get-WorldSeed')) 'run-server.ps1 can read the generated world seed'
    Assert ($RunServer.Contains('Write-Host "  seed:')) 'the ready status prints the seed before connection addresses'
    Assert ($RunServer.Contains('seed:')) 'runtime output seed fallback is recognized'
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
    Assert ($Updater.Contains('function Test-LocalSettingsPath')) 'the updater recognizes local launch settings as non-blocking'
    Assert ($Updater.Contains('status --porcelain=v1 -z')) 'the updater uses unambiguous Git status records'
    Assert ($Updater.Contains('function Test-LocalSettingsChange')) 'the updater filters local settings changes separately'
    Assert ($Updater.Contains('A rename involving any project file must remain blocking')) 'the updater keeps project-file renames blocking'
    Assert ($Updater.Contains('local scripts/server-launch-settings.ini file is preserved')) 'the updater explains that local settings do not block updates'
    Assert ($Updater.Contains('IsNullOrWhiteSpace($_)')) 'the updater ignores empty NUL-separated Git status records'

    New-Item -ItemType Directory -Force -Path $TempRoot | Out-Null
    $ChoiceHelperPath = Join-Path $TempRoot 'choice-u.bat'
    $ChoiceHelper = @'
@echo off
choice /c 1234567890XYIEU /n >nul
echo CHOICE=%errorlevel%
'@
    [IO.File]::WriteAllText($ChoiceHelperPath, $ChoiceHelper, (New-Object Text.UTF8Encoding($false)))
    $ChoiceOutput = @(& cmd.exe /d /c ('echo U|"' + $ChoiceHelperPath + '"') 2>&1 | ForEach-Object { [string]$_ })
    Assert ($ChoiceOutput -contains 'CHOICE=15') 'pressing U maps to the manual update-check branch'

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
