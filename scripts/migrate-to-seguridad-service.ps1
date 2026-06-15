$ErrorActionPreference = "Stop"
$backend = "e:\Work\sigre_web\03. backend"
$srcMod = Join-Path $backend "ms-auth-security"
$dstMod = Join-Path $backend "seguridad-service"

if (-not (Test-Path $srcMod)) { throw "No existe ms-auth-security" }

if (Test-Path (Join-Path $dstMod "src")) {
    Remove-Item -Recurse -Force (Join-Path $dstMod "src")
}

robocopy (Join-Path $srcMod "src") (Join-Path $dstMod "src") /E /XD target /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
if ($LASTEXITCODE -ge 8) { throw "robocopy src failed" }

$oldPkg = Join-Path $dstMod "src\main\java\com\sigre\auth"
$newPkg = Join-Path $dstMod "src\main\java\com\sigre\seguridad"
if (Test-Path $oldPkg) {
    New-Item -ItemType Directory -Force -Path (Split-Path $newPkg) | Out-Null
    Move-Item -Force $oldPkg $newPkg
    Remove-Item -Recurse -Force (Join-Path $dstMod "src\main\java\com\sigre\auth") -ErrorAction SilentlyContinue
}
$oldTest = Join-Path $dstMod "src\test\java\com\sigre\auth"
$newTest = Join-Path $dstMod "src\test\java\com\sigre\seguridad"
if (Test-Path $oldTest) {
    New-Item -ItemType Directory -Force -Path (Split-Path $newTest) | Out-Null
    Move-Item -Force $oldTest $newTest
}

$replacements = @(
    @('com.sigre.auth', 'com.sigre.seguridad'),
    @('ms-auth-security', 'seguridad-service'),
    @('AuthSecurityApplication', 'SeguridadApplication'),
    @('openapi-ms-auth-security.yaml', 'openapi-seguridad-service.yaml')
)
$exts = @('*.java', '*.xml', '*.yml', '*.yaml', '*.properties', '*.md')
Get-ChildItem -Path $dstMod -Recurse -Include $exts -File | ForEach-Object {
    $content = [IO.File]::ReadAllText($_.FullName)
    $orig = $content
    foreach ($pair in $replacements) { $content = $content.Replace($pair[0], $pair[1]) }
    if ($content -ne $orig) { [IO.File]::WriteAllText($_.FullName, $content) }
}

$openapiOld = Join-Path $dstMod "src\main\resources\static\openapi\openapi-ms-auth-security.yaml"
$openapiNew = Join-Path $dstMod "src\main\resources\static\openapi\openapi-seguridad-service.yaml"
if (Test-Path $openapiOld) { Move-Item -Force $openapiOld $openapiNew }

Write-Host "OK: codigo migrado a seguridad-service"
