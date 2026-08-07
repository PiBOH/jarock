[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Path
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
    Write-Error "EULA file not found: $Path"
    exit 1
}

# Get-Content handles UTF-8 BOMs and both CRLF/LF files. Match the setting rather
# than requiring an exact byte-for-byte line, so harmless spaces/casing do not
# make an accepted EULA appear to be rejected.
$Accepted = $false
foreach ($Line in Get-Content -LiteralPath $Path) {
    if ([string]$Line -match '^\s*eula\s*=\s*true\s*(?:#.*)?$') {
        $Accepted = $true
        break
    }
}

if (-not $Accepted) {
    exit 1
}

exit 0
