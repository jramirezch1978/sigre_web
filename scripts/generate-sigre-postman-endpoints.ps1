$ErrorActionPreference = "Stop"
$root = "e:\Work\sigre_web"
$backend = Join-Path $root "03. backend"
$dst = Join-Path $root "01. documentacion\SIGRE Web ERP.postman_collection.json"

function Get-MappingPath {
    param([string]$AnnotationLine)
    if ($AnnotationLine -match '@(?:Get|Post|Put|Patch|Delete)Mapping\s*\(\s*\)') { return '' }
    if ($AnnotationLine -match '@(?:Get|Post|Put|Patch|Delete)Mapping\s*\(\s*value\s*=\s*"([^"]+)"') { return $matches[1] }
    if ($AnnotationLine -match '@(?:Get|Post|Put|Patch|Delete)Mapping\s*\(\s*"([^"]+)"') { return $matches[1] }
    if ($AnnotationLine -match '@RequestMapping\s*\(\s*value\s*=\s*"([^"]+)"') { return $matches[1] }
    if ($AnnotationLine -match '@RequestMapping\s*\(\s*"([^"]+)"') { return $matches[1] }
    return $null
}

function Get-HttpMethod {
    param([string]$AnnotationLine)
    if ($AnnotationLine -match '@GetMapping') { return 'GET' }
    if ($AnnotationLine -match '@PostMapping') { return 'POST' }
    if ($AnnotationLine -match '@PutMapping') { return 'PUT' }
    if ($AnnotationLine -match '@PatchMapping') { return 'PATCH' }
    if ($AnnotationLine -match '@DeleteMapping') { return 'DELETE' }
    if ($AnnotationLine -match '@RequestMapping') { return 'REQUEST' }
    return $null
}

function Join-UrlPath {
    param([string]$Base, [string]$Sub)
    $b = ($Base -replace '/+$', '')
    if ([string]::IsNullOrWhiteSpace($Sub)) { return $b }
    if ($Sub.StartsWith('/')) { return "$b$Sub" }
    return "$b/$Sub"
}

function Normalize-GatewayPath {
    param([string]$ServiceKey, [string]$ServicePath)
    switch ($ServiceKey) {
        'asistencia-service' {
            $p = $ServicePath.TrimStart('/')
            return "/api/asistencia/$p"
        }
        default { return $ServicePath }
    }
}

function Test-PublicEndpoint {
    param([string]$Path, [string]$Method)
    if ($Path -match '/health$' -or $Path -match '/actuator/health') { return $true }
    if ($Path -eq '/api/auth/login') { return $true }
    if ($Path -like '/api/auth/recuperar/*') { return $true }
    if ($Path -eq '/api/admin/empresas/provision') { return $true }
    if ($Path -eq '/api/admin/empresas/deprovision') { return $true }
    return $false
}

function Test-ProvisionEndpoint {
    param([string]$Path)
    return $Path -like '/api/admin/empresas/*'
}

function New-PostmanRequest {
    param(
        [string]$Name,
        [string]$Method,
        [string]$GatewayPath,
        [string]$Body = $null,
        [switch]$UseBearer,
        [switch]$UseProvisionSecret,
        [switch]$IsMultipart
    )
    $clean = $GatewayPath.TrimStart('/')
    $urlPath = $clean -split '/'
    $req = [ordered]@{
        name    = $Name
        request = [ordered]@{
            method = $Method
            header = @()
            url    = [ordered]@{
                raw  = "{{base_url}}/$clean"
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
    if ($UseProvisionSecret) {
        $req.request.header += [ordered]@{ key = 'X-Provision-Secret'; value = '{{provision_secret}}'; type = 'text' }
    }
    if ($IsMultipart) {
        $req.request.body = [ordered]@{
            mode = 'formdata'
            formdata = @(
                [ordered]@{ key = 'file'; type = 'file'; src = '' }
            )
        }
    }
    elseif ($Method -in @('POST', 'PUT', 'PATCH')) {
        if ($IsMultipart) {
            # body ya definido arriba
        }
        else {
            $req.request.header += [ordered]@{ key = 'Content-Type'; value = 'application/json'; type = 'text' }
            $payload = if ($null -ne $Body) { $Body } else { '{}' }
            $req.request.body = [ordered]@{
                mode    = 'raw'
                raw     = $payload
                options = [ordered]@{ raw = [ordered]@{ language = 'json' } }
            }
        }
    }
    return [pscustomobject]$req
}

function Parse-ControllerFile {
    param([string]$FilePath, [string]$ServiceKey)
    $content = Get-Content $FilePath -Raw
    $className = [IO.Path]::GetFileNameWithoutExtension($FilePath) -replace 'Controller$', ''
    $classMapping = ''
    if ($content -match '@RequestMapping\s*\(\s*value\s*=\s*"([^"]+)"') { $classMapping = $matches[1] }
    elseif ($content -match '@RequestMapping\s*\(\s*"([^"]+)"') { $classMapping = $matches[1] }

    $endpoints = @()
    $lines = Get-Content $FilePath
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i].Trim()
        if ($line -notmatch '@(?:Get|Post|Put|Patch|Delete|Request)Mapping') { continue }
        $method = Get-HttpMethod $line
        if (-not $method -or $method -eq 'REQUEST') { continue }
        $subPath = Get-MappingPath $line
        if ($null -eq $subPath) { continue }
        $servicePath = Join-UrlPath $classMapping $subPath
        $gatewayPath = Normalize-GatewayPath $ServiceKey $servicePath
        $isMultipart = $line -match 'MULTIPART_FORM_DATA'
        $displayName = if ([string]::IsNullOrWhiteSpace($subPath)) {
            "$method $classMapping".Trim()
        } else {
            "$method $subPath"
        }
        $endpoints += [pscustomobject]@{
            Controller  = $className
            Name        = $displayName
            Method      = $method
            ServicePath = $servicePath
            GatewayPath = $gatewayPath
            IsMultipart = [bool]$isMultipart
        }
    }
    return $endpoints
}

$serviceConfig = [ordered]@{
    'seguridad-service'  = @{ folder = '01 - seguridad-service';  pattern = 'seguridad-service\src\main\java\*\controller\*.java' }
    'asistencia-service' = @{ folder = '02 - asistencia-service'; pattern = 'asistencia-service\src\main\java\*\controller\*.java' }
    'almacen-service'    = @{ folder = '10 - almacen-service';    pattern = 'almacen-service\src\main\java\*\controller\*.java' }
    'compras-service'    = @{ folder = '11 - compras-service';    pattern = 'compras-service\src\main\java\*\controller\*.java' }
    'contabilidad-service' = @{ folder = '12 - contabilidad-service'; pattern = 'contabilidad-service\src\main\java\*\controller\*.java' }
    'finanzas-service'   = @{ folder = '13 - finanzas-service';   pattern = 'finanzas-service\src\main\java\*\controller\*.java' }
    'rrhh-service'       = @{ folder = '14 - rrhh-service';       pattern = 'rrhh-service\src\main\java\*\controller\*.java' }
    'produccion-service' = @{ folder = '16 - produccion-service'; pattern = 'produccion-service\src\main\java\*\controller\*.java' }
    'comercializacion-service' = @{ folder = '17 - comercializacion-service (api/ventas)'; pattern = 'comercializacion-service\src\main\java\*\controller\*.java' }
    'sync-service'       = @{ folder = '03 - sync-service';       pattern = 'sync-service\src\main\java\*\controller\*.java' }
    'inventory-service'  = @{ folder = '04 - inventory-service';  pattern = 'inventory-service\src\main\java\*\controllers\*.java' }
    'orders-service'     = @{ folder = '05 - orders-service';     pattern = 'orders-service\src\main\java\*\controllers\*.java' }
    'products-service'   = @{ folder = '06 - products-service';   pattern = 'products-service\src\main\java\*\controllers\*.java' }
}

$sampleBodies = @{
    '/api/auth/login' = @'
{
  "username": "jramirez",
  "password": "tu-password"
}
'@
    '/api/auth/seleccionar-empresa' = @'
{
  "empresaId": {{empresa_id}}
}
'@
    '/api/auth/refresh' = @'
{
  "refreshToken": "{{jwt_token}}"
}
'@
    '/api/auth/recuperar/enviar-codigo' = @'
{
  "email": "usuario@empresa.com"
}
'@
    '/api/admin/empresas/provision' = @'
{
  "COD_EMPRESA": "E0000001",
  "NOMBRE": "EMPRESA DEMO S.A.C.",
  "NOMBRE_COMERCIAL": "DEMO",
  "SIGLA": "DEMO",
  "RUC": "20123456789",
  "PERSONERIA": "J",
  "DIR_CALLE": "AV. PRINCIPAL 123",
  "DIR_DISTRITO": "LIMA",
  "FLAG_REPLICACION": "1",
  "FLAG_CNTRL_CD": "0",
  "DIRECCION": "AV. PRINCIPAL 123",
  "DIR_PROVINCIA": "LIMA",
  "DIR_DEPARTAMENTO": "LIMA",
  "DIR_PAIS": "PERU",
  "DIR_UBIGEO": "150101",
  "CIU_COD_PAIS": "PE",
  "CORREO_CONTACTO": "contacto@demo.com",
  "CELULAR": "999999999",
  "REPRES_LEGAL": "REPRESENTANTE LEGAL"
}
'@
    '/api/admin/empresas/deprovision' = @'
{
  "dbName": "sigre_emp_demo"
}
'@
    '/api/admin/empresas/recreate' = @'
{
  "dbName": "sigre_emp_demo"
}
'@
    '/api/asistencia/procesar' = @'
{
  "codTrabajador": "22300596",
  "tipoMarcacion": "E"
}
'@
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

$folders = @()

$infraItems = @(
    (New-PostmanRequest 'GET actuator/health' 'GET' '/actuator/health')
    (New-PostmanRequest 'GET discovery eureka' 'GET' '/eureka/apps')
)
$folders += [pscustomobject]@{ name = '00 - Infraestructura'; item = $infraItems }

foreach ($svcKey in $serviceConfig.Keys) {
    $cfg = $serviceConfig[$svcKey]
    $files = Get-ChildItem -Path (Join-Path $backend $cfg.pattern.Split('\')[0]) -Recurse -Filter '*Controller.java' |
        Where-Object { $_.FullName -match '\\controller\\' -or $_.FullName -match '\\controllers\\' }

    $byController = @{}
    foreach ($file in $files) {
        foreach ($ep in (Parse-ControllerFile $file.FullName $svcKey)) {
            if (-not $byController.ContainsKey($ep.Controller)) {
                $byController[$ep.Controller] = @()
            }
            $byController[$ep.Controller] += $ep
        }
    }

    $controllerFolders = @()
    foreach ($ctrl in ($byController.Keys | Sort-Object)) {
        $requests = @()
        foreach ($ep in ($byController[$ctrl] | Sort-Object GatewayPath, Method)) {
            $path = $ep.GatewayPath
            $body = $sampleBodies[$path]
            $useBearer = -not (Test-PublicEndpoint $path $ep.Method)
            $useProvision = Test-ProvisionEndpoint $path
            $req = New-PostmanRequest -Name $ep.Name -Method $ep.Method -GatewayPath $path -Body $body -UseBearer:$useBearer -UseProvisionSecret:$useProvision -IsMultipart:$ep.IsMultipart

            if ($svcKey -eq 'seguridad-service') {
                if ($path -eq '/api/auth/login') {
                    $req | Add-Member -NotePropertyName event -NotePropertyValue @(
                        [pscustomobject]@{ listen = 'test'; script = [pscustomobject]@{ type = 'text/javascript'; exec = $loginTestScript } }
                    ) -Force
                }
                if ($path -eq '/api/auth/seleccionar-empresa') {
                    $req | Add-Member -NotePropertyName event -NotePropertyValue @(
                        [pscustomobject]@{ listen = 'test'; script = [pscustomobject]@{ type = 'text/javascript'; exec = $selectEmpresaScript } }
                    ) -Force
                }
            }
            $requests += $req
        }
        $controllerFolders += [pscustomobject]@{ name = $ctrl; item = $requests }
    }

    if ($svcKey -in @('almacen-service', 'compras-service')) {
        $healthPath = if ($svcKey -eq 'almacen-service') { '/api/almacen/actuator/health' } else { '/api/compras/actuator/health' }
        $controllerFolders = @(
            [pscustomobject]@{
                name = 'Actuator'
                item = @((New-PostmanRequest 'GET actuator/health' 'GET' $healthPath -UseBearer))
            }
        ) + $controllerFolders
    }

    $folders += [pscustomobject]@{ name = $cfg.folder; item = $controllerFolders }
}

$migrationMap = @(
    @('15 - activo-fijo-service', 'api/activos/actuator/health')
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
foreach ($m in $migrationMap) {
    $folders += [pscustomobject]@{
        name = $m[0]
        item = @((New-PostmanRequest 'health placeholder gateway' 'GET' "/$($m[1])" -UseBearer))
    }
}

$collection = [ordered]@{
    info = [ordered]@{
        _postman_id = '37d2a66e-f05d-4247-8009-92ca80e633c5'
        name        = 'SIGRE Web ERP'
        schema      = 'https://schema.getpostman.com/json/collection/v2.1.0/collection.json'
        _exporter_id = '4961867'
        description = 'Coleccion SIGRE Web generada desde controllers Java. Gateway puerto 9080 en cronos. Incluye seguridad-service, almacen-service, compras-service y demas servicios backend.'
    }
    item = $folders
    event = @(
        [pscustomobject]@{
            listen = 'prerequest'
            script = [pscustomobject]@{ type = 'text/javascript'; exec = @('') }
        },
        [pscustomobject]@{
            listen = 'test'
            script = [pscustomobject]@{ type = 'text/javascript'; exec = @('') }
        }
    )
    variable = @(
        @{ key = 'base_url'; value = 'http://crisaor.serveftp.com:9080'; type = 'string' }
        @{ key = 'base_url_local'; value = 'http://localhost:9080'; type = 'string' }
        @{ key = 'provision_secret'; value = 'dev-provision-cambiar-produccion'; type = 'string' }
        @{ key = 'jwt_token'; value = ''; type = 'string' }
        @{ key = 'jwt_definitive_token'; value = ''; type = 'string' }
        @{ key = 'empresa_id'; value = '2'; type = 'string' }
        @{ key = 'usuario_id'; value = '3'; type = 'string' }
    )
}

$json = $collection | ConvertTo-Json -Depth 40
[IO.File]::WriteAllText($dst, $json)

$totalEndpoints = 0
foreach ($f in $folders) {
    if ($f.item -and $f.item[0].item) {
        foreach ($c in $f.item) { $totalEndpoints += $c.item.Count }
    } elseif ($f.item) {
        $totalEndpoints += $f.item.Count
    }
}
Write-Host "OK: $dst ($totalEndpoints endpoints en servicios activos)"
