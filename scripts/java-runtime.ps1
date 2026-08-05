[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Get-JavaRuntimeInfo {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return $null
    }

    try {
        $VersionText = (& $Path -version 2>&1 | Out-String)
        $ExitCode = $LASTEXITCODE
        $Match = [regex]::Match($VersionText, 'version "(?<version>[^"]+)"')
        if (-not $Match.Success -or $ExitCode -ne 0) {
            return $null
        }

        $Version = $Match.Groups['version'].Value
        $MajorMatch = [regex]::Match($Version, '^(?<major>\d+)')
        if (-not $MajorMatch.Success) {
            return $null
        }

        $Major = [int]$MajorMatch.Groups['major'].Value
        if ($Major -eq 1) {
            $LegacyMatch = [regex]::Match($Version, '^1\.(?<legacy>\d+)')
            if ($LegacyMatch.Success) {
                $Major = [int]$LegacyMatch.Groups['legacy'].Value
            }
        }

        $SettingsText = (& $Path -XshowSettings:properties -version 2>&1 | Out-String)
        $ArchitectureMatch = [regex]::Match($SettingsText, '(?m)^\s*sun\.arch\.data\.model\s*=\s*(?<bits>\d+)\s*$')
        $Is64Bit = $ArchitectureMatch.Success -and ([int]$ArchitectureMatch.Groups['bits'].Value -eq 64)

        return [pscustomobject]@{
            Path = [IO.Path]::GetFullPath($Path)
            Version = $Version
            Major = $Major
            Is64Bit = $Is64Bit
        }
    }
    catch {
        return $null
    }
}

function Add-JavaCandidate {
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Generic.List[string]]$Candidates,
        [AllowNull()]
        [string]$Path
    )

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return
    }

    try {
        $FullPath = [IO.Path]::GetFullPath($Path)
        if (-not $Candidates.Contains($FullPath)) {
            $Candidates.Add($FullPath)
        }
    }
    catch {
        # Ignore malformed or inaccessible candidate paths; another candidate may work.
    }
}

function Find-CompatibleJava {
    param(
        [Parameter(Mandatory = $true)]
        [int]$MinimumMajor
    )

    $Candidates = New-Object 'System.Collections.Generic.List[string]'

    if (-not [string]::IsNullOrWhiteSpace($env:JAVA_HOME)) {
        Add-JavaCandidate $Candidates (Join-Path $env:JAVA_HOME 'bin\java.exe')
    }

    $PathCommands = @(Get-Command java.exe -All -ErrorAction SilentlyContinue)
    foreach ($Command in $PathCommands) {
        $CommandPath = $Command.Path
        if ([string]::IsNullOrWhiteSpace($CommandPath)) {
            $CommandPath = $Command.Source
        }
        Add-JavaCandidate $Candidates $CommandPath
    }

    $ProgramFilesRoots = @(
        ${env:ProgramW6432},
        ${env:ProgramFiles},
        ${env:ProgramFiles(x86)}
    ) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique
    $ProgramRoots = @()
    foreach ($ProgramFilesRoot in $ProgramFilesRoots) {
        $ProgramRoots += @(
            (Join-Path $ProgramFilesRoot 'Java'),
            (Join-Path $ProgramFilesRoot 'Eclipse Adoptium'),
            (Join-Path $ProgramFilesRoot 'Microsoft'),
            (Join-Path $ProgramFilesRoot 'Amazon Corretto'),
            (Join-Path $ProgramFilesRoot 'Azul Systems'),
            (Join-Path $ProgramFilesRoot 'BellSoft'),
            (Join-Path $ProgramFilesRoot 'SapMachine')
        )
    }
    foreach ($Root in $ProgramRoots) {
        if (-not (Test-Path -LiteralPath $Root -PathType Container)) {
            continue
        }
        $Installations = @(Get-ChildItem -LiteralPath $Root -Directory -ErrorAction SilentlyContinue)
        foreach ($Installation in $Installations) {
            Add-JavaCandidate $Candidates (Join-Path $Installation.FullName 'bin\java.exe')
        }
    }

    $RegistryRoots = @(
        'HKLM:\SOFTWARE\JavaSoft\JDK',
        'HKLM:\SOFTWARE\WOW6432Node\JavaSoft\JDK',
        'HKCU:\SOFTWARE\JavaSoft\JDK'
    )
    foreach ($RegistryRoot in $RegistryRoots) {
        if (-not (Test-Path -LiteralPath $RegistryRoot)) {
            continue
        }
        $RegistryVersions = @(Get-ChildItem -LiteralPath $RegistryRoot -ErrorAction SilentlyContinue)
        foreach ($RegistryVersion in $RegistryVersions) {
            $RegistryProperties = Get-ItemProperty -LiteralPath $RegistryVersion.PSPath -ErrorAction SilentlyContinue
            if ($null -eq $RegistryProperties) {
                continue
            }
            $JavaHomeProperty = $RegistryProperties.PSObject.Properties['JavaHome']
            if ($null -ne $JavaHomeProperty -and -not [string]::IsNullOrWhiteSpace([string]$JavaHomeProperty.Value)) {
                Add-JavaCandidate $Candidates (Join-Path ([string]$JavaHomeProperty.Value) 'bin\java.exe')
            }
        }
    }

    $Inspected = New-Object 'System.Collections.Generic.List[object]'
    foreach ($Candidate in $Candidates) {
        $Runtime = Get-JavaRuntimeInfo $Candidate
        if ($null -eq $Runtime) {
            continue
        }
        $Inspected.Add($Runtime)
        if ($Runtime.Major -ge $MinimumMajor -and $Runtime.Is64Bit) {
            return [pscustomobject]@{
                Selected = $Runtime
                Inspected = @($Inspected.ToArray())
            }
        }
    }

    return [pscustomobject]@{
        Selected = $null
        Inspected = @($Inspected.ToArray())
    }
}
