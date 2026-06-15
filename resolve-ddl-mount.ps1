param(
    [Parameter(Mandatory = $true)]
    [string]$RepoRoot
)

$ddlRoot = Join-Path $RepoRoot "04. Base de datos\ddl"
if (-not (Test-Path -LiteralPath $ddlRoot)) {
    exit 1
}

Write-Output $ddlRoot
Write-Output $ddlRoot
