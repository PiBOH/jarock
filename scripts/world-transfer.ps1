[CmdletBinding()]
param()

# World import and export helpers used by the loader bootstrap (import) and by the
# server launcher (export after a clean shutdown). The script only defines functions;
# the caller dot-sources it and calls Invoke-WorldImport or Export-WorldFolder.
#
# Import behavior:
#   - source is a world folder containing level.dat, or a .zip archive whose root
#     (or single top-level folder) contains level.dat;
#   - if the configured world already exists (complete or incomplete), the operator
#     is asked for confirmation and the existing world is first moved aside as
#     <name>_originalbkp (or <name>_originalbkp_<timestamp> when that name is
#     already taken), so the active world is replaced with the imported one only
#     after the operator confirms;
#   - WORLD_IMPORT_REMEMBER=true keeps the source after a successful import and
#     imports it again at the next start (always with confirmation and a backup);
#   - WORLD_IMPORT_REMEMBER=false clears the source after the one-shot import.
#
# Export behavior:
#   - destination is a fixed folder that is overwritten (mirror copy) after a clean
#     shutdown only;
#   - the destination must be outside the server folder, so an export can never be
#     mistaken for a local world on the next start.

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Get-SafeWorldFolderName([string]$Name) {
    if ([string]::IsNullOrWhiteSpace($Name) -or $Name -eq '.' -or $Name -eq '..' -or $Name -match '[\\/:*?"<>|]') {
        throw "Unsafe world folder name: '$Name'."
    }
    return $Name
}

function Test-WorldZipSafe([string]$Path) {
    # Reject archive entries that could escape the extraction folder.
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction SilentlyContinue
        $Archive = [IO.Compression.ZipFile]::OpenRead($Path)
        try {
            foreach ($Entry in $Archive.Entries) {
                $Name = $Entry.FullName.Replace('\\', '/')
                if ($Name.StartsWith('/') -or $Name -match '(^|/)\.\.(/|$)' -or $Name -match '^[A-Za-z]:') { return $false }
            }
            return $true
        }
        finally { $Archive.Dispose() }
    }
    catch { return $false }
}

function Resolve-ImportSource([string]$Source) {
    if ([string]::IsNullOrWhiteSpace($Source)) { return $null }
    $Path = $Source.Trim().Trim('"')
    if (Test-Path -LiteralPath $Path -PathType Container) {
        if (Test-Path -LiteralPath (Join-Path $Path 'level.dat') -PathType Leaf) {
            return @{ Type = 'folder'; Path = $Path }
        }
        throw "The import folder '$Path' does not contain level.dat, so it is not a Minecraft world folder."
    }
    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        if ($Path -notmatch '(?i)\.zip$') { throw "The import file '$Path' is not a .zip archive." }
        return @{ Type = 'zip'; Path = $Path }
    }
    throw "The world import source was not found: $Path"
}

function Set-SettingsValue([string]$SettingsPath, [string]$Name, [string]$Value) {
    if (-not (Test-Path -LiteralPath $SettingsPath -PathType Leaf)) { throw "The launch settings file was not found: $SettingsPath" }
    $Content = Get-Content -LiteralPath $SettingsPath -Raw -Encoding UTF8
    $Pattern = "(?m)^$Name=.*$"
    if ($Content -match $Pattern) { $Content = [regex]::Replace($Content, $Pattern, "$Name=$Value") }
    else { $Content = $Content.TrimEnd("`r", "`n") + "`r`n$Name=$Value`r`n" }
    [IO.File]::WriteAllText($SettingsPath, $Content, (New-Object Text.UTF8Encoding($false)))
}

function Invoke-WorldImport {
    param(
        [Parameter(Mandatory = $true)] [string]$ServerDirectory,
        [Parameter(Mandatory = $true)] [string]$SettingsPath,
        [Parameter(Mandatory = $true)] [string]$LevelName
    )
    $Settings = @{}
    if (Test-Path -LiteralPath $SettingsPath -PathType Leaf) {
        foreach ($Line in Get-Content -LiteralPath $SettingsPath -Encoding UTF8) {
            if ($Line -match '^\s*([A-Z_]+)=(.*?)\s*$') { $Settings[$Matches[1]] = $Matches[2] }
        }
    }
    if (-not $Settings.ContainsKey('WORLD_IMPORT_SOURCE')) { return }
    $SourceValue = ([string]$Settings['WORLD_IMPORT_SOURCE']).Trim()
    if ([string]::IsNullOrWhiteSpace($SourceValue)) { return }
    $RememberSource = $Settings.ContainsKey('WORLD_IMPORT_REMEMBER') -and ([string]$Settings['WORLD_IMPORT_REMEMBER']).Trim() -match '^(?i:true|yes|1)$'
    # A remembered source is imported at every start: the operator explicitly chose
    # "Import always", so the configured world replaces the active one at each start
    # after a confirmation prompt and after backing up the existing folder first.
    # The legacy WORLD_IMPORT_APPLIED marker does not change that behavior.

    $Resolved = Resolve-ImportSource $SourceValue
    # Never import from inside the server folder: the source copy would remain there
    # and the next start would mistake it for possible previous world data.
    $ServerRoot = [IO.Path]::GetFullPath($ServerDirectory).TrimEnd('\')
    $SourceFull = [IO.Path]::GetFullPath($Resolved.Path)
    if ($SourceFull.Equals($ServerRoot, [StringComparison]::OrdinalIgnoreCase) -or $SourceFull.ToLowerInvariant().StartsWith($ServerRoot.ToLowerInvariant() + '\')) {
        throw 'The world import source must be outside the server folder.'
    }
    $SafeName = Get-SafeWorldFolderName $LevelName
    $Target = Join-Path $ServerDirectory $SafeName

    if (Test-Path -LiteralPath $Target -PathType Container) {
        # A complete world has level.dat (and usually a region folder). A folder that
        # only contains icon.png/datapacks or was left behind by a crash is treated
        # as incomplete and is replaced after confirmation just like a full world.
        $TargetLooksComplete = (Test-Path -LiteralPath (Join-Path $Target 'level.dat') -PathType Leaf) -or
            (Test-Path -LiteralPath (Join-Path $Target 'region') -PathType Container)
        $PromptText = "A world already exists in '$LevelName'. Importing will replace it after creating a backup. Continue? (Y/N)"
        if (-not $TargetLooksComplete) {
            $PromptText = "The existing '$LevelName' folder is incomplete (no world data). Importing will move it aside and import the configured world. Continue? (Y/N)"
        }
        $Confirmed = $false
        if (-not [string]::IsNullOrWhiteSpace($env:JAROCK_WORLD_TRANSFER_ASSUME_YES)) {
            # Test hook (same pattern as JAROCK_PREREQ_DRY_RUN): lets the regression
            # test exercise the replacement path without an interactive prompt.
            $Confirmed = $true
        }
        else {
            $Confirm = Read-Host $PromptText
            $Confirmed = ($Confirm -match '^(?i:y|yes)$')
        }
        if (-not $Confirmed) {
            # The operator declined to replace the existing world: keep it untouched.
            # A remembered source remains configured and is offered again at the next
            # start; a one-shot request is cleared as before.
            if ($RememberSource) {
                Set-SettingsValue $SettingsPath 'WORLD_IMPORT_APPLIED' 'false'
                Write-Host 'World import skipped: the existing world was kept; the remembered source remains configured for the next start.' -ForegroundColor Yellow
            }
            else {
                Set-SettingsValue $SettingsPath 'WORLD_IMPORT_SOURCE' ''
                Set-SettingsValue $SettingsPath 'WORLD_IMPORT_APPLIED' 'false'
                Write-Host 'World import skipped: the existing world was kept and the import request was cleared.' -ForegroundColor Yellow
            }
            return
        }
        $BackupName = $SafeName + '_originalbkp'
        $BackupPath = Join-Path $ServerDirectory $BackupName
        if (Test-Path -LiteralPath $BackupPath) {
            $BackupName = $SafeName + '_originalbkp_' + (Get-Date -Format 'yyyyMMdd-HHmmss')
            $BackupPath = Join-Path $ServerDirectory $BackupName
        }
        Move-Item -LiteralPath $Target -Destination $BackupPath
        Write-Host "Backed up the previous world to server\$BackupName" -ForegroundColor Yellow
    }

    New-Item -ItemType Directory -Force -Path $Target | Out-Null
    if ($Resolved.Type -eq 'folder') {
        Get-ChildItem -LiteralPath $Resolved.Path -Force -ErrorAction Stop | Copy-Item -Destination $Target -Recurse -Force
    }
    else {
        if (-not (Test-WorldZipSafe $Resolved.Path)) { throw "The zip '$($Resolved.Path)' contains unsafe paths and was not imported." }
        $TempExtract = Join-Path ([IO.Path]::GetTempPath()) ('jarock-import-' + [IO.Path]::GetRandomFileName())
        New-Item -ItemType Directory -Force -Path $TempExtract | Out-Null
        try {
            Expand-Archive -LiteralPath $Resolved.Path -DestinationPath $TempExtract -Force
            $Root = $TempExtract
            if (-not (Test-Path -LiteralPath (Join-Path $Root 'level.dat') -PathType Leaf)) {
                $Candidates = @(Get-ChildItem -LiteralPath $Root -Directory -ErrorAction SilentlyContinue | Where-Object {
                    Test-Path -LiteralPath (Join-Path $_.FullName 'level.dat') -PathType Leaf
                })
                if ($Candidates.Count -eq 1) { $Root = $Candidates[0].FullName }
                elseif ($Candidates.Count -eq 0) { throw 'The zip does not contain a world with level.dat.' }
                else { throw 'The zip contains more than one world folder; extract it and import the exact world folder instead.' }
            }
            Get-ChildItem -LiteralPath $Root -Force -ErrorAction Stop | Copy-Item -Destination $Target -Recurse -Force
        }
        finally {
            Remove-Item -LiteralPath $TempExtract -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    if (-not (Test-Path -LiteralPath (Join-Path $Target 'level.dat') -PathType Leaf)) {
        throw "The imported world in '$SafeName' has no level.dat; the import was incomplete."
    }

    if ($RememberSource) {
        Set-SettingsValue $SettingsPath 'WORLD_IMPORT_REMEMBER' 'true'
        Set-SettingsValue $SettingsPath 'WORLD_IMPORT_APPLIED' 'true'
        Write-Host "Imported the world from '$SourceValue' into server\$SafeName." -ForegroundColor Green
        Write-Host 'The world source was remembered: it will be imported again at the next start, with confirmation and a backup of the existing world.' -ForegroundColor Cyan
    }
    else {
        Set-SettingsValue $SettingsPath 'WORLD_IMPORT_SOURCE' ''
        Set-SettingsValue $SettingsPath 'WORLD_IMPORT_APPLIED' 'false'
        Write-Host "Imported the world from '$SourceValue' into server\$SafeName." -ForegroundColor Green
        Write-Host 'The import request was cleared after the successful import; it will not repeat on the next start.' -ForegroundColor Cyan
    }
}

function Export-WorldFolder {
    param(
        [Parameter(Mandatory = $true)] [string]$ServerDirectory,
        [Parameter(Mandatory = $true)] [string]$LevelName,
        [Parameter(Mandatory = $true)] [string]$Destination
    )
    if ([string]::IsNullOrWhiteSpace($Destination)) { return }
    $Dest = $Destination.Trim().Trim('"')
    if ([string]::IsNullOrWhiteSpace($Dest)) { return }
    $SafeName = Get-SafeWorldFolderName $LevelName
    $WorldPath = Join-Path $ServerDirectory $SafeName
    if (-not (Test-Path -LiteralPath $WorldPath -PathType Container)) {
        throw "The world folder '$SafeName' does not exist, so there is nothing to export."
    }
    $ServerRoot = [IO.Path]::GetFullPath($ServerDirectory).TrimEnd('\')
    $DestFull = [IO.Path]::GetFullPath($Dest)
    if ($DestFull.Equals($ServerRoot, [StringComparison]::OrdinalIgnoreCase) -or $DestFull.ToLowerInvariant().StartsWith($ServerRoot.ToLowerInvariant() + '\')) {
        throw 'The world export destination must be outside the server folder, so the export can never be re-imported as local world data.'
    }
    New-Item -ItemType Directory -Force -Path $DestFull | Out-Null
    $Robocopy = Get-Command robocopy.exe -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -ne $Robocopy) {
        & $Robocopy.Source $WorldPath $DestFull /MIR /NFL /NDL /NJH /NJS /NP
        if ($LASTEXITCODE -ge 8) { throw "robocopy reported error code $LASTEXITCODE while exporting the world." }
    }
    else {
        Get-ChildItem -LiteralPath $DestFull -Force | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        Get-ChildItem -LiteralPath $WorldPath -Force | Copy-Item -Destination $DestFull -Recurse -Force
    }
    Write-Host "The world '$SafeName' was exported to $DestFull after the clean shutdown." -ForegroundColor Green
}
