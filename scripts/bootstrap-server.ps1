[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

# PSModulePath hygiene: the Microsoft Store build of PowerShell 7 can prepend its own
# module folders ahead of the Windows PowerShell 5.1 folders in the process PSModulePath.
# Windows PowerShell 5.1 then loads incompatible PS7 modules and loses cmdlets such as
# Get-FileHash. Put the standard 5.1 module folders first so the right modules always load.
if ($PSVersionTable.PSEdition -eq 'Desktop') {
    $StandardModulePath = "$env:ProgramFiles\WindowsPowerShell\Modules;$env:SystemRoot\System32\WindowsPowerShell\v1.0\Modules"
    if ($env:PSModulePath -notlike "$StandardModulePath*") { $env:PSModulePath = "$StandardModulePath;$env:PSModulePath" }
}

$Root = [IO.Path]::GetFullPath((Split-Path -Parent $PSScriptRoot))
$ServerDir = Join-Path $Root 'server'
$ModsDir = Join-Path $ServerDir 'mods'
$ConfigDir = Join-Path $ServerDir 'config'
$DatapacksManifestPath = Join-Path $ServerDir 'datapacks-manifest.ps1'
$SettingsPath = Join-Path $PSScriptRoot 'server-launch-settings.ini'
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
$WorldTransferScript = Join-Path $PSScriptRoot 'world-transfer.ps1'
. $WorldTransferScript

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
function Install-BundledPrerequisites {
    # When no compatible Java is installed, launch the bundled installers in order:
    # first the legacy Java 8 runtime, then the Eclipse Temurin JDK 25 MSI. Each
    # installer runs elevated (UAC prompt) and the next one starts only after the
    # previous one has closed.
    $PrereqDir = Join-Path $Root 'prerequisites'
    $JreInstaller = Join-Path $PrereqDir 'jre-8-windows-x64.exe'
    $JdkInstaller = Join-Path $PrereqDir 'OpenJDK25U-jdk_x64_windows_hotspot.msi'
    $JreName = [IO.Path]::GetFileName($JreInstaller)
    $JdkName = [IO.Path]::GetFileName($JdkInstaller)
    $Missing = @()
    if (-not (Test-Path -LiteralPath $JreInstaller -PathType Leaf)) { $Missing += $JreName }
    if (-not (Test-Path -LiteralPath $JdkInstaller -PathType Leaf)) { $Missing += $JdkName }
    if ($Missing.Count -gt 0) {
        Write-Host "The bundled Java installers are missing in prerequisites/: $($Missing -join ', ')" -ForegroundColor Yellow
        Write-Host 'Download a 64-bit Java 25+ JDK from https://adoptium.net/temurin/releases/?version=25&os=windows&arch=x64&package=jdk, or place the installers in the prerequisites folder and run start-server.bat again.' -ForegroundColor Yellow
        return $false
    }
    Write-Host ''
    Write-Host 'No compatible 64-bit Java 25+ runtime was found.' -ForegroundColor Yellow
    Write-Host 'Jarock will launch the bundled Java installers in order. A Windows UAC prompt appears for each one; accept it and let the installer finish.' -ForegroundColor Cyan
    Write-Host "  1) $JreName - legacy Java 8 runtime" -ForegroundColor Cyan
    Write-Host "  2) $JdkName - Eclipse Temurin JDK 25 (the runtime the server needs)" -ForegroundColor Cyan
    if (-not [string]::IsNullOrWhiteSpace($env:JAROCK_PREREQ_DRY_RUN)) {
        # Test hook used by the CI workflow: the installers are interactive and need
        # UAC elevation, so on a headless runner we only simulate the launch sequence.
        Write-Host 'JAROCK_PREREQ_DRY_RUN is set: simulating the installer launch sequence without launching the installers.' -ForegroundColor Cyan
        Write-Host "  Simulated launch 1: $JreName (Start-Process -Verb RunAs -Wait)" -ForegroundColor Cyan
        Write-Host "  Simulated launch 2: msiexec /i $JdkName (Start-Process -Verb RunAs -Wait)" -ForegroundColor Cyan
        Write-Host 'Simulated installation finished; Java will be re-checked.' -ForegroundColor Cyan
        return $true
    }
    Write-Host "Starting $JreName ..." -ForegroundColor Green
    try {
        $JreProcess = Start-Process -FilePath $JreInstaller -Verb RunAs -Wait -PassThru -ErrorAction Stop
        Write-Host "$JreName finished (exit code $($JreProcess.ExitCode))." -ForegroundColor Green
    }
    catch {
        Write-Host "WARNING: Could not start ${JreName}: $($_.Exception.Message)" -ForegroundColor Yellow
        return $false
    }
    Write-Host "Starting $JdkName ..." -ForegroundColor Green
    try {
        $JdkProcess = Start-Process -FilePath 'msiexec.exe' -ArgumentList @('/i', ('"' + $JdkInstaller + '"')) -Verb RunAs -Wait -PassThru -ErrorAction Stop
        Write-Host "$JdkName finished (exit code $($JdkProcess.ExitCode))." -ForegroundColor Green
    }
    catch {
        Write-Host "WARNING: Could not start ${JdkName}: $($_.Exception.Message)" -ForegroundColor Yellow
        return $false
    }
    return $true
}
function Get-SelectedJava {
    $Result = Find-CompatibleJava -MinimumMajor $JavaMinimum
    if ($null -eq $Result.Selected) {
        Install-BundledPrerequisites | Out-Null
        $Result = Find-CompatibleJava -MinimumMajor $JavaMinimum
    }
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
function Invoke-RobustDownload([string]$Url, [string]$Path) {
    # Prefer curl.exe (bundled with Windows 10 1803+ and every GitHub Actions Windows
    # runner): it follows redirects, retries transient CDN failures and never crashes
    # the way Windows PowerShell 5.1 Invoke-WebRequest can on certain responses. Fall
    # back to Invoke-WebRequest only when curl.exe is not available.
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Path) | Out-Null
    $Curl = Get-Command curl.exe -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -ne $Curl) {
        for ($Attempt = 1; $Attempt -le 3; $Attempt++) {
            & $Curl.Source -sS -L --fail --connect-timeout 30 --max-time 600 --retry 3 --retry-delay 2 -A 'Jarock-loader-bootstrap' -o $Path $Url
            if ($LASTEXITCODE -eq 0) { return }
            if ($Attempt -lt 3) {
                Write-Host "Download attempt $Attempt of 3 failed (curl exit code $LASTEXITCODE); retrying ..." -ForegroundColor Yellow
                Start-Sleep -Seconds 3
            }
        }
        Remove-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
        throw "curl.exe failed downloading $Url (exit code $LASTEXITCODE); the incomplete file was removed."
    }
    Invoke-WebRequest -Uri $Url -OutFile $Path -Headers @{ 'User-Agent' = 'Jarock-loader-bootstrap' } -UseBasicParsing
}
function Download-AndVerify([string]$Url, [string]$Path, [string]$Hash) {
    try {
        if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
            Write-Host "Downloading $([IO.Path]::GetFileName($Path)) ..."
            Invoke-RobustDownload -Url $Url -Path $Path
        }
        if ((Get-Sha512 $Path) -ne $Hash.ToLowerInvariant()) {
            Remove-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
            throw "SHA-512 verification failed for $Path; the invalid file was removed."
        }
    }
    catch { Stop-WithGuidance $_.Exception.Message 'Check Internet access, disk permissions and antivirus/proxy interference, then run start-server.bat again.' }
}
function Confirm-LoaderChange([string]$Loader) {
    # Only loader ENGINE artifacts count as a previous runtime: a stray mods folder
    # (or a single leftover jar) must not block startup, because the pinned manifest is
    # re-verified and overwritten deterministically anyway. Keying the guard on the
    # loader engine also keeps the CI first-run test working, where the harness seeds a
    # legacy welcome artifact into server/mods on a fresh checkout to test its removal.
    $RuntimeArtifacts = @(
        (Join-Path $ServerDir 'server.jar'),
        (Join-Path $ServerDir 'vanilla-server.jar'),
        (Join-Path $ServerDir 'fabric-server-launch.jar'),
        (Join-Path $ServerDir 'run.bat'),
        (Join-Path $ServerDir 'libraries')
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
function Ensure-WelcomeMessageConfig {
    # Welcome Message reads this file during mod initialization. On the first
    # Jarock-managed setup, replace only the mod's recognizable generic config with
    # the project configuration supplied in the repository. A local marker makes
    # this a one-time migration: later starts preserve the operator's edits.
    $TemplatePath = Join-Path $ConfigDir 'welcomemessage.json5.template-jarock'
    $ConfigPath = Join-Path $ConfigDir 'welcomemessage.json5'
    $MarkerPath = Join-Path $ConfigDir '.jarock-welcomemessage-configured'
    if (-not (Test-Path -LiteralPath $TemplatePath -PathType Leaf)) {
        Stop-WithGuidance 'The Jarock Welcome Message template is missing.' 'Restore server/config/welcomemessage.json5.template-jarock and run start-server.bat again.'
    }
    New-Item -ItemType Directory -Force -Path $ConfigDir | Out-Null
    if (-not (Test-Path -LiteralPath $MarkerPath -PathType Leaf)) {
        $ApplyTemplate = -not (Test-Path -LiteralPath $ConfigPath -PathType Leaf)
        if (-not $ApplyTemplate) {
            $ExistingConfig = Get-Content -LiteralPath $ConfigPath -Raw
            # Welcome Message 2.8 creates this recognizable first-run value. Do not
            # classify an already customized file as generic just because the marker
            # was introduced by a later Jarock release.
            $ApplyTemplate = ($ExistingConfig -match '"onlyRunOnDedicatedServers"\s*:\s*true') -and
                ($ExistingConfig -match '"sendEmptyLineBeforeFirstMessage"\s*:\s*false') -and
                ($ExistingConfig -match '"messageOneText"\s*:\s*"Welcome to the server!"') -and
                ($ExistingConfig -match '"messageOneColourIndex"\s*:\s*0') -and
                ($ExistingConfig -match '"messageOneOptionalURL"\s*:\s*""') -and
                ($ExistingConfig -match '"messageTwoText"\s*:\s*""') -and
                ($ExistingConfig -match '"messageTwoColourIndex"\s*:\s*0') -and
                ($ExistingConfig -match '"messageTwoOptionalURL"\s*:\s*""') -and
                ($ExistingConfig -match '"messageThreeText"\s*:\s*""') -and
                ($ExistingConfig -match '"messageThreeColourIndex"\s*:\s*0') -and
                ($ExistingConfig -match '"messageThreeOptionalURL"\s*:\s*""')
        }
        if ($ApplyTemplate) {
            Copy-Item -LiteralPath $TemplatePath -Destination $ConfigPath -Force
            Write-Host 'Applied the Jarock Welcome Message configuration for the first startup.' -ForegroundColor Green
        }
        else {
            Write-Host 'Preserved the existing customized Welcome Message configuration.' -ForegroundColor Cyan
        }
        [IO.File]::WriteAllText($MarkerPath, 'Jarock Welcome Message configuration checked once.', (New-Object Text.UTF8Encoding($false)))
    }
    elseif (-not (Test-Path -LiteralPath $ConfigPath -PathType Leaf)) {
        Copy-Item -LiteralPath $TemplatePath -Destination $ConfigPath
        Write-Host 'Restored the missing Welcome Message configuration from the Jarock template.' -ForegroundColor Yellow
    }
    else {
        Write-Host 'Preserved the existing server/config/welcomemessage.json5 Welcome Message configuration.' -ForegroundColor Cyan
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
    if (Test-Path -LiteralPath $PropertiesPath -PathType Leaf) {
        $Content = Get-Content -LiteralPath $PropertiesPath -Raw
    }
    else {
        Write-Host 'Fabric installer did not create launcher metadata; creating it locally.' -ForegroundColor Yellow
        $Content = "# Generated by Jarock`r`n"
    }
    $Pattern = '(?m)^serverJar=.*$'
    if ($Content -match $Pattern) {
        $Content = [regex]::Replace($Content, $Pattern, 'serverJar=vanilla-server.jar')
    }
    else {
        $Content = $Content.TrimEnd("`r", "`n") + "`r`nserverJar=vanilla-server.jar`r`n"
    }
    [IO.File]::WriteAllText($PropertiesPath, $Content, (New-Object Text.UTF8Encoding($false)))
    $WrittenContent = (Get-Content -LiteralPath $PropertiesPath) -join "`n"
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
    # Remove only the known replaced welcome artifact so an existing installation
    # cannot load both the legacy and current welcome mods at once.
    $LegacyWelcomeAwa = Join-Path $ModsDir 'welcome_awa-fabric-26.2-2.4.jar'
    if (Test-Path -LiteralPath $LegacyWelcomeAwa -PathType Leaf) {
        Remove-Item -LiteralPath $LegacyWelcomeAwa -Force
        Write-Host 'Removed the replaced Welcome AWA artifact; Welcome Message will be used instead.' -ForegroundColor Yellow
    }
    foreach ($Mod in $Mods) {
        $Destination = Join-Path $ModsDir $Mod.Name
        Download-AndVerify $Mod.Url $Destination $Mod.Sha512
        Write-Host "Verified $($Mod.Name) [$($Mod.Purpose)]" -ForegroundColor Green
    }
}
function Get-ConfiguredLevelName([string]$PropertiesPath) {
    $Content = Get-Content -LiteralPath $PropertiesPath -Raw
    if ($Content -match '(?m)^\s*level-name\s*=\s*([^\r\n#]+?)\s*(?:#.*)?$') {
        $Name = $Matches[1].Trim()
        if (-not [string]::IsNullOrWhiteSpace($Name) -and $Name -notmatch '[\\/:*?"<>|]') { return $Name }
    }
    return 'world'
}
function Ensure-DefaultWorldIcon([string]$LevelName) {
    $DefaultIcon = Join-Path $Root 'icon.png'
    if (-not (Test-Path -LiteralPath $DefaultIcon -PathType Leaf)) {
        Write-Host "WARNING: The tracked default world icon icon.png is missing; the world will keep Minecraft's default icon." -ForegroundColor Yellow
        return
    }
    $WorldDirectory = Join-Path $ServerDir $LevelName
    New-Item -ItemType Directory -Force -Path $WorldDirectory | Out-Null
    $WorldIcon = Join-Path $WorldDirectory 'icon.png'
    if (-not (Test-Path -LiteralPath $WorldIcon -PathType Leaf)) {
        Copy-Item -LiteralPath $DefaultIcon -Destination $WorldIcon -Force
        Write-Host "Applied the default Jarock world icon to $LevelName/icon.png." -ForegroundColor Green
    }
    else {
        Write-Host "Preserved the existing world icon at $LevelName/icon.png." -ForegroundColor Cyan
    }
}
function Read-DatapackMarker([string]$Path) {
    $Values = @{}
    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        foreach ($Line in Get-Content -LiteralPath $Path) {
            if ($Line -match '^\s*([A-Z_]+)=(.*?)\s*$') { $Values[$Matches[1]] = $Matches[2] }
        }
    }
    return $Values
}
function Test-SafeDatapackArchive([string]$Path) {
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction SilentlyContinue
        $Archive = [IO.Compression.ZipFile]::OpenRead($Path)
        try {
            $Entries = @($Archive.Entries)
            $PackEntry = $Archive.GetEntry('pack.mcmeta')
            if ($null -eq $PackEntry -or -not ($Entries | Where-Object { $_.FullName -match '^data/' })) { return $false }
            foreach ($Entry in $Entries) {
                $Name = $Entry.FullName.Replace('\\','/')
                if ($Name.StartsWith('/') -or $Name -match '(^|/)\.\.(/|$)' -or $Name -match '^[A-Za-z]:') { return $false }
            }
            $Reader = New-Object IO.StreamReader($PackEntry.Open())
            try {
                $Metadata = $Reader.ReadToEnd() | ConvertFrom-Json
                if ($null -eq $Metadata -or $null -eq $Metadata.pack) { return $false }
            } finally { $Reader.Dispose() }
            return $true
        } finally { $Archive.Dispose() }
    } catch { return $false }
}
function Install-Datapacks {
    if (-not (Test-Path -LiteralPath $DatapacksManifestPath -PathType Leaf)) { Stop-WithGuidance 'The tracked datapack manifest is missing.' 'Restore server/datapacks-manifest.ps1 and run start-server.bat again.' }
    . $DatapacksManifestPath
    if (-not $Datapacks -or $Datapacks.Count -eq 0) { Stop-WithGuidance 'The datapack manifest is empty.' 'Restore server/datapacks-manifest.ps1 and run start-server.bat again.' }
    $PropertiesPath = Join-Path $ServerDir 'server.properties'
    $LevelName = Get-ConfiguredLevelName $PropertiesPath
    $DatapacksDir = Join-Path (Join-Path $ServerDir $LevelName) 'datapacks'
    New-Item -ItemType Directory -Force -Path $DatapacksDir | Out-Null
    $MarkerPath = Join-Path $ConfigDir '.jarock-datapacks'
    $Marker = Read-DatapackMarker $MarkerPath
    foreach ($Datapack in $Datapacks) {
        if ($Datapack.Name -notmatch '^[^\\/:*?"<>|]+\.zip$') { Stop-WithGuidance "The datapack manifest contains an unsafe filename '$($Datapack.Name)'." 'Restore server/datapacks-manifest.ps1 from the repository and run start-server.bat again.' }
        if ($Marker.ContainsKey('BETTER_MULTIPLAYER_SLEEP_FILE') -and $Marker['BETTER_MULTIPLAYER_SLEEP_FILE'] -notmatch '^[^\\/:*?"<>|]+\.zip$') { Stop-WithGuidance 'The Jarock datapack marker contains an unsafe filename.' 'Delete the generated server/config/.jarock-datapacks marker and run start-server.bat again.' }
        $Destination = Join-Path $DatapacksDir $Datapack.Name
        $AlreadyVerified = $Marker.ContainsKey('BETTER_MULTIPLAYER_SLEEP_FILE') -and $Marker['BETTER_MULTIPLAYER_SLEEP_FILE'] -eq $Datapack.Name -and $Marker.ContainsKey('BETTER_MULTIPLAYER_SLEEP_HASH') -and $Marker['BETTER_MULTIPLAYER_SLEEP_HASH'].ToLowerInvariant() -eq $Datapack.Sha512.ToLowerInvariant() -and (Test-Path -LiteralPath $Destination -PathType Leaf)
        if (-not $AlreadyVerified) { Download-AndVerify $Datapack.Url $Destination $Datapack.Sha512 }
        if (-not (Test-SafeDatapackArchive $Destination)) {
            Remove-Item -LiteralPath $Destination -Force -ErrorAction SilentlyContinue
            Stop-WithGuidance "The downloaded datapack $($Datapack.Name) is not a safe, valid datapack archive." 'Run start-server.bat again; if the error repeats, report the pinned artifact to the project maintainer.'
        }
        if ($Marker.ContainsKey('BETTER_MULTIPLAYER_SLEEP_FILE') -and $Marker['BETTER_MULTIPLAYER_SLEEP_FILE'] -ne $Datapack.Name) {
            $PreviousPath = Join-Path $DatapacksDir $Marker['BETTER_MULTIPLAYER_SLEEP_FILE']
            if (Test-Path -LiteralPath $PreviousPath -PathType Leaf) { Remove-Item -LiteralPath $PreviousPath -Force }
        }
        $Marker['BETTER_MULTIPLAYER_SLEEP_FILE'] = $Datapack.Name
        $Marker['BETTER_MULTIPLAYER_SLEEP_HASH'] = $Datapack.Sha512
        New-Item -ItemType Directory -Force -Path $ConfigDir | Out-Null
        [IO.File]::WriteAllLines($MarkerPath, @("BETTER_MULTIPLAYER_SLEEP_FILE=$($Marker['BETTER_MULTIPLAYER_SLEEP_FILE'])", "BETTER_MULTIPLAYER_SLEEP_HASH=$($Marker['BETTER_MULTIPLAYER_SLEEP_HASH'])"), (New-Object Text.UTF8Encoding($false)))
        $Status = if ($AlreadyVerified) { 'already verified' } else { 'downloaded and verified' }
        Write-Host "Verified $($Datapack.Name) [$($Datapack.Purpose)] in $LevelName/datapacks" -ForegroundColor Green
    }
}
function Get-LatestDedicatedPowerRelease {
    try {
        return Invoke-RestMethod -Uri 'https://api.github.com/repos/PiBOH/DedicatedPower/releases/latest' -Headers @{ 'User-Agent' = 'Jarock-loader-bootstrap' }
    }
    catch {
        Write-Host "WARNING: Could not query the latest DedicatedPower release: $($_.Exception.Message)" -ForegroundColor Yellow
        return $null
    }
}
function Install-DedicatedPower {
    New-Item -ItemType Directory -Force -Path $ConfigDir | Out-Null
    # Migrate: remove the marker previously stored inside the mods folder.
    Remove-Item -LiteralPath (Join-Path $ModsDir '.dedicatedpower-version') -Force -ErrorAction SilentlyContinue
    $Marker = Join-Path $ConfigDir '.dedicatedpower-version'
    $StoredTag = ''; $StoredHash = ''; $StoredFile = ''
    if (Test-Path -LiteralPath $Marker -PathType Leaf) {
        $MarkerLines = @(Get-Content -LiteralPath $Marker)
        if ($MarkerLines.Count -ge 3) { $StoredTag = [string]$MarkerLines[0].Trim(); $StoredHash = [string]$MarkerLines[1].Trim(); $StoredFile = [string]$MarkerLines[2].Trim() }
    }
    $Release = Get-LatestDedicatedPowerRelease
    if ($null -eq $Release -or -not ($Release.PSObject.Properties.Name -contains 'tag_name')) {
        if ($StoredFile -and (Test-Path -LiteralPath (Join-Path $ModsDir $StoredFile) -PathType Leaf) -and (Get-Sha512 (Join-Path $ModsDir $StoredFile)) -eq $StoredHash) {
            Write-Host "DedicatedPower GitHub is unreachable; keeping $StoredFile ($StoredTag)." -ForegroundColor Yellow
            return
        }
        Stop-WithGuidance 'Could not resolve the latest DedicatedPower release and no valid local copy exists.' 'Check Internet access and proxy/antivirus settings, then run start-server.bat again.'
    }
    $Tag = [string]$Release.tag_name
    $Assets = @($Release.assets | Where-Object { $_.name -match '^dedicatedpower-.+\.jar$' })
    if ($Assets.Count -eq 0) { Stop-WithGuidance "The latest DedicatedPower release ($Tag) has no .jar asset." 'Check the DedicatedPower release page and report the missing asset to its maintainer.' }
    # Asset names look like dedicatedpower-<minecraft>-<mod>.jar; prefer the one for the target Minecraft version.
    $Asset = $Assets | Where-Object { $_.name -match "^dedicatedpower-$([regex]::Escape($MinecraftVersion))-" } | Select-Object -First 1
    if ($null -eq $Asset) {
        $Asset = $Assets[0]
        Write-Host "WARNING: The latest DedicatedPower release has no asset named for Minecraft $MinecraftVersion; using $($Asset.name)." -ForegroundColor Yellow
    }
    $Target = Join-Path $ModsDir $Asset.name
    $NeedDownload = $true
    if ($StoredTag -eq $Tag -and $StoredFile -eq $Asset.name -and (Test-Path -LiteralPath $Target -PathType Leaf) -and (Get-Sha512 $Target) -eq $StoredHash) { $NeedDownload = $false }
    if ($NeedDownload) {
        Write-Host "Downloading DedicatedPower $Tag ($($Asset.name)) ..."
        try {
            Invoke-RobustDownload -Url $Asset.browser_download_url -Path $Target
        }
        catch {
            Remove-Item -LiteralPath $Target -Force -ErrorAction SilentlyContinue
            Stop-WithGuidance "DedicatedPower download failed: $($_.Exception.Message)" 'Check Internet access, then run start-server.bat again.'
        }
        if ((Get-Item -LiteralPath $Target).Length -ne [int64]$Asset.size) {
            Remove-Item -LiteralPath $Target -Force
            Stop-WithGuidance 'The DedicatedPower download size does not match the release asset.' 'Run start-server.bat again; if the error repeats, report it to the DedicatedPower maintainer.'
        }
        $NewHash = Get-Sha512 $Target
        [IO.File]::WriteAllLines($Marker, @($Tag, $NewHash, $Asset.name), (New-Object Text.UTF8Encoding($false)))
        Get-ChildItem -LiteralPath $ModsDir -Filter 'dedicatedpower-*.jar' -File | Where-Object { $_.FullName -ne $Target } | Remove-Item -Force -ErrorAction SilentlyContinue
        Write-Host "Verified $($Asset.name) [DedicatedPower, latest GitHub release]" -ForegroundColor Green
    }
    else {
        Write-Host "Verified $($Asset.name) [DedicatedPower, already current]" -ForegroundColor Green
    }
}
try {
    Write-Step 'Checking repository and loader configuration'
    New-Item -ItemType Directory -Force -Path $ServerDir | Out-Null
    if (-not (Test-Path -LiteralPath $SettingsPath -PathType Leaf)) { Stop-WithGuidance 'scripts\server-launch-settings.ini is missing.' 'Run start-server.bat again so it can restore the settings template.' }
    $Loader = Select-Loader
    Confirm-LoaderChange $Loader
    if ($Loader -eq 'forge') { Stop-WithGuidance 'Forge currently has no official Minecraft 26.2 server build available to this bootstrap.' 'Choose Fabric or NeoForge in parameter-manager.bat. Forge will be enabled only after an official 26.2 installer and compatible mods are verified.' }
    Write-Step 'Checking prerequisites'
    $Java = Get-SelectedJava
    Write-Step "Installing $Loader for Minecraft $MinecraftVersion"
    if ($Loader -eq 'fabric') { Install-Fabric $Java } else { Install-NeoForge $Java }
    Ensure-LocalTemplates
    $LevelName = Get-ConfiguredLevelName (Join-Path $ServerDir 'server.properties')
    Invoke-WorldImport -ServerDirectory $ServerDir -SettingsPath $SettingsPath -LevelName $LevelName
    Ensure-DefaultWorldIcon $LevelName
    Write-Step "Downloading and verifying $Loader server mods"
    Install-Mods $Loader
    Ensure-WelcomeMessageConfig
    if ($Loader -eq 'fabric') { Install-DedicatedPower }
    Install-Datapacks
    Write-LoaderMarker $Loader
    Write-Step 'Bootstrap complete'
    Write-Host "Loader: $Loader" -ForegroundColor Green
    Write-Host 'No router, firewall, port-forwarding, or public-network changes were performed.' -ForegroundColor Yellow
}
catch { Stop-WithGuidance $_.Exception.Message 'Read the specific message above, apply its suggested fix, and run start-server.bat again.' }
