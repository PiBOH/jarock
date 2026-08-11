@echo off
setlocal EnableExtensions DisableDelayedExpansion
set "ROOT=%~dp0"
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"
set "SERVER=%ROOT%\server"
set "RESET_LOADER=false"

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
    echo Suggested fix: restore Windows PowerShell 5.1, then run this file again.
    pause
    exit /b 1
)

echo.
echo Reset the selected loader after cleanup?
echo Y = next start asks for Fabric or NeoForge again
echo N = keep the current loader selection
choice /c YN /n /m "Choose Y or N: "
if errorlevel 2 (
    set "RESET_LOADER=false"
) else if errorlevel 1 (
    set "RESET_LOADER=true"
) else (
    echo No valid choice was received. Keeping the current loader selection.
)

if /i "%RESET_LOADER%"=="true" (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\clean-server-runtime.ps1" -ServerDirectory "%SERVER%" -ResetLoader
) else (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\clean-server-runtime.ps1" -ServerDirectory "%SERVER%"
)
set "EXIT_CODE=%errorlevel%"
if not "%EXIT_CODE%"=="0" (
    echo.
    echo Cleanup failed. No commit or push was performed.
    pause
    exit /b %EXIT_CODE%
)

echo.
echo Cleanup completed. Repository templates, README and mod manifests were preserved.
if /i "%RESET_LOADER%"=="true" echo The loader selection was reset; the next start will ask you to choose Fabric or NeoForge again.
pause
exit /b 0
