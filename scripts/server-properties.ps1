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

function Set-ServerOnlineMode([string]$Path, [string]$Value) {
    if ($Value -notin @('true','false')) { throw "ONLINE_MODE must be true or false, not '$Value'." }
    $Latin1 = [Text.Encoding]::GetEncoding(28591)
    $Bytes = [IO.File]::ReadAllBytes($Path)
    $Content = $Latin1.GetString($Bytes)
    if ($Content -match '(?m)^[ \t]*online-mode[ \t]*=') { $Content = [regex]::Replace($Content, '(?m)^[ \t]*online-mode[ \t]*=[^\r\n]*', "online-mode=$Value") }
    else { $Content = $Content.TrimEnd("`r", "`n") + "`r`nonline-mode=$Value`r`n" }
    [IO.File]::WriteAllText($Path, $Content, $Latin1)
    if ($Value -eq 'false') { Write-Host 'WARNING: online-mode=false disables normal Mojang authentication.' -ForegroundColor Yellow }
}
