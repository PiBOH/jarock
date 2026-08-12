[CmdletBinding()]
param()

# Regression test for the server.properties online-mode rewrite. The rewrite must
# only touch the online-mode line and must preserve every other byte of the file:
# a custom motd with non-ASCII characters must survive byte-for-byte whether the
# file is saved as Latin-1 (classic Java), UTF-8 without BOM (modern Notepad) or
# UTF-8 with BOM. Uses only temporary folders; runs on any Windows machine
# without Java or network access.

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$Root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$Pass = 0
$Fail = 0
function Assert([bool]$Condition, [string]$Name) {
    if ($Condition) { $script:Pass++; Write-Host "PASS: $Name" -ForegroundColor Green }
    else { $script:Fail++; Write-Host "FAIL: $Name" -ForegroundColor Red }
}

try {
    . (Join-Path $PSScriptRoot 'server-properties.ps1')

    $TestDir = Join-Path ([IO.Path]::GetTempPath()) ('jarock-server-properties-' + [IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Force -Path $TestDir | Out-Null
    try {
        $Path = Join-Path $TestDir 'server.properties'
        $Latin1 = [Text.Encoding]::GetEncoding(28591)
        $MotdText = 'motd=Jarock server di prova: Sezione ' + [char]0x00E8 + ' 26.2'
        $Body = @($MotdText, 'level-name=world', 'max-players=20', 'online-mode=true') -join "`r`n"

        # 1) Latin-1 source file (classic Java properties encoding).
        [IO.File]::WriteAllText($Path, $Body + "`r`n", $Latin1)
        $BeforeBytes = [IO.File]::ReadAllBytes($Path)
        Set-ServerOnlineMode -Path $Path -Value 'false'
        $AfterText = $Latin1.GetString([IO.File]::ReadAllBytes($Path))
        $AfterMotd = ($AfterText -split "`r?`n" | Where-Object { $_ -match '^motd=' }) -join ''
        $AfterOnline = ($AfterText -split "`r?`n" | Where-Object { $_ -match '^online-mode=' }) -join ''
        Assert ($AfterMotd -eq $MotdText) 'Latin-1: non-ASCII motd survives the online-mode rewrite'
        Assert ($AfterOnline -eq 'online-mode=false') 'Latin-1: online-mode is updated to false'

        # 2) UTF-8 source without BOM (modern editors). Before the fix this
        #    re-encoded the accented motd and corrupted it (double encoding).
        [IO.File]::WriteAllText($Path, $Body + "`r`n", (New-Object Text.UTF8Encoding($false)))
        $BeforeUtf8 = [IO.File]::ReadAllBytes($Path)
        Set-ServerOnlineMode -Path $Path -Value 'true'
        $AfterUtf8 = [IO.File]::ReadAllBytes($Path)
        # Compare only the motd line bytes: everything except the online-mode
        # value must be byte-identical.
        $BeforeUtf8Motd = $Latin1.GetString($BeforeUtf8) -split "`r?`n" | Where-Object { $_ -match '^motd=' }
        $AfterUtf8Motd = $Latin1.GetString($AfterUtf8) -split "`r?`n" | Where-Object { $_ -match '^motd=' }
        Assert (($BeforeUtf8Motd -join '') -eq ($AfterUtf8Motd -join '')) 'UTF-8 (no BOM): motd bytes are unchanged'
        $AfterUtf8Text = [Text.Encoding]::UTF8.GetString($AfterUtf8)
        $AfterOnlineUtf8 = ($AfterUtf8Text -split "`r?`n" | Where-Object { $_ -match '^online-mode=' }) -join ''
        Assert ($AfterOnlineUtf8 -eq 'online-mode=true') 'UTF-8 (no BOM): online-mode is updated to true'
        $NonMotdBefore = [Text.Encoding]::UTF8.GetString($BeforeUtf8) -replace 'online-mode=(true|false)', 'online-mode=X'
        $NonMotdAfter = [Text.Encoding]::UTF8.GetString($AfterUtf8) -replace 'online-mode=(true|false)', 'online-mode=X'
        Assert ($NonMotdBefore -eq $NonMotdAfter) 'UTF-8 (no BOM): only the online-mode line changed'

        # 3) UTF-8 source with BOM (Notepad "UTF-8 with BOM"). The BOM must be
        #    preserved so the first property is not corrupted.
        [IO.File]::WriteAllText($Path, $Body + "`r`n", (New-Object Text.UTF8Encoding($true)))
        $BeforeBom = [IO.File]::ReadAllBytes($Path)
        Assert (($BeforeBom[0] -eq 0xEF) -and ($BeforeBom[1] -eq 0xBB) -and ($BeforeBom[2] -eq 0xBF)) 'UTF-8 BOM: input file has a BOM'
        Set-ServerOnlineMode -Path $Path -Value 'false'
        $AfterBom = [IO.File]::ReadAllBytes($Path)
        Assert (($AfterBom[0] -eq 0xEF) -and ($AfterBom[1] -eq 0xBB) -and ($AfterBom[2] -eq 0xBF)) 'UTF-8 BOM: BOM is preserved after the rewrite'
        $AfterBomMotd = $Latin1.GetString($AfterBom) -split "`r?`n" | Where-Object { $_ -match '^motd=' }
        $BeforeBomMotd = $Latin1.GetString($BeforeBom) -split "`r?`n" | Where-Object { $_ -match '^motd=' }
        Assert (($BeforeBomMotd -join '') -eq ($AfterBomMotd -join '')) 'UTF-8 BOM: motd bytes are unchanged'

        # 4) Missing online-mode line: the function appends it without touching
        #    the existing lines.
        [IO.File]::WriteAllText($Path, "motd=plain ascii`r`nlevel-name=world`r`n", (New-Object Text.UTF8Encoding($false)))
        Set-ServerOnlineMode -Path $Path -Value 'false'
        $Appended = [Text.Encoding]::UTF8.GetString([IO.File]::ReadAllBytes($Path))
        Assert ($Appended -match 'online-mode=false') 'Missing online-mode line is appended'
        Assert ($Appended -match 'motd=plain ascii') 'Appending keeps the existing motd'

        # 5) Invalid value is rejected.
        $Threw = $false
        try { Set-ServerOnlineMode -Path $Path -Value 'maybe' }
        catch { $Threw = $true }
        Assert $Threw 'Invalid online-mode value is rejected'

        # 6) Repeated rewrites stay stable (no cumulative corruption).
        [IO.File]::WriteAllText($Path, $Body + "`r`n", (New-Object Text.UTF8Encoding($false)))
        for ($i = 0; $i -lt 5; $i++) {
            $Next = if ($i % 2 -eq 0) { 'false' } else { 'true' }
            Set-ServerOnlineMode -Path $Path -Value $Next
        }
        $Stable = [Text.Encoding]::UTF8.GetString([IO.File]::ReadAllBytes($Path))
        $StableMotd = $Stable -split "`r?`n" | Where-Object { $_ -match '^motd=' }
        Assert (($StableMotd -join '') -eq $MotdText) 'Repeated rewrites do not corrupt the motd'

        Write-Host ''
        Write-Host "Test summary: $Pass passed, $Fail failed." -ForegroundColor Cyan
        if ($Fail -gt 0) { exit 1 }
        Write-Host 'All tests passed.' -ForegroundColor Green
    }
    finally {
        Remove-Item -LiteralPath $TestDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
catch {
    Write-Host ''
    Write-Host "HARNESS ERROR: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ScriptStackTrace) { Write-Host $_.ScriptStackTrace -ForegroundColor DarkGray }
    exit 1
}
