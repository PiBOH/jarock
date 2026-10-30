# Aternos-style console input for the Jarock server console.
#
# A command argument that is a known vanilla registry id and has no namespace is
# sent to the server as minecraft:<id>, so
#
#   give @p oak_button          ->  give @p minecraft:oak_button
#   setblock 10 64 10 stone     ->  setblock 10 64 10 minecraft:stone
#
# Only ids from scripts/registry-ids.txt are qualified. The command name itself,
# player names, numbers, coordinates, selectors, NBT and free text are never
# changed, and an argument that already carries a namespace is left alone.
#
# The registry list is generated from the vanilla block and item registries. It
# is a local reference list, not a whitelist of what the server will accept.

$script:RegistryIdsPath = Join-Path $PSScriptRoot 'registry-ids.txt'
$script:RegistryIds = $null

function Get-RegistryIdSet {
    if ($null -ne $script:RegistryIds) { return $script:RegistryIds }
    $Ids = @{}
    if (Test-Path -LiteralPath $script:RegistryIdsPath -PathType Leaf) {
        foreach ($Line in Get-Content -LiteralPath $script:RegistryIdsPath -Encoding UTF8) {
            $Name = $Line.Trim()
            if ($Name -and -not $Name.StartsWith('#')) { $Ids[$Name] = $true }
        }
    }
    $script:RegistryIds = $Ids
    return $script:RegistryIds
}

function ConvertTo-NamespacedCommand([string]$Line) {
    if ([string]::IsNullOrWhiteSpace($Line)) { return $Line }
    $Command = $Line.Trim()
    # The console takes commands without a leading slash; strip it when the
    # operator types one out of habit and keep the rest untouched.
    if ($Command.StartsWith('/')) { $Command = $Command.Substring(1) }
    $Ids = Get-RegistryIdSet
    if ($Ids.Count -eq 0) { return $Command }
    $Tokens = [regex]::Split($Command, '(\s+)')
    $Builder = New-Object System.Text.StringBuilder
    $Index = 0
    foreach ($Token in $Tokens) {
        if ($Token -eq '' -or $Token -match '^\s+$') { [void]$Builder.Append($Token); $Index++; continue }
        # The command name is never qualified; only its arguments can be ids.
        if ($Index -eq 0) { [void]$Builder.Append($Token); $Index++; continue }
        if ($Token.Contains(':') -or $Token -notmatch '^[a-z0-9_]+$') { [void]$Builder.Append($Token); $Index++; continue }
        if ($Ids.ContainsKey($Token)) { [void]$Builder.Append('minecraft:' + $Token) }
        else { [void]$Builder.Append($Token) }
        $Index++
    }
    return $Builder.ToString()
}
