@echo off
setlocal EnableExtensions DisableDelayedExpansion
set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
for %%I in ("%SCRIPT_DIR%\..") do set "ROOT=%%~fI"

rem Classic console guard: Windows Terminal hosts console apps in a pseudoconsole
rem that cannot deliver the console close-event protection and can hide the
rem SAFE TO CLOSE shutdown flow. When this launcher is started from Windows
rem Terminal, restart it in the classic Windows Console Host first.
if defined _JAROCK_CLASSIC_CONSOLE goto :classic_console_ok
if not defined WT_SESSION goto :classic_console_ok
if not exist "%ROOT%\scripts\classic-console.bat" goto :classic_console_ok
set "_JAROCK_CLASSIC_CONSOLE=1"
call "%ROOT%\scripts\classic-console.bat" "Jarock classic console" "%~f0"
echo.
echo Jarock was relaunched in the classic Windows console because it was started from Windows Terminal.
exit /b 0
:classic_console_ok
where powershell.exe >nul 2>&1
if errorlevel 1 (
    echo ERROR: Windows PowerShell was not found.
    echo Suggested fix: restore Windows PowerShell 5.1 or install PowerShell 7, then run this file again.
    pause
    exit /b 1
)

if not exist "%SCRIPT_DIR%\update-jarock.ps1" (
    echo ERROR: The Jarock updater script is missing.
    echo Suggested fix: restore scripts\update-jarock.ps1 from the repository or release package.
    pause
    exit /b 1
)

echo.
echo Jarock updater
echo Do not run this file while the server is running.
echo The updater uses the Lite release package because this installation already has its prerequisites.
echo Java installers are not downloaded, reinstalled or removed by an update.
echo The updater preserves the world, server runtime, mods, libraries and local settings.
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%\update-jarock.ps1"
set "EXIT_CODE=%errorlevel%"
echo.
if "%EXIT_CODE%"=="0" (
    echo Update check completed successfully.
) else if "%EXIT_CODE%"=="2" (
    echo Update cancelled. No files were changed.
) else (
    echo Update failed. Read the error and Suggested fix above.
)
pause
exit /b %EXIT_CODE%
