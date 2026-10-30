# Shared access to scripts/jarock.ini, the single source of the Jarock version
# and of the local launch settings. Dot-source this file and call the functions;
# every script that needs a setting or the version goes through here so there is
# exactly one parser and one file format.

$script:JarockConfigPath = Join-Path $PSScriptRoot 'jarock.ini'

function Get-JarockConfigPath { return $script:JarockConfigPath }

function Read-JarockConfig {
    $Values = @{}
    if (Test-Path -LiteralPath $script:JarockConfigPath -PathType Leaf) {
        # UTF-8 explicitly: Windows PowerShell 5.1 would otherwise read a BOM-less
        # UTF-8 file as ANSI and corrupt accented world paths.
        foreach ($Line in Get-Content -LiteralPath $script:JarockConfigPath -Encoding UTF8) {
            if ($Line -match '^\s*([A-Z_]+)=(.*?)\s*$') { $Values[$Matches[1]] = $Matches[2] }
        }
    }
    return $Values
}

function Get-JarockSetting([string]$Name, [string]$Default = '') {
    $Values = Read-JarockConfig
    if ($Values.ContainsKey($Name)) { return [string]$Values[$Name] }
    return $Default
}

function Get-JarockVersion {
    $Version = Get-JarockSetting 'JAROCK_VERSION' ''
    if ($Version -notmatch '^\d+\.\d+\.\d+(-[0-9A-Za-z.-]+)?$') {
        throw "scripts\jarock.ini must contain a semantic version in JAROCK_VERSION, for example 0.1.0-beta. Found: '$Version'."
    }
    return $Version
}

function Get-JarockMinecraftVersion {
    return Get-JarockSetting 'MINECRAFT_VERSION' ''
}

function Set-JarockSetting([string]$Name, [string]$Value) {
    if ($Name -notmatch '^[A-Z_]+$') { throw "Unsafe setting name '$Name'." }
    if ($Value -match '[\r\n]') { throw "$Name must be a single-line value." }
    $Content = [IO.File]::ReadAllText($script:JarockConfigPath, [Text.Encoding]::UTF8)
    $Pattern = "(?m)^$Name=.*$"
    if ($Content -match $Pattern) {
        $Content = [regex]::Replace($Content, $Pattern, "$Name=$Value")
    }
    else {
        $Content = $Content.TrimEnd("`r", "`n") + "`r`n$Name=$Value`r`n"
    }
    [IO.File]::WriteAllText($script:JarockConfigPath, $Content, (New-Object Text.UTF8Encoding($false)))
}
