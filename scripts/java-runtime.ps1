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
        [AllowEmptyCollection()]
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
            [void]$Candidates.Add($FullPath)
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

    $ProjectRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
    $JavaHomeFile = Join-Path $ProjectRoot 'java-home.txt'
    $JavaHomeValues = @()
    if (-not [string]::IsNullOrWhiteSpace($env:JAROCK_JAVA_HOME)) {
        $JavaHomeValues += $env:JAROCK_JAVA_HOME
    }
    if (Test-Path -LiteralPath $JavaHomeFile -PathType Leaf) {
        $JavaHomeFileValue = @(
            Get-Content -LiteralPath $JavaHomeFile -ErrorAction SilentlyContinue |
                ForEach-Object { $_.Trim() } |
                Where-Object { $_ -and -not $_.StartsWith('#') } |
                Select-Object -First 1
        )
        if ($JavaHomeFileValue.Count -gt 0) {
            $JavaHomeValues += [string]$JavaHomeFileValue[0]
        }
    }
    $JavaHomeValues += @(
        $env:JAVA_HOME,
        [Environment]::GetEnvironmentVariable('JAVA_HOME', 'User'),
        [Environment]::GetEnvironmentVariable('JAVA_HOME', 'Machine')
    )
    $JavaHomeValues = @($JavaHomeValues | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique)
    foreach ($JavaHomeValue in $JavaHomeValues) {
        $ExpandedJavaHome = [Environment]::ExpandEnvironmentVariables([string]$JavaHomeValue).Trim().Trim('"').Trim("'")
        if ([string]::IsNullOrWhiteSpace($ExpandedJavaHome)) {
            continue
        }
        if (-not [IO.Path]::IsPathRooted($ExpandedJavaHome)) {
            $ExpandedJavaHome = Join-Path $ProjectRoot $ExpandedJavaHome
        }
        if ($ExpandedJavaHome -match '(?i)\.exe$') {
            Add-JavaCandidate -Candidates $Candidates -Path $ExpandedJavaHome
        }
        else {
            Add-JavaCandidate -Candidates $Candidates -Path (Join-Path $ExpandedJavaHome 'bin\java.exe')
            Add-JavaCandidate -Candidates $Candidates -Path (Join-Path $ExpandedJavaHome 'java.exe')
        }
    }

    $PathCommands = @(Get-Command java.exe -All -ErrorAction SilentlyContinue)
    foreach ($Command in $PathCommands) {
        $CommandPath = $Command.Path
        if ([string]::IsNullOrWhiteSpace($CommandPath)) {
            $CommandPath = $Command.Source
        }
        Add-JavaCandidate -Candidates $Candidates -Path $CommandPath
    }

    $PersistentPathValues = @(
        [Environment]::GetEnvironmentVariable('Path', 'User'),
        [Environment]::GetEnvironmentVariable('Path', 'Machine')
    ) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    foreach ($PersistentPathValue in $PersistentPathValues) {
        foreach ($PathEntry in ($PersistentPathValue -split ';')) {
            $TrimmedPathEntry = [Environment]::ExpandEnvironmentVariables($PathEntry.Trim())
            if ($TrimmedPathEntry -match '(?i)(java|jdk|jre|temurin|adoptium|adoptopenjdk|corretto|zulu|sapmachine)') {
                if ($TrimmedPathEntry -match '(?i)\.exe$') {
                    Add-JavaCandidate -Candidates $Candidates -Path $TrimmedPathEntry
                }
                else {
                    Add-JavaCandidate -Candidates $Candidates -Path (Join-Path $TrimmedPathEntry 'java.exe')
                }
            }
        }
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
            (Join-Path $ProgramFilesRoot 'Adoptium'),
            (Join-Path $ProgramFilesRoot 'Temurin'),
            (Join-Path $ProgramFilesRoot 'Microsoft'),
            (Join-Path $ProgramFilesRoot 'Amazon Corretto'),
            (Join-Path $ProgramFilesRoot 'Azul Systems'),
            (Join-Path $ProgramFilesRoot 'BellSoft'),
            (Join-Path $ProgramFilesRoot 'SapMachine'),
            (Join-Path $ProgramFilesRoot 'Zulu'),
            (Join-Path $ProgramFilesRoot 'Oracle')
        )
    }
    foreach ($Root in $ProgramRoots) {
        if (-not (Test-Path -LiteralPath $Root -PathType Container)) {
            continue
        }
        $Installations = @(Get-ChildItem -LiteralPath $Root -Directory -ErrorAction SilentlyContinue)
        foreach ($Installation in $Installations) {
            Add-JavaCandidate -Candidates $Candidates -Path (Join-Path $Installation.FullName 'bin\java.exe')
        }
    }

    $RegistryRoots = @(
        'HKLM:\SOFTWARE\JavaSoft\JDK',
        'HKLM:\SOFTWARE\WOW6432Node\JavaSoft\JDK',
        'HKCU:\SOFTWARE\JavaSoft\JDK',
        'HKLM:\SOFTWARE\Eclipse Adoptium',
        'HKLM:\SOFTWARE\WOW6432Node\Eclipse Adoptium',
        'HKCU:\SOFTWARE\Eclipse Adoptium',
        'HKLM:\SOFTWARE\AdoptOpenJDK',
        'HKLM:\SOFTWARE\WOW6432Node\AdoptOpenJDK',
        'HKCU:\SOFTWARE\AdoptOpenJDK',
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\java.exe',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\java.exe',
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\java.exe'
    )
    foreach ($RegistryRoot in $RegistryRoots) {
        if (-not (Test-Path -LiteralPath $RegistryRoot)) {
            continue
        }

        $RegistryKeys = @(
            Get-Item -LiteralPath $RegistryRoot -ErrorAction SilentlyContinue
            Get-ChildItem -LiteralPath $RegistryRoot -Recurse -ErrorAction SilentlyContinue
        )
        foreach ($RegistryKey in $RegistryKeys) {
            $RegistryProperties = Get-ItemProperty -LiteralPath $RegistryKey.PSPath -ErrorAction SilentlyContinue
            if ($null -eq $RegistryProperties) {
                continue
            }

            foreach ($PropertyName in @('JavaHome', 'Path', 'InstallationPath', 'Home', '(default)')) {
                $Property = $RegistryProperties.PSObject.Properties[$PropertyName]
                if ($null -eq $Property -or [string]::IsNullOrWhiteSpace([string]$Property.Value)) {
                    continue
                }

            $PropertyPath = [Environment]::ExpandEnvironmentVariables(([string]$Property.Value).Trim())
            if ($PropertyPath -match '(?i)\.exe$') {
                    Add-JavaCandidate -Candidates $Candidates -Path $PropertyPath
                }
                else {
                    Add-JavaCandidate -Candidates $Candidates -Path (Join-Path $PropertyPath 'bin\java.exe')
                    Add-JavaCandidate -Candidates $Candidates -Path (Join-Path $PropertyPath 'java.exe')
                }
            }
        }
    }

    $Inspected = New-Object 'System.Collections.Generic.List[object]'
    foreach ($Candidate in $Candidates) {
        $Runtime = Get-JavaRuntimeInfo $Candidate
        if ($null -eq $Runtime) {
            continue
        }
        [void]$Inspected.Add($Runtime)
        if ($Runtime.Major -ge $MinimumMajor -and $Runtime.Is64Bit) {
            return [pscustomobject]@{
                Selected = $Runtime
                Inspected = @($Inspected.ToArray())
                Candidates = @($Candidates.ToArray())
            }
        }
    }

    return [pscustomobject]@{
        Selected = $null
        Inspected = @($Inspected.ToArray())
        Candidates = @($Candidates.ToArray())
    }
}
