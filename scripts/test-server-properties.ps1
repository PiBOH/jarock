[CmdletBinding()]
param()

# Regression test for the server.properties online-mode rewrite. The rewrite must
# only touch the online-mode value and must preserve every other byte of the
# file: a custom motd with non-ASCII characters must survive byte-for-byte when
# the file is saved as Latin-1 (classic Java), UTF-8 without BOM (modern
# Notepad) or UTF-8 with BOM. For each encoding the test compares the whole file
# before/after with the online-mode value masked, so any accidental re-encoding
# (double encoding, BOM loss, line-ending drift) fails the assertion. Uses only
# temporary folders; runs on any Windows machine without Java or network access.

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$Root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$Pass = 0
$Fail = 0
function Assert([bool]$Condition, [string]$Name) {
    if ($Condition) { $script:Pass++; Write-Host "PASS: $Name" -ForegroundColor Green }
    else { $script:Fail++; Write-Host "FAIL: $Name" -ForegroundColor Red }
}

# Mask the online-mode value in a raw byte stream (Latin-1 decode keeps every
# byte addressable 1:1) so two versions of the file can be compared without the
# intended value change hiding any other drift.
function Get-OnlineModeMasked([byte[]]$Bytes) {
    $MaskLatin1 = [Text.Encoding]::GetEncoding(28591)
    $Text = $MaskLatin1.GetString($Bytes)
    $Masked = [regex]::Replace($Text, '(?m)^[ \t]*online-mode[ \t]*=(true|false)', 'online-mode=X')
    return $MaskLatin1.GetBytes($Masked)
}

function Assert-OnlyOnlineModeChanged([byte[]]$Before, [byte[]]$After, [string]$Name) {
    $MaskedBefore = Get-OnlineModeMasked $Before
    $MaskedAfter = Get-OnlineModeMasked $After
    $Equal = $MaskedBefore.Length -eq $MaskedAfter.Length
    if ($Equal) {
        for ($Index = 0; $Index -lt $MaskedBefore.Length; $Index++) {
            if ($MaskedBefore[$Index] -ne $MaskedAfter[$Index]) { $Equal = $false; break }
        }
    }
    Assert $Equal $Name
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

        # 1) Latin-1 source file (classic Java properties encoding). The accented
        #    motd byte (0xE8) must survive and only online-mode may change.
        [IO.File]::WriteAllText($Path, $Body + "`r`n", $Latin1)
        $BeforeBytes = [IO.File]::ReadAllBytes($Path)
        Set-ServerOnlineMode -Path $Path -Value 'false'
        $AfterBytes = [IO.File]::ReadAllBytes($Path)
        $AfterText = $Latin1.GetString($AfterBytes)
        $AfterMotd = ($AfterText -split "`r?`n" | Where-Object { $_ -match '^motd=' }) -join ''
        $AfterOnline = ($AfterText -split "`r?`n" | Where-Object { $_ -match '^online-mode=' }) -join ''
        Assert ($AfterMotd -eq $MotdText) 'Latin-1: non-ASCII motd survives the online-mode rewrite'
        Assert ($AfterOnline -eq 'online-mode=false') 'Latin-1: online-mode is updated to false'
        Assert-OnlyOnlineModeChanged $BeforeBytes $AfterBytes 'Latin-1: only the online-mode line changed byte-for-byte'

        # 2) UTF-8 source without BOM (modern editors). Before the fix this
        #    re-encoded the accented motd and corrupted it (double encoding).
        [IO.File]::WriteAllText($Path, $Body + "`r`n", (New-Object Text.UTF8Encoding($false)))
        $BeforeUtf8 = [IO.File]::ReadAllBytes($Path)
        Set-ServerOnlineMode -Path $Path -Value 'true'
        $AfterUtf8 = [IO.File]::ReadAllBytes($Path)
        $BeforeUtf8Motd = @($Latin1.GetString($BeforeUtf8) -split "`r?`n" | Where-Object { $_ -match '^motd=' })
        $AfterUtf8Motd = @($Latin1.GetString($AfterUtf8) -split "`r?`n" | Where-Object { $_ -match '^motd=' })
        Assert (($BeforeUtf8Motd.Count -gt 0) -and (($BeforeUtf8Motd -join '') -eq ($AfterUtf8Motd -join ''))) 'UTF-8 (no BOM): motd bytes are unchanged'
        $AfterUtf8Text = [Text.Encoding]::UTF8.GetString($AfterUtf8)
        $AfterOnlineUtf8 = ($AfterUtf8Text -split "`r?`n" | Where-Object { $_ -match '^online-mode=' }) -join ''
        Assert ($AfterOnlineUtf8 -eq 'online-mode=true') 'UTF-8 (no BOM): online-mode is updated to true'
        Assert-OnlyOnlineModeChanged $BeforeUtf8 $AfterUtf8 'UTF-8 (no BOM): only the online-mode line changed byte-for-byte'

        # 3) UTF-8 source with BOM (Notepad "UTF-8 with BOM"). The BOM must be
        #    preserved so the first property is not corrupted. Note the BOM bytes
        #    prefix the first line, so the motd line must be matched without a
        #    strict start anchor (a ^motd= match would be vacuous here).
        [IO.File]::WriteAllText($Path, $Body + "`r`n", (New-Object Text.UTF8Encoding($true)))
        $BeforeBom = [IO.File]::ReadAllBytes($Path)
        Assert (($BeforeBom[0] -eq 0xEF) -and ($BeforeBom[1] -eq 0xBB) -and ($BeforeBom[2] -eq 0xBF)) 'UTF-8 BOM: input file has a BOM'
        Set-ServerOnlineMode -Path $Path -Value 'false'
        $AfterBom = [IO.File]::ReadAllBytes($Path)
        Assert (($AfterBom[0] -eq 0xEF) -and ($AfterBom[1] -eq 0xBB) -and ($AfterBom[2] -eq 0xBF)) 'UTF-8 BOM: BOM is preserved after the rewrite'
        $AfterBomMotd = @($Latin1.GetString($AfterBom) -split "`r?`n" | Where-Object { $_ -match 'motd=' })
        $BeforeBomMotd = @($Latin1.GetString($BeforeBom) -split "`r?`n" | Where-Object { $_ -match 'motd=' })
        Assert (($BeforeBomMotd.Count -gt 0) -and (($BeforeBomMotd -join '') -eq ($AfterBomMotd -join ''))) 'UTF-8 BOM: motd bytes are unchanged'
        $AfterBomOnline = ($Latin1.GetString($AfterBom) -split "`r?`n" | Where-Object { $_ -match '^online-mode=' }) -join ''
        Assert ($AfterBomOnline -eq 'online-mode=false') 'UTF-8 BOM: online-mode is updated to false'
        Assert-OnlyOnlineModeChanged $BeforeBom $AfterBom 'UTF-8 BOM: only the online-mode line changed byte-for-byte'

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
