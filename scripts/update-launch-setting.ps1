[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string]$SettingsPath,
    [Parameter(Mandatory = $true)] [ValidateSet('GUI_MODE','GC_PROFILE','AUTO_CONFIGURE_JAVA')] [string]$Name,
    [Parameter(Mandatory = $true)] [string]$Value
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

try {
    switch ($Name) {
        'GUI_MODE' { if ($Value -notin @('gui','nogui')) { throw 'GUI_MODE must be gui or nogui.' } }
        'GC_PROFILE' { if ($Value -notin @('default','low-pause')) { throw 'GC_PROFILE must be default or low-pause.' } }
        'AUTO_CONFIGURE_JAVA' { if ($Value -notin @('true','false')) { throw 'AUTO_CONFIGURE_JAVA must be true or false.' } }
    }
    $Content = Get-Content -LiteralPath $SettingsPath -Raw
    $Content = [regex]::Replace($Content, "(?m)^$Name=.*$", "$Name=$Value")
    Set-Content -LiteralPath $SettingsPath -Value $Content -Encoding UTF8
    exit 0
}
catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host 'Suggested fix: choose one of the values shown by parameter-manager.bat.' -ForegroundColor Yellow
    exit 1
}
