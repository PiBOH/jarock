[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$JavaExecutable
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Show-ErrorGuidance([string]$Message, [string]$Action) {
    Write-Host "ERROR: $Message" -ForegroundColor Red
    Write-Host "Suggested fix: $Action" -ForegroundColor Yellow
    Write-Host 'The server can still use its selected absolute Java path; no router, firewall or port-forwarding changes were made.' -ForegroundColor Yellow
}

try {
    $JavaExecutable = [IO.Path]::GetFullPath($JavaExecutable)
    if (-not (Test-Path -LiteralPath $JavaExecutable -PathType Leaf)) {
        throw "Java executable was not found: $JavaExecutable"
    }

    $JavaBin = Split-Path -Parent $JavaExecutable
    $JavaHome = Split-Path -Parent $JavaBin
    $UserPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    if ($null -eq $UserPath) { $UserPath = '' }

    $Entries = @($UserPath -split ';' | ForEach-Object { $_.Trim() } | Where-Object { $_ })
    $NormalizedTarget = $JavaBin.TrimEnd('\').ToLowerInvariant()
    $AlreadyPresent = $false
    foreach ($Entry in $Entries) {
        if ($Entry.TrimEnd('\').ToLowerInvariant() -eq $NormalizedTarget) {
            $AlreadyPresent = $true
            break
        }
    }
    if (-not $AlreadyPresent) {
        $Entries = @($JavaBin) + $Entries
    }

    [Environment]::SetEnvironmentVariable('JAVA_HOME', $JavaHome, 'User')
    [Environment]::SetEnvironmentVariable('Path', ($Entries -join ';'), 'User')

    if (-not ('JarockEnvironmentBroadcast' -as [type])) {
        Add-Type @'
using System;
using System.Runtime.InteropServices;
public static class JarockEnvironmentBroadcast {
    [DllImport("user32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    public static extern IntPtr SendMessageTimeout(
        IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam,
        uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
}
'@
    }
    $Result = [UIntPtr]::Zero
    [void][JarockEnvironmentBroadcast]::SendMessageTimeout([IntPtr]0xffff, 0x001A, [UIntPtr]::Zero, 'Environment', 0x0002, 5000, [ref]$Result)

    Write-Host "User JAVA_HOME configured: $JavaHome" -ForegroundColor Green
    Write-Host "User PATH contains Java first: $JavaBin" -ForegroundColor Green
    Write-Host 'Existing user PATH entries were preserved. New terminals will see the change; already-open terminals may need to be reopened.' -ForegroundColor Yellow
    exit 0
}
catch {
    Show-ErrorGuidance $_.Exception.Message 'Close programs using the environment settings, then run start-server.bat again. The server will still use the selected absolute Java executable.'
    exit 1
}
