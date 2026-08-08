@echo off
setlocal EnableExtensions DisableDelayedExpansion

rem Run from an isolated copy so a startup self-update can safely replace this file.
rem cmd.exe reads batch files by position; replacing the active file otherwise makes
rem it execute random fragments of the new file (for example, "Internet" or "install").
if /i "%~nx0"=="start-server-runner.bat" if defined _JAROCK_RUNNER_ROOT goto :runner_start
set "ROOT=%~dp0"
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"
if not exist "%ROOT%\.cache" mkdir "%ROOT%\.cache" >nul 2>&1
if exist "%ROOT%\.cache\start-server-runner.bat" del /q "%ROOT%\.cache\start-server-runner.bat" >nul 2>&1
copy /y "%~f0" "%ROOT%\.cache\start-server-runner.bat" >nul 2>&1
if not exist "%ROOT%\.cache\start-server-runner.bat" goto :runner_fallback
set "_JAROCK_RUNNER_ROOT=%ROOT%"
"%ROOT%\.cache\start-server-runner.bat" %*
set "RUNNER_EXIT_CODE=%errorlevel%"
exit /b %RUNNER_EXIT_CODE%

:runner_fallback
echo ERROR: Could not create the isolated startup runner.
echo Suggested fix: check that the repository is writable and that antivirus software is not blocking the .cache folder, then run start-server.bat again.
echo The server was not started because automatic updates cannot be made safe without the isolated runner.
pause
exit /b 1

:runner_start
if defined _JAROCK_RUNNER_ROOT set "ROOT=%_JAROCK_RUNNER_ROOT%"

where powershell.exe >nul 2>&1
if errorlevel 1 (
    echo ERROR: Windows PowerShell was not found.
    echo Suggested fix: restore Windows PowerShell 5.1 or install PowerShell 7, then run this file again.
    pause
    exit /b 1
)

set "SETTINGS=%ROOT%\scripts\server-launch-settings.ini"
set "TEMPLATE=%ROOT%\scripts\server-launch-settings.ini.template"
if not exist "%SETTINGS%" if exist "%ROOT%\server-launch-settings.ini" (
    echo Migrating local launch settings to scripts\server-launch-settings.ini ...
    move /y "%ROOT%\server-launch-settings.ini" "%SETTINGS%" >nul
    if errorlevel 1 (
        echo ERROR: Could not migrate the existing local launch settings.
        echo Suggested fix: close editors or antivirus scans using the file, check permissions, and run start-server.bat again.
        pause
        exit /b 1
    )
)
if not exist "%SETTINGS%" (
    if not exist "%TEMPLATE%" (
        echo ERROR: The launch-settings template is missing.
        echo Suggested fix: restore scripts\server-launch-settings.ini.template from the repository.
        pause
        exit /b 1
    )
    copy /y "%TEMPLATE%" "%SETTINGS%" >nul
)

rem Read the setting value through FOR /F so CRLF and LF files behave identically.
rem Comparing the value separately also prevents invalid prefixes such as installXYZ.
set "STARTUP_UPDATE_MODE="
set "LEGACY_AUTO_UPDATE_CHECK="
set "STARTUP_UPDATE_MODE_RECOGNIZED=false"
for /f "tokens=1,* delims==" %%A in ('findstr /i /b /c:"AUTO_UPDATE_MODE=" "%SETTINGS%"') do if /i "%%A"=="AUTO_UPDATE_MODE" set "STARTUP_UPDATE_MODE=%%B"
for /f "tokens=1,* delims==" %%A in ('findstr /i /b /c:"AUTO_UPDATE_CHECK=" "%SETTINGS%"') do if /i "%%A"=="AUTO_UPDATE_CHECK" set "LEGACY_AUTO_UPDATE_CHECK=%%B"
if /i "%STARTUP_UPDATE_MODE%"=="install" set "STARTUP_UPDATE_MODE_RECOGNIZED=true"
if /i "%STARTUP_UPDATE_MODE%"=="check" set "STARTUP_UPDATE_MODE_RECOGNIZED=true"
if /i "%STARTUP_UPDATE_MODE%"=="never" set "STARTUP_UPDATE_MODE_RECOGNIZED=true"
if /i "%STARTUP_UPDATE_MODE%"=="install" call :startup_update_install
if /i "%STARTUP_UPDATE_MODE%"=="check" call :startup_update_check_only
if /i "%STARTUP_UPDATE_MODE%"=="never" call :startup_update_never
rem A legacy boolean is honored only when AUTO_UPDATE_MODE is absent.
if not defined STARTUP_UPDATE_MODE (
    if /i "%LEGACY_AUTO_UPDATE_CHECK%"=="true" call :startup_update_install
    if /i "%LEGACY_AUTO_UPDATE_CHECK%"=="false" call :startup_update_never
    if not defined LEGACY_AUTO_UPDATE_CHECK call :startup_update_install
)
rem A malformed explicit mode must not silently skip the update check.
if defined STARTUP_UPDATE_MODE if /i "%STARTUP_UPDATE_MODE_RECOGNIZED%"=="false" (
    echo WARNING: Invalid AUTO_UPDATE_MODE "%STARTUP_UPDATE_MODE%"; using the safe default install mode.
    call :startup_update_install
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\bootstrap-server.ps1"
set "BOOTSTRAP_EXIT_CODE=%errorlevel%"
if "%BOOTSTRAP_EXIT_CODE%"=="2" (
    echo.
    echo Setup cancelled. No parameter changes were saved and the server was not started.
    pause
    exit /b 2
)
if not "%BOOTSTRAP_EXIT_CODE%"=="0" (
    echo.
    echo Bootstrap failed. The detailed error and suggested fix are above.
    pause
    exit /b %BOOTSTRAP_EXIT_CODE%
)

if not exist "%ROOT%\server\eula.txt" (
    echo ERROR: server\eula.txt does not exist.
    echo Suggested fix: run this file again and check that the repository is writable.
    pause
    exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\validate-eula.ps1" -Path "%ROOT%\server\eula.txt" >nul
if errorlevel 1 (
    echo.
    echo ERROR: The Minecraft EULA has not been accepted.
    echo Suggested fix: read https://www.minecraft.net/eula, then edit:
    echo   "%ROOT%\server\eula.txt"
    echo Change eula=false to eula=true only if you agree, then run this file again.
    pause
    exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\configure-geyser.ps1"
if errorlevel 1 (
    echo.
    echo ERROR: Geyser configuration could not be updated.
    echo Suggested fix: start the server once so Geyser can generate its config, then run this file again.
    pause
    exit /b 1
)

echo.
echo Starting Jarock server from:
echo   "%ROOT%\server"
echo No router or firewall changes are performed by this file.
echo Type "stop" in the server console to shut it down safely.
echo IMPORTANT: after typing "stop", do not close this window yet.
echo Wait for the final "SAFE TO CLOSE" message after Minecraft finishes saving the world.
echo Do not double-click server\server.jar directly: Windows may use an older Java association.
echo The classic console close button is protected while Jarock is running.
echo Type "stop" (or close the Minecraft GUI normally) and wait for "SAFE TO CLOSE" before closing this window.
echo.
pushd "%ROOT%\server"
if errorlevel 1 (
    echo ERROR: Could not enter the server directory.
    echo Suggested fix: check folder permissions, drive availability and Windows long-path support.
    popd
    pause
    exit /b 1
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\run-server.ps1" -ServerDirectory "%ROOT%\server"
set "EXIT_CODE=%errorlevel%"
popd

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\configure-geyser.ps1"
set "GEYSER_EXIT_CODE=%errorlevel%"
if not "%GEYSER_EXIT_CODE%"=="0" (
    echo.
    echo WARNING: Geyser authentication could not be patched after shutdown.
    echo Suggested fix: inspect the generated Geyser config and set auth-type: floodgate, then run this file again.
)
echo.
echo Server stopped with exit code %EXIT_CODE%.
if "%EXIT_CODE%"=="0" (
    echo CLEAN SHUTDOWN COMPLETE: Minecraft finished saving the world and exited normally.
    if "%GEYSER_EXIT_CODE%"=="0" (
        echo SAFE TO CLOSE: You may now close this window.
    ) else (
        echo SAFE TO CLOSE: The world was saved; you may now close this window after reviewing the Geyser warning above.
    )
) else (
    echo NOT SAFE TO ASSUME: Minecraft did not exit normally.
    echo Suggested fix: inspect server\logs\latest.log and the newest server\crash-reports file before restarting.
    echo The first "Caused by:" line usually identifies the incompatible mod or missing dependency.
)
pause
exit /b %EXIT_CODE%

:startup_update_install
echo.
echo ^==^> Checking for and installing Jarock updates automatically
echo The verified Lite package will be installed before the server starts when a newer compatible release exists.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-jarock.ps1" -NonInteractive -StartupUpdate
set "UPDATE_CHECK_EXIT_CODE=%errorlevel%"
if "%UPDATE_CHECK_EXIT_CODE%"=="1" echo WARNING: The automatic startup update could not complete.
if "%UPDATE_CHECK_EXIT_CODE%"=="1" echo Suggested fix: verify Internet access and repository safety, or choose Check updates only in parameter-manager.bat.
if "%UPDATE_CHECK_EXIT_CODE%"=="2" echo Update was not applied. Continuing with the current Jarock version.
exit /b 0

:startup_update_check_only
echo.
echo ^==^> Checking for Jarock updates (no installation)
echo This read-only check runs before the server bootstrap and never changes files.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-jarock.ps1" -CheckOnly
set "UPDATE_CHECK_EXIT_CODE=%errorlevel%"
if "%UPDATE_CHECK_EXIT_CODE%"=="1" echo WARNING: The read-only startup update check could not complete.
if "%UPDATE_CHECK_EXIT_CODE%"=="1" echo Suggested fix: verify Internet access, or choose Do not check updates in parameter-manager.bat.
if "%UPDATE_CHECK_EXIT_CODE%"=="2" echo A newer release was found, but no files were changed.
exit /b 0

:startup_update_never
echo.
echo ^==^> Startup update check disabled
echo GitHub will not be contacted and no update will be installed before startup.
exit /b 0
