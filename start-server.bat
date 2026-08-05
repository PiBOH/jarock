@echo off
setlocal EnableExtensions
cd /d "%~dp0"

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\bootstrap-fabric.ps1"
if errorlevel 1 (
    echo.
    echo Bootstrap failed. Read the error above, fix the problem, and try again.
    pause
    exit /b 1
)

if not exist "%~dp0server\fabric-server-launch.jar" (
    echo Fabric server launcher was not created.
    pause
    exit /b 1
)

if not exist "%~dp0server\eula.txt" (
    echo.
    echo The server has not been started yet.
    echo Read server\eula.txt and change eula=false to eula=true only if you accept the Minecraft EULA.
    pause
    exit /b 1
)

findstr /r /c:"^eula=true$" "%~dp0server\eula.txt" >nul
if errorlevel 1 (
    echo.
    echo EULA is not accepted. Read server\eula.txt and set eula=true if you agree.
    pause
    exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\configure-geyser.ps1"
if errorlevel 1 (
    echo.
    echo Geyser configuration could not be updated. Fix the generated config and try again.
    pause
    exit /b 1
)

echo.
echo Starting Jarock Fabric server. No router or firewall changes are performed by this script.
echo Type "stop" in the server console to shut it down safely.
echo.
cd /d "%~dp0server"
java -Xms4G -Xmx4G -jar fabric-server-launch.jar nogui
set EXIT_CODE=%errorlevel%
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\configure-geyser.ps1"
if errorlevel 1 (
    echo.
    echo Warning: Geyser authentication could not be patched after shutdown.
    echo Check server\config\Geyser-Fabric\config.yml manually.
)
echo.
echo Server stopped with exit code %EXIT_CODE%.
pause
exit /b %EXIT_CODE%
