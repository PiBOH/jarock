[CmdletBinding()]
param()

# Regression test for the Geyser config.yml auth-type rewrite. The rewrite must
# only change the auth-type value and preserve every other byte of the file: a
# custom bedrock motd or comment with non-ASCII characters must survive
# byte-for-byte whether config.yml is saved as Latin-1, UTF-8 without BOM or
# UTF-8 with BOM. The BOM and the CRLF ending of the auth-type line must also
# survive. Uses only temporary folders.

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$Root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$Pass = 0
$Fail = 0
function Assert([bool]$Condition, [string]$Name) {
    if ($Condition) { $script:Pass++; Write-Host "PASS: $Name" -ForegroundColor Green }
    else { $script:Fail++; Write-Host "FAIL: $Name" -ForegroundColor Red }
}

# Mask the auth-type value in a raw byte stream (Latin-1 decode keeps every byte
# addressable 1:1) so two versions of the file can be compared without the
# intended value change hiding any other drift.
function Get-AuthMasked([byte[]]$Bytes) {
    $MaskLatin1 = [Text.Encoding]::GetEncoding(28591)
    $Text = $MaskLatin1.GetString($Bytes)
    $Masked = [regex]::Replace($Text, '(?m)^(\s*auth-type:\s*)[^\r\n]*', '${1}X')
    return $MaskLatin1.GetBytes($Masked)
}

function Assert-AuthOnlyChanged([byte[]]$Before, [byte[]]$After, [string]$Name) {
    $MaskedBefore = Get-AuthMasked $Before
    $MaskedAfter = Get-AuthMasked $After
    $Equal = $MaskedBefore.Length -eq $MaskedAfter.Length
    if ($Equal) {
        for ($Index = 0; $Index -lt $MaskedBefore.Length; $Index++) {
            if ($MaskedBefore[$Index] -ne $MaskedAfter[$Index]) { $Equal = $false; break }
        }
    }
    Assert $Equal $Name
}

function Assert-BytesIdentical([byte[]]$Before, [byte[]]$After, [string]$Name) {
    $Equal = $Before.Length -eq $After.Length
    if ($Equal) {
        for ($Index = 0; $Index -lt $Before.Length; $Index++) {
            if ($Before[$Index] -ne $After[$Index]) { $Equal = $false; break }
        }
    }
    Assert $Equal $Name
}

try {
    . (Join-Path $PSScriptRoot 'geyser-config.ps1')

    $TestDir = Join-Path ([IO.Path]::GetTempPath()) ('jarock-geyser-config-' + [IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Force -Path $TestDir | Out-Null
    try {
        $Path = Join-Path $TestDir 'config.yml'
        $Latin1 = [Text.Encoding]::GetEncoding(28591)
        $MotdLine = 'motd: "Jarock server di prova: Sezione ' + [char]0x00E8 + ' 26.2"'
        $Body = @('# Geyser configuration for Jarock', 'bedrock:', '  port: 19132', $MotdLine, 'auth-type: online', 'passthrough-motd: true') -join "`r`n"

        # 1) UTF-8 without BOM (Geyser's own output): only auth-type changes and
        #    the accented motd bytes survive.
        [IO.File]::WriteAllText($Path, $Body + "`r`n", (New-Object Text.UTF8Encoding($false)))
        $BeforeBytes = [IO.File]::ReadAllBytes($Path)
        $Result = Set-GeyserAuthType -ConfigPath $Path -Value 'floodgate'
        $AfterBytes = [IO.File]::ReadAllBytes($Path)
        Assert ($Result -eq 'updated') 'UTF-8 (no BOM): auth-type is updated'
        Assert-AuthOnlyChanged $BeforeBytes $AfterBytes 'UTF-8 (no BOM): only the auth-type value changed byte-for-byte'
        $AfterText = $Latin1.GetString($AfterBytes)
        $AuthLine = @($AfterText -split "`r?`n" | Where-Object { $_ -match 'auth-type:' })
        Assert (($AuthLine -join '') -eq 'auth-type: floodgate') 'UTF-8 (no BOM): auth-type value is floodgate'

        # 2) UTF-8 with BOM: the BOM and the motd bytes must survive.
        [IO.File]::WriteAllText($Path, $Body + "`r`n", (New-Object Text.UTF8Encoding($true)))
        $BeforeBom = [IO.File]::ReadAllBytes($Path)
        Assert (($BeforeBom[0] -eq 0xEF) -and ($BeforeBom[1] -eq 0xBB) -and ($BeforeBom[2] -eq 0xBF)) 'UTF-8 BOM: input file has a BOM'
        Set-GeyserAuthType -ConfigPath $Path -Value 'floodgate' | Out-Null
        $AfterBom = [IO.File]::ReadAllBytes($Path)
        Assert (($AfterBom[0] -eq 0xEF) -and ($AfterBom[1] -eq 0xBB) -and ($AfterBom[2] -eq 0xBF)) 'UTF-8 BOM: BOM is preserved after the rewrite'
        Assert-AuthOnlyChanged $BeforeBom $AfterBom 'UTF-8 BOM: only the auth-type value changed byte-for-byte'

        # 3) Latin-1 source: the byte-preserving round-trip keeps byte 0xE8 intact.
        [IO.File]::WriteAllText($Path, $Body + "`r`n", $Latin1)
        $BeforeLatin = [IO.File]::ReadAllBytes($Path)
        Set-GeyserAuthType -ConfigPath $Path -Value 'floodgate' | Out-Null
        $AfterLatin = [IO.File]::ReadAllBytes($Path)
        Assert-AuthOnlyChanged $BeforeLatin $AfterLatin 'Latin-1: only the auth-type value changed byte-for-byte'

        # 4) Already floodgate: unchanged and the file stays byte-identical.
        $BeforeSame = [IO.File]::ReadAllBytes($Path)
        $Result = Set-GeyserAuthType -ConfigPath $Path -Value 'floodgate'
        Assert ($Result -eq 'unchanged') 'Already floodgate reports unchanged'
        Assert-BytesIdentical $BeforeSame ([IO.File]::ReadAllBytes($Path)) 'Already floodgate leaves the file byte-identical'

        # 5) Missing auth-type: reported and the file is untouched.
        [IO.File]::WriteAllText($Path, "# no auth here`r`nbedrock:`r`n  port: 19132`r`n", (New-Object Text.UTF8Encoding($false)))
        $BeforeMissing = [IO.File]::ReadAllBytes($Path)
        $Result = Set-GeyserAuthType -ConfigPath $Path -Value 'floodgate'
        Assert ($Result -eq 'no-auth-type') 'Missing auth-type is reported'
        Assert-BytesIdentical $BeforeMissing ([IO.File]::ReadAllBytes($Path)) 'Missing auth-type leaves the file byte-identical'

        # 6) Missing file: reported as missing.
        $Result = Set-GeyserAuthType -ConfigPath (Join-Path $TestDir 'absent.yml') -Value 'floodgate'
        Assert ($Result -eq 'missing') 'A missing config file is reported as missing'

        # 7) The auth-type line keeps its CRLF ending (the old .*$ form ate the CR).
        [IO.File]::WriteAllText($Path, $Body + "`r`n", (New-Object Text.UTF8Encoding($false)))
        Set-GeyserAuthType -ConfigPath $Path -Value 'floodgate' | Out-Null
        $CrlfText = $Latin1.GetString([IO.File]::ReadAllBytes($Path))
        Assert ($CrlfText -match '(?m)^auth-type: floodgate\r$') 'auth-type line keeps its CRLF ending'

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
