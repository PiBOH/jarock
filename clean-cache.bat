@echo off
setlocal EnableExtensions DisableDelayedExpansion
set "ROOT=%~dp0"
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"

rem Classic console guard: keep cache cleanup and its confirmation visible in
rem the classic Windows Console Host instead of a Windows Terminal pseudoconsole.
if defined _JAROCK_CLASSIC_CONSOLE goto :classic_console_ok
if not defined WT_SESSION goto :classic_console_ok
if not exist "%ROOT%\scripts\classic-console.bat" goto :classic_console_ok
set "_JAROCK_CLASSIC_CONSOLE=1"
call "%ROOT%\scripts\classic-console.bat" "Jarock cache cleanup" "%~f0" /wait
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
echo This removes inactive temporary files, downloads, backups and wrappers from .cache.
echo Active launcher runners are preserved so the current CLI or TUI session is not corrupted.
echo The server and all other Java applications must be stopped first.
echo.
choice /c YN /n /m "Clean the Jarock .cache directory? (Y/N): "
if errorlevel 2 (
    echo Cache cleanup cancelled. No files were changed.
    exit /b 0
)
if not errorlevel 1 (
    echo No valid choice was received. No files were changed.
    exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\clean-cache.ps1" -CacheDirectory "%ROOT%\.cache"
set "EXIT_CODE=%errorlevel%"
if not "%EXIT_CODE%"=="0" (
    echo.
    echo Cache cleanup failed. No commit or push was performed.
    pause
    exit /b %EXIT_CODE%
)
echo.
echo Cache cleanup completed. The repository, server runtime and world data were not changed.
pause
exit /b 0
