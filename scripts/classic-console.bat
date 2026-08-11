@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem Usage: call "scripts\classic-console.bat" "Window title" "script path"
rem Spawns the given batch script in a NEW classic Windows Console Host window.
rem Windows Terminal hosts newly created console windows when it is the default
rem terminal application (HKCU\Console\DelegationConsole points at the Windows
rem Terminal CLSID). This helper temporarily points that value at the classic
rem console CLSID before spawning, then restores the previous value immediately,
rem so the new window always uses the classic console host and the console
rem close-event protection works.
if not exist "%~2" exit /b 1
set "_JAROCK_DELEGATION_HAD="
set "_JAROCK_DELEGATION_BACKUP="
reg query "HKCU\Console" /v DelegationConsole >nul 2>&1
if not errorlevel 1 (
    set "_JAROCK_DELEGATION_HAD=1"
    for /f "tokens=1,2,*" %%A in ('reg query "HKCU\Console" /v DelegationConsole ^| findstr /i "DelegationConsole"') do set "_JAROCK_DELEGATION_BACKUP=%%C"
)
reg add "HKCU\Console" /v DelegationConsole /t REG_SZ /d "{B23D10C0-E52E-411E-9D5B-C09FDF709C7D}" /f >nul 2>&1
start "%~1" "%ComSpec%" /d /c call "%~2"
if defined _JAROCK_DELEGATION_HAD (
    reg add "HKCU\Console" /v DelegationConsole /t REG_SZ /d "%_JAROCK_DELEGATION_BACKUP%" /f >nul 2>&1
) else (
    reg delete "HKCU\Console" /v DelegationConsole /f >nul 2>&1
)
exit /b 0
