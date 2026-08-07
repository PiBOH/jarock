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
function Mask-Java {
    [Environment]::SetEnvironmentVariable('JAVA_HOME', $null, 'User')
    [Environment]::SetEnvironmentVariable('JAVA_HOME', $null, 'Machine')
    [Environment]::SetEnvironmentVariable('Path', (Strip-JavaEntries $Saved.UserPath), 'User')
    [Environment]::SetEnvironmentVariable('Path', (Strip-JavaEntries $Saved.MachinePath), 'Machine')
    Remove-Item Env:JAVA_HOME -ErrorAction SilentlyContinue
    Remove-Item Env:JAROCK_JAVA_HOME -ErrorAction SilentlyContinue
    if (Test-Path -LiteralPath $Saved.JavaHomeFile -PathType Leaf) {
        if (Test-Path -LiteralPath $Saved.JavaHomeBackup -PathType Leaf) { Remove-Item -LiteralPath $Saved.JavaHomeBackup -Force }
        Rename-Item -LiteralPath $Saved.JavaHomeFile -NewName ([IO.Path]::GetFileName($Saved.JavaHomeBackup)) -Force
    }
    $env:Path = Strip-JavaEntries $env:Path
}
function Restore-Java {
    [Environment]::SetEnvironmentVariable('JAVA_HOME', $Saved.UserJavaHome, 'User')
    [Environment]::SetEnvironmentVariable('JAVA_HOME', $Saved.MachineJavaHome, 'Machine')
    [Environment]::SetEnvironmentVariable('Path', $Saved.UserPath, 'User')
    [Environment]::SetEnvironmentVariable('Path', $Saved.MachinePath, 'Machine')
    if ([string]::IsNullOrWhiteSpace($Saved.ProcessJavaHome)) { Remove-Item Env:JAVA_HOME -ErrorAction SilentlyContinue }
    else { $env:JAVA_HOME = $Saved.ProcessJavaHome }
    if ([string]::IsNullOrWhiteSpace($Saved.JarockJavaHome)) { Remove-Item Env:JAROCK_JAVA_HOME -ErrorAction SilentlyContinue }
    else { $env:JAROCK_JAVA_HOME = $Saved.JarockJavaHome }
    if (Test-Path -LiteralPath $Saved.JavaHomeBackup -PathType Leaf) { Move-Item -LiteralPath $Saved.JavaHomeBackup -Destination $Saved.JavaHomeFile -Force }
    $env:Path = $Saved.ProcessPath
}

$SettingsPath = Join-Path $Root 'server-launch-settings.ini'
$SettingsTemplate = Join-Path $Root 'server-launch-settings.ini.template'

try {
    Write-Host '==> Simulating a Windows PC that does not have the Java prerequisites installed' -ForegroundColor Cyan

    # 1. Local settings must exist and select Fabric so the bootstrap never prompts.
    if (-not (Test-Path -LiteralPath $SettingsPath -PathType Leaf)) {
        if (-not (Test-Path -LiteralPath $SettingsTemplate -PathType Leaf)) { throw 'server-launch-settings.ini.template is missing.' }
        Copy-Item -LiteralPath $SettingsTemplate -Destination $SettingsPath
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
    Assert ($RealCode -eq 0) 'Bootstrap completes successfully'
    Assert (Test-Path -LiteralPath (Join-Path $Root 'server\java-path.txt') -PathType Leaf) 'Selected Java executable was stored'

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
    $script:ServerStopped = $false
    $OutputHandler = {
        param($Sender, $EventArgs)
        try {
            if ($null -ne $EventArgs -and -not [string]::IsNullOrEmpty($EventArgs.Data)) {
                Write-Host $EventArgs.Data
                if (-not $script:ServerStopped -and ($EventArgs.Data -match 'The Jarock server has finished loading' -or $EventArgs.Data -match 'Done \(\d+\.\d+s\)')) {
                    # Preferred trigger: the ready banner message. Fallback: the vanilla
                    # "Done (...)!" line, in case Geyser does not print its ready line on CI.
                    $script:ServerStopped = $true
                    try { $Sender.StandardInput.WriteLine('stop') } catch { }
                }
            }
        }
        catch {
            # Never let an exception inside the async output handler crash the harness:
            # when a background callback throws, pwsh terminates with 0xE0434352 instead
            # of reporting a clean failure.
        }
    }
    $ServerProc.add_OutputDataReceived($OutputHandler)
    $ServerProc.add_ErrorDataReceived($OutputHandler)
    $ServerProc.BeginOutputReadLine()
    $ServerProc.BeginErrorReadLine()
    if (-not $ServerProc.WaitForExit(900000)) {
        try { $ServerProc.Kill() } catch { }
        Assert $false 'Server reached the ready banner and stopped within 15 minutes'
    }
    else {
        $ServerExitCode = $ServerProc.ExitCode
        Assert $script:ServerStopped 'Ready banner appeared (server finished loading)'
        Assert ($ServerExitCode -eq 0) "Server shut down cleanly (exit code $ServerExitCode)"
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
    Restore-Java
}
