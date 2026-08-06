[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ServerDirectory
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

try {
    $ServerDirectory = [IO.Path]::GetFullPath($ServerDirectory).TrimEnd('\')
    $RepositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..')).TrimEnd('\')
    $ExpectedServerDirectory = [IO.Path]::GetFullPath((Join-Path $RepositoryRoot 'server')).TrimEnd('\')

    if ($ServerDirectory -ine $ExpectedServerDirectory) {
        throw "Refusing to clean an unexpected directory: $ServerDirectory"
    }
    if (-not (Test-Path -LiteralPath $ServerDirectory -PathType Container)) {
        throw "The server directory was not found: $ServerDirectory"
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
        'server.jar',
        'eula.txt.template',
        'server.properties.template',
        'config\Geyser-Fabric\config.yml.template'
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
    Write-Host 'Preserving only server.jar, repository templates, README, manifest and the tracked config template.' -ForegroundColor Green
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

    Write-Host 'Cleanup finished successfully.' -ForegroundColor Green
    Write-Host 'The next start-server.bat run will download/regenerate the removed runtime files.' -ForegroundColor Cyan
    exit 0
}
catch {
    Show-ErrorGuidance $_.Exception.Message 'Stop the server, close other Java applications, check the repository path and permissions, then run clean-server-runtime.bat again.'
    exit 1
}
