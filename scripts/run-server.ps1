[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ServerDirectory
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$JavaRuntimeScript = Join-Path (Split-Path -Parent $PSScriptRoot) 'scripts\java-runtime.ps1'
if (-not (Test-Path -LiteralPath $JavaRuntimeScript -PathType Leaf)) {
    Write-Host 'ERROR: The Java runtime helper is missing.' -ForegroundColor Red
    Write-Host 'Suggested fix: restore scripts/java-runtime.ps1 and run start-server.bat again.' -ForegroundColor Yellow
    exit 1
}
. $JavaRuntimeScript

function Show-ErrorGuidance([string]$Message, [string]$Action) {
    Write-Host "ERROR: $Message" -ForegroundColor Red
    Write-Host "Suggested fix: $Action" -ForegroundColor Yellow
    Write-Host 'No router, firewall, port-forwarding, or public-network changes were performed.' -ForegroundColor Yellow
}

try {
    $ServerDirectory = [IO.Path]::GetFullPath($ServerDirectory)
    $JavaPathFile = Join-Path $ServerDirectory 'java-path.txt'
    $LauncherPath = Join-Path $ServerDirectory 'fabric-server-launch.jar'

    if (-not (Test-Path -LiteralPath $JavaPathFile -PathType Leaf)) {
        throw "The selected Java path file was not found: $JavaPathFile"
    }
    if (-not (Test-Path -LiteralPath $LauncherPath -PathType Leaf)) {
        throw "The Fabric server launcher was not found: $LauncherPath"
    }

    $JavaPath = (Get-Content -LiteralPath $JavaPathFile -Raw).Trim()
    if ([string]::IsNullOrWhiteSpace($JavaPath) -or -not (Test-Path -LiteralPath $JavaPath -PathType Leaf)) {
        throw "The selected Java executable is missing or invalid: '$JavaPath'"
    }

    $Runtime = Get-JavaRuntimeInfo $JavaPath
    if ($null -eq $Runtime) {
        throw "Could not inspect the selected Java executable: '$JavaPath'."
    }
    if ($Runtime.Major -lt 25 -or -not $Runtime.Is64Bit) {
        throw "The selected Java executable is Java $($Runtime.Major), 64-bit=$($Runtime.Is64Bit); Minecraft 26.2 requires 64-bit Java 25 or newer."
    }

    Write-Host "Using Java executable: $($Runtime.Path) (Java $($Runtime.Version), 64-bit=$($Runtime.Is64Bit))" -ForegroundColor Green
    Push-Location -LiteralPath $ServerDirectory
    try {
        & $JavaPath '-Xms4G' '-Xmx4G' '-jar' $LauncherPath 'nogui'
        $ExitCode = $LASTEXITCODE
    }
    finally {
        Pop-Location
    }

    exit $ExitCode
}
catch {
    Show-ErrorGuidance $_.Exception.Message 'Run start-server.bat again so Java discovery can repair java-path.txt. If no Java 25+ runtime is found, install one and set JAVA_HOME to its JDK folder.'
    exit 1
}
