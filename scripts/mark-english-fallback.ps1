[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string]$Path,
    [Parameter(Mandatory = $true)] [ValidateSet('server','neoforge')] [string]$GuideType
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

try {
    $Content = Get-Content -LiteralPath $Path -Raw
    $Notice = if ($GuideType -eq 'server') {
        '> **Translation status:** This locale currently provides an English fallback summary. The complete canonical installation guide is linked below.'
    } else {
        '> **Translation status:** This locale currently provides an English fallback summary. The complete canonical NeoForge guide is linked below.'
    }
    if ($Content -notmatch 'Translation status:') {
        $Content = $Content -replace "(\n\n)(See the \[canonical English)", "`$1$Notice`$1`$2"
        Set-Content -LiteralPath $Path -Value $Content -Encoding UTF8
    }
    exit 0
}
catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
