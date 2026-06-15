# Migra microservicios Restaurant.pe -> SIGRE Web
param(
    [ValidateSet('almacen', 'compras', 'contabilidad', 'finanzas', 'produccion', 'rrhh', 'ventas', 'all')]
    [string]$Module = 'all'
)

$ErrorActionPreference = 'Stop'
$Root = Split-Path $PSScriptRoot -Parent

$modules = @(
    @{ Key = 'almacen';     Source = 'ms-almacen';     Target = 'almacen-service';          Pkg = 'almacen';         AppClass = 'AlmacenApplication' }
    @{ Key = 'compras';     Source = 'ms-compras';     Target = 'compras-service';          Pkg = 'compras';         AppClass = 'ComprasApplication' }
    @{ Key = 'contabilidad'; Source = 'ms-contabilidad'; Target = 'contabilidad-service';   Pkg = 'contabilidad';    AppClass = 'ContabilidadApplication' }
    @{ Key = 'finanzas';    Source = 'ms-finanzas';    Target = 'finanzas-service';         Pkg = 'finanzas';        AppClass = 'FinanzasApplication' }
    @{ Key = 'produccion';  Source = 'ms-produccion';  Target = 'produccion-service';       Pkg = 'produccion';      AppClass = 'ProduccionApplication' }
    @{ Key = 'rrhh';        Source = 'ms-rrhh';        Target = 'rrhh-service';             Pkg = 'rrhh';            AppClass = 'RrhhApplication' }
    @{ Key = 'ventas';      Source = 'ms-ventas';      Target = 'comercializacion-service'; Pkg = 'comercializacion'; SourcePkg = 'ventas'; AppClass = 'ComercializacionApplication'; SourceAppClass = 'VentasApplication' }
)

function Apply-FeignReplacements {
    param([string]$TargetDir)
    Get-ChildItem -Path $TargetDir -Recurse -File | Where-Object {
        $_.Extension -match '\.(java|yml|yaml|properties)$'
    } | ForEach-Object {
        $c = [IO.File]::ReadAllText($_.FullName)
        $n = $c
        $pairs = @(
            @('name = "ms-almacen"', 'name = "almacen-service"'),
            @('name = "ms-almacen-costeo"', 'name = "almacen-service"'),
            @('name = "ms-compras"', 'name = "compras-service"'),
            @('name = "ms-contabilidad"', 'name = "contabilidad-service"'),
            @('name = "ms-finanzas"', 'name = "finanzas-service"'),
            @('name = "ms-rrhh"', 'name = "rrhh-service"'),
            @('name = "ms-produccion"', 'name = "produccion-service"'),
            @('name = "ms-ventas"', 'name = "comercializacion-service"'),
            @('name = "ms-auth-security"', 'name = "seguridad-service"'),
            @('client.ms-almacen.url', 'client.almacen-service.url'),
            @('client.ms-contabilidad.url', 'client.contabilidad-service.url'),
            @('client.ms-finanzas.url', 'client.finanzas-service.url'),
            @('feign.client.config.ms-finanzas.url', 'feign.client.config.finanzas-service.url'),
            @('feign.client.config.ms-contabilidad.url', 'feign.client.config.contabilidad-service.url'),
            @('http://ms-almacen:9003', 'http://almacen-service:9003'),
            @('http://ms-contabilidad:9006', 'http://contabilidad-service:9006'),
            @('http://ms-finanzas:9005', 'http://finanzas-service:9005'),
            @('http://ms-produccion:9009', 'http://produccion-service:9009'),
            @('http://ms-ventas:9010', 'http://comercializacion-service:9010'),
            @('http://localhost:9003', 'http://almacen-service:9003'),
            @('http://localhost:9005', 'http://finanzas-service:9005'),
            @('http://localhost:9006', 'http://contabilidad-service:9006')
        )
        foreach ($p in $pairs) { $n = $n.Replace($p[0], $p[1]) }
        if ($n -ne $c) { [IO.File]::WriteAllText($_.FullName, $n) }
    }
}

function Migrate-Module {
    param($Cfg)

    $sourceName = $Cfg.Source
    $targetName = $Cfg.Target
    $modulePkg = if ($Cfg.SourcePkg) { $Cfg.SourcePkg } else { $Cfg.Pkg }

    $source = Join-Path $Root "deploy\02. Backend\$sourceName"
    $target = Join-Path $Root "03. backend\$targetName"
    if (-not (Test-Path $source)) { throw "No existe origen: $source" }

    Write-Host "==> Migrando $sourceName -> $targetName"

    if (Test-Path "$target\src") {
        Remove-Item -Recurse -Force "$target\src"
    }
    Copy-Item -Recurse "$source\src" "$target\src"

    foreach ($root in @('main', 'test')) {
        $oldBase = Join-Path $target "src\$root\java\pe\restaurant\$modulePkg"
        $newBase = Join-Path $target "src\$root\java\com\sigre\$($Cfg.Pkg)"
        if (Test-Path $oldBase) {
            New-Item -ItemType Directory -Force -Path (Split-Path $newBase -Parent) | Out-Null
            Move-Item -Force $oldBase $newBase
            $peDir = Join-Path $target "src\$root\java\pe"
            if (Test-Path $peDir) { Remove-Item -Recurse -Force $peDir }
        }
    }

    $replacements = @(
        @{ Old = "pe.restaurant.$modulePkg"; New = "com.sigre.$($Cfg.Pkg)" },
        @{ Old = 'pe.restaurant.common'; New = 'com.sigre.common' },
        @{ Old = 'pe/restaurant/' + $modulePkg; New = 'com/sigre/' + $Cfg.Pkg },
        @{ Old = 'pe/restaurant/common'; New = 'com/sigre/common' },
        @{ Old = $sourceName; New = $targetName },
        @{ Old = 'ms-almacen'; New = 'almacen-service' },
        @{ Old = 'ms-compras'; New = 'compras-service' },
        @{ Old = 'ms-contabilidad'; New = 'contabilidad-service' },
        @{ Old = 'ms-finanzas'; New = 'finanzas-service' },
        @{ Old = 'ms-rrhh'; New = 'rrhh-service' },
        @{ Old = 'ms-produccion'; New = 'produccion-service' },
        @{ Old = 'ms-ventas'; New = 'comercializacion-service' },
        @{ Old = 'ms-auth-security'; New = 'seguridad-service' },
        @{ Old = 'restaurant_pe_security'; New = 'sigre_security' },
        @{ Old = 'restaurant_pe_template'; New = 'sigre_template' },
        @{ Old = 'restaurant_admin'; New = 'postgres' },
        @{ Old = 'R3st4ur4nt_D3v!'; New = 'jarch32b' },
        @{ Old = 'R4bb1t_D3v!'; New = 'sigre' },
        @{ Old = 'restaurant'; New = 'sigre' },
        @{ Old = 'UmVzdGF1cmFudFBlQWVzMjU2S2V5RGV2MjAyNiEhISE='; New = 'U2lncmVFcnBXZWJBZXMyNTZLZXlEZXYyMDI2ISEhISE=' },
        @{ Old = 'dGhpcyBpcyBhIHNlY3JldCBrZXkgZm9yIHJlc3RhdXJhbnQucGUgZXJwIGp3dCB0b2tlbiBzaWduaW5n'; New = 'dGhpcyBpcyBhIHNlY3JldCBrZXkgZm9yIHNpZ3JlLXdlYiBlcnAgand0IHRva2VuIHNpZ25pbmc=' },
        @{ Old = 'RestaurantePe'; New = 'SigreWeb' },
        @{ Old = 'restaurant.pe'; New = 'sigre.web' },
        @{ Old = 'Restaurant.pe'; New = 'SIGRE' },
        @{ Old = 'RESTPE'; New = 'SIGRE Backend' },
        @{ Old = '${DB_SSL_MODE:require}'; New = '${DB_SSL_MODE:disable}' },
        @{ Old = 'http://localhost:8080'; New = 'http://api-gateway:9080' }
    )

    Get-ChildItem -Path $target -Recurse -File | Where-Object {
        $_.Extension -match '\.(java|yml|yaml|xml|properties|jrxml|sql|md)$'
    } | ForEach-Object {
        $content = [IO.File]::ReadAllText($_.FullName)
        $original = $content
        foreach ($r in $replacements) {
            $content = $content.Replace($r.Old, $r.New)
        }
        if ($content -ne $original) {
            [IO.File]::WriteAllText($_.FullName, $content)
        }
    }

    Apply-FeignReplacements $target

    if ($Cfg.SourceAppClass) {
        $appFile = Get-ChildItem -Path $target -Recurse -Filter "$($Cfg.SourceAppClass).java" | Select-Object -First 1
        if ($appFile) {
            $appContent = [IO.File]::ReadAllText($appFile.FullName)
            $appContent = $appContent.Replace($Cfg.SourceAppClass, $Cfg.AppClass)
            $newPath = Join-Path $appFile.DirectoryName "$($Cfg.AppClass).java"
            [IO.File]::WriteAllText($newPath, $appContent)
            if ($appFile.FullName -ne $newPath) { Remove-Item -Force $appFile.FullName }
        }
    }

    Write-Host "    OK $targetName"
}

foreach ($m in $modules) {
    if ($Module -eq 'all' -or $Module -eq $m.Key) {
        Migrate-Module $m
    }
}

Write-Host 'Migracion completada.'
