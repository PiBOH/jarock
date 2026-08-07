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
$ManifestPath = Join-Path $ServerDir 'mods-manifest.ps1'
$FabricInstaller = Join-Path $ServerDir 'fabric-installer-1.1.2.jar'
$FabricInstallerUrl = 'https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.1.2/fabric-installer-1.1.2.jar'
$FabricInstallerSha512 = '3cbe7b69498c44d814fc95e71cd9ce9c12c45a9e1dcf01085cb3e9aaf6fe63134b701065167be1fa6e4c2df19dfa5400bc5b6b1b7fb5e99e334d24dcdca55c20'
$MinecraftVersion = '26.2'
$FabricLoaderVersion = '0.19.3'
$JavaMinimum = 25
$LongPathThreshold = 220
$ProjectVersionPath = Join-Path $Root 'version.txt'
$ProjectVersion = if (Test-Path -LiteralPath $ProjectVersionPath -PathType Leaf) { (Get-Content -LiteralPath $ProjectVersionPath -Raw).Trim() } else { 'unknown' }
$JavaRuntimeScript = Join-Path $PSScriptRoot 'java-runtime.ps1'
if (-not (Test-Path -LiteralPath $JavaRuntimeScript -PathType Leaf)) {
    Write-Host 'ERROR: The Java runtime helper is missing.' -ForegroundColor Red
    Write-Host 'Suggested fix: restore scripts/java-runtime.ps1 from the repository and run start-server.bat again.' -ForegroundColor Yellow
    exit 1
}
. $JavaRuntimeScript
$SelectedJava = $null
$JavaPathFile = Join-Path $ServerDir 'java-path.txt'

function Write-Step([string]$Message) {
    Write-Host "`n==> $Message" -ForegroundColor Cyan
}

function Show-ErrorGuidance([string]$Message, [string]$Action) {
    Write-Host "`nERROR: $Message" -ForegroundColor Red
    Write-Host 'Suggested fix:' -ForegroundColor Yellow
    Write-Host "  $Action"
    Write-Host 'The server was not started. No router, firewall, or port-forwarding changes were made.' -ForegroundColor Yellow
}

function Stop-WithGuidance([string]$Message, [string]$Action) {
    Show-ErrorGuidance $Message $Action
    exit 1
}

function Select-JavaRuntime {
    $Result = Find-CompatibleJava -MinimumMajor $JavaMinimum
    if ($null -eq $Result.Selected) {
        $InspectedText = 'No usable Java executable was found.'
        if ($Result.Inspected.Count -gt 0) {
            $InspectedText = (($Result.Inspected | ForEach-Object { "$($_.Path) -> Java $($_.Major), 64-bit=$($_.Is64Bit)" }) -join '; ')
        }
        elseif ($Result.Candidates.Count -gt 0) {
            $InspectedText = "Candidate paths were checked but none could be executed or inspected: $($Result.Candidates -join '; ')"
        }
        $JavaInstallUrl = 'https://adoptium.net/temurin/releases/?version=25&os=windows&arch=x64&package=jdk'
        $SuggestedFix = "Install a 64-bit Java $JavaMinimum (or newer) JDK from $JavaInstallUrl. Choose the Windows x64 JDK installer, not Java 8 or Java 21. If Java 25 is installed in a custom folder, put its JDK folder in java-home.txt in the repository root (or set JAROCK_JAVA_HOME), verify that it contains bin\java.exe, close and reopen this window, and run start-server.bat again. Do not double-click server.jar, because Windows may launch it with an older Java associated with .jar files."
        Stop-WithGuidance "No compatible 64-bit Java $JavaMinimum+ runtime was found. Detected candidates: $InspectedText" $SuggestedFix
    }

    $script:SelectedJava = $Result.Selected
    Write-Host "Selected Java executable: $($SelectedJava.Path)" -ForegroundColor Green
    Write-Host "Selected Java version: $($SelectedJava.Version) ($($SelectedJava.Major), 64-bit=$($SelectedJava.Is64Bit))" -ForegroundColor Green

    try {
        [IO.File]::WriteAllText($JavaPathFile, $SelectedJava.Path, (New-Object Text.UTF8Encoding($false)))
    }
    catch {
        Stop-WithGuidance "Could not save the selected Java path to '$JavaPathFile'. $($_.Exception.Message)" 'Check that the server folder is writable and run start-server.bat again.'
    }
}

function Get-Sha512([string]$Path) {
    try {
        return (Get-FileHash -Algorithm SHA512 -LiteralPath $Path).Hash.ToLowerInvariant()
    }
    catch {
        Stop-WithGuidance "Could not read or hash '$Path'." 'Check that the repository folder is writable, that antivirus is not locking the file, and that the path is accessible.'
    }
}

function Invoke-RobustDownload([string]$Url, [string]$Path) {
    # Prefer curl.exe (bundled with Windows 10 1803+ and every GitHub Actions Windows
    # runner): it follows redirects, retries transient CDN failures and never crashes
    # the way Windows PowerShell 5.1 Invoke-WebRequest can on certain responses. Fall
    # back to Invoke-WebRequest only when curl.exe is not available.
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Path) | Out-Null
    $Curl = Get-Command curl.exe -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -ne $Curl) {
        for ($Attempt = 1; $Attempt -le 3; $Attempt++) {
            & $Curl.Source -sS -L --fail --connect-timeout 30 --max-time 600 --retry 3 --retry-delay 2 -A 'Jarock-Fabric-Bootstrap' -o $Path $Url
            if ($LASTEXITCODE -eq 0) { return }
            if ($Attempt -lt 3) {
                Write-Host "Download attempt $Attempt of 3 failed (curl exit code $LASTEXITCODE); retrying ..." -ForegroundColor Yellow
                Start-Sleep -Seconds 3
            }
        }
        Remove-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
        throw "curl.exe failed downloading $Url (exit code $LASTEXITCODE); the incomplete file was removed."
    }
    Invoke-WebRequest -Uri $Url -OutFile $Path -Headers @{ 'User-Agent' = "Jarock-Fabric-Bootstrap/$ProjectVersion (https://github.com/PiBOH/jarock)" } -UseBasicParsing
}
function Download-AndVerify([string]$Url, [string]$Path, [string]$ExpectedSha512) {
    try {
        if (-not (Test-Path -LiteralPath $Path)) {
            Write-Host "Downloading $([IO.Path]::GetFileName($Path)) ..."
            Invoke-RobustDownload -Url $Url -Path $Path
        }

        $Actual = Get-Sha512 $Path
        if ($Actual -ne $ExpectedSha512.ToLowerInvariant()) {
            Remove-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
            Stop-WithGuidance "SHA-512 verification failed for '$Path'. The invalid file was removed." 'Run the bootstrap again. If it repeats, check antivirus/proxy interference and report the exact filename to the project maintainer.'
        }
    }
    catch {
        if ($_.Exception.Message -like '*SHA-512 verification failed*') { throw }
        Stop-WithGuidance "Could not download or verify '$Path'. $($_.Exception.Message)" 'Check Internet access, DNS/proxy settings, disk permissions and free space, then run start-server.bat again.'
    }
}

function Get-LongPathsEnabled {
    try {
        $Value = (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -ErrorAction SilentlyContinue).LongPathsEnabled
        return ([int]$Value -eq 1)
    }
    catch {
        return $false
    }
}

function Ensure-LongPathsIfNeeded {
    $LongestExpectedPath = (Join-Path $ServerDir 'mods\fabric-api-0.156.0+26.2.jar').Length
    if ($Root.Length -lt $LongPathThreshold -and $LongestExpectedPath -lt 260) {
        Write-Host "Repository path length is safe ($($Root.Length) characters). Windows long-path policy is not required." -ForegroundColor Green
        return
    }

    Write-Host "This repository is in a deep path ($($Root.Length) characters); Windows long-path support is required." -ForegroundColor Yellow
    if (Get-LongPathsEnabled) {
        Write-Host 'Windows long-path support is already enabled (LongPathsEnabled=1).' -ForegroundColor Green
        return
    }

    $LongPathScript = Join-Path $PSScriptRoot 'enable-long-paths.ps1'
    if (-not (Test-Path -LiteralPath $LongPathScript)) {
        Stop-WithGuidance 'Long-path support is needed but the helper script is missing.' 'Re-download the complete repository, preserving scripts/enable-long-paths.ps1.'
    }

    Write-Host 'LongPathsEnabled is disabled. Requesting administrator permission to enable it now.' -ForegroundColor Yellow
    try {
        $ElevatedArguments = "-NoProfile -ExecutionPolicy Bypass -File `"$LongPathScript`""
        $Process = Start-Process -FilePath 'powershell.exe' -Verb RunAs -Wait -PassThru -ArgumentList $ElevatedArguments
        if ($Process.ExitCode -ne 0 -or -not (Get-LongPathsEnabled)) {
            Stop-WithGuidance 'Windows long-path support could not be enabled.' 'Accept the administrator prompt, or ask an administrator to set HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled to DWORD 1, then reboot if requested.'
        }
        Write-Host 'Long-path support was enabled successfully. The change was reported above.' -ForegroundColor Green
    }
    catch {
        Stop-WithGuidance "The administrator elevation request failed. $($_.Exception.Message)" 'Run start-server.bat as Administrator once, or move the repository to a shorter path and try again.'
    }
}

function Ensure-EulaTemplate {
    $EulaPath = Join-Path $ServerDir 'eula.txt'
    $TemplatePath = Join-Path $ServerDir 'eula.txt.template'
    try {
        if (-not (Test-Path -LiteralPath $EulaPath) -and (Test-Path -LiteralPath $TemplatePath)) {
            Copy-Item -LiteralPath $TemplatePath -Destination $EulaPath
            Write-Host 'Created server/eula.txt from the template.' -ForegroundColor Green
        }
    }
    catch {
        Stop-WithGuidance "Could not create '$EulaPath'. $($_.Exception.Message)" 'Check that the repository folder is writable and that the file is not open in another program.'
    }
}

try {
    Write-Step 'Checking repository path and Windows long-path support'
    Ensure-LongPathsIfNeeded

    Write-Step 'Checking prerequisites'
    New-Item -ItemType Directory -Force -Path $ServerDir, $ModsDir | Out-Null
    Select-JavaRuntime

    if (-not (Test-Path -LiteralPath $ManifestPath)) {
        Stop-WithGuidance "Missing mod manifest: $ManifestPath" 'Download the complete repository again; do not remove server/mods-manifest.ps1.'
    }
    . $ManifestPath
    if (-not $Mods -or $Mods.Count -eq 0) {
        Stop-WithGuidance 'The mod manifest is empty.' 'Restore server/mods-manifest.ps1 from the repository and try again.'
    }

    Write-Step 'Downloading and verifying the official Fabric installer'
    Download-AndVerify $FabricInstallerUrl $FabricInstaller $FabricInstallerSha512

    if (-not (Test-Path -LiteralPath (Join-Path $ServerDir 'fabric-server-launch.jar'))) {
        Write-Step "Installing Fabric Server for Minecraft $MinecraftVersion (Loader $FabricLoaderVersion)"
        Push-Location $ServerDir
        try {
            & $SelectedJava.Path -jar $FabricInstaller server -mcversion $MinecraftVersion -loader $FabricLoaderVersion -downloadMinecraft
            if ($LASTEXITCODE -ne 0) {
                Stop-WithGuidance "Fabric installer exited with code $LASTEXITCODE." 'Check the Fabric installer log, confirm Java 25 is selected, verify Internet access, and run start-server.bat again.'
            }
        }
        finally {
            Pop-Location
        }
    }

    Write-Step 'Downloading and verifying pinned server mods'
    foreach ($Mod in $Mods) {
        $Destination = Join-Path $ModsDir $Mod.Name
        Download-AndVerify $Mod.Url $Destination $Mod.Sha512
        Write-Host "Verified $($Mod.Name) [$($Mod.Purpose)]" -ForegroundColor Green
    }

    Ensure-EulaTemplate

    $PropertiesPath = Join-Path $ServerDir 'server.properties'
    $PropertiesTemplate = Join-Path $ServerDir 'server.properties.template'
    try {
        if (-not (Test-Path -LiteralPath $PropertiesPath) -and (Test-Path -LiteralPath $PropertiesTemplate)) {
            Copy-Item -LiteralPath $PropertiesTemplate -Destination $PropertiesPath
            Write-Host 'Created server.properties from the safe template.' -ForegroundColor Green
        }
    }
    catch {
        Stop-WithGuidance "Could not create '$PropertiesPath'. $($_.Exception.Message)" 'Check write permissions and close any editor using server.properties.'
    }

    Write-Step 'Bootstrap complete'
    Write-Host 'No router, firewall, port-forwarding, or public-network changes were performed.' -ForegroundColor Yellow
    Write-Host 'Geyser configuration is generated by the first server start; the start script applies auth-type: floodgate afterward.'
    Write-Host 'If eula=true is accepted, start-server.bat will launch the server.'
}
catch {
    Show-ErrorGuidance $_.Exception.Message 'Read the specific message above, apply its suggested fix, and run start-server.bat again.'
    exit 1
}
