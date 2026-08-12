[CmdletBinding()]
param()

# Geyser config.yml helpers used by the loader bootstrap. The script only defines
# functions; the caller dot-sources it and calls Set-GeyserAuthType.
#
# Encoding note: Geyser (Java) generates and reads config.yml as UTF-8. Editing
# the file through Get-Content (ANSI in Windows PowerShell 5.1) and Set-Content
# UTF-8 re-encodes every non-ASCII byte and corrupts values such as a custom
# bedrock motd, announcement text or translated comments. This module therefore
# uses the same byte-preserving Latin-1 round-trip as server-properties.ps1:
# every byte 0x00-0xFF maps to exactly one code point and back, so only the
# targeted auth-type value changes and the rest of the file (motd bytes, BOM,
# CRLF/LF line endings) stays byte-for-byte identical regardless of the original
# encoding.

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Set-GeyserAuthType([string]$ConfigPath, [string]$Value = 'floodgate') {
    if (-not (Test-Path -LiteralPath $ConfigPath -PathType Leaf)) { return 'missing' }
    $Latin1 = [Text.Encoding]::GetEncoding(28591)
    $Bytes = [IO.File]::ReadAllBytes($ConfigPath)
    $Content = $Latin1.GetString($Bytes)
    # Replace only the auth-type value. [^\r\n]* keeps the original line ending
    # intact (the older .*$ form consumed the CR of a CRLF file).
    $Updated = [regex]::Replace($Content, '(?m)^(\s*auth-type:\s*)[^\r\n]*', ('${1}' + $Value))
    if ($Updated -eq $Content -and $Content -notmatch '(?m)^\s*auth-type:\s*') { return 'no-auth-type' }
    if ($Updated -ne $Content) {
        [IO.File]::WriteAllText($ConfigPath, $Updated, $Latin1)
        return 'updated'
    }
    return 'unchanged'
}
