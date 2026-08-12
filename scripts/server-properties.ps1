[CmdletBinding()]
param()

# server.properties helpers used by the server launcher. The script only defines
# functions; the caller dot-sources it and calls Set-ServerOnlineMode.
#
# Encoding note: server.properties is a Java properties file. Java historically
# reads and writes it as ISO-8859-1 (Latin-1), while modern Windows editors save
# it as UTF-8 with or without BOM. Rewriting the file through Get-Content (ANSI
# in Windows PowerShell 5.1) and WriteAllText UTF-8 re-encodes every non-ASCII
# byte and corrupts values such as a custom motd. This module therefore uses a
# byte-preserving Latin-1 round-trip: every byte 0x00-0xFF maps to exactly one
# code point and back, so only the targeted online-mode line changes and the
# rest of the file (motd, BOM, CRLF/LF line endings) stays byte-for-byte
# identical regardless of the original encoding.

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Repair-MotdMojibake([byte[]]$Bytes) {
    # Pre-0.0.147 Jarock rewrote server.properties through Get-Content -Raw, which
    # decodes with the system ANSI codepage (CP1252 on Western Windows), and saved
    # it back as UTF-8. A motd stored in UTF-8 was therefore double-encoded once:
    # UTF-8 bytes were read as CP1252 characters and written back as UTF-8, so for
    # example the Italian word for "coffee" (with an accented e) became the
    # permanent mojibake "Caff" + U+00C3 + U+00A8. Those corrupted bytes are
    # still valid UTF-8, so Minecraft 26.2 and the byte-preserving rewrite below
    # keep the corrupted text on every restart.
    #
    # This helper repairs exactly that historical damage. It only fires when the
    # classic mojibake signature (U+00C2/U+00C3/U+00E2) appears in the motd, and
    # only when the strict inverse transform succeeds: every character must map
    # back to a single CP1252 byte and those bytes must decode cleanly as UTF-8.
    # Legitimate text (plain accents, the section sign, emoji, French a-circumflex)
    # fails one of the strict steps and is returned unchanged. Returns the healed
    # file content in the UTF-8 text domain, or $null when there is nothing to
    # repair.
    $Utf8Strict = New-Object Text.UTF8Encoding($false, $true)
    $Decoded = $null
    try { $Decoded = $Utf8Strict.GetString($Bytes) } catch { return $null }
    $Motd = [regex]::Match($Decoded, '(?m)^[ \t]*motd[ \t]*=[ \t]*([^\r\n]*?)[ \t]*(\r?)$')
    if (-not $Motd.Success) { return $null }
    $Value = $Motd.Groups[1].Value
    if ($Value -notmatch '[\u00c2\u00c3\u00e2]') { return $null }
    $Healed = $null
    try {
        $Cp1252 = [Text.Encoding]::GetEncoding(1252, [Text.EncoderExceptionFallback]::new(), [Text.DecoderExceptionFallback]::new())
        $Healed = $Utf8Strict.GetString($Cp1252.GetBytes($Value))
    } catch { return $null }
    if ([string]::IsNullOrEmpty($Healed) -or $Healed -eq $Value) { return $null }
    if ($Healed -match '[\u00c2\u00c3\u00e2]') { return $null }
    # Replace exactly the matched motd line span (no regex evaluator: its
    # scriptblock output is unreliable under StrictMode in some PowerShell hosts).
    # The match includes the trailing line terminator (group 2), so append it back
    # to keep the motd line's CR/LF ending byte-identical to the original.
    return $Decoded.Substring(0, $Motd.Index) + 'motd=' + $Healed + $Motd.Groups[2].Value + $Decoded.Substring($Motd.Index + $Motd.Length)
}

function Set-ServerOnlineMode([string]$Path, [string]$Value) {
    if ($Value -notin @('true','false')) { throw "ONLINE_MODE must be true or false, not '$Value'." }
    $Latin1 = [Text.Encoding]::GetEncoding(28591)
    $Bytes = [IO.File]::ReadAllBytes($Path)
    $HealedContent = Repair-MotdMojibake $Bytes
    if ($null -ne $HealedContent) {
        $Content = $HealedContent
        $WriteEncoding = New-Object Text.UTF8Encoding($false)
        Write-Host 'Repaired the motd text corrupted by an older Jarock release (encoding mojibake).' -ForegroundColor Green
    }
    else {
        $Content = $Latin1.GetString($Bytes)
        $WriteEncoding = $Latin1
    }
    if ($Content -match '(?m)^[ \t]*online-mode[ \t]*=') { $Content = [regex]::Replace($Content, '(?m)^[ \t]*online-mode[ \t]*=[^\r\n]*', "online-mode=$Value") }
    else { $Content = $Content.TrimEnd("`r", "`n") + "`r`nonline-mode=$Value`r`n" }
    [IO.File]::WriteAllText($Path, $Content, $WriteEncoding)
    if ($Value -eq 'false') { Write-Host 'WARNING: online-mode=false disables normal Mojang authentication.' -ForegroundColor Yellow }
}
