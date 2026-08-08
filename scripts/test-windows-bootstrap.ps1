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
    $WelcomeAwaPath = Join-Path $Root 'server\mods\welcome_awa-fabric-26.2-2.4.jar'
    Assert (Test-Path -LiteralPath $WelcomeAwaPath -PathType Leaf) 'Welcome AWA was downloaded into server/mods'
    if (Test-Path -LiteralPath $WelcomeAwaPath -PathType Leaf) {
        $WelcomeAwaHash = Get-Sha512 $WelcomeAwaPath
        Assert ($WelcomeAwaHash -eq '981c813ae53a230b49b8e2a33f83cb6fac810847baffaef43369f3caeccace19b7d5f578093277d656f5e5817ec18139485b8d76bee8ec6329279cc6eaa388c5') 'Downloaded Welcome AWA SHA-512 matches the pinned hash'
    }

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
