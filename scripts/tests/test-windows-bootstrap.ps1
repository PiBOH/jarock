[CmdletBinding()]
param()

# End-to-end test that simulates a fresh Windows PC without the Java prerequisites:
#   1. masks every Java source the bootstrap reads (JAVA_HOME, PATH, discovery),
#   2. confirms the bundled installers are present and that Jarock detects the missing Java,
#   3. runs the real bootstrap with JAROCK_PREREQ_DRY_RUN=1 and verifies the simulated
#      install sequence (legacy Java 8 first, then the Temurin JDK 25 MSI),
#   4. restores the Java environment, runs the real bootstrap (loader + mods),
#   5. boots the real server and stops it automatically once the ready banner appears.
#
# The Java environment is restored in a finally block, so the test is safe to run locally
# (the machine needs a 64-bit Java 25+ runtime for phase 4 to succeed).

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$Root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..'))
$Pass = 0
$Fail = 0
function Assert([bool]$Condition, [string]$Name) {
    if ($Condition) { $script:Pass++; Write-Host "PASS: $Name" -ForegroundColor Green }
    else { $script:Fail++; Write-Host "FAIL: $Name" -ForegroundColor Red }
}
function Get-Sha512([string]$Path) {
    $Stream = [IO.File]::OpenRead($Path)
    try {
        $Hasher = [Security.Cryptography.SHA512]::Create()
        try { return ([BitConverter]::ToString($Hasher.ComputeHash($Stream)) -replace '-', '').ToLowerInvariant() }
        finally { $Hasher.Dispose() }
    }
    finally { $Stream.Dispose() }
}
function Invoke-TestDownload([string]$Url, [string]$Path) {
    $Curl = Get-Command curl.exe -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -ne $Curl) {
        for ($Attempt = 1; $Attempt -le 3; $Attempt++) {
            & $Curl.Source -sS -L --fail --connect-timeout 30 --max-time 600 --retry 3 --retry-delay 2 -A 'Jarock-bootstrap-test' -o $Path $Url
            if ($LASTEXITCODE -eq 0) { return }
            if ($Attempt -lt 3) { Start-Sleep -Seconds 3 }
        }
        throw "curl.exe failed downloading the isolated test artifact (exit code $LASTEXITCODE)."
    }
    Invoke-WebRequest -Uri $Url -OutFile $Path -Headers @{ 'User-Agent' = 'Jarock-bootstrap-test' } -UseBasicParsing
}

# Save every Java source so the environment can be restored exactly. The discovery also
# reads java-home.txt and JAROCK_JAVA_HOME first, so those are masked too. Note that the
# Program Files and registry scans of java-runtime.ps1 are NOT masked: on the CI runner no
# JDK 25 lives there (setup-java only uses the toolcache and environment variables), so the
# "discovery finds nothing" assertion would fail loudly if a future runner image changed.
$Saved = [ordered]@{
    ProcessJavaHome   = $env:JAVA_HOME
    ProcessPath       = $env:Path
    UserJavaHome      = [Environment]::GetEnvironmentVariable('JAVA_HOME', 'User')
    MachineJavaHome   = [Environment]::GetEnvironmentVariable('JAVA_HOME', 'Machine')
    UserPath          = [Environment]::GetEnvironmentVariable('Path', 'User')
    MachinePath       = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    JarockJavaHome    = $env:JAROCK_JAVA_HOME
    JavaHomeFile      = Join-Path $Root 'java-home.txt'
    JavaHomeBackup    = Join-Path $Root 'java-home.txt.jarock-test-backup'
}
function Strip-JavaEntries([string]$Value) {
    if ([string]::IsNullOrWhiteSpace($Value)) { return '' }
    return (($Value -split ';') | Where-Object { $_ -and $_ -notmatch '(?i)(java|jdk|jre|temurin|adoptium|hostedtoolcache)' }) -join ';'
}
function Set-EnvTolerant([string]$Name, $Value, [string]$Scope, [string]$Label) {
    # $Value stays untyped so that $null flows through unchanged: with a [string]
    # coercion, $null becomes '' and SetEnvironmentVariable would WRITE an empty value
    # to the persistent registry instead of removing the variable.
    try { [Environment]::SetEnvironmentVariable($Name, $Value, $Scope) }
    catch { Write-Host "WARNING: could not $Label at $Scope level: $($_.Exception.Message)" -ForegroundColor Yellow }
}
function Mask-Java {
    # Writing the persistent machine/user environment requires elevation. On CI the
    # runner is elevated, so the full mask applies; locally without admin the write is
    # skipped with a warning and the process-level masking below still applies.
    Set-EnvTolerant 'JAVA_HOME' $null 'User' 'mask JAVA_HOME'
    Set-EnvTolerant 'JAVA_HOME' $null 'Machine' 'mask JAVA_HOME'
    Set-EnvTolerant 'Path' (Strip-JavaEntries $Saved.UserPath) 'User' 'mask PATH'
    Set-EnvTolerant 'Path' (Strip-JavaEntries $Saved.MachinePath) 'Machine' 'mask PATH'
    Remove-Item Env:JAVA_HOME -ErrorAction SilentlyContinue
    Remove-Item Env:JAROCK_JAVA_HOME -ErrorAction SilentlyContinue
    if (Test-Path -LiteralPath $Saved.JavaHomeFile -PathType Leaf) {
        if (Test-Path -LiteralPath $Saved.JavaHomeBackup -PathType Leaf) { Remove-Item -LiteralPath $Saved.JavaHomeBackup -Force }
        Rename-Item -LiteralPath $Saved.JavaHomeFile -NewName ([IO.Path]::GetFileName($Saved.JavaHomeBackup)) -Force
    }
    $env:Path = Strip-JavaEntries $env:Path
}
function Restore-Java {
    # Mirror the tolerance of Mask-Java: never let a non-elevated restore failure in
    # the finally block hide the real test result.
    Set-EnvTolerant 'JAVA_HOME' $Saved.UserJavaHome 'User' 'restore JAVA_HOME'
    Set-EnvTolerant 'JAVA_HOME' $Saved.MachineJavaHome 'Machine' 'restore JAVA_HOME'
    Set-EnvTolerant 'Path' $Saved.UserPath 'User' 'restore PATH'
    Set-EnvTolerant 'Path' $Saved.MachinePath 'Machine' 'restore PATH'
    if ([string]::IsNullOrWhiteSpace($Saved.ProcessJavaHome)) { Remove-Item Env:JAVA_HOME -ErrorAction SilentlyContinue }
    else { $env:JAVA_HOME = $Saved.ProcessJavaHome }
    if ([string]::IsNullOrWhiteSpace($Saved.JarockJavaHome)) { Remove-Item Env:JAROCK_JAVA_HOME -ErrorAction SilentlyContinue }
    else { $env:JAROCK_JAVA_HOME = $Saved.JarockJavaHome }
    if (Test-Path -LiteralPath $Saved.JavaHomeBackup -PathType Leaf) { Move-Item -LiteralPath $Saved.JavaHomeBackup -Destination $Saved.JavaHomeFile -Force }
    $env:Path = $Saved.ProcessPath
}

# scripts/jarock.ini is the only settings file, so the test borrows it: the
# original bytes are restored in the finally block.
$SettingsPath = Join-Path $Root 'scripts/jarock.ini'
$SettingsBackupPath = Join-Path $Root 'scripts/jarock.ini.jarock-test-backup'
$WelcomeMessageTestConfigPath = Join-Path $Root 'server\config\welcomemessage.json5'
$WelcomeMessageTestMarkerPath = Join-Path $Root 'server\config\.jarock-welcomemessage-configured'
$WelcomeMessageOriginalConfigExists = $false
$WelcomeMessageOriginalConfigBytes = $null
$WelcomeMessageOriginalMarkerExists = $false
$WelcomeMessageOriginalMarkerBytes = $null
$WelcomeMessageWasValidated = $false
$WelcomeMessageConfigText = ''

try {
    Write-Host '==> Simulating a Windows PC that does not have the Java prerequisites installed' -ForegroundColor Cyan

    # Jarock never replaces an existing world icon, so the "default icon"
    # check below only makes sense on a fresh world.
    $WorldExistedBefore = Test-Path -LiteralPath (Join-Path $Root 'server\world')

    # 1. scripts/jarock.ini must exist and select Fabric so the bootstrap never prompts.
    if (-not (Test-Path -LiteralPath $SettingsPath -PathType Leaf)) { throw 'scripts/jarock.ini is missing.' }
    if (Test-Path -LiteralPath $SettingsBackupPath -PathType Leaf) { Remove-Item -LiteralPath $SettingsBackupPath -Force }
    Copy-Item -LiteralPath $SettingsPath -Destination $SettingsBackupPath
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $Root 'scripts/update-launch-setting.ps1') -SettingsPath $SettingsPath -Name LOADER_TYPE -Value fabric
    if ($LASTEXITCODE -ne 0) { throw 'Could not set LOADER_TYPE=fabric for the test.' }

    # 2. The bundled installers must be present (the workflow checks out with Git LFS).
    Assert (Test-Path -LiteralPath (Join-Path $Root 'prerequisites\jre-8-windows-x64.exe') -PathType Leaf) 'The bundled JRE 8 installer is present'
    Assert (Test-Path -LiteralPath (Join-Path $Root 'prerequisites\OpenJDK25U-jdk_x64_windows_hotspot.msi') -PathType Leaf) 'The bundled Temurin JDK 25 MSI is present'
    $BootstrapScript = Get-Content -LiteralPath (Join-Path $Root 'scripts/bootstrap-server.ps1') -Raw
    Assert ($BootstrapScript.Contains('Start-InClassicConsole')) 'bootstrap defines the classic-console spawn helper'
    Assert ($BootstrapScript.Contains('DelegationConsole')) 'bootstrap uses the documented default-terminal registry value'

    # 3. Mask every Java source, then confirm the discovery finds nothing.
    . (Join-Path $Root 'scripts/java-runtime.ps1')
    # A JDK installed under Program Files or registered in the registry cannot be masked
    # from a non-elevated test, and the bootstrap would legitimately find it. Detect that
    # case first and skip the fresh-PC simulation instead of reporting a false failure.
    $MachineWideJava = Find-CompatibleJava -MinimumMajor 25
    Mask-Java
    $Result = Find-CompatibleJava -MinimumMajor 25
    if ($null -ne $MachineWideJava.Selected) {
        Write-Host "SKIP: this machine has a JDK 25 outside the environment variables ($($MachineWideJava.Selected)); the fresh-PC simulation needs a runner without one." -ForegroundColor Yellow
    }
    else {
        Assert ($null -eq $Result.Selected) 'Java discovery finds nothing after masking (simulated fresh PC)'

        # 4. Run the real bootstrap with the dry-run flag: it must detect the missing Java,
        #    simulate the installer sequence (JRE first, then the MSI) and stop with guidance.
        $env:JAROCK_PREREQ_DRY_RUN = '1'
        $BootOutput = @(& powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $Root 'scripts/bootstrap-server.ps1') 2>&1)
        $BootCode = $LASTEXITCODE
        Remove-Item Env:JAROCK_PREREQ_DRY_RUN -ErrorAction SilentlyContinue
        $BootText = $BootOutput -join "`n"
        Write-Host ''
        Write-Host '--- bootstrap output (no Java, dry-run) ---'
        $BootOutput | ForEach-Object { Write-Host $_ }
        Write-Host '--------------------------------------------'
        Assert ($BootText -match 'No compatible 64-bit Java 25\+ runtime was found') 'Bootstrap reports that no compatible Java is installed'
        Assert ($BootText -match 'Simulated launch 1: jre-8-windows-x64.exe') 'Dry run simulates the JRE 8 installer first'
        Assert ($BootText -match 'Simulated launch 2: msiexec /i OpenJDK25U-jdk_x64_windows_hotspot.msi') 'Dry run simulates the Temurin JDK 25 MSI second'
        Assert ($BootCode -eq 1) 'Bootstrap stops cleanly with exit code 1 after the simulated install'
    }

    # 5. Restore Java and run the REAL bootstrap: the loader and the mods must install.
    # Seed the known replaced welcome artifact so the bootstrap's migration cleanup is tested.
    $LegacyWelcomePath = Join-Path $Root 'server\mods\welcome_awa-fabric-26.2-2.4.jar'
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $LegacyWelcomePath) | Out-Null
    [IO.File]::WriteAllBytes($LegacyWelcomePath, [byte[]](1, 2, 3))
    # Simulate the generic file generated by Welcome Message before Jarock's first
    # managed startup. The bootstrap must migrate it to the Jarock template.
    $WelcomeMessageConfigPath = $WelcomeMessageTestConfigPath
    $WelcomeMessageMarkerPath = $WelcomeMessageTestMarkerPath
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $WelcomeMessageConfigPath) | Out-Null
    $WelcomeMessageOriginalConfigExists = Test-Path -LiteralPath $WelcomeMessageConfigPath -PathType Leaf
    if ($WelcomeMessageOriginalConfigExists) { $WelcomeMessageOriginalConfigBytes = [IO.File]::ReadAllBytes($WelcomeMessageConfigPath) }
    $WelcomeMessageOriginalMarkerExists = Test-Path -LiteralPath $WelcomeMessageMarkerPath -PathType Leaf
    if ($WelcomeMessageOriginalMarkerExists) { $WelcomeMessageOriginalMarkerBytes = [IO.File]::ReadAllBytes($WelcomeMessageMarkerPath) }
    [IO.File]::WriteAllText($WelcomeMessageConfigPath, '{"onlyRunOnDedicatedServers": true, "sendEmptyLineBeforeFirstMessage": false, "messageOneText": "Welcome to the server!", "messageOneColourIndex": 0, "messageOneOptionalURL": "", "messageTwoText": "", "messageTwoColourIndex": 0, "messageTwoOptionalURL": "", "messageThreeText": "", "messageThreeColourIndex": 0, "messageThreeOptionalURL": ""}', (New-Object Text.UTF8Encoding($false)))
    Remove-Item -LiteralPath $WelcomeMessageMarkerPath -Force -ErrorAction SilentlyContinue
    Restore-Java
    Write-Host '==> Java environment restored; running the real bootstrap' -ForegroundColor Cyan
    $RealOutput = @(& powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $Root 'scripts/bootstrap-server.ps1') 2>&1)
    $RealCode = $LASTEXITCODE
    $RealText = $RealOutput -join "`n"
    Write-Host ''
    Write-Host '--- bootstrap output (real, tail) ---'
    $RealOutput | Select-Object -Last 20 | ForEach-Object { Write-Host $_ }
    Write-Host '--------------------------------------'
    Assert ($RealCode -eq 0) "Bootstrap completes successfully (exit code $RealCode)"
    Assert (Test-Path -LiteralPath (Join-Path $Root 'icon.png') -PathType Leaf) 'Jarock default world icon is present'
    $ServerIconPath = Join-Path $Root 'server\server-icon.png'
    $ServerRuntimeIconPath = Join-Path $Root 'server\icon.png'
    Assert (Test-Path -LiteralPath $ServerIconPath -PathType Leaf) 'Jarock server icon is present in the server runtime'
    Assert (Test-Path -LiteralPath $ServerRuntimeIconPath -PathType Leaf) 'Jarock runtime icon is present in the server runtime'
    if ((Test-Path -LiteralPath $ServerIconPath -PathType Leaf) -and (Test-Path -LiteralPath $ServerRuntimeIconPath -PathType Leaf)) {
        Assert ((Get-Sha512 $ServerRuntimeIconPath) -eq (Get-Sha512 $ServerIconPath)) 'Runtime icon matches the server-list icon'
    }
    $DefaultWorldIconPath = Join-Path $Root 'server\world\icon.png'
    Assert (Test-Path -LiteralPath $DefaultWorldIconPath -PathType Leaf) 'The world has an icon'
    if ($WorldExistedBefore) {
        Write-Host 'SKIP: the world already existed, so Jarock keeps its icon instead of applying the default one.' -ForegroundColor Yellow
    }
    else {
        Assert ((Get-Sha512 $DefaultWorldIconPath) -eq (Get-Sha512 (Join-Path $Root 'icon.png'))) 'World icon matches the root Jarock icon'
    }
    # A world supplied by the operator may have its own icon. The next bootstrap must
    # preserve that custom file instead of replacing it with Jarock's default.
    $CustomWorldIconBytes = [byte[]](9, 8, 7, 6, 5)
    [IO.File]::WriteAllBytes($DefaultWorldIconPath, $CustomWorldIconBytes)
    $CustomWorldIconHash = Get-Sha512 $DefaultWorldIconPath
    Assert (Test-Path -LiteralPath $DefaultWorldIconPath -PathType Leaf) 'Custom world icon test fixture was created'
    Assert (Test-Path -LiteralPath (Join-Path $Root 'server\java-path.txt') -PathType Leaf) 'Selected Java executable was stored'
    # The bootstrap installs the manifest that matches the configured Minecraft
    # line, so the 26.3 manifests are the source of truth for this check: every
    # pinned entry must exist in server\mods with exactly the pinned bytes.
    $FabricManifestPath = Join-Path $Root 'server\mods-manifest-26.3-fabric.ps1'
    Assert (Test-Path -LiteralPath $FabricManifestPath -PathType Leaf) 'Fabric 26.3 manifest is present'
    $FabricMods = @(& { . $FabricManifestPath; $Mods })
    Assert ($FabricMods.Count -gt 0) 'Fabric 26.3 manifest pins at least one mod'
    # AUTO_UPDATE_MODS is on, so a managed mod that Modrinth published a newer build
    # for is stored under the new file name and recorded in the marker. The pinned
    # bytes are still the fallback; accept either the pin or the managed update.
    $ModMarkerPath = Join-Path $Root 'server\config\.jarock-mods'
    $ModMarker = @{}
    if (Test-Path -LiteralPath $ModMarkerPath -PathType Leaf) {
        foreach ($MarkerLine in (Get-Content -LiteralPath $ModMarkerPath -Encoding UTF8)) {
            $MarkerParts = ([string]$MarkerLine).Trim() -split '\|'
            if ($MarkerParts.Count -eq 3 -and $MarkerParts[0]) {
                $ModMarker[$MarkerParts[0]] = [pscustomobject]@{ Name = $MarkerParts[1]; Sha512 = $MarkerParts[2] }
            }
        }
    }
    foreach ($PinnedMod in $FabricMods) {
        $PinnedPath = Join-Path $Root ('server\mods\' + $PinnedMod.Name)
        if (Test-Path -LiteralPath $PinnedPath -PathType Leaf) {
            Assert ((Get-Sha512 $PinnedPath) -eq $PinnedMod.Sha512) "$($PinnedMod.Name) SHA-512 matches the pinned hash"
            continue
        }
        $Managed = if ($PinnedMod.PSObject.Properties.Name -contains 'Project' -and $ModMarker.ContainsKey([string]$PinnedMod.Project)) { $ModMarker[[string]$PinnedMod.Project] } else { $null }
        $ManagedPath = if ($null -ne $Managed) { Join-Path $Root ('server\mods\' + $Managed.Name) } else { '' }
        Assert ($null -ne $Managed -and (Test-Path -LiteralPath $ManagedPath -PathType Leaf)) "$($PinnedMod.Name) was downloaded into server/mods (or updated to a newer managed build)"
        if ($null -ne $Managed -and (Test-Path -LiteralPath $ManagedPath -PathType Leaf)) {
            Assert ((Get-Sha512 $ManagedPath) -eq $Managed.Sha512) "$($Managed.Name) SHA-512 matches the managed update marker"
        }
    }
    Assert (-not (Test-Path -LiteralPath $LegacyWelcomePath -PathType Leaf)) 'Replaced welcome artifact was removed during bootstrap'
    Assert (Test-Path -LiteralPath (Join-Path $Root 'server\config\welcomemessage.json5.jarock') -PathType Leaf) 'The welcome template ships with the package'
    $NeoForgeManifestPath = Join-Path $Root 'server\mods-manifest-26.3-neoforge.ps1'
    $NeoForgeManifest = Get-Content -LiteralPath $NeoForgeManifestPath -Raw
    $NeoForgeMods = @(& { . $NeoForgeManifestPath; $Mods })
    Assert ($NeoForgeMods.Count -gt 0) 'NeoForge 26.3 manifest pins at least one mod'
    Assert ($NeoForgeManifest -notmatch '(?i)essential_commands|ec-core|offlinecommands|InvView') 'NeoForge manifest excludes Fabric-only Essential Commands, InvView and OfflineCommands'
    foreach ($PinnedMod in $NeoForgeMods) {
        Assert ($PinnedMod.Sha512 -match '^[0-9a-f]{128}$') "$($PinnedMod.Name) pins a full SHA-512"
        Assert ($PinnedMod.Url -match '^https://cdn\.modrinth\.com/data/') "$($PinnedMod.Name) downloads from Modrinth"
    }
    # One real NeoForge download proves that the pinned URL and hash still resolve.
    $NeoForgeProbe = $NeoForgeMods[0]
    $NeoForgeTemp = Join-Path ([IO.Path]::GetTempPath()) ("jarock-neoforge-probe-$PID.jar")
    try {
        Invoke-TestDownload -Url $NeoForgeProbe.Url -Path $NeoForgeTemp
        Assert (Test-Path -LiteralPath $NeoForgeTemp -PathType Leaf) 'NeoForge probe artifact downloaded to an isolated temporary path'
        if (Test-Path -LiteralPath $NeoForgeTemp -PathType Leaf) {
            Assert ((Get-Sha512 $NeoForgeTemp) -eq $NeoForgeProbe.Sha512) "$($NeoForgeProbe.Name) SHA-512 matches the pinned hash"
        }
    } finally {
        Remove-Item -LiteralPath $NeoForgeTemp -Force -ErrorAction SilentlyContinue
    }
    # The loader-neutral datapack manifest is verified the same way as the mod ones.
    $DatapackManifestPath = Join-Path $Root 'server\datapacks-manifest.ps1'
    $DatapackManifest = Get-Content -LiteralPath $DatapackManifestPath -Raw
    $Datapacks = @(& { . $DatapackManifestPath; $Datapacks })
    Assert ($Datapacks.Count -gt 0) 'The datapack manifest pins at least one datapack'
    foreach ($PinnedDatapack in $Datapacks) {
        Assert ($PinnedDatapack.Sha512 -match '^[0-9a-f]{128}$') "$($PinnedDatapack.Name) pins a full SHA-512"
    }
    $DatapackPath = Join-Path $Root ('server\world\datapacks\' + $Datapacks[0].Name)
    Assert (Test-Path -LiteralPath $DatapackPath -PathType Leaf) 'The managed datapack was installed in the configured world/datapacks folder'
    if (Test-Path -LiteralPath $DatapackPath -PathType Leaf) {
        Assert ((Get-Sha512 $DatapackPath) -eq $Datapacks[0].Sha512) 'Downloaded datapack SHA-512 matches the pinned hash'
    }
    Assert ($RealText -match 'datapacks|BetterMultiplayerSleep') 'Bootstrap reports configured datapack installation support'
    $DatapackConfigRoot = Join-Path $Root 'server\\config'
    $DatapackMarkerPath = Join-Path $DatapackConfigRoot '.jarock-datapacks'
    Assert (Test-Path -LiteralPath $DatapackMarkerPath -PathType Leaf) 'Jarock datapack marker was created'
    $DatapackMarkerBefore = if (Test-Path -LiteralPath $DatapackMarkerPath -PathType Leaf) { Get-Content -LiteralPath $DatapackMarkerPath -Raw } else { '' }
    $DatapackPathBefore = if (Test-Path -LiteralPath $DatapackPath -PathType Leaf) { (Get-Item -LiteralPath $DatapackPath).FullName } else { '' }
    # The bootstrap must self-heal a missing Welcome Message template (for example
    # an installation updated from a version created before the template existed)
    # instead of failing startup. Delete the template and let the second bootstrap
    # restore it automatically.
    $WelcomeMessageTemplatePath = Join-Path $Root 'server\config\welcomemessage.json5.jarock'
    $LegacyWelcomeMessageTemplatePath = Join-Path $Root 'server\config\welcomemessage.json5.template-jarock'
    $WelcomeMessageTemplateHash = if (Test-Path -LiteralPath $WelcomeMessageTemplatePath -PathType Leaf) { Get-Sha512 $WelcomeMessageTemplatePath } else { '' }
    if (Test-Path -LiteralPath $WelcomeMessageTemplatePath -PathType Leaf) {
        Move-Item -LiteralPath $WelcomeMessageTemplatePath -Destination $LegacyWelcomeMessageTemplatePath -Force
    }
    $SecondBootstrapOutput = @(& powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $Root 'scripts/bootstrap-server.ps1') 2>&1)
    $SecondBootstrapCode = $LASTEXITCODE
    Assert ($SecondBootstrapCode -eq 0) 'A second bootstrap remains idempotent'
    Assert (Test-Path -LiteralPath $WelcomeMessageTemplatePath -PathType Leaf) 'Bootstrap migrates/restores the Welcome Message template'
    Assert ((Get-Sha512 $WelcomeMessageTemplatePath) -eq $WelcomeMessageTemplateHash) 'Bootstrap preserves the migrated Welcome Message template content'
    Assert (-not (Test-Path -LiteralPath $LegacyWelcomeMessageTemplatePath -PathType Leaf)) 'Bootstrap removes the legacy Welcome Message template alias'
    Assert ((Test-Path -LiteralPath $DefaultWorldIconPath -PathType Leaf) -and ((Get-Sha512 $DefaultWorldIconPath) -eq $CustomWorldIconHash)) 'Second bootstrap preserves a custom world icon'
    Assert ((Test-Path -LiteralPath $DatapackPath -PathType Leaf) -and ((Get-Item -LiteralPath $DatapackPath).FullName -eq $DatapackPathBefore)) 'Second bootstrap preserves the managed datapack path'
    Assert ((Get-Content -LiteralPath $DatapackMarkerPath -Raw) -eq $DatapackMarkerBefore) 'Second bootstrap preserves the datapack marker'

    # 6. Accept the EULA and boot the real server; stop it automatically after the ready banner.
    $EulaPath = Join-Path $Root 'server\eula.txt'
    Assert (Test-Path -LiteralPath $EulaPath -PathType Leaf) 'The bootstrap created server/eula.txt'
    $EulaText = if (Test-Path -LiteralPath $EulaPath -PathType Leaf) { Get-Content -LiteralPath $EulaPath -Raw } else { '' }
    Assert ($EulaText -match '(?m)^\s*eula\s*=\s*true\s*$') 'The bootstrap accepts the Minecraft EULA automatically'

    Write-Host '==> Starting the Jarock server (nogui); it stops automatically after the ready banner' -ForegroundColor Cyan
    $Psi = New-Object System.Diagnostics.ProcessStartInfo
    $Psi.FileName = 'powershell.exe'
    $Psi.Arguments = '-NoProfile -ExecutionPolicy Bypass -File "' + (Join-Path $Root 'scripts/run-server.ps1') + '" -ServerDirectory "' + (Join-Path $Root 'server') + '" -GuiMode nogui'
    $Psi.WorkingDirectory = $Root
    $Psi.UseShellExecute = $false
    $Psi.RedirectStandardInput = $true
    $Psi.RedirectStandardOutput = $true
    $Psi.RedirectStandardError = $true
    $ServerProc = [System.Diagnostics.Process]::Start($Psi)
    # Read the server output synchronously on the main thread. Do NOT use the async
    # DataReceived event handlers: their scriptblock callback runs on a thread without a
    # runspace, so pwsh dies with "There is no Runspace available to run scripts in this
    # thread" (on CI this surfaces as the cryptic 0xE0434352 process crash).
    $script:ServerStopped = $false
    $TimedOut = $false
    $OutEof = $false; $ErrEof = $false
    $CollectedOutput = New-Object System.Collections.Generic.List[string]
    $OutTask = $ServerProc.StandardOutput.ReadLineAsync()
    $ErrTask = $ServerProc.StandardError.ReadLineAsync()
    # The first boot on a machine downloads the Fabric libraries, scans every mod jar
    # and generates the world, which can take far longer than a warm start (a slow or
    # antivirus-scanned disk has been observed taking 30 minutes); allow 60 minutes.
    $Deadline = [DateTime]::UtcNow.AddMinutes(60)
    # Keep draining both redirected streams after the child exits. A PowerShell
    # parse/runtime failure can close the process before its final error lines have
    # been consumed; stopping at HasExited would hide the useful diagnostic.
    while ((-not $OutEof -or -not $ErrEof) -and -not $TimedOut) {
        $Progress = $false
        # Read every line that is already available before sleeping. A slow reader lets
        # the OS pipe buffer fill, which blocks the server's console log appender and
        # then the whole server thread: the boot looks hung for minutes even though the
        # process is only waiting for this loop to drain its stdout.
        $Burst = 0
        while (-not $OutEof -and $Burst -lt 5000 -and $OutTask.Wait(0)) {
            $Burst++
            # Guard the Result access: if the child hard-crashes and its pipe faults
            # instead of EOF, Result throws; treat it as end of stream.
            try { $Line = $OutTask.Result } catch { $OutEof = $true; $Line = $null }
            if ($null -ne $Line) {
                Write-Host $Line
                $CollectedOutput.Add($Line)
                if (-not $script:ServerStopped -and ($Line -match 'The Jarock server has finished loading' -or $Line -match 'Done \(\d+\.\d+s\)')) {
                    # Preferred trigger: the ready banner message. Fallback: the vanilla
                    # "Done (...)!" line, in case Geyser does not print its ready line on CI.
                    $script:ServerStopped = $true
                    try { $ServerProc.StandardInput.WriteLine('stop') } catch { }
                }
            }
            else { $OutEof = $true }
            if (-not $OutEof) { $OutTask = $ServerProc.StandardOutput.ReadLineAsync() }
            $Progress = $true
        }
        $Burst = 0
        while (-not $ErrEof -and $Burst -lt 5000 -and $ErrTask.Wait(0)) {
            $Burst++
            try { $ErrLine = $ErrTask.Result } catch { $ErrEof = $true; $ErrLine = $null }
            if ($null -ne $ErrLine) { Write-Host $ErrLine }
            else { $ErrEof = $true }
            if (-not $ErrEof) { $ErrTask = $ServerProc.StandardError.ReadLineAsync() }
            $Progress = $true
        }
        if ([DateTime]::UtcNow -gt $Deadline) { $TimedOut = $true }
        if (-not $Progress) { Start-Sleep -Milliseconds 50 }
    }
    if ($TimedOut) { try { $ServerProc.Kill() } catch { } }
    if (-not $ServerProc.HasExited) { $ServerProc.WaitForExit(30000) | Out-Null }
    $ServerExitCode = $ServerProc.ExitCode
    $LatestLogPath = Join-Path $Root 'server\\logs\\latest.log'
    $LatestLogText = if (Test-Path -LiteralPath $LatestLogPath -PathType Leaf) { Get-Content -LiteralPath $LatestLogPath -Raw } else { '' }
    Assert ($LatestLogText -match '(?i)welcomemessage|welcome message') 'Fabric server log includes Welcome Message'
    Assert ($LatestLogText -match '(?i)offline[_-]?commands') 'Fabric server log includes OfflineCommands'
    Assert ($LatestLogText -match '(?i)inv[_-]?view') 'Fabric server log includes InvView'
    Assert ($LatestLogText -match '(?i)async') 'Fabric server log includes Async'
    Assert ($LatestLogText -match 'essential_commands') 'Fabric server log includes Essential Commands'
    Assert ($LatestLogText -match 'ec[_-]?core') 'Fabric server log includes the Essential Commands core dependency'
    $CollectedText = $CollectedOutput -join "`n"
    Assert $script:ServerStopped 'Ready banner appeared (server finished loading)'
    Assert ($ServerExitCode -eq 0) "Server shut down cleanly (exit code $ServerExitCode)"
    Assert ($CollectedText -match '(?m)seed:\s+(-?\d+)') 'The ready status shows the world seed read from world_gen_settings.dat'
    Assert ($CollectedText -match 'shutting down and saving the world') 'The server console warns that the world is being saved when stop is detected'
    Assert ($CollectedText -match 'SAFE TO CLOSE') 'The server console prints the SAFE TO CLOSE confirmation after the world save completes'
    # Welcome Message 2.9 (Collective DuskConfig) imports the Jarock template on the
    # first start and keeps its own file at config/serilum/welcomemessage.json, so the
    # Jarock values must survive that migration.
    $WelcomeMessageConfigPath = Join-Path $Root 'server\config\serilum\welcomemessage.json'
    Assert (Test-Path -LiteralPath $WelcomeMessageConfigPath -PathType Leaf) 'Welcome Message generated its configuration'
    Assert (Test-Path -LiteralPath $WelcomeMessageTemplatePath -PathType Leaf) 'Jarock Welcome Message template is present'
    Assert (Test-Path -LiteralPath $WelcomeMessageMarkerPath -PathType Leaf) 'Jarock Welcome Message migration marker was created'
    $WelcomeMessageWasValidated = $false
    $WelcomeMessageConfigText = ''
    if ((Test-Path -LiteralPath $WelcomeMessageConfigPath -PathType Leaf) -and (Test-Path -LiteralPath $WelcomeMessageTemplatePath -PathType Leaf)) {
        $WelcomeMessageConfigText = Get-Content -LiteralPath $WelcomeMessageConfigPath -Raw
        $WelcomeMessageWasValidated = $true
        Assert ($WelcomeMessageConfigText -match '"value": "Welcome to the Jarock server!"') 'Welcome Message uses the Jarock first message'
        Assert ($WelcomeMessageConfigText -match '"value": "https://piboh.github.io/jarock/index.html"') 'Welcome Message uses the Jarock website link'
        Assert ($WelcomeMessageConfigText -match '"value": "https://piboh.github.io/jarock/downloads.html"') 'Welcome Message uses the Jarock downloads link'
        Assert ($WelcomeMessageConfigText -match '"value": "https://github.com/PiBOH/jarock/issues/new/choose"') 'Welcome Message uses the Jarock issue link'
    }

    if ($WelcomeMessageWasValidated) {
        $WelcomeMessageCustomizedText = $WelcomeMessageConfigText -replace '"value": "Welcome to the Jarock server!"', '"value": "My customized Jarock welcome!"'
        [IO.File]::WriteAllText($WelcomeMessageConfigPath, $WelcomeMessageCustomizedText, (New-Object Text.UTF8Encoding($false)))
        $WelcomeMessageCustomHash = Get-Sha512 $WelcomeMessageConfigPath
        $ThirdBootstrapOutput = @(& powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $Root 'scripts/bootstrap-server.ps1') 2>&1)
        $ThirdBootstrapCode = $LASTEXITCODE
        Assert ($ThirdBootstrapCode -eq 0) 'A third bootstrap remains successful after Welcome Message customization'
        Assert ((Get-Sha512 $WelcomeMessageConfigPath) -eq $WelcomeMessageCustomHash) 'Later Welcome Message customization is preserved'
        Assert ((Get-Content -LiteralPath $WelcomeMessageConfigPath -Raw) -match '"value": "My customized Jarock welcome!"') 'Customized Welcome Message text remains unchanged'
    } else {
        Assert $false 'Welcome Message customization could not be tested because the migrated config was unavailable'
    }

    # 7. Summary.
    Write-Host ''
    Write-Host "Test summary: $Pass passed, $Fail failed." -ForegroundColor Cyan
    if ($Fail -gt 0) { exit 1 }
    Write-Host 'All tests passed.' -ForegroundColor Green
}
catch {
    # Report any unexpected failure with a clear message and a clean exit code instead of
    # letting pwsh die with the cryptic 0xE0434352 (unhandled .NET exception) code.
    Write-Host ''
    Write-Host "HARNESS ERROR: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ScriptStackTrace) { Write-Host $_.ScriptStackTrace -ForegroundColor DarkGray }
    exit 1
}
finally {
    if ($WelcomeMessageOriginalConfigExists) { [IO.File]::WriteAllBytes($WelcomeMessageTestConfigPath, $WelcomeMessageOriginalConfigBytes) }
    else { Remove-Item -LiteralPath $WelcomeMessageTestConfigPath -Force -ErrorAction SilentlyContinue }
    if ($WelcomeMessageOriginalMarkerExists) { [IO.File]::WriteAllBytes($WelcomeMessageTestMarkerPath, $WelcomeMessageOriginalMarkerBytes) }
    else { Remove-Item -LiteralPath $WelcomeMessageTestMarkerPath -Force -ErrorAction SilentlyContinue }
    if (Test-Path -LiteralPath $SettingsBackupPath -PathType Leaf) { Move-Item -LiteralPath $SettingsBackupPath -Destination $SettingsPath -Force }
    Restore-Java
}
