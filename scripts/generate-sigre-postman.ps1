$ErrorActionPreference = "Stop"
$src = "e:\Work\sigre_web\01. documentacion\Restaurante.pe V2.0.postman_collection.json"
$dst = "e:\Work\sigre_web\01. documentacion\SIGRE Web ERP.postman_collection.json"

$raw = [IO.File]::ReadAllText($src)
$replacements = @(
    @('Restaurante.pe V2.0', 'SIGRE Web ERP'),
    @('restaurant_pe_emp_', 'sigre_emp_'),
    @('restaurant_pe_security', 'sigre_security'),
    @('restaurant_pe_template', 'sigre_template'),
    @('{{base_url_docker}}', '{{base_url}}')
)
foreach ($pair in $replacements) {
    $raw = $raw.Replace($pair[0], $pair[1])
}

$collection = $raw | ConvertFrom-Json
$collection.info | Add-Member -NotePropertyName description -NotePropertyValue 'Coleccion SIGRE Web. Gateway puerto 9080 en cronos. Incluye seguridad-service y servicios en migracion.' -Force

$collection.variable = @(
    @{ key = 'base_url'; value = 'http://crisaor.serveftp.com:9080'; type = 'string' },
    @{ key = 'base_url_local'; value = 'http://localhost:9080'; type = 'string' },
    @{ key = 'provision_secret'; value = 'dev-provision-cambiar-produccion'; type = 'string' },
    @{ key = 'jwt_token'; value = ''; type = 'string' },
    @{ key = 'jwt_definitive_token'; value = ''; type = 'string' },
    @{ key = 'empresa_id'; value = '2'; type = 'string' },
    @{ key = 'usuario_id'; value = '3'; type = 'string' }
)

function New-Request {
    param(
        [string]$Name,
        [string]$Method,
        [string]$Path,
        [string]$Body = $null,
        [switch]$UseBearer
    )
    $urlPath = $Path.TrimStart('/') -split '/'
    $req = [ordered]@{
        name    = $Name
        request = [ordered]@{
            method = $Method
            header = @()
            url    = [ordered]@{
                raw  = "{{base_url}}/$Path"
                host = @('{{base_url}}')
                path = $urlPath
            }
        }
        response = @()
    }
    if ($UseBearer) {
        $req.request.auth = [ordered]@{
            type   = 'bearer'
            bearer = @([ordered]@{ key = 'token'; value = '{{jwt_definitive_token}}'; type = 'string' })
        }
    }
    if ($Body) {
        $req.request.header += [ordered]@{ key = 'Content-Type'; value = 'application/json'; type = 'text' }
        $req.request.body = [ordered]@{
            mode    = 'raw'
            raw     = $Body
            options = [ordered]@{ raw = [ordered]@{ language = 'json' } }
        }
    }
    return [pscustomobject]$req
}

function New-Folder {
    param([string]$Name, [array]$Items)
    return [pscustomobject]@{ name = $Name; item = $Items }
}

$loginTestScript = @(
    'if (pm.response.code === 200) {'
    '  var json = pm.response.json();'
    '  var data = json.data || json;'
    '  if (data.accessToken) pm.collectionVariables.set("jwt_token", data.accessToken);'
    '  if (data.token) pm.collectionVariables.set("jwt_token", data.token);'
    '  if (data.definitiveToken) pm.collectionVariables.set("jwt_definitive_token", data.definitiveToken);'
    '}'
)

$selectEmpresaScript = @(
    'if (pm.response.code === 200) {'
    '  var json = pm.response.json();'
    '  var data = json.data || json;'
    '  if (data.definitiveToken) pm.collectionVariables.set("jwt_definitive_token", data.definitiveToken);'
    '  if (data.accessToken) pm.collectionVariables.set("jwt_token", data.accessToken);'
    '}'
)

foreach ($item in $collection.item) {
    if ($item.name -eq 'seguridad-service') { $item.name = '01 - seguridad-service' }
    if ($item.name -eq 'ms-core-maestros') { $item.name = '99 - ms-core-maestros (migracion pendiente)' }
    if ($item.name -like '*seguridad-service*') {
        foreach ($req in $item.item) {
            if ($req.name -eq 'Login') {
                $req | Add-Member -NotePropertyName event -NotePropertyValue @(
                    [pscustomobject]@{
                        listen = 'test'
                        script = [pscustomobject]@{ type = 'text/javascript'; exec = $loginTestScript }
                    }
                ) -Force
            }
            if ($req.name -eq 'seleccionar-empresa') {
                $req | Add-Member -NotePropertyName event -NotePropertyValue @(
                    [pscustomobject]@{
                        listen = 'test'
                        script = [pscustomobject]@{ type = 'text/javascript'; exec = $selectEmpresaScript }
                    }
                ) -Force
            }
        }
    }
}

$infra = New-Folder '00 - Infraestructura' @(
    (New-Request 'api-gateway - health' 'GET' 'actuator/health')
)

$asistencia = New-Folder '02 - asistencia-service' @(
    (New-Request 'time - current' 'GET' 'api/asistencia/api/time/current' -UseBearer)
    (New-Request 'time - health' 'GET' 'api/asistencia/api/time/health')
    (New-Request 'asistencia - health' 'GET' 'api/asistencia/api/asistencia/health')
    (New-Request 'dashboard - health' 'GET' 'api/asistencia/api/dashboard/health' -UseBearer)
    (New-Request 'trabajadores - buscar' 'GET' 'api/asistencia/api/trabajadores/buscar/22300596' -UseBearer)
    (New-Request 'marcacion - procesar' 'POST' 'api/asistencia/procesar' -Body '{"codTrabajador":"22300596","tipoMarcacion":"E"}' -UseBearer)
)

$sync = New-Folder '03 - sync-service (migracion)' @(
    (New-Request 'health placeholder' 'GET' 'actuator/health')
)

$legacyCommerce = New-Folder '04 - inventory | orders | products' @(
    (New-Request 'inventory - health placeholder' 'GET' 'api/inventory/actuator/health')
    (New-Request 'orders - health placeholder' 'GET' 'api/order/actuator/health')
    (New-Request 'products - health placeholder' 'GET' 'api/product/actuator/health')
)

$migrationMap = @(
    @('10 - almacen-service', 'api/almacen/actuator/health')
    @('11 - compras-service', 'api/compras/actuator/health')
    @('12 - finanzas-service', 'api/finanzas/actuator/health')
    @('13 - contabilidad-service', 'api/contabilidad/actuator/health')
    @('14 - rrhh-service', 'api/rrhh/actuator/health')
    @('15 - activo-fijo-service', 'api/activos/actuator/health')
    @('16 - produccion-service', 'api/produccion/actuator/health')
    @('17 - comercializacion-service', 'api/ventas/actuator/health')
    @('18 - auditoria-service', 'api/auditoria/actuator/health')
    @('19 - sig-service reportes', 'api/reportes/actuator/health')
    @('20 - aprovision-service notif', 'api/notificaciones/actuator/health')
    @('21 - campo-service', 'api/campo/actuator/health')
    @('22 - comedor-service', 'api/comedor/actuator/health')
    @('23 - flota-service', 'api/flota/actuator/health')
    @('24 - mantenimiento-service', 'api/mantenimiento/actuator/health')
    @('25 - operaciones-service', 'api/operaciones/actuator/health')
    @('26 - presupuesto-service', 'api/presupuesto/actuator/health')
)

$migrationFolders = foreach ($m in $migrationMap) {
    New-Folder $m[0] @( (New-Request 'health placeholder gateway' 'GET' $m[1] -UseBearer) )
}

$collection.item = @($infra, $asistencia, $sync, $legacyCommerce) + $migrationFolders + @($collection.item)

$json = $collection | ConvertTo-Json -Depth 30
[IO.File]::WriteAllText($dst, $json)
Write-Host "OK: $dst"
