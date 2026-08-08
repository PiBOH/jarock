[CmdletBinding()]
param(
    [switch]$NonInteractive,
    [switch]$CheckOnly,
    [switch]$PromptForUpdate,
    [switch]$AllowLocalChanges,
    [switch]$StartupUpdate,
    [string]$ReleaseApiUrl = 'https://api.github.com/repos/PiBOH/jarock/releases?per_page=100'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

# GitHub requires TLS 1.2 or newer. Windows PowerShell 5.1 may otherwise negotiate
# an obsolete protocol on older Windows installations.
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch { }

$Root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$CacheRoot = Join-Path $Root '.cache'
$DownloadRoot = Join-Path $CacheRoot 'updates'
$BackupRoot = Join-Path $CacheRoot 'update-backups'
$VersionPath = Join-Path $PSScriptRoot 'version.txt'
$UserAgent = 'Jarock-updater'
$script:TrackedFilesCache = $null
$script:DeferredLauncherPath = Join-Path $CacheRoot 'pending-start-server.bat'

function Test-StartupInvocation {
    try {
        $Current = Get-CimInstance Win32_Process -Filter "ProcessId = $PID" -ErrorAction Stop
        if ($null -eq $Current -or $null -eq $Current.ParentProcessId) { return $false }
        $Parent = Get-CimInstance Win32_Process -Filter "ProcessId = $($Current.ParentProcessId)" -ErrorAction Stop
        return ([string]$Parent.CommandLine -match '(?i)(start-server(?:-runner)?\.bat)')
    }
    catch { return $false }
}
if (-not $StartupUpdate -and (Test-StartupInvocation)) { $StartupUpdate = $true }

function Show-ErrorGuidance([string]$Message, [string]$Action) {
    Write-Host "`nERROR: $Message" -ForegroundColor Red
    Write-Host "Suggested fix: $Action" -ForegroundColor Yellow
    Write-Host 'No router, firewall, port-forwarding, or public-network changes were performed.' -ForegroundColor Yellow
}

function Parse-SemVer([string]$Value) {
    $Text = ([string]$Value).Trim()
    if ($Text.StartsWith('v')) { $Text = $Text.Substring(1) }
    if ($Text -notmatch '^(\d+)\.(\d+)\.(\d+)(?:-([0-9A-Za-z.-]+))?$') {
        throw "Invalid semantic version '$Value'. Expected MAJOR.MINOR.PATCH or MAJOR.MINOR.PATCH-prerelease."
    }
    $Pre = $null
    if ($Matches[4]) { $Pre = @($Matches[4].Split('.')) }
    [PSCustomObject]@{
        Text = $Text
        Major = [int64]$Matches[1]
        Minor = [int64]$Matches[2]
        Patch = [int64]$Matches[3]
        Pre = $Pre
    }
}

function Compare-SemVer($Left, $Right) {
    foreach ($Name in @('Major','Minor','Patch')) {
        if ($Left.$Name -lt $Right.$Name) { return -1 }
        if ($Left.$Name -gt $Right.$Name) { return 1 }
    }
    $LeftStable = $null -eq $Left.Pre
    $RightStable = $null -eq $Right.Pre
    if ($LeftStable -and $RightStable) { return 0 }
    if ($LeftStable) { return 1 }
    if ($RightStable) { return -1 }
    $Count = [Math]::Max($Left.Pre.Count, $Right.Pre.Count)
    for ($Index = 0; $Index -lt $Count; $Index++) {
        if ($Index -ge $Left.Pre.Count) { return -1 }
        if ($Index -ge $Right.Pre.Count) { return 1 }
        $A = [string]$Left.Pre[$Index]
        $B = [string]$Right.Pre[$Index]
        $ANumeric = $A -match '^\d+$'
        $BNumeric = $B -match '^\d+$'
        if ($ANumeric -and $BNumeric) {
            $Cmp = ([int64]$A).CompareTo([int64]$B)
            if ($Cmp -ne 0) { return $Cmp }
        }
        elseif ($ANumeric -and -not $BNumeric) { return -1 }
        elseif (-not $ANumeric -and $BNumeric) { return 1 }
        else {
            $Cmp = [string]::Compare($A, $B, [StringComparison]::OrdinalIgnoreCase)
            if ($Cmp -ne 0) { return $Cmp }
        }
    }
    return 0
}

function Get-LocalVersion {
    if (-not (Test-Path -LiteralPath $VersionPath -PathType Leaf)) { throw 'scripts/version.txt is missing.' }
    return Parse-SemVer (Get-Content -LiteralPath $VersionPath -Raw)
}

function Get-ReleaseList {
    try {
        # Invoke-WebRequest provides a bounded timeout in Windows PowerShell 5.1.
        # Startup checks must not wait indefinitely when DNS, GitHub or a proxy is unavailable.
        $Response = Invoke-WebRequest -Uri $ReleaseApiUrl -Headers @{ 'User-Agent' = $UserAgent } -UseBasicParsing -TimeoutSec 30
        return @($Response.Content | ConvertFrom-Json)
    }
    catch {
        throw "Could not query the Jarock GitHub releases within 30 seconds: $($_.Exception.Message)"
    }
}

function Get-ReleaseCandidate($Release, $LocalVersion) {
    if ($null -eq $Release -or [bool]$Release.draft) { return $null }
    try { $ReleaseVersion = Parse-SemVer ([string]$Release.tag_name) } catch { return $null }
    $SameChannel = (($null -ne $LocalVersion.Pre) -eq ($null -ne $ReleaseVersion.Pre))
    if (-not $SameChannel -or (Compare-SemVer $ReleaseVersion $LocalVersion) -le 0) { return $null }
    $ExpectedName = if ($null -ne $LocalVersion.Pre) { "jarock-lite-$($ReleaseVersion.Text).zip" } else { 'jarock-lite.zip' }
    $Asset = @($Release.assets | Where-Object { $_.name -eq $ExpectedName } | Select-Object -First 1)
    $ChecksumName = "$ExpectedName.sha512"
    $ChecksumAsset = @($Release.assets | Where-Object { $_.name -eq $ChecksumName } | Select-Object -First 1)
    # Updates use the Lite package: an existing installation already has its
    # prerequisites, and the Lite archive avoids downloading/installing Java again.
    # The package and its SHA-512 checksum are still required; never apply an unchecked archive.
    if ($Asset.Count -eq 0 -or $ChecksumAsset.Count -eq 0) { return $null }
    [PSCustomObject]@{ Release = $Release; Version = $ReleaseVersion; Asset = $Asset[0]; ChecksumAsset = $ChecksumAsset[0] }
}

function Find-LatestUpdate($LocalVersion) {
    $Candidates = @()
    $UnverifiedNewer = @()
    foreach ($Release in (Get-ReleaseList)) {
        $Candidate = Get-ReleaseCandidate $Release $LocalVersion
        if ($null -ne $Candidate) { $Candidates += $Candidate; continue }
        if ($null -eq $Release -or [bool]$Release.draft) { continue }
        try { $ReleaseVersion = Parse-SemVer ([string]$Release.tag_name) } catch { continue }
        $SameChannel = (($null -ne $LocalVersion.Pre) -eq ($null -ne $ReleaseVersion.Pre))
        if ($SameChannel -and (Compare-SemVer $ReleaseVersion $LocalVersion) -gt 0) { $UnverifiedNewer += $ReleaseVersion.Text }
    }
    if ($Candidates.Count -eq 0) {
        if ($UnverifiedNewer.Count -gt 0) { throw "A newer $($(if ($null -ne $LocalVersion.Pre) { 'prerelease/beta' } else { 'stable' })) release exists, but it has no matching Lite package and SHA-512 checksum. Install it manually from the GitHub Releases page before using the updater again." }
        return $null
    }
    $Best = $Candidates[0]
    foreach ($Candidate in $Candidates | Select-Object -Skip 1) {
        if ((Compare-SemVer $Candidate.Version $Best.Version) -gt 0) { $Best = $Candidate }
    }
    return $Best
}

function Invoke-RobustDownload([string]$Url, [string]$Path) {
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Path) | Out-Null
    $Curl = Get-Command curl.exe -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -ne $Curl) {
        for ($Attempt = 1; $Attempt -le 3; $Attempt++) {
            & $Curl.Source -sS -L --fail --connect-timeout 30 --max-time 900 --retry 3 --retry-delay 2 -A $UserAgent -o $Path $Url
            if ($LASTEXITCODE -eq 0) { return }
            if ($Attempt -lt 3) { Write-Host "Download attempt $Attempt of 3 failed; retrying ..." -ForegroundColor Yellow; Start-Sleep -Seconds 3 }
        }
        Remove-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
        throw "curl.exe failed to download the update (exit code $LASTEXITCODE); the incomplete file was removed."
    }
    for ($Attempt = 1; $Attempt -le 3; $Attempt++) {
        try {
            Invoke-WebRequest -Uri $Url -OutFile $Path -Headers @{ 'User-Agent' = $UserAgent } -UseBasicParsing -TimeoutSec 900
            return
        }
        catch {
            if ($Attempt -eq 3) {
                Remove-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
                throw "PowerShell failed to download the update after 3 attempts: $($_.Exception.Message)"
            }
            Write-Host "Download attempt $Attempt of 3 failed; retrying ..." -ForegroundColor Yellow
            Start-Sleep -Seconds 3
        }
    }
}

function Assert-ServerStopped {
    $Needle = $Root.TrimEnd('\').ToLowerInvariant()
    try {
        $Processes = @(Get-CimInstance Win32_Process -ErrorAction Stop | Where-Object { $_.Name -match '^(java|javaw)\.exe$' })
    }
    catch {
        throw "Windows process inspection failed: $($_.Exception.Message). The updater stopped without changing files because it cannot safely confirm that Minecraft is stopped."
    }
    foreach ($Process in $Processes) {
        if ([string]::IsNullOrWhiteSpace([string]$Process.CommandLine)) {
            throw "A Java process (PID $($Process.ProcessId)) could not be inspected safely. Close Minecraft and other Java applications, then run the updater again."
        }
        $CommandLine = ([string]$Process.CommandLine).ToLowerInvariant()
        if ($CommandLine.Contains($Needle) -or $CommandLine.Contains('fabricserverlauncher') -or $CommandLine.Contains('net.neoforged') -or $CommandLine.Contains('server.jar')) {
            throw "A Jarock or Minecraft process appears to be running (PID $($Process.ProcessId)). Stop the server and wait for SAFE TO CLOSE before updating."
        }
    }
}

function Get-GitExecutable {
    if (-not (Test-Path -LiteralPath (Join-Path $Root '.git'))) { return $null }
    $Git = Get-Command git.exe -ErrorAction SilentlyContinue
    if ($null -eq $Git) { throw 'This folder is a Git checkout, but git.exe was not found. The updater stopped to avoid overwriting uncommitted changes.' }
    return $Git.Source
}
function Assert-GitTreeSafe {
    if ($AllowLocalChanges) { return }
    $GitPath = Get-GitExecutable
    if ($null -eq $GitPath) { return }
    $Status = @(& $GitPath -C $Root status --porcelain 2>$null)
    if ($LASTEXITCODE -ne 0) { throw 'Git could not inspect the repository status. The updater stopped without changing files.' }
    if ($Status.Count -gt 0) {
        throw 'The repository contains uncommitted changes. The updater will not overwrite them automatically. Commit/stash them or rerun with -AllowLocalChanges after making a backup.'
    }
}
function Get-TrackedFiles {
    if ($null -ne $script:TrackedFilesCache) { return $script:TrackedFilesCache }
    $GitPath = Get-GitExecutable
    if ($null -eq $GitPath) {
        $script:TrackedFilesCache = @()
        return $script:TrackedFilesCache
    }
    $Files = @(& $GitPath -C $Root ls-files 2>$null)
    if ($LASTEXITCODE -ne 0) { throw 'Git could not list tracked files. The updater stopped without changing files.' }
    $script:TrackedFilesCache = @($Files | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object { ([string]$_).Replace('\','/') })
    return $script:TrackedFilesCache
}

function Test-Package([string]$ZipPath, $ExpectedVersion) {
    Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction SilentlyContinue
    $Archive = [IO.Compression.ZipFile]::OpenRead($ZipPath)
    try {
        $VersionEntry = $Archive.GetEntry('scripts/version.txt')
        $StartEntry = $Archive.GetEntry('start-server.bat')
        $UpdateEntry = $Archive.GetEntry('scripts/update-jarock.ps1')
        $UpdateLauncherEntry = $Archive.GetEntry('scripts/update-jarock.bat')
        $DeferredLauncherEntry = $Archive.GetEntry('scripts/apply-pending-launcher.ps1')
        if ($null -eq $VersionEntry -or $null -eq $StartEntry -or $null -eq $UpdateEntry -or $null -eq $UpdateLauncherEntry -or $null -eq $DeferredLauncherEntry) { throw 'The downloaded Lite package is missing required Jarock updater files.' }
        $Reader = New-Object IO.StreamReader($VersionEntry.Open())
        try { $PackageVersion = Parse-SemVer $Reader.ReadToEnd() } finally { $Reader.Dispose() }
        if ((Compare-SemVer $PackageVersion $ExpectedVersion) -ne 0) { throw "The package version ($($PackageVersion.Text)) does not match the release version ($($ExpectedVersion.Text))." }
        foreach ($Entry in $Archive.Entries) {
            $Name = ([string]$Entry.FullName).Replace('\','/')
            $IsRooted = $Name.StartsWith('/') -or $Name -match '^[A-Za-z]:'
            $HasTraversal = $Name.Split('/') -contains '.' -or $Name.Split('/') -contains '..'
            $IsForbiddenTopLevel = $Name.Equals('.git', [StringComparison]::OrdinalIgnoreCase) -or $Name.Equals('.cache', [StringComparison]::OrdinalIgnoreCase) -or $Name.StartsWith('.git/', [StringComparison]::OrdinalIgnoreCase) -or $Name.StartsWith('.github/', [StringComparison]::OrdinalIgnoreCase) -or $Name.StartsWith('.website/', [StringComparison]::OrdinalIgnoreCase)
            if ($IsRooted -or $HasTraversal -or $IsForbiddenTopLevel) { throw "The package contains a forbidden archive entry: $Name" }
        }
    }
    finally { $Archive.Dispose() }
}

function Get-Sha512([string]$Path) { return (Get-FileHash -Algorithm SHA512 -LiteralPath $Path).Hash.ToLowerInvariant() }
function Verify-ReleaseChecksum([string]$ZipPath, [string]$ChecksumPath, [string]$ExpectedName) {
    $Text = (Get-Content -LiteralPath $ChecksumPath -Raw).Trim()
    if ($Text -notmatch '(?i)([0-9a-f]{128})\s+\*?' + [regex]::Escape($ExpectedName) + '$') { throw 'The release checksum file does not contain a valid SHA-512 entry for the downloaded package.' }
    $ExpectedHash = $Matches[1].ToLowerInvariant()
    $ActualHash = Get-Sha512 $ZipPath
    if ($ActualHash -ne $ExpectedHash) { throw 'The SHA-512 checksum of the downloaded package does not match the release checksum asset.' }
}

function Get-Stage([string]$ZipPath) {
    $Stage = Join-Path $DownloadRoot ('stage-' + [guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Force -Path $Stage | Out-Null
    Expand-Archive -LiteralPath $ZipPath -DestinationPath $Stage -Force
    return $Stage
}

function Test-ProtectedProjectPath([string]$Relative) {
    $Normalized = ([string]$Relative).Replace('\','/')
    $Comparable = $Normalized.ToLowerInvariant()
    $Top = $Comparable.Split('/')[0]
    if (@('.git', '.github', '.website', '.cache', 'prerequisites') -contains $Top) { return $true }
    if ($Comparable -in @('.gitignore', '.gitattributes', 'scripts/server-launch-settings.ini', 'java-home.txt')) { return $true }
    if ($Top -ne 'server') { return $false }

    # In a Git checkout, tracked server templates/manifests are project files and
    # may be updated; all other server paths are generated runtime data.
    $Tracked = @(Get-TrackedFiles | ForEach-Object { ([string]$_).ToLowerInvariant() })
    if ($Tracked.Count -gt 0) { return -not ($Tracked -contains $Comparable) }

    # A downloaded release ZIP may be unpacked outside Git. Preserve the known
    # generated runtime paths while allowing committed templates and manifests,
    # including templates below server/config/, to be refreshed.
    if ($Comparable -match '^server/(.+\.template|readme\.md|mods-manifest[^/]*\.ps1)$') { return $false }
    $FirstChild = if ($Comparable.Contains('/')) { $Comparable.Substring(7).Split('/')[0] } else { $Comparable.Substring(7) }
    if (@('world','world_nether','world_the_end','logs','crash-reports','libraries','mods','config') -contains $FirstChild) { return $true }
    if ($Comparable -match '^server/(server\.jar|vanilla-server\.jar|run\.bat|user_jvm_args\.txt|fabric-server-launcher\.properties|jarock-loader\.txt|eula\.txt|server\.properties|java-path\.txt)$') { return $true }
    if ($Comparable -match '^server/.*\.(jar|log|pem|key)$') { return $true }
    return $false
}

function Schedule-DeferredLauncherApply {
    if (-not $StartupUpdate -or -not (Test-Path -LiteralPath $script:DeferredLauncherPath -PathType Leaf)) { return }
    try {
        $Current = Get-CimInstance Win32_Process -Filter "ProcessId = $PID" -ErrorAction Stop
        $ParentProcessId = [int]$Current.ParentProcessId
        $Helper = Join-Path $Root 'scripts/apply-pending-launcher.ps1'
        if (-not (Test-Path -LiteralPath $Helper -PathType Leaf)) { throw 'The deferred launcher helper is missing.' }
        Start-Process -FilePath 'powershell.exe' -WindowStyle Hidden -ArgumentList @(
            '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $Helper,
            '-ParentProcessId', [string]$ParentProcessId,
            '-PendingPath', $script:DeferredLauncherPath,
            '-DestinationPath', (Join-Path $Root 'start-server.bat')
        ) | Out-Null
        Write-Host 'The updated start-server.bat launcher is queued and will be applied after this startup window closes.' -ForegroundColor Cyan
    }
    catch {
        Write-Host "WARNING: The updated start-server.bat could not be queued automatically: $($_.Exception.Message)" -ForegroundColor Yellow
        Write-Host 'Suggested fix: close this startup window normally, then run the updater again if the launcher was not updated.' -ForegroundColor Yellow
    }
}

function Backup-AndApply([string]$Stage, $NewVersion) {
    $Stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $Backup = Join-Path $BackupRoot "jarock-$Stamp-$($NewVersion.Text)"
    New-Item -ItemType Directory -Force -Path $Backup | Out-Null
    $Files = @(Get-ChildItem -LiteralPath $Stage -File -Recurse)
    $PackageRelative = @{}
    foreach ($File in $Files) {
        $Relative = $File.FullName.Substring($Stage.Length).TrimStart('\','/').Replace('\','/')
        if (-not [string]::IsNullOrWhiteSpace($Relative) -and -not (Test-ProtectedProjectPath $Relative)) {
            $PackageRelative[$Relative] = $true
        }
    }
    $TrackedRelative = @(Get-TrackedFiles | ForEach-Object { ([string]$_).Replace('\','/') } | Where-Object { -not (Test-ProtectedProjectPath $_) })
    $Touched = @{}
    $Existing = @{}
    foreach ($Relative in @($PackageRelative.Keys) + $TrackedRelative) {
        if ([string]::IsNullOrWhiteSpace($Relative) -or $Touched.ContainsKey($Relative)) { continue }
        $Touched[$Relative] = $true
        $Destination = Join-Path $Root $Relative
        if (Test-Path -LiteralPath $Destination -PathType Leaf) {
            $BackupPath = Join-Path $Backup $Relative
            $Existing[$Relative] = $true
            New-Item -ItemType Directory -Force -Path (Split-Path -Parent $BackupPath) | Out-Null
            Copy-Item -LiteralPath $Destination -Destination $BackupPath -Force
        }
    }
    try {
        foreach ($File in $Files) {
            $Relative = $File.FullName.Substring($Stage.Length).TrimStart('\','/').Replace('\','/')
            if (Test-ProtectedProjectPath $Relative) { continue }
            $Destination = Join-Path $Root $Relative
            if ($StartupUpdate -and $Relative -ieq 'start-server.bat') {
                Copy-Item -LiteralPath $File.FullName -Destination $script:DeferredLauncherPath -Force
                continue
            }
            New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Destination) | Out-Null
            Copy-Item -LiteralPath $File.FullName -Destination $Destination -Force
        }
        foreach ($Relative in $TrackedRelative) {
            if (-not $PackageRelative.ContainsKey($Relative)) {
                $Destination = Join-Path $Root $Relative
                if (Test-Path -LiteralPath $Destination -PathType Leaf) { Remove-Item -LiteralPath $Destination -Force }
            }
        }
    }
    catch {
        foreach ($Relative in $Touched.Keys) {
            $Destination = Join-Path $Root $Relative
            $BackupPath = Join-Path $Backup $Relative
            if ($Existing.ContainsKey($Relative) -and (Test-Path -LiteralPath $BackupPath -PathType Leaf)) {
                New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Destination) | Out-Null
                Copy-Item -LiteralPath $BackupPath -Destination $Destination -Force
            }
            elseif (Test-Path -LiteralPath $Destination -PathType Leaf) {
                Remove-Item -LiteralPath $Destination -Force -ErrorAction SilentlyContinue
            }
        }
        throw "Update application failed and was rolled back: $($_.Exception.Message)"
    }
    return $Backup
}

try {
    Write-Host '==> Checking Jarock update status' -ForegroundColor Cyan
    if (-not $CheckOnly) {
        Assert-ServerStopped
        Assert-GitTreeSafe
    }
    else {
        Write-Host 'Read-only startup/update check: no files will be changed.' -ForegroundColor Cyan
    }
    $LocalVersion = Get-LocalVersion
    Write-Host "Installed Jarock version: $($LocalVersion.Text)" -ForegroundColor Green
    $Candidate = Find-LatestUpdate $LocalVersion
    if ($null -eq $Candidate) {
        $Channel = if ($null -ne $LocalVersion.Pre) { 'prerelease/beta' } else { 'stable' }
        Write-Host "No newer $Channel Jarock release with a compatible package was found." -ForegroundColor Green
        exit 0
    }
    Write-Host "Available update: $($Candidate.Version.Text) ($($Candidate.Asset.name))" -ForegroundColor Yellow
    Write-Host "Download size: $([math]::Round(([double]$Candidate.Asset.size / 1MB), 1)) MB" -ForegroundColor Yellow
    if ($CheckOnly -and -not $PromptForUpdate) { exit 0 }
    if ($PromptForUpdate) {
        $Answer = Read-Host 'A newer Jarock release is available. Download and install it now? (y/N)'
        if ($Answer -notmatch '^(?i:y|yes)$') { Write-Host 'Update skipped. Continuing with the current Jarock version.' -ForegroundColor Yellow; exit 2 }
        # The startup prompt is the confirmation; do not ask a second time below.
        $NonInteractive = $true
    }
    if (-not $NonInteractive) {
        $Answer = Read-Host 'Download and install this update now? (Y/N)'
        if ($Answer -notmatch '^(?i:y|yes)$') { Write-Host 'Update cancelled. No files were changed.' -ForegroundColor Yellow; exit 2 }
    }
    New-Item -ItemType Directory -Force -Path $DownloadRoot | Out-Null
    $ZipPath = Join-Path $DownloadRoot $Candidate.Asset.name
    $ChecksumPath = Join-Path $DownloadRoot $Candidate.ChecksumAsset.name
    Write-Host "Downloading $($Candidate.Asset.name) ..." -ForegroundColor Cyan
    Invoke-RobustDownload -Url $Candidate.Asset.browser_download_url -Path $ZipPath
    if ((Get-Item -LiteralPath $ZipPath).Length -ne [int64]$Candidate.Asset.size) { throw 'The downloaded package size does not match the GitHub release asset.' }
    Write-Host "Downloading $($Candidate.ChecksumAsset.name) ..." -ForegroundColor Cyan
    Invoke-RobustDownload -Url $Candidate.ChecksumAsset.browser_download_url -Path $ChecksumPath
    Verify-ReleaseChecksum $ZipPath $ChecksumPath $Candidate.Asset.name
    Test-Package $ZipPath $Candidate.Version
    $Stage = Get-Stage $ZipPath
    try {
        $Backup = Backup-AndApply $Stage $Candidate.Version
    }
    finally { Remove-Item -LiteralPath $Stage -Recurse -Force -ErrorAction SilentlyContinue }
    Write-Host ''
    Write-Host "Jarock was updated from $($LocalVersion.Text) to $($Candidate.Version.Text)." -ForegroundColor Green
    Write-Host "Local runtime, world, settings and secrets were preserved." -ForegroundColor Green
    Write-Host "Rollback backup: $Backup" -ForegroundColor Cyan
    if ($StartupUpdate) {
        Schedule-DeferredLauncherApply
    }
    else {
        Write-Host 'Run start-server.bat to verify the updated installation.' -ForegroundColor Cyan
    }
    exit 0
}
catch {
    if ($CheckOnly) {
        Show-ErrorGuidance $_.Exception.Message 'The startup update check could not reach GitHub. Verify Internet/proxy settings if you want update notifications; the server startup can continue and no files were changed.'
    }
    else {
        Show-ErrorGuidance $_.Exception.Message 'Stop the server, make a backup, check Internet access and permissions, then run scripts/update-jarock.bat again. No update was applied if the error occurred before the final success message.'
    }
    exit 1
}
