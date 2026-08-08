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

$Root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
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

$SettingsPath = Join-Path $PSScriptRoot 'server-launch-settings.ini'
$SettingsTemplate = Join-Path $PSScriptRoot 'server-launch-settings.ini.template'

try {
    Write-Host '==> Simulating a Windows PC that does not have the Java prerequisites installed' -ForegroundColor Cyan

    # 1. Local settings must exist and select Fabric so the bootstrap never prompts.
    if (-not (Test-Path -LiteralPath $SettingsPath -PathType Leaf)) {
        if (Test-Path -LiteralPath (Join-Path $Root 'server-launch-settings.ini') -PathType Leaf) {
            Move-Item -LiteralPath (Join-Path $Root 'server-launch-settings.ini') -Destination $SettingsPath
        }
        elseif (-not (Test-Path -LiteralPath $SettingsTemplate -PathType Leaf)) { throw 'scripts/server-launch-settings.ini.template is missing.' }
        else { Copy-Item -LiteralPath $SettingsTemplate -Destination $SettingsPath }
    }
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'update-launch-setting.ps1') -SettingsPath $SettingsPath -Name LOADER_TYPE -Value fabric
    if ($LASTEXITCODE -ne 0) { throw 'Could not set LOADER_TYPE=fabric for the test.' }

    # 2. The bundled installers must be present (the workflow checks out with Git LFS).
    Assert (Test-Path -LiteralPath (Join-Path $Root 'prerequisites\jre-8-windows-x64.exe') -PathType Leaf) 'The bundled JRE 8 installer is present'
    Assert (Test-Path -LiteralPath (Join-Path $Root 'prerequisites\OpenJDK25U-jdk_x64_windows_hotspot.msi') -PathType Leaf) 'The bundled Temurin JDK 25 MSI is present'

    # 3. Mask every Java source, then confirm the discovery finds nothing.
    Mask-Java
    . (Join-Path $PSScriptRoot 'java-runtime.ps1')
    $Result = Find-CompatibleJava -MinimumMajor 25
    Assert ($null -eq $Result.Selected) 'Java discovery finds nothing after masking (simulated fresh PC)'

    # 4. Run the real bootstrap with the dry-run flag: it must detect the missing Java,
    #    simulate the installer sequence (JRE first, then the MSI) and stop with guidance.
    $env:JAROCK_PREREQ_DRY_RUN = '1'
    $BootOutput = @(& powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'bootstrap-server.ps1') 2>&1)
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

    # 5. Restore Java and run the REAL bootstrap: the loader and the mods must install.
    Restore-Java
    Write-Host '==> Java environment restored; running the real bootstrap' -ForegroundColor Cyan
    $RealOutput = @(& powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'bootstrap-server.ps1') 2>&1)
    $RealCode = $LASTEXITCODE
    $RealText = $RealOutput -join "`n"
    Write-Host ''
    Write-Host '--- bootstrap output (real, tail) ---'
    $RealOutput | Select-Object -Last 20 | ForEach-Object { Write-Host $_ }
    Write-Host '--------------------------------------'
    Assert ($RealCode -eq 0) "Bootstrap completes successfully (exit code $RealCode)"
    Assert (Test-Path -LiteralPath (Join-Path $Root 'server\java-path.txt') -PathType Leaf) 'Selected Java executable was stored'
    $FabricManifest = Get-Content -LiteralPath (Join-Path $Root 'server\mods-manifest.ps1') -Raw
    Assert ($FabricManifest -match 'InvView-1\.4\.21-26\.2\+\.jar') 'Fabric manifest contains InvView for Minecraft 26.2'
    Assert ($FabricManifest -match '6eec7e7831316f9768b42daa441af83442ec9d30cfe2a963b51d77339805e4c8cdd8283ae758ec73ce4bfbce2a6454c0a6389683e830acb6ff1fb0dcef2534ea') 'InvView SHA-512 is pinned'
    $InvViewPath = Join-Path $Root 'server\\mods\\InvView-1.4.21-26.2+.jar'
    Assert (Test-Path -LiteralPath $InvViewPath -PathType Leaf) 'InvView was downloaded into server/mods'
    if (Test-Path -LiteralPath $InvViewPath -PathType Leaf) {
        Assert ((Get-Sha512 $InvViewPath) -eq '6eec7e7831316f9768b42daa441af83442ec9d30cfe2a963b51d77339805e4c8cdd8283ae758ec73ce4bfbce2a6454c0a6389683e830acb6ff1fb0dcef2534ea') 'Downloaded InvView SHA-512 matches the pinned hash'
    }
    Assert ($FabricManifest -match 'linksinchat-1\.3\.1\+26\.2\.jar') 'Fabric manifest contains Links In Chat for Minecraft 26.2'
    Assert ($FabricManifest -match '9cbd4eb2b26b518920a2df78c22c95c998ded2f36b6a524881f96f22a2f1a111790791283d32613db8eb71f48e71b30625114c3eaf9d134cd57b776163290067') 'Links In Chat SHA-512 is pinned'
    $LinksInChatPath = Join-Path $Root 'server\mods\linksinchat-1.3.1+26.2.jar'
    Assert (Test-Path -LiteralPath $LinksInChatPath -PathType Leaf) 'Links In Chat was downloaded into server/mods'
    if (Test-Path -LiteralPath $LinksInChatPath -PathType Leaf) {
        $LinksInChatHash = Get-Sha512 $LinksInChatPath
        Assert ($LinksInChatHash -eq '9cbd4eb2b26b518920a2df78c22c95c998ded2f36b6a524881f96f22a2f1a111790791283d32613db8eb71f48e71b30625114c3eaf9d134cd57b776163290067') 'Downloaded Links In Chat SHA-512 matches the pinned hash'
    }
    Assert ($FabricManifest -match 'welcome_awa-fabric-26\.2-2\.4\.jar') 'Fabric manifest contains Welcome AWA for Minecraft 26.2'
    Assert ($FabricManifest -match '981c813ae53a230b49b8e2a33f83cb6fac810847baffaef43369f3caeccace19b7d5f578093277d656f5e5817ec18139485b8d76bee8ec6329279cc6eaa388c5') 'Welcome AWA SHA-512 is pinned'
    Assert ($FabricManifest -match 'essential_commands-0\.41\.0-mc26\.2\.jar') 'Fabric manifest contains Essential Commands for Minecraft 26.2'
    Assert ($FabricManifest -match 'ec-core-1\.3\.0-mc26\.2\.jar') 'Fabric manifest contains the Essential Commands core dependency'
    Assert ($FabricManifest -match 'e70b62784e5dd0e41477cd0d9184a6da11c62f9f53899dd5309742a43ccf6c0abd4faddbc942799e94edb37daf88d09a0af66f99202c8e199ee465f98732c919') 'Essential Commands SHA-512 is pinned'
    $EssentialCommandsPath = Join-Path $Root 'server\\mods\\essential_commands-0.41.0-mc26.2.jar'
    Assert (Test-Path -LiteralPath $EssentialCommandsPath -PathType Leaf) 'Essential Commands was downloaded into server/mods'
    if (Test-Path -LiteralPath $EssentialCommandsPath -PathType Leaf) {
        Assert ((Get-Sha512 $EssentialCommandsPath) -eq 'e70b62784e5dd0e41477cd0d9184a6da11c62f9f53899dd5309742a43ccf6c0abd4faddbc942799e94edb37daf88d09a0af66f99202c8e199ee465f98732c919') 'Downloaded Essential Commands SHA-512 matches the pinned hash'
    }
    $EcCorePath = Join-Path $Root 'server\\mods\\ec-core-1.3.0-mc26.2.jar'
    Assert (Test-Path -LiteralPath $EcCorePath -PathType Leaf) 'Essential Commands core dependency was downloaded into server/mods'
    if (Test-Path -LiteralPath $EcCorePath -PathType Leaf) {
        Assert ((Get-Sha512 $EcCorePath) -eq '44c7b74e07050334b5b2b9a3448232dcc2eb94ecf9769827e64b0fc290a54b47ef7edd623d2546cf636e554e6406e77ab0b84e546ae253543a26a7692d2a945f') 'Downloaded Essential Commands core SHA-512 matches the pinned hash'
    }
    Assert ($FabricManifest -match 'NoChatReports-FABRIC-26\.2-v2\.20\.1\.jar') 'Fabric manifest contains No Chat Reports for Minecraft 26.2'
    Assert ($FabricManifest -match '139dd09e04cc66fe4745264ddfbe3249be6e956326c931eb9707f9a640bbc011a4f1fd5684d04ca90e1b473be55772b0279e5c2f935c2f2e85d054e2ab0a6923') 'Fabric No Chat Reports SHA-512 is pinned'
    $NoChatReportsFabricPath = Join-Path $Root 'server\\mods\\NoChatReports-FABRIC-26.2-v2.20.1.jar'
    Assert (Test-Path -LiteralPath $NoChatReportsFabricPath -PathType Leaf) 'Fabric No Chat Reports was downloaded into server/mods'
    if (Test-Path -LiteralPath $NoChatReportsFabricPath -PathType Leaf) {
        Assert ((Get-Sha512 $NoChatReportsFabricPath) -eq '139dd09e04cc66fe4745264ddfbe3249be6e956326c931eb9707f9a640bbc011a4f1fd5684d04ca90e1b473be55772b0279e5c2f935c2f2e85d054e2ab0a6923') 'Downloaded Fabric No Chat Reports SHA-512 matches the pinned hash'
    }
    $WelcomeAwaPath = Join-Path $Root 'server\mods\welcome_awa-fabric-26.2-2.4.jar'
    Assert (Test-Path -LiteralPath $WelcomeAwaPath -PathType Leaf) 'Welcome AWA was downloaded into server/mods'
    if (Test-Path -LiteralPath $WelcomeAwaPath -PathType Leaf) {
        $WelcomeAwaHash = Get-Sha512 $WelcomeAwaPath
        Assert ($WelcomeAwaHash -eq '981c813ae53a230b49b8e2a33f83cb6fac810847baffaef43369f3caeccace19b7d5f578093277d656f5e5817ec18139485b8d76bee8ec6329279cc6eaa388c5') 'Downloaded Welcome AWA SHA-512 matches the pinned hash'
    }
    $DatapackManifest = Get-Content -LiteralPath (Join-Path $Root 'server\\datapacks-manifest.ps1') -Raw
    Assert ($DatapackManifest -match 'BetterMultiplayerSleep-1\.1\.0-1\.21\.11\+\.zip') 'Datapack manifest contains Better Multiplayer Sleep for Minecraft 26.2'
    Assert ($DatapackManifest -match '8ecadc28a73bbe12dade19d5dfa0840dc8d28b2bd80c0ef154779063375fb5c96cc7c877c55c627909f2aea2907a30b2a8f2038769d269443f0e1689f7f3017a') 'Better Multiplayer Sleep SHA-512 is pinned'
    $DatapackPath = Join-Path $Root 'server\\world\\datapacks\\BetterMultiplayerSleep-1.1.0-1.21.11+.zip'
    Assert (Test-Path -LiteralPath $DatapackPath -PathType Leaf) 'Better Multiplayer Sleep was installed in the configured world/datapacks folder'
    if (Test-Path -LiteralPath $DatapackPath -PathType Leaf) {
        $DatapackHash = Get-Sha512 $DatapackPath
        Assert ($DatapackHash -eq '8ecadc28a73bbe12dade19d5dfa0840dc8d28b2bd80c0ef154779063375fb5c96cc7c877c55c627909f2aea2907a30b2a8f2038769d269443f0e1689f7f3017a') 'Downloaded Better Multiplayer Sleep SHA-512 matches the pinned hash'
    }
    Assert ($RealText -match 'datapacks|BetterMultiplayerSleep') 'Bootstrap reports configured datapack installation support'
    $NeoForgeManifest = Get-Content -LiteralPath (Join-Path $Root 'server\\mods-manifest-neoforge.ps1') -Raw
    Assert ($NeoForgeManifest -notmatch '(?i)essential_commands|ec-core') 'NeoForge manifest excludes Fabric-only Essential Commands'
    Assert ($NeoForgeManifest -match 'NoChatReports-NEOFORGE-26\\.2-v2\\.20\\.1\\.jar') 'NeoForge manifest contains No Chat Reports for Minecraft 26.2'
    Assert ($NeoForgeManifest -match '782b4b081c5d8bdd19139894feacc9c48b6fb025856e904c2bb9ee84438734de96eb5540f471e57830ecb92df8f18f6da20a1b619c4806b16f06780250999d03') 'NeoForge No Chat Reports SHA-512 is pinned'
    $NoChatReportsNeoForgeTemp = Join-Path ([IO.Path]::GetTempPath()) ("jarock-NoChatReports-NEOFORGE-26.2-v2.20.1-$PID.jar")
    try {
        Invoke-TestDownload -Url 'https://cdn.modrinth.com/data/qQyHxfxd/versions/k9fqrSE6/NoChatReports-NEOFORGE-26.2-v2.20.1.jar' -Path $NoChatReportsNeoForgeTemp
        Assert (Test-Path -LiteralPath $NoChatReportsNeoForgeTemp -PathType Leaf) 'NeoForge No Chat Reports downloaded to an isolated temporary path'
        if (Test-Path -LiteralPath $NoChatReportsNeoForgeTemp -PathType Leaf) {
            Assert ((Get-Item -LiteralPath $NoChatReportsNeoForgeTemp).Length -eq 237914) 'NeoForge No Chat Reports size matches the pinned artifact'
            Assert ((Get-Sha512 $NoChatReportsNeoForgeTemp) -eq '782b4b081c5d8bdd19139894feacc9c48b6fb025856e904c2bb9ee84438734de96eb5540f471e57830ecb92df8f18f6da20a1b619c4806b16f06780250999d03') 'Downloaded NeoForge No Chat Reports SHA-512 matches the pinned hash'
        }
    } finally {
        Remove-Item -LiteralPath $NoChatReportsNeoForgeTemp -Force -ErrorAction SilentlyContinue
    }
    $DatapackConfigRoot = Join-Path $Root 'server\\config'
    $DatapackMarkerPath = Join-Path $DatapackConfigRoot '.jarock-datapacks'
    Assert (Test-Path -LiteralPath $DatapackMarkerPath -PathType Leaf) 'Jarock datapack marker was created'
    $DatapackMarkerBefore = if (Test-Path -LiteralPath $DatapackMarkerPath -PathType Leaf) { Get-Content -LiteralPath $DatapackMarkerPath -Raw } else { '' }
    $DatapackPathBefore = if (Test-Path -LiteralPath $DatapackPath -PathType Leaf) { (Get-Item -LiteralPath $DatapackPath).FullName } else { '' }
    $SecondBootstrapOutput = @(& powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'bootstrap-server.ps1') 2>&1)
    $SecondBootstrapCode = $LASTEXITCODE
    Assert ($SecondBootstrapCode -eq 0) 'A second bootstrap remains idempotent'
    Assert ((Test-Path -LiteralPath $DatapackPath -PathType Leaf) -and ((Get-Item -LiteralPath $DatapackPath).FullName -eq $DatapackPathBefore)) 'Second bootstrap preserves the managed datapack path'
    Assert ((Get-Content -LiteralPath $DatapackMarkerPath -Raw) -eq $DatapackMarkerBefore) 'Second bootstrap preserves the datapack marker'

    # 6. Accept the EULA and boot the real server; stop it automatically after the ready banner.
    $EulaPath = Join-Path $Root 'server\eula.txt'
    if (Test-Path -LiteralPath $EulaPath -PathType Leaf) {
        (Get-Content -LiteralPath $EulaPath -Raw) -replace 'eula=false', 'eula=true' | Set-Content -LiteralPath $EulaPath -NoNewline
    }
    else { throw 'server/eula.txt was not created by the bootstrap.' }

    Write-Host '==> Starting the Jarock server (nogui); it stops automatically after the ready banner' -ForegroundColor Cyan
    $Psi = New-Object System.Diagnostics.ProcessStartInfo
    $Psi.FileName = 'powershell.exe'
    $Psi.Arguments = '-NoProfile -ExecutionPolicy Bypass -File "' + (Join-Path $PSScriptRoot 'run-server.ps1') + '" -ServerDirectory "' + (Join-Path $Root 'server') + '" -GuiMode nogui'
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
    $OutTask = $ServerProc.StandardOutput.ReadLineAsync()
    $ErrTask = $ServerProc.StandardError.ReadLineAsync()
    $Deadline = [DateTime]::UtcNow.AddMinutes(15)
    # Keep draining both redirected streams after the child exits. A PowerShell
    # parse/runtime failure can close the process before its final error lines have
    # been consumed; stopping at HasExited would hide the useful diagnostic.
    while ((-not $OutEof -or -not $ErrEof) -and -not $TimedOut) {
        $OutReady = $OutTask.Wait(1000)
        if ($OutReady) {
            # Guard the Result access: if the child hard-crashes and its pipe faults
            # instead of EOF, Result throws; treat it as end of stream.
            try { $Line = $OutTask.Result } catch { $OutEof = $true; $Line = $null }
            if ($null -ne $Line) {
                Write-Host $Line
                if (-not $script:ServerStopped -and ($Line -match 'The Jarock server has finished loading' -or $Line -match 'Done \(\d+\.\d+s\)')) {
                    # Preferred trigger: the ready banner message. Fallback: the vanilla
                    # "Done (...)!" line, in case Geyser does not print its ready line on CI.
                    $script:ServerStopped = $true
                    try { $ServerProc.StandardInput.WriteLine('stop') } catch { }
                }
            }
            else { $OutEof = $true }
            if (-not $OutEof) { $OutTask = $ServerProc.StandardOutput.ReadLineAsync() }
        }
        $ErrReady = $ErrTask.Wait(0)
        if ($ErrReady) {
            try { $ErrLine = $ErrTask.Result } catch { $ErrEof = $true; $ErrLine = $null }
            if ($null -ne $ErrLine) { Write-Host $ErrLine }
            else { $ErrEof = $true }
            if (-not $ErrEof) { $ErrTask = $ServerProc.StandardError.ReadLineAsync() }
        }
        if ([DateTime]::UtcNow -gt $Deadline) { $TimedOut = $true }
        Start-Sleep -Milliseconds 150
    }
    if ($TimedOut) { try { $ServerProc.Kill() } catch { } }
    if (-not $ServerProc.HasExited) { $ServerProc.WaitForExit(30000) | Out-Null }
    $ServerExitCode = $ServerProc.ExitCode
    $LatestLogPath = Join-Path $Root 'server\\logs\\latest.log'
    $LatestLogText = if (Test-Path -LiteralPath $LatestLogPath -PathType Leaf) { Get-Content -LiteralPath $LatestLogPath -Raw } else { '' }
    Assert ($LatestLogText -match '(?i)inv[_-]?view') 'Fabric server log includes InvView'
    Assert ($LatestLogText -match 'essential_commands') 'Fabric server log includes Essential Commands'
    Assert ($LatestLogText -match 'ec[_-]?core') 'Fabric server log includes the Essential Commands core dependency'
    Assert $script:ServerStopped 'Ready banner appeared (server finished loading)'
    Assert ($ServerExitCode -eq 0) "Server shut down cleanly (exit code $ServerExitCode)"
    $WelcomeConfigPath = Join-Path $Root 'server\config\welcome-mod.json'
    Assert (Test-Path -LiteralPath $WelcomeConfigPath -PathType Leaf) 'Welcome AWA generated config/welcome-mod.json'

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
    Restore-Java
}
