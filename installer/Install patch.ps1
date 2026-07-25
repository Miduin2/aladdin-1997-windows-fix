[CmdletBinding()]
param(
    [Parameter()]
    [string]$GameDirectory = $PSScriptRoot
)

$ErrorActionPreference = 'Stop'
$originalSha256 = '77B7B7B03F80BAD087E23217D4CDCA51A5F93C550D0FF290B22EC7FB4694C209'
$patchedSha256 = '8CE7F608D1BFEF1F67B5495D33653ED602B1CA05BBFC521255D9D6DF48FB4740'
$componentHashes = @{
    'ddraw.dll' = 'B2200A365FB371DE34FFD87734086B4D3DF4174FED85F91FDD2E0B6660C05C27'
    'GameVaultDraw.ini' = '57E0DF9C9C29CC8B147D400C917171ABACB6AC21DB5B01B758DCA07396E58167'
    'Play Aladdin.exe' = '44BA3FB33C0FFF64E31198CD5FE6810E10BF5C059656F06F020B620279FDF300'
}
$edits = @(
    @{ Offset = 0x2E0B; Before = 0x73; After = 0xEB; Purpose = 'colour-depth check' },
    @{ Offset = 0x8992; Before = 0xFA; After = 0x90; Purpose = 'privileged CLI instruction' },
    @{ Offset = 0x89A0; Before = 0xFB; After = 0x90; Purpose = 'privileged STI instruction' }
)

function Get-Sha256([string]$Path) {
    (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToUpperInvariant()
}

try {
    $gameRoot = [IO.Path]::GetFullPath($GameDirectory)
    $target = Join-Path $gameRoot 'ALADDINW.EXE'
    $backup = Join-Path $gameRoot 'ALADDINW.EXE.gamevault-original'
    $temporary = Join-Path $gameRoot 'ALADDINW.EXE.gamevault-new'

    if (-not (Test-Path -LiteralPath $target -PathType Leaf)) {
        throw "ALADDINW.EXE was not found in: $gameRoot"
    }
    foreach ($component in $componentHashes.GetEnumerator()) {
        $componentPath = Join-Path $gameRoot $component.Key
        if (-not (Test-Path -LiteralPath $componentPath -PathType Leaf)) {
            throw "A patch component is missing: $($component.Key)"
        }
        $actual = Get-Sha256 $componentPath
        if ($actual -ne $component.Value) {
            throw "Component $($component.Key) does not match the official version 1.1.1.`nExpected: $($component.Value)`nActual: $actual"
        }
    }

    $targetHash = Get-Sha256 $target
    if ($targetHash -eq $patchedSha256) {
        Write-Host 'The GameVaultDraw 1.1.1 patch is already installed.' -ForegroundColor Green
        Write-Host 'To play, open: Play Aladdin.exe'
        exit 0
    }
    if ($targetHash -ne $originalSha256) {
        throw "This ALADDINW.EXE edition is not supported and will not be modified.`nExpected: $originalSha256`nActual: $targetHash"
    }

    if (Test-Path -LiteralPath $backup -PathType Leaf) {
        $backupHash = Get-Sha256 $backup
        if ($backupHash -ne $originalSha256) {
            throw "An unknown backup already exists: $backup"
        }
    } else {
        [IO.File]::Copy($target, $backup, $false)
    }

    $bytes = [IO.File]::ReadAllBytes($target)
    foreach ($edit in $edits) {
        if ($bytes[$edit.Offset] -ne $edit.Before) {
            throw ('Unexpected byte at 0x{0:X}: expected 0x{1:X2}, found 0x{2:X2} ({3}).' -f $edit.Offset, $edit.Before, $bytes[$edit.Offset], $edit.Purpose)
        }
        $bytes[$edit.Offset] = [byte]$edit.After
    }

    [IO.File]::WriteAllBytes($temporary, $bytes)
    $resultHash = Get-Sha256 $temporary
    if ($resultHash -ne $patchedSha256) {
        Remove-Item -LiteralPath $temporary -Force -ErrorAction SilentlyContinue
        throw "Final verification failed. The original ALADDINW.EXE remains unchanged.`nExpected: $patchedSha256`nActual: $resultHash"
    }

    Move-Item -LiteralPath $temporary -Destination $target -Force
    Write-Host 'Patch installed and verified successfully.' -ForegroundColor Green
    Write-Host "Original preserved at: $backup"
    Write-Host 'To play, open: Play Aladdin.exe'
    exit 0
} catch {
    if ($temporary -and (Test-Path -LiteralPath $temporary)) {
        Remove-Item -LiteralPath $temporary -Force -ErrorAction SilentlyContinue
    }
    Write-Error $_.Exception.Message
    exit 1
}
