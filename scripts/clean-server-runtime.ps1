[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ServerDirectory,

    [switch]$ResetLoader
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Show-ErrorGuidance([string]$Message, [string]$Action) {
    Write-Host "ERROR: $Message" -ForegroundColor Red
    Write-Host "Suggested fix: $Action" -ForegroundColor Yellow
    Write-Host 'No router, firewall, port-forwarding, or public-network changes were performed.' -ForegroundColor Yellow
}

function Remove-GeneratedPath([string]$Path) {
    if (Test-Path -LiteralPath $Path) {
        Remove-Item -LiteralPath $Path -Recurse -Force
        Write-Host "Removed: $Path" -ForegroundColor DarkYellow
    }
}

function Reset-LoaderSelection([string]$SettingsPath) {
    if (-not (Test-Path -LiteralPath $SettingsPath -PathType Leaf)) {
        throw "The launch settings file was not found, so the loader selection could not be reset: $SettingsPath"
    }

    $Content = Get-Content -LiteralPath $SettingsPath -Raw
    $Pattern = '(?m)^LOADER_TYPE=.*$'
    if ($Content -match $Pattern) {
        $Content = [regex]::Replace($Content, $Pattern, 'LOADER_TYPE=none')
    }
    else {
        $Content = $Content.TrimEnd("`r", "`n") + "`r`nLOADER_TYPE=none`r`n"
    }
    Set-Content -LiteralPath $SettingsPath -Value $Content -Encoding UTF8
    Write-Host 'Loader selection reset to none. The next start will ask you to choose Fabric or NeoForge again.' -ForegroundColor Green
}

try {
    $ServerDirectory = [IO.Path]::GetFullPath($ServerDirectory).TrimEnd('\')
    $RepositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..')).TrimEnd('\')
    $ExpectedServerDirectory = [IO.Path]::GetFullPath((Join-Path $RepositoryRoot 'server')).TrimEnd('\')
    $SettingsPath = Join-Path $PSScriptRoot 'server-launch-settings.ini'

    if ($ServerDirectory -ine $ExpectedServerDirectory) {
        throw "Refusing to clean an unexpected directory: $ServerDirectory"
    }
    if (-not (Test-Path -LiteralPath $ServerDirectory -PathType Container)) {
        throw "The server directory was not found: $ServerDirectory"
    }
    if ($ResetLoader -and -not (Test-Path -LiteralPath $SettingsPath -PathType Leaf)) {
        throw "The launch settings file was not found, so the loader selection could not be reset: $SettingsPath"
    }

    try {
        # Be deliberately conservative: an inaccessible process query is an error,
        # and any Java process blocks cleanup so a missed server process cannot lose data.
        $JavaProcesses = @(Get-CimInstance Win32_Process -Filter "Name = 'java.exe' OR Name = 'javaw.exe'" -ErrorAction Stop)
    }
    catch {
        throw "Could not safely check whether Java is running. Cleanup was cancelled. $($_.Exception.Message)"
    }
    if ($JavaProcesses.Count -gt 0) {
        $ProcessIds = ($JavaProcesses | ForEach-Object { $_.ProcessId }) -join ', '
        throw "Java process(es) are running (PID: $ProcessIds). Stop the server and close other Java applications, then run this cleanup again."
    }

    $PreservedRelativePaths = @(
        '.gitkeep',
        'README.md',
        'mods-manifest.ps1',
        'mods-manifest-neoforge.ps1',
        'datapacks-manifest.ps1',
        'jarock-loader.txt.template',
        'eula.txt.template',
        'server.properties.template',
        'config\Geyser-Fabric\config.yml.template',
        'config\Geyser-NeoForge\config.yml.template'
    )
    $PreservedPaths = @{}
    foreach ($RelativePath in $PreservedRelativePaths) {
        $AbsolutePath = [IO.Path]::GetFullPath((Join-Path $ServerDirectory $RelativePath))
        if (-not (Test-Path -LiteralPath $AbsolutePath -PathType Leaf)) {
            throw "A required repository file is missing: $AbsolutePath"
        }
        $PreservedPaths[$AbsolutePath.ToLowerInvariant()] = $true
    }

    Write-Host "Cleaning generated runtime data under: $ServerDirectory" -ForegroundColor Cyan
    Write-Host 'Preserving repository templates, README and loader-specific manifests. server.jar is generated locally for the selected loader.' -ForegroundColor Green
    Write-Host 'This removes worlds, player data, logs, generated configs, Floodgate keys, downloaded mods and libraries.' -ForegroundColor Yellow

    # Remove every file that is not explicitly part of the repository template.
    # This catches future runtime files as well as currently known files.
    $Files = @(Get-ChildItem -LiteralPath $ServerDirectory -File -Force -Recurse -ErrorAction Stop)
    foreach ($File in $Files) {
        if (-not $PreservedPaths.ContainsKey($File.FullName.ToLowerInvariant())) {
            Remove-GeneratedPath $File.FullName
        }
    }

    # Remove empty/generated directories while retaining directories needed by
    # preserved files. The server root itself is never removed.
    $Directories = @(Get-ChildItem -LiteralPath $ServerDirectory -Directory -Force -Recurse -ErrorAction Stop | Sort-Object FullName -Descending)
    foreach ($Directory in $Directories) {
        $HasPreservedFile = $false
        foreach ($PreservedPath in $PreservedPaths.Keys) {
            if ($PreservedPath.StartsWith(($Directory.FullName + '\').ToLowerInvariant())) {
                $HasPreservedFile = $true
                break
            }
        }
        if (-not $HasPreservedFile) {
            Remove-GeneratedPath $Directory.FullName
        }
    }

    if ($ResetLoader) {
        Reset-LoaderSelection $SettingsPath
    }

    Write-Host 'Cleanup finished successfully.' -ForegroundColor Green
    if ($ResetLoader) {
        Write-Host 'The next start-server.bat run will ask for the loader and download/regenerate the selected runtime.' -ForegroundColor Cyan
    }
    else {
        Write-Host 'The next start-server.bat run will keep the current loader selection and download/regenerate its runtime.' -ForegroundColor Cyan
    }
    exit 0
}
catch {
    Show-ErrorGuidance $_.Exception.Message 'Stop the server, close other Java applications, check the repository path and permissions, then run clean-server-runtime.bat again.'
    exit 1
}
