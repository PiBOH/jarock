@echo off
setlocal EnableExtensions DisableDelayedExpansion
set "ROOT=%~dp0"
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"
set "SETTINGS=%ROOT%\scripts\server-launch-settings.ini"
set "TEMPLATE=%ROOT%\scripts\server-launch-settings.ini.template"
set "TEMP_SETTINGS=%TEMP%\Jarock-parameter-manager-%RANDOM%-%RANDOM%.ini"
set "CONFIG_ONLY=false"
if /i "%~1"=="/configure-only" set "CONFIG_ONLY=true"

where powershell.exe >nul 2>&1
if errorlevel 1 (
    echo ERROR: Windows PowerShell was not found.
    echo Suggested fix: restore Windows PowerShell 5.1 and run this file again.
    pause
    exit /b 1
)

if not exist "%SETTINGS%" if exist "%ROOT%\server-launch-settings.ini" (
    echo Migrating local launch settings to scripts\server-launch-settings.ini ...
    move /y "%ROOT%\server-launch-settings.ini" "%SETTINGS%" >nul
    if errorlevel 1 (
        echo ERROR: Could not migrate the existing local launch settings.
        echo Suggested fix: close editors or antivirus scans using the file, check permissions, and run parameter-manager.bat again.
        pause
        exit /b 1
    )
)
if not exist "%SETTINGS%" if not exist "%TEMPLATE%" (
    echo ERROR: The launch-settings template is missing.
    echo Suggested fix: restore scripts\server-launch-settings.ini.template from the repository.
    pause
    exit /b 1
)

if exist "%SETTINGS%" (
    copy /y "%SETTINGS%" "%TEMP_SETTINGS%" >nul
) else (
    copy /y "%TEMPLATE%" "%TEMP_SETTINGS%" >nul
)
if errorlevel 1 (
    echo ERROR: Could not create a temporary settings copy.
    echo Suggested fix: check the Windows temporary folder and repository permissions, then run this file again.
    pause
    exit /b 1
)

:menu
cls
echo ================================================
echo Jarock server parameter manager
echo ================================================
call :read_menu_values
set "PAD=                                                  "
echo   %OPT1%%PAD:~0,23%[%LOADER_TYPE%]
echo   %OPT2%%PAD:~0,34%[%RAM_INITIAL% / %RAM_MAX%]
echo   %OPT3%%PAD:~0,21%[%GUI_MODE%]
echo   %OPT4%%PAD:~0,14%[%GC_PROFILE%]
echo   %OPT5%%PAD:~0,3%[%AUTO_CONFIGURE_JAVA%]
echo   %OPT6%%PAD:~0,29%[%ONLINE_MODE%]
echo   %OPT7%%PAD:~0,28%[%SHOW_READY_BANNER%]
echo   %OPTI%%PAD:~0,31%[%IMPORT_SHOW%]
echo   %OPTE%%PAD:~0,31%[%EXPORT_SHOW%]
echo   %OPTY%%PAD:~0,30%[%AUTO_UPDATE_MODE%]
echo.
echo   %OPT8%%PAD:~0,22%[starts the server]
echo   %OPT9%%PAD:~0,34%[saves settings]
echo   %OPT0%%PAD:~0,28%[discards changes]
echo   %OPTX%%PAD:~0,28%[restores defaults]
echo.
if /i "%ONLINE_MODE%"=="false" echo  WARNING: online-mode=false disables Mojang authentication. Keep it for private testing only.
echo.
choice /c 1234567890XYIE /n /m "Choose an option: "
if errorlevel 14 goto export_world_menu
if errorlevel 13 goto import_world_menu
if errorlevel 12 goto update_mode_menu
if errorlevel 11 goto reset
if errorlevel 10 goto cancel_exit
if errorlevel 9 goto save_exit
if errorlevel 8 goto save_start
if errorlevel 7 goto banner_toggle
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
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-launch-setting.ps1" -SettingsPath "%TEMP_SETTINGS%" -Name LOADER_TYPE -Value neoforge
if errorlevel 1 pause
goto menu
:loader_fabric
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-launch-setting.ps1" -SettingsPath "%TEMP_SETTINGS%" -Name LOADER_TYPE -Value fabric
if errorlevel 1 pause
goto menu

:ram_menu
cls
echo Current values:
call :read_value RAM_INITIAL 4G
call :read_value RAM_MAX 4G
echo.
echo Enter values such as 4G or 6144M. Minimum is 1G.
set "NEW_INITIAL="
set /p "NEW_INITIAL=Initial RAM [%RAM_INITIAL%]: "
if not defined NEW_INITIAL set "NEW_INITIAL=%RAM_INITIAL%"
set "NEW_MAX="
set /p "NEW_MAX=Maximum RAM [%RAM_MAX%]: "
if not defined NEW_MAX set "NEW_MAX=%RAM_MAX%"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-launch-settings.ps1" -SettingsPath "%TEMP_SETTINGS%" -InitialMemory "%NEW_INITIAL%" -MaximumMemory "%NEW_MAX%"
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
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-launch-setting.ps1" -SettingsPath "%TEMP_SETTINGS%" -Name GUI_MODE -Value "%NEW_MODE%"
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
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-launch-setting.ps1" -SettingsPath "%TEMP_SETTINGS%" -Name GC_PROFILE -Value "%NEW_GC%"
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
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-launch-setting.ps1" -SettingsPath "%TEMP_SETTINGS%" -Name ONLINE_MODE -Value "%NEW_ONLINE_MODE%"
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
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-launch-setting.ps1" -SettingsPath "%TEMP_SETTINGS%" -Name AUTO_CONFIGURE_JAVA -Value "%NEW_JAVA%"
if errorlevel 1 pause
pause
goto menu

:update_mode_menu
cls
echo Startup update behavior:
echo 1. Check and install updates automatically
 echo    Contacts GitHub and installs a verified compatible Lite package before startup.
echo 2. Check updates only
 echo    Contacts GitHub and reports updates, but never installs anything.
echo 3. Do not check updates ^& do not install updates
 echo    Does not contact GitHub during startup.
echo.
choice /c 123 /n /m "Choose update mode: "
if errorlevel 3 goto update_mode_never
if errorlevel 2 goto update_mode_check
if errorlevel 1 goto update_mode_install
goto menu
:update_mode_install
set "NEW_UPDATE_MODE=install"
goto update_mode_save
:update_mode_check
set "NEW_UPDATE_MODE=check"
goto update_mode_save
:update_mode_never
set "NEW_UPDATE_MODE=never"
:update_mode_save
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-launch-setting.ps1" -SettingsPath "%TEMP_SETTINGS%" -Name AUTO_UPDATE_MODE -Value "%NEW_UPDATE_MODE%"
if errorlevel 1 pause
pause
goto menu

:banner_toggle
cls
call :read_value SHOW_READY_BANNER true
if /i "%SHOW_READY_BANNER%"=="true" (
    set "NEW_BANNER=false"
    echo The ready banner will be hidden when the server finishes loading.
) else (
    set "NEW_BANNER=true"
    echo The ready banner will be shown when the server finishes loading.
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-launch-setting.ps1" -SettingsPath "%TEMP_SETTINGS%" -Name SHOW_READY_BANNER -Value "%NEW_BANNER%"
if errorlevel 1 pause
pause
goto menu

:import_world_menu
cls
call :read_value WORLD_IMPORT_SOURCE ""
echo Current world import source: [%WORLD_IMPORT_SOURCE%]
echo.
echo Paste the full path of a world folder (containing level.dat) or a .zip world archive
echo that you want to import on the next start-server.bat run.
echo Leave empty and press Enter to open a folder picker.
echo Type CLEAR and press Enter to remove the import request.
set "NEW_IMPORT="
set /p "NEW_IMPORT=Import source: "
if /i "%NEW_IMPORT%"=="CLEAR" (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-launch-setting.ps1" -SettingsPath "%TEMP_SETTINGS%" -Name WORLD_IMPORT_SOURCE -Value ""
    if errorlevel 1 pause
    echo World import request removed.
    pause
    goto menu
)
if not defined NEW_IMPORT (
    for /f "delims=" %%P in ('powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\pick-folder.ps1" -Description "Select the world folder to import"') do set "NEW_IMPORT=%%P"
)
if not defined NEW_IMPORT (
    echo No folder was selected; the world import source was left unchanged.
    pause
    goto menu
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-launch-setting.ps1" -SettingsPath "%TEMP_SETTINGS%" -Name WORLD_IMPORT_SOURCE -Value "%NEW_IMPORT%"
if errorlevel 1 pause
echo World import source set. The world will be imported on the next start-server.bat run; if the world already exists you will be asked to confirm and a backup is created first.
pause
goto menu

:export_world_menu
cls
call :read_value WORLD_EXPORT_DEST ""
echo Current world export destination: [%WORLD_EXPORT_DEST%]
echo.
echo Paste the full path of a folder where the world should be copied after every
echo clean shutdown. The destination folder is overwritten (mirror copy) and must
echo be outside the server folder.
echo Leave empty and press Enter to open a folder picker.
echo Type CLEAR and press Enter to remove the export request.
set "NEW_EXPORT="
set /p "NEW_EXPORT=Export destination: "
if /i "%NEW_EXPORT%"=="CLEAR" (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-launch-setting.ps1" -SettingsPath "%TEMP_SETTINGS%" -Name WORLD_EXPORT_DEST -Value ""
    if errorlevel 1 pause
    echo World export request removed.
    pause
    goto menu
)
if not defined NEW_EXPORT (
    for /f "delims=" %%P in ('powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\pick-folder.ps1" -Description "Select the world export folder"') do set "NEW_EXPORT=%%P"
)
if not defined NEW_EXPORT (
    echo No folder was selected; the world export destination was left unchanged.
    pause
    goto menu
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-launch-setting.ps1" -SettingsPath "%TEMP_SETTINGS%" -Name WORLD_EXPORT_DEST -Value "%NEW_EXPORT%"
if errorlevel 1 pause
echo World export destination set. The world will be copied there after every clean shutdown.
pause
goto menu

:reset
copy /y "%TEMPLATE%" "%TEMP_SETTINGS%" >nul
if errorlevel 1 (
    echo ERROR: Could not restore safe defaults in the temporary settings copy.
    echo Suggested fix: check the template and temporary-folder permissions, then try again.
    pause
    goto menu
)
echo Safe defaults restored. Choose Save and exit or Save and start to keep them.
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
if errorlevel 1 exit /b 1
if /i "%CONFIG_ONLY%"=="true" exit /b 0
pause
exit /b 0

:cancel_exit
del /q "%TEMP_SETTINGS%" >nul 2>&1
echo No changes were saved. The existing server settings were left unchanged.
if /i "%CONFIG_ONLY%"=="true" echo First-run configuration was cancelled; run start-server.bat again when ready.
exit /b 2

:save
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\validate-launch-settings.ps1" -SettingsPath "%TEMP_SETTINGS%"
if errorlevel 1 (
    pause
    exit /b 1
)
copy /y "%TEMP_SETTINGS%" "%SETTINGS%" >nul
if errorlevel 1 (
    echo ERROR: Could not save the settings file.
    echo Suggested fix: check repository permissions, then choose Save again.
    pause
    exit /b 1
)
echo Settings saved:
 type "%SETTINGS%"
del /q "%TEMP_SETTINGS%" >nul 2>&1
exit /b 0

:read_menu_values
rem Initialize every displayed value before reading the temporary settings copy.
rem This keeps the menu usable even if a legacy or damaged settings file omits a key.
set "LOADER_TYPE=none"
set "RAM_INITIAL=4G"
set "RAM_MAX=4G"
set "GUI_MODE=nogui"
set "GC_PROFILE=default"
set "AUTO_CONFIGURE_JAVA=true"
set "ONLINE_MODE=true"
set "SHOW_READY_BANNER=true"
set "AUTO_UPDATE_CHECK=false"
set "HAS_AUTO_UPDATE_CHECK=false"
set "HAS_AUTO_UPDATE_MODE=false"
findstr /i /b /c:"AUTO_UPDATE_CHECK=" "%TEMP_SETTINGS%" >nul
if not errorlevel 1 set "HAS_AUTO_UPDATE_CHECK=true"
findstr /i /b /c:"AUTO_UPDATE_MODE=" "%TEMP_SETTINGS%" >nul
if not errorlevel 1 set "HAS_AUTO_UPDATE_MODE=true"
set "AUTO_UPDATE_MODE=install"
set "OPT1=1. Choose server mod loader"
set "OPT2=2. Configure RAM"
set "OPT3=3. Choose GUI or console mode"
set "OPT4=4. Choose garbage-collection profile"
set "OPT5=5. Toggle automatic user Java environment setup"
set "OPT6=6. Choose online-mode"
set "OPT7=7. Show ready banner"
set "OPTI=I. Import world"
set "OPTE=E. Export world"
set "OPT8=8. Save and start the server"
set "OPT9=9. Save and exit"
set "OPT0=0. Exit without saving"
set "OPTX=X. Reset safe defaults"
set "OPTY=Y. Choose startup update mode"
set "WORLD_IMPORT_SOURCE="
set "WORLD_EXPORT_DEST="
set "IMPORT_SHOW=none"
set "EXPORT_SHOW=none"
call :read_value LOADER_TYPE none
call :read_value RAM_INITIAL 4G
call :read_value RAM_MAX 4G
call :read_value GUI_MODE nogui
call :read_value GC_PROFILE default
call :read_value AUTO_CONFIGURE_JAVA true
call :read_value ONLINE_MODE true
call :read_value SHOW_READY_BANNER true
call :read_value AUTO_UPDATE_CHECK false
call :read_value AUTO_UPDATE_MODE install
call :read_value WORLD_IMPORT_SOURCE ""
call :read_value WORLD_EXPORT_DEST ""
if defined WORLD_IMPORT_SOURCE (set "IMPORT_SHOW=%WORLD_IMPORT_SOURCE%") else (set "IMPORT_SHOW=none")
if defined WORLD_EXPORT_DEST (set "EXPORT_SHOW=%WORLD_EXPORT_DEST%") else (set "EXPORT_SHOW=none")
if /i "%HAS_AUTO_UPDATE_MODE%"=="false" (
    if /i "%HAS_AUTO_UPDATE_CHECK%"=="true" if /i "%AUTO_UPDATE_CHECK%"=="true" set "AUTO_UPDATE_MODE=install"
    if /i "%HAS_AUTO_UPDATE_CHECK%"=="true" if /i "%AUTO_UPDATE_CHECK%"=="false" set "AUTO_UPDATE_MODE=never"
)
if /i not "%AUTO_UPDATE_MODE%"=="install" if /i not "%AUTO_UPDATE_MODE%"=="check" if /i not "%AUTO_UPDATE_MODE%"=="never" (
    set "AUTO_UPDATE_MODE=install"
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ROOT%\scripts\update-launch-setting.ps1" -SettingsPath "%TEMP_SETTINGS%" -Name AUTO_UPDATE_MODE -Value install >nul
)
rem An explicit AUTO_UPDATE_MODE always wins over the legacy boolean setting.
if /i "%HAS_AUTO_UPDATE_MODE%"=="false" if /i "%AUTO_UPDATE_MODE%"=="false" set "AUTO_UPDATE_MODE=never"
if /i "%AUTO_UPDATE_MODE%"=="true" set "AUTO_UPDATE_MODE=install"
exit /b 0

:read_value
rem Read one key from the temporary INI and keep the supplied default if absent.
set "%~1=%~2"
for /f "tokens=1,* delims==" %%A in ('findstr /b /c:"%~1=" "%TEMP_SETTINGS%" 2^>nul') do set "%~1=%%B"
exit /b 0
