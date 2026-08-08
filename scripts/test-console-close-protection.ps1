[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$ProtectionPath = Join-Path $PSScriptRoot 'console-close-protection.ps1'
$Pass = 0
$Fail = 0

function Assert([bool]$Condition, [string]$Name) {
    if ($Condition) {
        $script:Pass++
        Write-Host "PASS: $Name" -ForegroundColor Green
    }
    else {
        $script:Fail++
        Write-Host "FAIL: $Name" -ForegroundColor Red
    }
}

try {
    Write-Host '==> Testing Jarock console-close protection without closing the CI console' -ForegroundColor Cyan

    Assert (Test-Path -LiteralPath $ProtectionPath -PathType Leaf) 'Console-close protection script is present'
    $Source = Get-Content -LiteralPath $ProtectionPath -Raw
    Assert ($Source -match 'SetConsoleCtrlHandler') 'The native console handler API is declared'
    Assert ($Source -match 'CTRL_CLOSE_EVENT') 'The close event is explicitly handled'
    Assert ($Source -match 'MessageBoxW') 'The warning message box is defined'
    Assert ($Source -match 'SAFE TO CLOSE') 'The warning contains safe-shutdown guidance'
    Assert ($Source -match 'Windows Terminal') 'Pseudoconsole limitations are documented in the script'
    Assert ($Source -match '(?i)best-effort') 'The implementation is explicitly marked as best-effort'

    # Loading the script compiles the embedded C# and defines the public helpers.
    . $ProtectionPath
    Assert ($null -ne ('JarockConsoleCloseProtection' -as [type])) 'Embedded C# protection type compiled successfully'
    Assert ($null -ne (Get-Command Enable-JarockConsoleCloseProtection -ErrorAction SilentlyContinue)) 'Enable helper is available'
    Assert ($null -ne (Get-Command Disable-JarockConsoleCloseProtection -ErrorAction SilentlyContinue)) 'Disable helper is available'

    # Calling Start/Stop is safe in CI: it registers and unregisters the handler but
    # does not generate CTRL_CLOSE_EVENT and therefore never opens the MsgBox. This
    # deliberately tests compilation and lifecycle only; sending a real close event
    # could terminate the runner or block it on the interactive warning dialog.
    $FirstStart = Enable-JarockConsoleCloseProtection
    $SecondStart = Enable-JarockConsoleCloseProtection
    Disable-JarockConsoleCloseProtection
    Assert ([bool]$FirstStart) 'The handler registers successfully'
    Assert ([bool]$SecondStart) 'Repeated enable is idempotent'

    # A second stop must also be harmless, which is important for finally blocks and
    # error paths in run-server.ps1.
    Disable-JarockConsoleCloseProtection
    Assert $true 'Repeated disable is harmless'

    Write-Host ''
    Write-Host "Test summary: $Pass passed, $Fail failed." -ForegroundColor Cyan
    if ($Fail -gt 0) { exit 1 }
    Write-Host 'All console-close protection tests passed.' -ForegroundColor Green
}
catch {
    Write-Host ''
    Write-Host "TEST ERROR: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ScriptStackTrace) { Write-Host $_.ScriptStackTrace -ForegroundColor DarkGray }
    exit 1
}
