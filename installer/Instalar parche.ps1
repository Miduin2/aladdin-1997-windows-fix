[CmdletBinding()]
param(
    [Parameter()]
    [string]$GameDirectory = $PSScriptRoot
)

$ErrorActionPreference = 'Stop'
$originalSha256 = '77B7B7B03F80BAD087E23217D4CDCA51A5F93C550D0FF290B22EC7FB4694C209'
$patchedSha256 = '8CE7F608D1BFEF1F67B5495D33653ED602B1CA05BBFC521255D9D6DF48FB4740'
$componentHashes = @{
    'ddraw.dll' = '778294553D7F39D49204330303E474377254FED5C67BA7511037948DD62FF443'
    'GameVaultDraw.ini' = '57E0DF9C9C29CC8B147D400C917171ABACB6AC21DB5B01B758DCA07396E58167'
    'Jugar Aladdin.exe' = 'A358C5731A67524C28787BF866E20183ECE36B5171364471DFF0D4A25F97019D'
}
$edits = @(
    @{ Offset = 0x2E0B; Before = 0x73; After = 0xEB; Purpose = 'comprobacion de profundidad de color' },
    @{ Offset = 0x8992; Before = 0xFA; After = 0x90; Purpose = 'instruccion CLI privilegiada' },
    @{ Offset = 0x89A0; Before = 0xFB; After = 0x90; Purpose = 'instruccion STI privilegiada' }
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
        throw "No se encontro ALADDINW.EXE en: $gameRoot"
    }
    foreach ($component in $componentHashes.GetEnumerator()) {
        $componentPath = Join-Path $gameRoot $component.Key
        if (-not (Test-Path -LiteralPath $componentPath -PathType Leaf)) {
            throw "Falta el componente del parche: $($component.Key)"
        }
        $actual = Get-Sha256 $componentPath
        if ($actual -ne $component.Value) {
            throw "El componente $($component.Key) no coincide con la version 1.1.0 oficial.`nEsperado: $($component.Value)`nObtenido: $actual"
        }
    }

    $targetHash = Get-Sha256 $target
    if ($targetHash -eq $patchedSha256) {
        Write-Host 'El ejecutable ya tiene aplicado el parche GameVaultDraw 1.1.0.' -ForegroundColor Green
        Write-Host 'Para jugar, abre: Jugar Aladdin.exe'
        exit 0
    }
    if ($targetHash -ne $originalSha256) {
        throw "Esta edicion de ALADDINW.EXE no esta soportada y no se modificara.`nEsperado: $originalSha256`nObtenido: $targetHash"
    }

    if (Test-Path -LiteralPath $backup -PathType Leaf) {
        $backupHash = Get-Sha256 $backup
        if ($backupHash -ne $originalSha256) {
            throw "Ya existe una copia de seguridad desconocida: $backup"
        }
    } else {
        [IO.File]::Copy($target, $backup, $false)
    }

    $bytes = [IO.File]::ReadAllBytes($target)
    foreach ($edit in $edits) {
        if ($bytes[$edit.Offset] -ne $edit.Before) {
            throw ('Byte inesperado en 0x{0:X}: se esperaba 0x{1:X2} y se encontro 0x{2:X2} ({3}).' -f $edit.Offset, $edit.Before, $bytes[$edit.Offset], $edit.Purpose)
        }
        $bytes[$edit.Offset] = [byte]$edit.After
    }

    [IO.File]::WriteAllBytes($temporary, $bytes)
    $resultHash = Get-Sha256 $temporary
    if ($resultHash -ne $patchedSha256) {
        Remove-Item -LiteralPath $temporary -Force -ErrorAction SilentlyContinue
        throw "La verificacion final fallo. ALADDINW.EXE original se conserva intacto.`nEsperado: $patchedSha256`nObtenido: $resultHash"
    }

    Move-Item -LiteralPath $temporary -Destination $target -Force
    Write-Host 'Parche instalado y verificado correctamente.' -ForegroundColor Green
    Write-Host "Original conservado en: $backup"
    Write-Host 'Para jugar, abre: Jugar Aladdin.exe'
    exit 0
} catch {
    if ($temporary -and (Test-Path -LiteralPath $temporary)) {
        Remove-Item -LiteralPath $temporary -Force -ErrorAction SilentlyContinue
    }
    Write-Error $_.Exception.Message
    exit 1
}
