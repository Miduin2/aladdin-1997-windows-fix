[CmdletBinding()]
param(
    [Parameter()]
    [string]$GameDirectory = $PSScriptRoot
)

$ErrorActionPreference = 'Stop'
$originalSha256 = '77B7B7B03F80BAD087E23217D4CDCA51A5F93C550D0FF290B22EC7FB4694C209'
$patchedSha256 = '8CE7F608D1BFEF1F67B5495D33653ED602B1CA05BBFC521255D9D6DF48FB4740'

try {
    $gameRoot = [IO.Path]::GetFullPath($GameDirectory)
    $target = Join-Path $gameRoot 'ALADDINW.EXE'
    $backup = Join-Path $gameRoot 'ALADDINW.EXE.gamevault-original'
    if (-not (Test-Path -LiteralPath $backup -PathType Leaf)) {
        throw "No existe la copia de seguridad creada por GameVaultDraw: $backup"
    }
    $backupHash = (Get-FileHash -LiteralPath $backup -Algorithm SHA256).Hash.ToUpperInvariant()
    if ($backupHash -ne $originalSha256) {
        throw "La copia de seguridad no coincide con el original soportado y no se usara."
    }
    if (Test-Path -LiteralPath $target -PathType Leaf) {
        $targetHash = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash.ToUpperInvariant()
        if ($targetHash -ne $patchedSha256 -and $targetHash -ne $originalSha256) {
            throw "ALADDINW.EXE ha cambiado desde la instalacion; no se sobrescribira."
        }
    }
    [IO.File]::Copy($backup, $target, $true)
    if ((Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash.ToUpperInvariant() -ne $originalSha256) {
        throw 'No se pudo verificar el ejecutable restaurado.'
    }
    Write-Host 'ALADDINW.EXE original restaurado correctamente.' -ForegroundColor Green
    Write-Host 'Los archivos de GameVaultDraw se han conservado para no borrar datos sin permiso.'
    exit 0
} catch {
    Write-Error $_.Exception.Message
    exit 1
}
