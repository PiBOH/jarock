[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string]$SettingsPath,
    [Parameter(Mandatory = $true)] [ValidateSet('LOADER_TYPE','GUI_MODE','GC_PROFILE','AUTO_CONFIGURE_JAVA','ONLINE_MODE','SHOW_READY_BANNER','AUTO_UPDATE_CHECK','AUTO_UPDATE_MODE','WORLD_IMPORT_SOURCE','WORLD_IMPORT_REMEMBER','WORLD_IMPORT_APPLIED','WORLD_EXPORT_DEST')] [string]$Name,
    [Parameter(Mandatory = $true)] [string]$Value
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

try {
    switch ($Name) {
        'LOADER_TYPE' { if ($Value -notin @('none','fabric','forge','neoforge')) { throw 'LOADER_TYPE must be none, fabric, forge or neoforge.' } }
        'GUI_MODE' { if ($Value -notin @('gui','nogui')) { throw 'GUI_MODE must be gui or nogui.' } }
        'GC_PROFILE' { if ($Value -notin @('default','low-pause')) { throw 'GC_PROFILE must be default or low-pause.' } }
        'AUTO_CONFIGURE_JAVA' { if ($Value -notin @('true','false')) { throw 'AUTO_CONFIGURE_JAVA must be true or false.' } }
        'ONLINE_MODE' { if ($Value -notin @('true','false')) { throw 'ONLINE_MODE must be true or false.' } }
        'SHOW_READY_BANNER' { if ($Value -notin @('true','false')) { throw 'SHOW_READY_BANNER must be true or false.' } }
        'AUTO_UPDATE_CHECK' { if ($Value -notin @('true','false')) { throw 'AUTO_UPDATE_CHECK must be true or false.' } }
        'AUTO_UPDATE_MODE' { if ($Value -notin @('install','check','never')) { throw 'AUTO_UPDATE_MODE must be install, check or never.' } }
        'WORLD_IMPORT_REMEMBER' { if ($Value -notin @('true','false')) { throw 'WORLD_IMPORT_REMEMBER must be true or false.' } }
        'WORLD_IMPORT_APPLIED' { if ($Value -notin @('true','false')) { throw 'WORLD_IMPORT_APPLIED must be true or false.' } }
    }
    $Content = Get-Content -LiteralPath $SettingsPath -Raw
    $SettingPattern = "(?m)^$Name=.*$"
    if ($Content -match $SettingPattern) {
        $Content = [regex]::Replace($Content, $SettingPattern, "$Name=$Value")
    }
    else {
        $Content = $Content.TrimEnd("`r", "`n") + "`r`n$Name=$Value`r`n"
    }
    Set-Content -LiteralPath $SettingsPath -Value $Content -Encoding UTF8
    exit 0
}
catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host 'Suggested fix: choose one of the values shown by parameter-manager.bat.' -ForegroundColor Yellow
    exit 1
}
