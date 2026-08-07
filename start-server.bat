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

if not exist "%ROOT%\server-launch-settings.ini" (
    if not exist "%ROOT%\server-launch-settings.ini.template" (
        echo ERROR: The launch-settings template is missing.
        echo Suggested fix: restore server-launch-settings.ini.template from the repository.
        pause
        exit /b 1
    )
    copy /y "%ROOT%\server-launch-settings.ini.template" "%ROOT%\server-launch-settings.ini" >nul
)

findstr /i /r /c:"^AUTO_UPDATE_CHECK=true$" "%ROOT%\server-launch-settings.ini" >nul
if not errorlevel 1 (
    echo.
    echo ==> Checking for a newer Jarock release (read-only)
    echo This check never installs updates automatically and does not change server files.
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-jarock.ps1" -CheckOnly -NonInteractive
    if errorlevel 1 (
        echo WARNING: The automatic update check could not complete.
        echo Suggested fix: verify Internet access, or run update-jarock.bat manually when the server is stopped.
        echo Continuing with the server startup; no automatic update was installed.
    )
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

findstr /r /c:"^eula=true$" "%ROOT%\server\eula.txt" >nul
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
