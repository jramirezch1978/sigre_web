# Migra ms-core-maestros -> core-service (SIGRE)
$ErrorActionPreference = 'Stop'
$Root = Split-Path $PSScriptRoot -Parent

$source = Join-Path $Root "deploy\02. Backend\ms-core-maestros"
$target = Join-Path $Root "03. backend\core-service"
if (-not (Test-Path $source)) { throw "No existe origen: $source" }

Write-Host "==> Migrando ms-core-maestros -> core-service"

if (Test-Path "$target\src") { Remove-Item -Recurse -Force "$target\src" }
Copy-Item -Recurse "$source\src" "$target\src"

foreach ($root in @('main', 'test')) {
    $oldBase = Join-Path $target "src\$root\java\pe\restaurant\core"
    $newBase = Join-Path $target "src\$root\java\com\sigre\core"
    if (Test-Path $oldBase) {
        New-Item -ItemType Directory -Force -Path (Split-Path $newBase -Parent) | Out-Null
        Move-Item -Force $oldBase $newBase
        $peDir = Join-Path $target "src\$root\java\pe"
        if (Test-Path $peDir) { Remove-Item -Recurse -Force $peDir }
    }
}

$replacements = @(
    @{ Old = 'pe.restaurant.core'; New = 'com.sigre.core' },
    @{ Old = 'pe.restaurant.common'; New = 'com.sigre.common' },
    @{ Old = 'pe/restaurant/core'; New = 'com/sigre/core' },
    @{ Old = 'pe/restaurant/common'; New = 'com/sigre/common' },
    @{ Old = 'ms-core-maestros'; New = 'core-service' },
    @{ Old = 'ms-almacen'; New = 'almacen-service' },
    @{ Old = 'ms-compras'; New = 'compras-service' },
    @{ Old = 'ms-contabilidad'; New = 'contabilidad-service' },
    @{ Old = 'ms-finanzas'; New = 'finanzas-service' },
    @{ Old = 'ms-rrhh'; New = 'rrhh-service' },
    @{ Old = 'ms-produccion'; New = 'produccion-service' },
    @{ Old = 'ms-ventas'; New = 'comercializacion-service' },
    @{ Old = 'ms-auth-security'; New = 'seguridad-service' },
    @{ Old = 'client.ms-core-maestros.url'; New = 'client.core-service.url' },
    @{ Old = 'client.ms-almacen.url'; New = 'client.almacen-service.url' },
    @{ Old = 'restaurant_pe_security'; New = 'sigre_security' },
    @{ Old = 'restaurant_pe_template'; New = 'sigre_template' },
    @{ Old = 'restaurant_admin'; New = 'postgres' },
    @{ Old = 'R3st4ur4nt_D3v!'; New = 'jarch32b' },
    @{ Old = 'R4bb1t_D3v!'; New = 'sigre' },
    @{ Old = 'restaurant'; New = 'sigre' },
    @{ Old = 'UmVzdGF1cmFudFBlQWVzMjU2S2V5RGV2MjAyNiEhISE='; New = 'U2lncmVFcnpXZWJBZXMyNTZLZXlEZXYyMDI2ISEhISE=' },
    @{ Old = 'dGhpcyBpcyBhIHNlY3JldCBrZXkgZm9yIHJlc3RhdXJhbnQucGUgZXJwIGp3dCB0b2tlbiBzaWduaW5n'; New = 'dGhpcyBpcyBhIHNlY3JldCBrZXkgZm9yIHNpZ3JlLXdlYiBlcnAgand0IHRva2VuIHNpZ25pbmc=' },
    @{ Old = 'RestaurantePe'; New = 'SigreWeb' },
    @{ Old = 'restaurant.pe'; New = 'sigre.web' },
    @{ Old = 'Restaurant.pe'; New = 'SIGRE' },
    @{ Old = '${DB_SSL_MODE:require}'; New = '${DB_SSL_MODE:disable}' }
)

Get-ChildItem -Path $target -Recurse -File | Where-Object {
    $_.Extension -match '\.(java|yml|yaml|xml|properties|sql|md)$'
} | ForEach-Object {
    $content = [IO.File]::ReadAllText($_.FullName)
    $original = $content
    foreach ($r in $replacements) { $content = $content.Replace($r.Old, $r.New) }
    if ($content -ne $original) { [IO.File]::WriteAllText($_.FullName, $content) }
}

$appFile = Get-ChildItem -Path $target -Recurse -Filter "CoreMaestrosApplication.java" | Select-Object -First 1
if ($appFile) {
    $appContent = [IO.File]::ReadAllText($appFile.FullName)
    $appContent = $appContent.Replace('CoreMaestrosApplication', 'CoreServiceApplication')
    $newPath = Join-Path $appFile.DirectoryName "CoreServiceApplication.java"
    [IO.File]::WriteAllText($newPath, $appContent)
    Remove-Item -Force $appFile.FullName
}

Write-Host "    OK core-service (ejecutar mvn compile y revisar pom/Dockerfile)"
