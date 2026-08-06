@echo off
setlocal EnableExtensions DisableDelayedExpansion
set "ROOT=%~dp0"
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"
set "SETTINGS=%ROOT%\server-launch-settings.ini"
set "TEMPLATE=%ROOT%\server-launch-settings.ini.template"
set "CONFIG_ONLY=false"
if /i "%~1"=="/configure-only" set "CONFIG_ONLY=true"

where powershell.exe >nul 2>&1
if errorlevel 1 (
    echo ERROR: Windows PowerShell was not found.
    echo Suggested fix: restore Windows PowerShell 5.1 and run this file again.
    pause
    exit /b 1
)

if not exist "%SETTINGS%" (
    if not exist "%TEMPLATE%" (
        echo ERROR: The launch-settings template is missing.
        echo Suggested fix: restore server-launch-settings.ini.template from the repository.
        pause
        exit /b 1
    )
    copy /y "%TEMPLATE%" "%SETTINGS%" >nul
)

:menu
cls
echo ================================================
echo Jarock server parameter manager
echo ================================================
echo.
echo 1. Choose server mod loader
echo 2. Configure RAM
echo 3. Choose GUI or console mode
echo 4. Choose garbage-collection profile
echo 5. Toggle automatic user Java environment setup
echo 6. Choose online-mode (authentication)
echo 7. Save and start the server
echo 8. Save and exit
echo 9. Reset safe defaults
echo.
choice /c 123456789 /n /m "Choose an option: "
if errorlevel 9 goto reset
if errorlevel 8 goto save_exit
if errorlevel 7 goto save_start
if errorlevel 6 goto online_mode_menu
if errorlevel 5 goto java_toggle
if errorlevel 4 goto gc_menu
if errorlevel 3 goto mode_menu
if errorlevel 2 goto ram_menu
if errorlevel 1 goto loader_menu
goto menu

:loader_menu
cls
echo 1. Fabric (recommended first choice)
echo 2. NeoForge (fallback; official 26.2 beta installer)
echo 3. Forge (currently unavailable for official Minecraft 26.2)
echo.
choice /c 123 /n /m "Choose loader: "
if errorlevel 3 goto loader_forge
if errorlevel 2 goto loader_neoforge
if errorlevel 1 goto loader_fabric
:loader_forge
echo Forge is currently unavailable because no official Minecraft 26.2 server build is published for this bootstrap.
echo Choose Fabric or NeoForge instead.
pause
goto menu
:loader_neoforge
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-launch-setting.ps1" -SettingsPath "%SETTINGS%" -Name LOADER_TYPE -Value neoforge
if errorlevel 1 pause
goto menu
:loader_fabric
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-launch-setting.ps1" -SettingsPath "%SETTINGS%" -Name LOADER_TYPE -Value fabric
if errorlevel 1 pause
goto menu

:ram_menu
cls
echo Current values:
call :read_value RAM_INITIAL 4G
call :read_value RAM_MAX 4G
echo.
echo Enter values such as 4G or 6144M. Minimum is 512M.
set "NEW_INITIAL="
set /p "NEW_INITIAL=Initial RAM [%RAM_INITIAL%]: "
if not defined NEW_INITIAL set "NEW_INITIAL=%RAM_INITIAL%"
set "NEW_MAX="
set /p "NEW_MAX=Maximum RAM [%RAM_MAX%]: "
if not defined NEW_MAX set "NEW_MAX=%RAM_MAX%"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-launch-settings.ps1" -SettingsPath "%SETTINGS%" -InitialMemory "%NEW_INITIAL%" -MaximumMemory "%NEW_MAX%"
if errorlevel 1 (
    pause
    goto menu
)
goto menu

:mode_menu
cls
echo 1. Console mode (recommended): no graphical server window
echo 2. GUI mode: graphical Minecraft server window when supported
echo.
choice /c 12 /n /m "Choose mode: "
if errorlevel 2 goto mode_gui
if errorlevel 1 goto mode_nogui
:mode_gui
set "NEW_MODE=gui"
goto mode_save
:mode_nogui
set "NEW_MODE=nogui"
:mode_save
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-launch-setting.ps1" -SettingsPath "%SETTINGS%" -Name GUI_MODE -Value "%NEW_MODE%"
if errorlevel 1 pause
goto menu

:gc_menu
cls
echo 1. Default JVM garbage collector (recommended)
echo 2. Low-pause G1GC profile (test before production)
echo.
choice /c 12 /n /m "Choose profile: "
if errorlevel 2 goto gc_low_pause
if errorlevel 1 goto gc_default
:gc_default
set "NEW_GC=default"
goto gc_save
:gc_low_pause
set "NEW_GC=low-pause"
:gc_save
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-launch-setting.ps1" -SettingsPath "%SETTINGS%" -Name GC_PROFILE -Value "%NEW_GC%"
if errorlevel 1 pause
goto menu

:online_mode_menu
cls
echo 1. online-mode=true (recommended; authenticated Java accounts)
echo 2. online-mode=false (advanced/offline mode; unsafe for public servers without a trusted proxy)
echo.
choice /c 12 /n /m "Choose online-mode: "
if errorlevel 2 goto online_mode_false
if errorlevel 1 goto online_mode_true
:online_mode_true
set "NEW_ONLINE_MODE=true"
goto online_mode_save
:online_mode_false
set "NEW_ONLINE_MODE=false"
echo WARNING: online-mode=false disables normal Mojang account authentication.
echo Do not use it on a public server unless a trusted, correctly configured proxy handles authentication.
pause
:online_mode_save
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-launch-setting.ps1" -SettingsPath "%SETTINGS%" -Name ONLINE_MODE -Value "%NEW_ONLINE_MODE%"
if errorlevel 1 pause
goto menu

:java_toggle
cls
call :read_value AUTO_CONFIGURE_JAVA true
if /i "%AUTO_CONFIGURE_JAVA%"=="true" (
    set "NEW_JAVA=false"
    echo Automatic user Java environment setup will be disabled.
) else (
    set "NEW_JAVA=true"
    echo Automatic user Java environment setup will be enabled.
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-launch-setting.ps1" -SettingsPath "%SETTINGS%" -Name AUTO_CONFIGURE_JAVA -Value "%NEW_JAVA%"
if errorlevel 1 pause
pause
goto menu

:reset
copy /y "%TEMPLATE%" "%SETTINGS%" >nul
echo Safe defaults restored.
pause
goto menu

:save_start
call :save
if errorlevel 1 exit /b 1
if /i "%CONFIG_ONLY%"=="true" (
    echo Configuration-only mode: returning to the first-run bootstrap.
    exit /b 0
)
pushd "%ROOT%"
if errorlevel 1 (
    echo ERROR: Could not enter the repository folder before starting the server.
    echo Suggested fix: check folder permissions, drive availability, and the repository path.
    pause
    exit /b 1
)
start-server.bat
exit /b %errorlevel%

:save_exit
call :save
if /i "%CONFIG_ONLY%"=="true" exit /b %errorlevel%
pause
exit /b %errorlevel%

:save
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\validate-launch-settings.ps1" -SettingsPath "%SETTINGS%"
if errorlevel 1 (
    pause
    exit /b 1
)
echo Settings saved:
 type "%SETTINGS%"
exit /b 0

:read_value
for /f "tokens=1,* delims==" %%A in ('findstr /b /c:"%~1=" "%SETTINGS%" 2^>nul') do set "%~1=%%B"
if not defined %~1 set "%~1=%~2"
exit /b 0
