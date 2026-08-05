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

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\bootstrap-fabric.ps1"
if errorlevel 1 (
    echo.
    echo Bootstrap failed. The detailed error and suggested fix are above.
    pause
    exit /b 1
)

if not exist "%ROOT%\server\fabric-server-launch.jar" (
    echo ERROR: Fabric server launcher was not created.
    echo Suggested fix: verify Java 25, write permissions, Internet access, and that the repository was downloaded completely.
    pause
    exit /b 1
)

if not exist "%ROOT%\server\eula.txt" (
    echo ERROR: server\eula.txt does not exist.
    echo Suggested fix: run this file again. If it still fails, check that the repository folder is writable.
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
    echo If the config exists, set auth-type: floodgate manually and inspect the error above.
    pause
    exit /b 1
)

echo.
echo Starting Jarock Fabric server from:
echo   "%ROOT%\server"
echo No router or firewall changes are performed by this file.
echo Type "stop" in the server console to shut it down safely.
echo.
pushd "%ROOT%\server"
if errorlevel 1 (
    echo ERROR: Could not enter the generated server directory.
    echo Suggested fix: check folder permissions, drive availability, and Windows long-path support.
    popd
    pause
    exit /b 1
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\run-server.ps1" -ServerDirectory "%ROOT%\server"
set "EXIT_CODE=%errorlevel%"
popd

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\configure-geyser.ps1"
if errorlevel 1 (
    echo.
    echo WARNING: Geyser authentication could not be patched after shutdown.
    echo Suggested fix: open "%ROOT%\server\config\Geyser-Fabric\config.yml" and set auth-type: floodgate, then run this file again.
)
echo.
echo Server stopped with exit code %EXIT_CODE%.
if not "%EXIT_CODE%"=="0" (
    echo Suggested fix: inspect server\logs\latest.log and the newest server\crash-reports file.
    echo The first "Caused by:" line usually identifies the incompatible mod or missing dependency.
)
pause
exit /b %EXIT_CODE%
