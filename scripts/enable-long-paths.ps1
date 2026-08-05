[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$RegistryPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem'
$ValueName = 'LongPathsEnabled'

function Show-ErrorGuidance([string]$Message) {
    Write-Host "ERROR: $Message" -ForegroundColor Red
    Write-Host 'What to do:' -ForegroundColor Yellow
    Write-Host '  1. Close other Minecraft/PowerShell windows using this repository.'
    Write-Host '  2. Run start-server.bat again and accept the Windows administrator prompt.'
    Write-Host '  3. If the PC is managed by an organization, ask an administrator to enable LongPathsEnabled.'
    Write-Host '  4. Reboot Windows if applications still report the old path limit.'
}

try {
    $Identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $Principal = New-Object Security.Principal.WindowsPrincipal($Identity)
    $IsAdministrator = $Principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $IsAdministrator) {
        throw 'Administrator privileges are required to change LongPathsEnabled.'
    }

    New-Item -Path $RegistryPath -Force | Out-Null
    New-ItemProperty -Path $RegistryPath -Name $ValueName -PropertyType DWord -Value 1 -Force | Out-Null
    $Current = (Get-ItemProperty -Path $RegistryPath -Name $ValueName).$ValueName
    if ([int]$Current -ne 1) {
        throw 'Windows did not report LongPathsEnabled=1 after the registry update.'
    }

    Write-Host 'Windows long-path support is now enabled (LongPathsEnabled=1).' -ForegroundColor Green
    Write-Host 'The change is machine-wide. Restart applications, and reboot Windows if an old application still uses the 260-character limit.' -ForegroundColor Yellow
    exit 0
}
catch {
    Show-ErrorGuidance $_.Exception.Message
    exit 1
}
