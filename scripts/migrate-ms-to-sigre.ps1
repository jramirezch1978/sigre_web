# Migra ms-almacen / ms-compras (Restaurant.pe) -> almacen-service / compras-service (SIGRE)
param(
    [ValidateSet('almacen', 'compras', 'all')]
    [string]$Module = 'all'
)

$ErrorActionPreference = 'Stop'
$Root = Split-Path $PSScriptRoot -Parent

function Migrate-Module {
    param(
        [string]$SourceName,
        [string]$TargetName,
        [string]$ModulePkg
    )

    $source = Join-Path $Root "deploy\02. Backend\$SourceName"
    $target = Join-Path $Root "03. backend\$TargetName"
    if (-not (Test-Path $source)) { throw "No existe origen: $source" }

    Write-Host "==> Migrando $SourceName -> $TargetName"

    if (Test-Path "$target\src") {
        Remove-Item -Recurse -Force "$target\src"
    }
    Copy-Item -Recurse "$source\src" "$target\src"

    foreach ($root in @('main', 'test')) {
        $oldBase = Join-Path $target "src\$root\java\pe\restaurant\$ModulePkg"
        $newBase = Join-Path $target "src\$root\java\com\sigre\$ModulePkg"
        if (Test-Path $oldBase) {
            New-Item -ItemType Directory -Force -Path (Split-Path $newBase -Parent) | Out-Null
            Move-Item -Force $oldBase $newBase
            $peDir = Join-Path $target "src\$root\java\pe"
            if (Test-Path $peDir) { Remove-Item -Recurse -Force $peDir }
        }
    }

    $replacements = @(
        @{ Old = "pe.restaurant.$ModulePkg"; New = "com.sigre.$ModulePkg" },
        @{ Old = 'pe.restaurant.common'; New = 'com.sigre.common' },
        @{ Old = 'pe/restaurant/' + $ModulePkg; New = 'com/sigre/' + $ModulePkg },
        @{ Old = 'pe/restaurant/common'; New = 'com/sigre/common' },
        @{ Old = $SourceName; New = $TargetName },
        @{ Old = 'ms-contabilidad'; New = 'contabilidad-service' },
        @{ Old = 'restaurant_pe_security'; New = 'sigre_security' },
        @{ Old = 'restaurant_admin'; New = 'postgres' },
        @{ Old = 'RestaurantePe'; New = 'SigreWeb' },
        @{ Old = 'restaurant.pe'; New = 'sigre.web' },
        @{ Old = 'Restaurant.pe'; New = 'SIGRE' },
        @{ Old = 'RESTPE'; New = 'SIGRE Backend' }
    )

    Get-ChildItem -Path $target -Recurse -File | Where-Object {
        $_.Extension -match '\.(java|yml|yaml|xml|properties|jrxml|sql|md)$'
    } | ForEach-Object {
        $content = [System.IO.File]::ReadAllText($_.FullName)
        $original = $content
        foreach ($r in $replacements) {
            $content = $content.Replace($r.Old, $r.New)
        }
        if ($content -ne $original) {
            [System.IO.File]::WriteAllText($_.FullName, $content)
        }
    }

    # Feign: almacen-service URL
    if ($ModulePkg -eq 'compras') {
        Get-ChildItem -Path $target -Recurse -Filter '*.java' | ForEach-Object {
            $c = [System.IO.File]::ReadAllText($_.FullName)
            $n = $c -replace 'name = "ms-almacen"', 'name = "almacen-service"'
            $n = $n -replace 'feign\.client\.config\.ms-almacen\.url', 'feign.client.config.almacen-service.url'
            $n = $n -replace 'http://localhost:9003', 'http://almacen-service:9003'
            if ($n -ne $c) { [System.IO.File]::WriteAllText($_.FullName, $n) }
        }
    }

    Write-Host "    OK $TargetName"
}

if ($Module -eq 'all' -or $Module -eq 'almacen') {
    Migrate-Module -SourceName 'ms-almacen' -TargetName 'almacen-service' -ModulePkg 'almacen'
}
if ($Module -eq 'all' -or $Module -eq 'compras') {
    Migrate-Module -SourceName 'ms-compras' -TargetName 'compras-service' -ModulePkg 'compras'
}

Write-Host 'Migracion completada.'
