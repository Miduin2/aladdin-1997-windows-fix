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
        throw "The backup created by GameVaultDraw does not exist: $backup"
    }
    $backupHash = (Get-FileHash -LiteralPath $backup -Algorithm SHA256).Hash.ToUpperInvariant()
    if ($backupHash -ne $originalSha256) {
        throw "The backup does not match the supported original and will not be used."
    }
    if (Test-Path -LiteralPath $target -PathType Leaf) {
        $targetHash = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash.ToUpperInvariant()
        if ($targetHash -ne $patchedSha256 -and $targetHash -ne $originalSha256) {
            throw "ALADDINW.EXE has changed since installation and will not be overwritten."
        }
    }
    [IO.File]::Copy($backup, $target, $true)
    if ((Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash.ToUpperInvariant() -ne $originalSha256) {
        throw 'The restored executable could not be verified.'
    }
    Write-Host 'The original ALADDINW.EXE was restored successfully.' -ForegroundColor Green
    Write-Host 'GameVaultDraw files were preserved to avoid deleting data without permission.'
    exit 0
} catch {
    Write-Error $_.Exception.Message
    exit 1
}
