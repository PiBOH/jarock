[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$Root = [IO.Path]::GetFullPath((Split-Path -Parent $PSScriptRoot))
$ServerDir = Join-Path $Root 'server'
$ModsDir = Join-Path $ServerDir 'mods'
$SettingsPath = Join-Path $Root 'server-launch-settings.ini'
$MinecraftVersion = '26.2'
$JavaMinimum = 25
$FabricInstallerUrl = 'https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.1.2/fabric-installer-1.1.2.jar'
$FabricInstallerSha512 = '3cbe7b69498c44d814fc95e71cd9ce9c12c45a9e1dcf01085cb3e9aaf6fe63134b701065167be1fa6e4c2df19dfa5400bc5b6b1b7fb5e99e334d24dcdca55c20'
$FabricLoaderVersion = '0.19.3'
$NeoForgeInstallerUrl = 'https://maven.neoforged.net/releases/net/neoforged/neoforge/26.2.0.48-beta/neoforge-26.2.0.48-beta-installer.jar'
$NeoForgeInstallerSha512 = '336b2010e133639b576a2848bf667a59e64e744bfce527d9262059819dcfb0957f0b3d24e35847df056ebe865c3913ec4df61e72bae3f673311c4f42a626d8e7'
$LoaderMarkerPath = Join-Path $ServerDir 'jarock-loader.txt'
$JavaRuntimeScript = Join-Path $PSScriptRoot 'java-runtime.ps1'
. $JavaRuntimeScript

function Write-Step([string]$Message) { Write-Host "`n==> $Message" -ForegroundColor Cyan }
function Stop-WithGuidance([string]$Message, [string]$Action) {
    Write-Host "`nERROR: $Message" -ForegroundColor Red
    Write-Host "Suggested fix: $Action" -ForegroundColor Yellow
    Write-Host 'The server was not started. No router, firewall, or port-forwarding changes were made.' -ForegroundColor Yellow
    exit 1
}
function Read-Settings {
    $Values = @{}
    if (Test-Path -LiteralPath $SettingsPath -PathType Leaf) {
        foreach ($Line in Get-Content -LiteralPath $SettingsPath) {
            if ($Line -match '^\s*([A-Z_]+)=(.*?)\s*$') { $Values[$Matches[1]] = $Matches[2] }
        }
    }
    return $Values
}
function Save-Loader([string]$Loader) {
    $Content = Get-Content -LiteralPath $SettingsPath -Raw
    $Pattern = '(?m)^LOADER_TYPE=.*$'
    if ($Content -match $Pattern) { $Content = [regex]::Replace($Content, $Pattern, "LOADER_TYPE=$Loader") }
    else { $Content = $Content.TrimEnd("`r", "`n") + "`r`nLOADER_TYPE=$Loader`r`n" }
    Set-Content -LiteralPath $SettingsPath -Value $Content -Encoding UTF8
}
function Select-Loader {
    $Values = Read-Settings
    $Loader = if ($Values.ContainsKey('LOADER_TYPE')) { ([string]$Values['LOADER_TYPE']).ToLowerInvariant() } else { 'none' }
    if ($Loader -in @('fabric','forge','neoforge')) {
        Write-Host "Configured loader: $Loader" -ForegroundColor Green
        return $Loader
    }
    Write-Host ''
    Write-Host 'No server loader is configured yet.' -ForegroundColor Yellow
    Write-Host '1. Fabric (recommended first choice)'
    Write-Host '2. NeoForge (fallback; official 26.2 beta installer)'
    Write-Host '3. Forge (not available for Minecraft 26.2 from the official source currently)'
    $Choice = Read-Host 'Choose a loader (1/2/3)'
    switch ($Choice) {
        '1' { $Loader = 'fabric' }
        '2' { $Loader = 'neoforge' }
        '3' { $Loader = 'forge' }
        default { Stop-WithGuidance "Invalid loader choice '$Choice'." 'Run start-server.bat again and type 1, 2 or 3.' }
    }
    $OriginalSettingsContent = Get-Content -LiteralPath $SettingsPath -Raw
    Save-Loader $Loader
    Write-Host "Selected loader for this setup: $Loader" -ForegroundColor Green
    $OpenManager = Read-Host 'Open parameter-manager.bat now before continuing? (Y/N)'
    if ($OpenManager -match '^(?i:y|yes)$') {
        $Manager = Join-Path $Root 'parameter-manager.bat'
        if (-not (Test-Path -LiteralPath $Manager -PathType Leaf)) { Stop-WithGuidance 'parameter-manager.bat is missing.' 'Restore it from the repository and run start-server.bat again.' }
        Write-Host 'Opening parameter-manager.bat in a separate Windows command window. Choose Save and exit to continue, or Exit without saving to cancel.' -ForegroundColor Cyan
        $ManagerCommand = 'call "' + $Manager.Replace('"', '""') + '" /configure-only'
        try {
            $ManagerProcess = Start-Process -FilePath $env:ComSpec -ArgumentList @('/d', '/c', $ManagerCommand) -WorkingDirectory $Root -Wait -PassThru -ErrorAction Stop
        }
        catch {
            Set-Content -LiteralPath $SettingsPath -Value $OriginalSettingsContent -Encoding UTF8
            Stop-WithGuidance "Could not open parameter-manager.bat: $($_.Exception.Message)" 'Open parameter-manager.bat manually from the repository root, choose Save and exit, then run start-server.bat again. Exit without saving cancels this first-run setup.'
        }
        if ($ManagerProcess.ExitCode -eq 2) {
            Set-Content -LiteralPath $SettingsPath -Value $OriginalSettingsContent -Encoding UTF8
            Write-Host 'Setup cancelled. No parameter changes were saved and the server was not started.' -ForegroundColor Yellow
            exit 2
        }
        if ($ManagerProcess.ExitCode -ne 0) {
            Set-Content -LiteralPath $SettingsPath -Value $OriginalSettingsContent -Encoding UTF8
            Stop-WithGuidance "parameter-manager.bat did not finish successfully (exit code $($ManagerProcess.ExitCode))." 'Open parameter-manager.bat manually, save valid settings with Save and exit, then run start-server.bat again. Do not choose Exit without saving if you want to continue this first-run setup.'
        }
        $Values = Read-Settings
        if ($Values.ContainsKey('LOADER_TYPE')) { $Loader = ([string]$Values['LOADER_TYPE']).ToLowerInvariant() }
        if ($Loader -eq 'none') { $Loader = Select-Loader }
        if ($Loader -notin @('fabric','forge','neoforge')) { Stop-WithGuidance "The parameter manager did not save a valid loader ('$Loader')." 'Choose Fabric or NeoForge, choose Save and exit, then run start-server.bat again.' }
    }
    return $Loader
}
function Get-SelectedJava {
    $Result = Find-CompatibleJava -MinimumMajor $JavaMinimum
    if ($null -eq $Result.Selected) {
        $Details = if ($Result.Inspected.Count -gt 0) { (($Result.Inspected | ForEach-Object { "$($_.Path) -> Java $($_.Major), 64-bit=$($_.Is64Bit)" }) -join '; ') } else { 'No usable Java executable was found.' }
        Stop-WithGuidance "No compatible 64-bit Java $JavaMinimum+ runtime was found. Detected candidates: $Details" 'Install a 64-bit Java 25+ JDK, set java-home.txt to its JDK folder if necessary, close and reopen the terminal, then run start-server.bat again.'
    }
    $JavaPathFile = Join-Path $ServerDir 'java-path.txt'
    [IO.File]::WriteAllText($JavaPathFile, $Result.Selected.Path, (New-Object Text.UTF8Encoding($false)))
    Write-Host "Selected Java: $($Result.Selected.Path) ($($Result.Selected.Version), 64-bit=$($Result.Selected.Is64Bit))" -ForegroundColor Green
    return $Result.Selected
}
function Get-Sha512([string]$Path) { return (Get-FileHash -Algorithm SHA512 -LiteralPath $Path).Hash.ToLowerInvariant() }
function Download-AndVerify([string]$Url, [string]$Path, [string]$Hash) {
    try {
        if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
            Write-Host "Downloading $([IO.Path]::GetFileName($Path)) ..."
            Invoke-WebRequest -Uri $Url -OutFile $Path -Headers @{ 'User-Agent' = 'Jarock-loader-bootstrap' } -UseBasicParsing
        }
        if ((Get-Sha512 $Path) -ne $Hash.ToLowerInvariant()) {
            Remove-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
            throw "SHA-512 verification failed for $Path; the invalid file was removed."
        }
    }
    catch { Stop-WithGuidance $_.Exception.Message 'Check Internet access, disk permissions and antivirus/proxy interference, then run start-server.bat again.' }
}
function Confirm-LoaderChange([string]$Loader) {
    $RuntimeArtifacts = @(
        (Join-Path $ServerDir 'server.jar'),
        (Join-Path $ServerDir 'vanilla-server.jar'),
        (Join-Path $ServerDir 'fabric-server-launch.jar'),
        (Join-Path $ServerDir 'run.bat'),
        (Join-Path $ServerDir 'libraries'),
        (Join-Path $ServerDir 'mods')
    )
    $HasRuntimeArtifacts = @($RuntimeArtifacts | Where-Object { Test-Path -LiteralPath $_ }).Count -gt 0
    if (-not (Test-Path -LiteralPath $LoaderMarkerPath -PathType Leaf) -and $HasRuntimeArtifacts) {
        Stop-WithGuidance 'A previous or incomplete loader runtime was found without a Jarock loader marker.' 'Back up the world if needed, run clean-server-runtime.bat, then start again so the loader can be selected safely.'
    }
    if (Test-Path -LiteralPath $LoaderMarkerPath -PathType Leaf) {
        $Previous = (Get-Content -LiteralPath $LoaderMarkerPath -Raw).Trim().ToLowerInvariant()
        if ($Previous -eq 'fabric' -and ((-not (Test-Path -LiteralPath (Join-Path $ServerDir 'server.jar') -PathType Leaf)) -or (-not (Test-Path -LiteralPath (Join-Path $ServerDir 'vanilla-server.jar') -PathType Leaf)) -or (-not (Test-FabricLauncher (Join-Path $ServerDir 'server.jar'))) -or (-not (Test-VanillaServerJar (Join-Path $ServerDir 'vanilla-server.jar'))))) {
            Stop-WithGuidance 'The saved Fabric loader marker exists but its runtime files are incomplete or invalid.' 'Run clean-server-runtime.bat after making a backup, then run start-server.bat again.'
        }
        if ($Previous -eq 'neoforge' -and ((-not (Test-Path -LiteralPath (Join-Path $ServerDir 'run.bat') -PathType Leaf)) -or (-not (Test-Path -LiteralPath (Join-Path $ServerDir 'libraries') -PathType Container)))) {
            Stop-WithGuidance 'The saved NeoForge loader marker exists but its runtime files are incomplete.' 'Run clean-server-runtime.bat after making a backup, then run start-server.bat again.'
        }
        if ($Previous -and $Previous -ne $Loader) {
            $Confirm = Read-Host "The server was previously configured for '$Previous'. Changing to '$Loader' can require a backup and cleanup. Continue? (Y/N)"
            if ($Confirm -notmatch '^(?i:y|yes)$') { Stop-WithGuidance 'Loader change cancelled.' 'Keep the existing loader or make a backup, run clean-server-runtime.bat, then try again.' }
            Stop-WithGuidance "The server is configured for '$Previous', but '$Loader' was selected." 'Back up the world, run clean-server-runtime.bat, then select the new loader again. This prevents incompatible runtimes and mods from being mixed.'
        }
    }
}
function Write-LoaderMarker([string]$Loader) { [IO.File]::WriteAllText($LoaderMarkerPath,$Loader,(New-Object Text.UTF8Encoding($false))) }
function Ensure-LocalTemplates {
    $EulaPath = Join-Path $ServerDir 'eula.txt'
    $EulaTemplate = Join-Path $ServerDir 'eula.txt.template'
    if (-not (Test-Path -LiteralPath $EulaPath -PathType Leaf)) {
        if (-not (Test-Path -LiteralPath $EulaTemplate -PathType Leaf)) { Stop-WithGuidance 'The EULA template is missing.' 'Restore server/eula.txt.template from the repository and run start-server.bat again.' }
        Copy-Item -LiteralPath $EulaTemplate -Destination $EulaPath
        Write-Host 'Created server/eula.txt from the tracked template.' -ForegroundColor Green
    }
    $PropertiesPath = Join-Path $ServerDir 'server.properties'
    $PropertiesTemplate = Join-Path $ServerDir 'server.properties.template'
    if (-not (Test-Path -LiteralPath $PropertiesPath -PathType Leaf)) {
        if (-not (Test-Path -LiteralPath $PropertiesTemplate -PathType Leaf)) { Stop-WithGuidance 'The server.properties template is missing.' 'Restore server/server.properties.template from the repository and run start-server.bat again.' }
        Copy-Item -LiteralPath $PropertiesTemplate -Destination $PropertiesPath
        Write-Host 'Created server.properties from the tracked template.' -ForegroundColor Green
    }
}
function Test-VanillaServerJar([string]$Path) {
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction SilentlyContinue
        $Archive = [IO.Compression.ZipFile]::OpenRead($Path)
        try {
            $ManifestEntry = $Archive.GetEntry('META-INF/MANIFEST.MF')
            $VersionEntry = $Archive.GetEntry('version.json')
            if ($null -eq $ManifestEntry -or $null -eq $VersionEntry) { return $false }
            $Reader = New-Object IO.StreamReader($ManifestEntry.Open())
            try { $Manifest = $Reader.ReadToEnd() } finally { $Reader.Dispose() }
            return ($Manifest -match '(?m)^Main-Class:\s*net\.minecraft\.bundler\.Main\s*$')
        } finally { $Archive.Dispose() }
    } catch { return $false }
}
function Set-FabricVanillaJarReference {
    $PropertiesPath = Join-Path $ServerDir 'fabric-server-launcher.properties'
    if (-not (Test-Path -LiteralPath $PropertiesPath -PathType Leaf)) {
        Stop-WithGuidance 'Fabric launcher metadata is missing: fabric-server-launcher.properties.' 'Run clean-server-runtime.bat, then run start-server.bat again to reinstall Fabric safely.'
    }
    $Content = Get-Content -LiteralPath $PropertiesPath -Raw
    $Pattern = '(?m)^serverJar=.*$'
    if ($Content -match $Pattern) {
        $Content = [regex]::Replace($Content, $Pattern, 'serverJar=vanilla-server.jar')
    }
    else {
        $Content = $Content.TrimEnd("`r", "`n") + "`r`nserverJar=vanilla-server.jar`r`n"
    }
    [IO.File]::WriteAllText($PropertiesPath, $Content, (New-Object Text.UTF8Encoding($false)))
    $WrittenContent = Get-Content -LiteralPath $PropertiesPath -Raw
    if ($WrittenContent -notmatch '(?m)^serverJar=vanilla-server\.jar[ \t]*$') {
        Stop-WithGuidance 'Fabric launcher metadata could not be repaired: serverJar is not vanilla-server.jar.' 'Run clean-server-runtime.bat, then run start-server.bat again to reinstall Fabric safely.'
    }
    Write-Host 'Fabric launcher metadata now points to vanilla-server.jar.' -ForegroundColor Green
}
function Test-FabricLauncher([string]$Path) {
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction SilentlyContinue
        $Archive = [IO.Compression.ZipFile]::OpenRead($Path)
        try {
            $ManifestEntry = $Archive.GetEntry('META-INF/MANIFEST.MF')
            if ($null -eq $ManifestEntry) { return $false }
            $Reader = New-Object IO.StreamReader($ManifestEntry.Open())
            try { return ($Reader.ReadToEnd() -match '(?m)^Main-Class:\s*net\.fabricmc\.loader\.impl\.launch\.server\.FabricServerLauncher\s*$') } finally { $Reader.Dispose() }
        } finally { $Archive.Dispose() }
    } catch { return $false }
}
function Install-Fabric($Java) {
    $VanillaJar = Join-Path $ServerDir 'server.jar'
    $LocalVanillaJar = Join-Path $ServerDir 'vanilla-server.jar'
    if ((Test-Path -LiteralPath $VanillaJar -PathType Leaf) -and (Test-Path -LiteralPath $LocalVanillaJar -PathType Leaf) -and (Test-FabricLauncher $VanillaJar)) {
        Set-FabricVanillaJarReference
        Write-Host 'Existing Fabric server.jar launcher and vanilla-server.jar are valid; reusing them.' -ForegroundColor Green
        return
    }
    $Installer = Join-Path $ServerDir 'fabric-installer-1.1.2.jar'
    Download-AndVerify $FabricInstallerUrl $Installer $FabricInstallerSha512
    if (-not (Test-Path -LiteralPath (Join-Path $ServerDir 'fabric-server-launch.jar') -PathType Leaf)) {
        Push-Location $ServerDir
        try { & $Java.Path -jar $Installer server -mcversion $MinecraftVersion -loader $FabricLoaderVersion -downloadMinecraft } finally { Pop-Location }
        if ($LASTEXITCODE -ne 0) { Stop-WithGuidance "Fabric installer exited with code $LASTEXITCODE." 'Confirm Java 25, Internet access and free disk space, then run start-server.bat again.' }
    }
    $VanillaJar = Join-Path $ServerDir 'server.jar'
    $LocalVanillaJar = Join-Path $ServerDir 'vanilla-server.jar'
    if (-not (Test-Path -LiteralPath $VanillaJar -PathType Leaf) -and -not (Test-Path -LiteralPath $LocalVanillaJar -PathType Leaf)) { Stop-WithGuidance 'Fabric did not create the vanilla Minecraft engine.' 'Delete only the incomplete Fabric runtime and run start-server.bat again.' }
    if ((Test-Path -LiteralPath $VanillaJar -PathType Leaf) -and -not (Test-Path -LiteralPath $LocalVanillaJar -PathType Leaf)) {
        if (-not (Test-VanillaServerJar $VanillaJar)) { Stop-WithGuidance 'The existing server.jar is not the official vanilla Minecraft engine, so it was not moved automatically.' 'Run clean-server-runtime.bat after making a backup, then run start-server.bat again.' }
        Move-Item -LiteralPath $VanillaJar -Destination $LocalVanillaJar -Force
    }
    if ((Test-Path -LiteralPath $LocalVanillaJar -PathType Leaf) -and -not (Test-VanillaServerJar $LocalVanillaJar)) { Stop-WithGuidance 'vanilla-server.jar is not a recognized vanilla Minecraft engine.' 'Run clean-server-runtime.bat after making a backup, then run start-server.bat again.' }
    $FabricLauncher = Join-Path $ServerDir 'fabric-server-launch.jar'
    if (-not (Test-Path -LiteralPath $FabricLauncher -PathType Leaf)) { Stop-WithGuidance 'Fabric did not create fabric-server-launch.jar.' 'Delete only the incomplete Fabric runtime and run start-server.bat again.' }
    if (Test-Path -LiteralPath $VanillaJar -PathType Leaf) { Remove-Item -LiteralPath $VanillaJar -Force }
    Move-Item -LiteralPath $FabricLauncher -Destination $VanillaJar -Force
    Set-FabricVanillaJarReference
    Write-Host 'Fabric runtime installed. The Fabric launcher was renamed to server.jar; vanilla-server.jar is retained as the local vanilla engine.' -ForegroundColor Green
}
function Install-NeoForge($Java) {
    $Installer = Join-Path $ServerDir 'neoforge-26.2.0.48-beta-installer.jar'
    Download-AndVerify $NeoForgeInstallerUrl $Installer $NeoForgeInstallerSha512
    if (-not (Test-Path -LiteralPath (Join-Path $ServerDir 'run.bat') -PathType Leaf)) {
        Push-Location $ServerDir
        try { & $Java.Path -jar $Installer --installServer } finally { Pop-Location }
        if ($LASTEXITCODE -ne 0) { Stop-WithGuidance "NeoForge installer exited with code $LASTEXITCODE." 'Confirm Java 25, Internet access and free disk space, then run start-server.bat again.' }
    }
    if (-not (Test-Path -LiteralPath (Join-Path $ServerDir 'run.bat') -PathType Leaf) -or -not (Test-Path -LiteralPath (Join-Path $ServerDir 'libraries') -PathType Container)) { Stop-WithGuidance 'NeoForge did not create its complete run.bat/libraries runtime.' 'Inspect the installer output and run start-server.bat again after fixing the installation.' }
    Write-Host 'NeoForge runtime installed. NeoForge uses its generated run.bat and libraries; it does not have a portable single loader jar to rename safely.' -ForegroundColor Green
}
function Get-ManifestPath([string]$Loader) {
    if ($Loader -eq 'fabric') { return (Join-Path $ServerDir 'mods-manifest.ps1') }
    if ($Loader -eq 'neoforge') { return (Join-Path $ServerDir 'mods-manifest-neoforge.ps1') }
    return $null
}
function Install-Mods([string]$Loader) {
    $Manifest = Get-ManifestPath $Loader
    if ($null -eq $Manifest -or -not (Test-Path -LiteralPath $Manifest -PathType Leaf)) { Stop-WithGuidance "No pinned mod manifest exists for $Loader." 'Use Fabric or NeoForge, or add a reviewed loader-specific manifest before selecting this loader.' }
    . $Manifest
    if (-not $Mods -or $Mods.Count -eq 0) { Stop-WithGuidance "The $Loader mod manifest is empty." 'Restore the loader-specific manifest and run start-server.bat again.' }
    New-Item -ItemType Directory -Force -Path $ModsDir | Out-Null
    foreach ($Mod in $Mods) {
        $Destination = Join-Path $ModsDir $Mod.Name
        Download-AndVerify $Mod.Url $Destination $Mod.Sha512
        Write-Host "Verified $($Mod.Name) [$($Mod.Purpose)]" -ForegroundColor Green
    }
}
try {
    Write-Step 'Checking repository and loader configuration'
    New-Item -ItemType Directory -Force -Path $ServerDir | Out-Null
    if (-not (Test-Path -LiteralPath $SettingsPath -PathType Leaf)) { Stop-WithGuidance 'server-launch-settings.ini is missing.' 'Run start-server.bat again so it can restore the settings template.' }
    $Loader = Select-Loader
    Confirm-LoaderChange $Loader
    if ($Loader -eq 'forge') { Stop-WithGuidance 'Forge currently has no official Minecraft 26.2 server build available to this bootstrap.' 'Choose Fabric or NeoForge in parameter-manager.bat. Forge will be enabled only after an official 26.2 installer and compatible mods are verified.' }
    Write-Step 'Checking prerequisites'
    $Java = Get-SelectedJava
    Write-Step "Installing $Loader for Minecraft $MinecraftVersion"
    if ($Loader -eq 'fabric') { Install-Fabric $Java } else { Install-NeoForge $Java }
    Ensure-LocalTemplates
    Write-Step "Downloading and verifying $Loader server mods"
    Install-Mods $Loader
    Write-LoaderMarker $Loader
    Write-Step 'Bootstrap complete'
    Write-Host "Loader: $Loader" -ForegroundColor Green
    Write-Host 'No router, firewall, port-forwarding, or public-network changes were performed.' -ForegroundColor Yellow
}
catch { Stop-WithGuidance $_.Exception.Message 'Read the specific message above, apply its suggested fix, and run start-server.bat again.' }
