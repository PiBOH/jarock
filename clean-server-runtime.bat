@echo off
setlocal EnableExtensions DisableDelayedExpansion
set "ROOT=%~dp0"
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"
set "SERVER=%ROOT%\server"

where powershell.exe >nul 2>&1
if errorlevel 1 (
    echo ERROR: Windows PowerShell was not found.
    echo Suggested fix: restore Windows PowerShell 5.1, then run this file again.
    pause
    exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\clean-server-runtime.ps1" -ServerDirectory "%SERVER%"
set "EXIT_CODE=%errorlevel%"
if not "%EXIT_CODE%"=="0" (
    echo.
    echo Cleanup failed. No commit or push was performed.
    pause
    exit /b %EXIT_CODE%
)

echo.
echo Cleanup completed. The server.jar, templates, README and mod manifest were preserved.
pause
exit /b 0
