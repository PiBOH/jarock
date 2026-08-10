[CmdletBinding()]
param()

# Regression test for the world import/export feature. It uses only temporary folders
# and never touches the real server directory or the local launch settings, so it can
# run on any Windows machine (including CI) without Java or network access.

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$Root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$Pass = 0
$Fail = 0
function Assert([bool]$Condition, [string]$Name) {
    if ($Condition) { $script:Pass++; Write-Host "PASS: $Name" -ForegroundColor Green }
    else { $script:Fail++; Write-Host "FAIL: $Name" -ForegroundColor Red }
}

try {
    . (Join-Path $PSScriptRoot 'world-transfer.ps1')

    $env:JAROCK_WORLD_TRANSFER_ASSUME_YES = '1'
    $TestDir = Join-Path ([IO.Path]::GetTempPath()) ('jarock-world-transfer-' + [IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Force -Path $TestDir | Out-Null
    try {
        $ServerDir = Join-Path $TestDir 'server'
        $Source1 = Join-Path $TestDir 'source-world-1'
        $Source2 = Join-Path $TestDir 'source-world-2'
        $Dest = Join-Path $TestDir 'exported'
        $SettingsPath = Join-Path $TestDir 'settings.ini'
        New-Item -ItemType Directory -Force -Path (Join-Path $Source1 'region') | Out-Null
        New-Item -ItemType Directory -Force -Path (Join-Path $Source2 'region') | Out-Null
        [IO.File]::WriteAllText((Join-Path $Source1 'level.dat'), 'SOURCE-1')
        [IO.File]::WriteAllBytes((Join-Path $Source1 'icon.png'), [byte[]](4, 3, 2, 1))
        [IO.File]::WriteAllText((Join-Path $Source2 'level.dat'), 'SOURCE-2')
        [IO.File]::WriteAllText((Join-Path (Join-Path $Source1 'region') 'r.0.0.mca'), 'R1')
        [IO.File]::WriteAllText((Join-Path (Join-Path $Source2 'region') 'r.0.0.mca'), 'R2')
        New-Item -ItemType Directory -Force -Path $ServerDir | Out-Null
        [IO.File]::WriteAllText((Join-Path $ServerDir 'server.properties'), "level-name=world`r`n")

        # No source configured: the import must be a no-op.
        [IO.File]::WriteAllText($SettingsPath, "LOADER_TYPE=fabric`r`n")
        Invoke-WorldImport -ServerDirectory $ServerDir -SettingsPath $SettingsPath -LevelName 'world'
        Assert (-not (Test-Path -LiteralPath (Join-Path $ServerDir 'world') -PathType Container)) 'Import with no source is a no-op'

        # Folder import into a fresh server.
        [IO.File]::WriteAllText($SettingsPath, "LOADER_TYPE=fabric`r`nWORLD_IMPORT_SOURCE=$Source1`r`n")
        Invoke-WorldImport -ServerDirectory $ServerDir -SettingsPath $SettingsPath -LevelName 'world'
        $Level = Join-Path $ServerDir 'world'
        Assert (Test-Path -LiteralPath (Join-Path $Level 'level.dat') -PathType Leaf) 'Folder import copies level.dat'
        Assert ((Get-Content -LiteralPath (Join-Path $Level 'level.dat') -Raw) -eq 'SOURCE-1') 'Folder import content matches'
        $ImportedIconBytes = [IO.File]::ReadAllBytes((Join-Path $Level 'icon.png'))
        Assert (($ImportedIconBytes.Length -eq 4) -and ($ImportedIconBytes[0] -eq 4) -and ($ImportedIconBytes[1] -eq 3) -and ($ImportedIconBytes[2] -eq 2) -and ($ImportedIconBytes[3] -eq 1)) 'Folder import preserves a custom world icon'
        Assert ((Get-Content -LiteralPath $SettingsPath -Raw) -notmatch 'WORLD_IMPORT_SOURCE=[^\r\n]') 'Import clears the source setting'

        # A remembered source is retained and does not overwrite the active world on
        # the next start. WORLD_IMPORT_APPLIED=false is intentional here: the parameter
        # manager resets that internal marker whenever the saved source is edited, but
        # remembering the source must still prevent a recurring overwrite prompt.
        Remove-Item -LiteralPath $Level -Recurse -Force
        [IO.File]::WriteAllText($SettingsPath, "LOADER_TYPE=fabric`r`nWORLD_IMPORT_SOURCE=$Source1`r`nWORLD_IMPORT_REMEMBER=true`r`nWORLD_IMPORT_APPLIED=false`r`n")
        Invoke-WorldImport -ServerDirectory $ServerDir -SettingsPath $SettingsPath -LevelName 'world'
        Assert ((Get-Content -LiteralPath (Join-Path $Level 'level.dat') -Raw) -eq 'SOURCE-1') 'Remembered source restores a deleted world'
        Assert ((Get-Content -LiteralPath $SettingsPath -Raw) -match 'WORLD_IMPORT_SOURCE=.*source-world-1') 'Remembered source remains saved after restore'
        [IO.File]::WriteAllText((Join-Path $Level 'level.dat'), 'ACTIVE-CHANGES')
        $global:JarockWorldTransferPromptCalled = $false
        function global:Read-Host {
            $global:JarockWorldTransferPromptCalled = $true
            throw 'The remembered-world restart unexpectedly requested overwrite confirmation.'
        }
        try {
            Invoke-WorldImport -ServerDirectory $ServerDir -SettingsPath $SettingsPath -LevelName 'world'
        }
        catch {
            Write-Host "Unexpected remembered-world prompt: $($_.Exception.Message)" -ForegroundColor Red
        }
        Assert ((Get-Content -LiteralPath (Join-Path $Level 'level.dat') -Raw) -eq 'ACTIVE-CHANGES') 'Remembered source does not overwrite an existing world'
        Assert (-not $global:JarockWorldTransferPromptCalled) 'Remembered restart does not ask for overwrite confirmation'
        Remove-Item Function:\Read-Host -Force -ErrorAction SilentlyContinue
        Remove-Variable JarockWorldTransferPromptCalled -Scope Global -ErrorAction SilentlyContinue

        # Replacing an existing world creates the backup first.
        [IO.File]::WriteAllText($SettingsPath, "LOADER_TYPE=fabric`r`nWORLD_IMPORT_SOURCE=$Source2`r`nWORLD_IMPORT_REMEMBER=false`r`nWORLD_IMPORT_APPLIED=false`r`n")
        Invoke-WorldImport -ServerDirectory $ServerDir -SettingsPath $SettingsPath -LevelName 'world'
        Assert (Test-Path -LiteralPath (Join-Path $ServerDir 'world_originalbkp') -PathType Container) 'Replacement import creates the world_originalbkp backup'
        Assert ((Get-Content -LiteralPath (Join-Path (Join-Path $ServerDir 'world') 'level.dat') -Raw) -eq 'SOURCE-2') 'Replacement import copies the new world'

        # Zip import with a single nested world folder.
        $ZipPath = Join-Path $TestDir 'source.zip'
        $ZipRoot = Join-Path $TestDir 'ziproot'
        New-Item -ItemType Directory -Force -Path (Join-Path (Join-Path $ZipRoot 'nestedworld') 'region') | Out-Null
        [IO.File]::WriteAllText((Join-Path (Join-Path $ZipRoot 'nestedworld') 'level.dat'), 'SOURCE-ZIP')
        [IO.File]::WriteAllText((Join-Path (Join-Path (Join-Path $ZipRoot 'nestedworld') 'region') 'r.0.0.mca'), 'RZ')
        Compress-Archive -Path (Join-Path $ZipRoot 'nestedworld') -DestinationPath $ZipPath -Force
        [IO.File]::WriteAllText($SettingsPath, "LOADER_TYPE=fabric`r`nWORLD_IMPORT_SOURCE=$ZipPath`r`n")
        Invoke-WorldImport -ServerDirectory $ServerDir -SettingsPath $SettingsPath -LevelName 'world'
        Assert ((Get-Content -LiteralPath (Join-Path (Join-Path $ServerDir 'world') 'level.dat') -Raw) -eq 'SOURCE-ZIP') 'Zip import with a nested world folder works'

        # Import sources inside the server folder are refused (they would remain there
        # and the next start would mistake them for previous world data).
        $InsideSource = Join-Path $ServerDir 'inside-world'
        New-Item -ItemType Directory -Force -Path $InsideSource | Out-Null
        [IO.File]::WriteAllText((Join-Path $InsideSource 'level.dat'), 'IN')
        [IO.File]::WriteAllText($SettingsPath, "LOADER_TYPE=fabric`r`nWORLD_IMPORT_SOURCE=$InsideSource`r`n")
        $RefusedImport = $false
        try { Invoke-WorldImport -ServerDirectory $ServerDir -SettingsPath $SettingsPath -LevelName 'world' }
        catch { $RefusedImport = $true }
        Assert $RefusedImport 'Import refuses a source inside the server folder'

        # Export after a clean shutdown: fixed destination is mirrored.
        Export-WorldFolder -ServerDirectory $ServerDir -LevelName 'world' -Destination $Dest
        Assert (Test-Path -LiteralPath (Join-Path $Dest 'level.dat') -PathType Leaf) 'Export copies the world to the destination'
        Assert ((Get-Content -LiteralPath (Join-Path $Dest 'level.dat') -Raw) -eq 'SOURCE-ZIP') 'Export content matches'

        # Export must refuse a destination inside the server folder.
        $Inside = Join-Path $ServerDir 'exports'
        $Refused = $false
        try { Export-WorldFolder -ServerDirectory $ServerDir -LevelName 'world' -Destination $Inside }
        catch { $Refused = $true }
        Assert $Refused 'Export refuses a destination inside the server folder'

        # Export with a whitespace-only destination is a no-op (PowerShell 5.1 refuses
        # to bind an explicit empty string to a mandatory parameter, so whitespace is
        # used to exercise the guard inside the function).
        $NoOp = $true
        try { Export-WorldFolder -ServerDirectory $ServerDir -LevelName 'world' -Destination '   ' }
        catch { $NoOp = $false }
        Assert $NoOp 'Export with an empty destination is a no-op'

        Write-Host ''
        Write-Host "Test summary: $Pass passed, $Fail failed." -ForegroundColor Cyan
        if ($Fail -gt 0) { exit 1 }
        Write-Host 'All tests passed.' -ForegroundColor Green
    }
    finally {
        Remove-Item -LiteralPath $TestDir -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item Env:JAROCK_WORLD_TRANSFER_ASSUME_YES -ErrorAction SilentlyContinue
        Remove-Item Env:JAROCK_WORLD_TRANSFER_PROMPT_CALLED -ErrorAction SilentlyContinue
        Remove-Item Function:\Read-Host -Force -ErrorAction SilentlyContinue
        Remove-Variable JarockWorldTransferPromptCalled -Scope Global -ErrorAction SilentlyContinue
    }
}
catch {
    Write-Host ''
    Write-Host "HARNESS ERROR: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ScriptStackTrace) { Write-Host $_.ScriptStackTrace -ForegroundColor DarkGray }
    exit 1
}
