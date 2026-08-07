@echo off
setlocal EnableExtensions DisableDelayedExpansion
set "ROOT=%~dp0"
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"

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

findstr /i /r /c:"^AUTO_UPDATE_CHECK=true$" "%SETTINGS%" >nul
if not errorlevel 1 call :startup_update_check

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

:startup_update_check
echo.
echo ==> Checking for a newer Jarock release
echo If a newer release is available, Jarock will ask whether to install it now.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-jarock.ps1" -PromptForUpdate
set "UPDATE_CHECK_EXIT_CODE=%errorlevel%"
if "%UPDATE_CHECK_EXIT_CODE%"=="1" echo WARNING: The startup update check could not complete.
if "%UPDATE_CHECK_EXIT_CODE%"=="1" echo Suggested fix: verify Internet access, or run scripts\update-jarock.bat manually when the server is stopped.
if "%UPDATE_CHECK_EXIT_CODE%"=="1" echo Continuing with the current Jarock version.
if "%UPDATE_CHECK_EXIT_CODE%"=="2" echo Update skipped. Continuing with the current Jarock version.
exit /b 0
