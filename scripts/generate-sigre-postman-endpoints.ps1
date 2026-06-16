$ErrorActionPreference = "Stop"
$root = "e:\Work\sigre_web"
$backend = Join-Path $root "03. backend"
$dst = Join-Path $root "01. documentacion\SIGRE Web ERP.postman_collection.json"

function Get-MappingPath {
    param([string]$AnnotationBlock)
    $block = ($AnnotationBlock -replace '\s+', ' ').Trim()
    if ($block -match '@(?:Get|Post|Put|Patch|Delete)Mapping\s*\(\s*\)') { return '' }
    if ($block -match '@(?:Get|Post|Put|Patch|Delete)Mapping\s*$') { return '' }
    if ($block -match '@(?:Get|Post|Put|Patch|Delete)Mapping\s*\(\s*(?:value|path)\s*=\s*\{([^}]+)\}') {
        $paths = [regex]::Matches($block, '"([^"]+)"') | ForEach-Object { $_.Groups[1].Value }
        return ($paths -join '|')
    }
    if ($block -match '@(?:Get|Post|Put|Patch|Delete)Mapping\s*\(\s*(?:value|path)\s*=\s*"([^"]+)"') { return $matches[1] }
    if ($block -match '@(?:Get|Post|Put|Patch|Delete)Mapping\s*\(\s*"([^"]+)"') { return $matches[1] }
    if ($block -match '@RequestMapping\s*\(\s*(?:value|path)\s*=\s*"([^"]+)"') { return $matches[1] }
    if ($block -match '@RequestMapping\s*\(\s*"([^"]+)"') { return $matches[1] }
    return $null
}

function Get-AnnotationBlock {
    param([string[]]$Lines, [int]$StartIndex)
    $block = $Lines[$StartIndex].Trim()
    $depth = ($block.ToCharArray() | Where-Object { $_ -eq '(' }).Count - ($block.ToCharArray() | Where-Object { $_ -eq ')' }).Count
    $j = $StartIndex
    while ($depth -gt 0 -and ($j + 1) -lt $Lines.Count) {
        $j++
        $next = $Lines[$j].Trim()
        $block += ' ' + $next
        $depth += ($next.ToCharArray() | Where-Object { $_ -eq '(' }).Count
        $depth -= ($next.ToCharArray() | Where-Object { $_ -eq ')' }).Count
    }
    return @{ Block = $block; EndIndex = $j }
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

function Get-TableGroupFromPath {
    param([string]$Path)
    if ($Path -match 'actuator') { return 'actuator' }

    $segments = @()
    foreach ($m in [regex]::Matches($Path, '/([^/]+)')) {
        $s = $m.Groups[1].Value
        if ($s -notmatch '^\{') { $segments += $s.ToLower() }
    }

    if ($segments.Count -lt 2 -or $segments[0] -ne 'api') { return 'general' }

    $idx = 2
    if ($idx -lt $segments.Count -and $segments[$idx] -eq 'recuperar') {
        return 'recuperar'
    }
    if ($idx -lt $segments.Count -and $segments[$idx] -in @('seguridad', 'admin')) {
        $idx++
    }

    $resource = @($segments[$idx..($segments.Count - 1)])
    if ($resource.Count -eq 0) { return 'general' }

    $actionsOnEntity = @('estado', 'activar', 'desactivar', 'aprobar', 'rechazar', 'anular', 'confirmar')
    if ($resource.Count -eq 2 -and $actionsOnEntity -contains $resource[-1]) {
        return $resource[0]
    }

    return $resource[-1]
}

function Format-TableFolderName {
    param([string]$TableKey, [string]$ServiceKey)
    $labels = @{
        'login'              = 'login (genera jwt_temporal_token)'
        'seleccionar-empresa'= 'seleccionar-empresa (genera jwt_definitive_token)'
        'refresh'            = 'refresh (renueva jwt_definitive_token)'
        'empresas'           = 'empresas'
        'acciones'           = 'acciones'
        'roles'              = 'roles'
        'opciones-menu'      = 'opciones-menu'
        'opciones-libres'    = 'opciones-libres'
        'sucursales'         = 'sucursales'
        'modulos'            = 'modulos'
        'mi-menu'            = 'mi-menu'
        'usuarios'           = 'usuarios'
        'recuperar'          = 'recuperar-password'
    }
    if ($labels.ContainsKey($TableKey)) { return $labels[$TableKey] }
    return ($TableKey -replace '-', ' ')
}

function Get-TableSortKey {
    param([string]$TableKey, [string]$ServiceKey)
    if ($ServiceKey -eq 'seguridad-service') {
        $order = @{
            'login' = '01'
            'empresas' = '02'
            'seleccionar-empresa' = '03'
            'me' = '04'
            'refresh' = '05'
            'logout' = '06'
            'recuperar' = '07'
            'actuator' = '00'
        }
        if ($order.ContainsKey($TableKey)) { return $order[$TableKey] + $TableKey }
    }
    return '99' + $TableKey
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
    if ($content -match '@RequestMapping\s*\([^)]*?(?:value|path)\s*=\s*"([^"]+)"') { $classMapping = $matches[1] }
    elseif ($content -match '@RequestMapping\s*\(\s*"([^"]+)"') { $classMapping = $matches[1] }

    $endpoints = @()
    $lines = Get-Content $FilePath
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i].Trim()
        if ($line -notmatch '@(?:Get|Post|Put|Patch|Delete)Mapping') { continue }
        $method = Get-HttpMethod $line
        if (-not $method) { continue }

        $anno = Get-AnnotationBlock -Lines $lines -StartIndex $i
        $annoBlock = $anno.Block
        $i = $anno.EndIndex

        $subPathRaw = Get-MappingPath $annoBlock
        if ($null -eq $subPathRaw) { continue }

        $contextBlock = ($lines[[Math]::Max(0, $anno.EndIndex - 2)..([Math]::Min($lines.Count - 1, $anno.EndIndex + 8))] -join ' ')
        $isMultipart = $contextBlock -match 'MULTIPART_FORM_DATA|MediaType\.MULTIPART'

        foreach ($subPath in ($subPathRaw -split '\|')) {
            $servicePath = Join-UrlPath $classMapping $subPath
            $gatewayPath = Normalize-GatewayPath $ServiceKey $servicePath
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
    }
    return $endpoints
}

$serviceConfig = [ordered]@{
    'seguridad-service'  = @{ folder = '01 - seguridad-service';  pattern = 'seguridad-service\src\main\java\*\controller\*.java' }
    'asistencia-service' = @{ folder = '02 - asistencia-service'; pattern = 'asistencia-service\src\main\java\*\controller\*.java' }
    'sync-service'       = @{ folder = '03 - sync-service';       pattern = 'sync-service\src\main\java\*\controller\*.java' }
    'inventory-service'  = @{ folder = '04 - inventory-service';  pattern = 'inventory-service\src\main\java\*\controllers\*.java' }
    'orders-service'     = @{ folder = '05 - orders-service';     pattern = 'orders-service\src\main\java\*\controllers\*.java' }
    'products-service'   = @{ folder = '06 - products-service';   pattern = 'products-service\src\main\java\*\controllers\*.java' }
    'core-service'       = @{ folder = '07 - core-service';       pattern = 'core-service\src\main\java\*\controller\*.java' }
    'almacen-service'    = @{ folder = '10 - almacen-service';    pattern = 'almacen-service\src\main\java\*\controller\*.java' }
    'compras-service'    = @{ folder = '11 - compras-service';    pattern = 'compras-service\src\main\java\*\controller\*.java' }
    'contabilidad-service' = @{ folder = '12 - contabilidad-service'; pattern = 'contabilidad-service\src\main\java\*\controller\*.java' }
    'finanzas-service'   = @{ folder = '13 - finanzas-service';   pattern = 'finanzas-service\src\main\java\*\controller\*.java' }
    'rrhh-service'       = @{ folder = '14 - rrhh-service';       pattern = 'rrhh-service\src\main\java\*\controller\*.java' }
    'produccion-service' = @{ folder = '16 - produccion-service'; pattern = 'produccion-service\src\main\java\*\controller\*.java' }
    'comercializacion-service' = @{ folder = '17 - comercializacion-service (api/ventas)'; pattern = 'comercializacion-service\src\main\java\*\controller\*.java' }
}

$sampleBodies = @{
    '/api/auth/login' = @'
{
  "email": "jramirez@npssac.com.pe",
  "password": "vMZRnU+HMLYd09Uj4jIv4HpkLzoIEA==",
  "passwordHash": "009389e3858fa09ccdabb98c29170408f65bbe7dc76268e7e4d37c79b97efafc",
  "ipAddress": "127.0.0.1",
  "ipPrivada": "192.168.1.10",
  "browser": "PostmanRuntime/7.44.0",
  "sistemaOperativo": "Windows 11"
}
'@
    '/api/auth/seleccionar-empresa' = @'
{
  "email": "jramirez@npssac.com.pe",
  "password": "vMZRnU+HMLYd09Uj4jIv4HpkLzoIEA==",
  "passwordHash": "009389e3858fa09ccdabb98c29170408f65bbe7dc76268e7e4d37c79b97efafc",
  "empresaId": {{empresa_id}},
  "sucursalId": 1,
  "ipAddress": "127.0.0.1",
  "ipPrivada": "192.168.1.10",
  "browser": "PostmanRuntime/7.44.0",
  "sistemaOperativo": "Windows 11"
}
'@
    '/api/auth/refresh' = @'
{
  "refreshToken": "{{refresh_token}}"
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
    '/api/admin/empresas/credenciales-bd' = @'
{
  "dbName": "sigre_emp_cantabria",
  "dbUser": "cantabria",
  "dbPassword": "Cantabria@Dev2026!"
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

$saveAuthTokensScript = @(
    'function saveSigreAuthTokens(data) {'
    '  if (!data) return;'
    '  var token = data.accessToken || data.token;'
    '  if (!token) return;'
    '  if (data.temporal === true) {'
    '    pm.collectionVariables.set("jwt_temporal_token", token);'
    '  } else {'
    '    pm.collectionVariables.set("jwt_definitive_token", token);'
    '  }'
    '  if (data.refreshToken) {'
    '    pm.collectionVariables.set("refresh_token", data.refreshToken);'
    '  }'
    '}'
)

$loginTestScript = @(
    'if (pm.response.code === 200) {'
    '  var json = pm.response.json();'
    '  var data = json.data || json;'
    '  saveSigreAuthTokens(data);'
    '}'
)

$selectEmpresaScript = @(
    'if (pm.response.code === 200) {'
    '  var json = pm.response.json();'
    '  var data = json.data || json;'
    '  saveSigreAuthTokens(data);'
    '}'
)

$refreshTestScript = @(
    'if (pm.response.code === 200) {'
    '  var json = pm.response.json();'
    '  var data = json.data || json;'
    '  if (data.accessToken) pm.collectionVariables.set("jwt_definitive_token", data.accessToken);'
    '  if (data.refreshToken) pm.collectionVariables.set("refresh_token", data.refreshToken);'
    '}'
)

$collectionPreRequestScript = @(
    '(function () {'
    '  var auth = pm.request.auth;'
    '  if (!auth || auth.type !== "bearer") return;'
    '  var url = pm.request.url.toString();'
    '  var temporal = pm.collectionVariables.get("jwt_temporal_token") || "";'
    '  var definitive = pm.collectionVariables.get("jwt_definitive_token") || "";'
    '  var needsTemporal = /\/api\/auth\/(empresas|seleccionar-empresa)(?:\?|$|\/)/.test(url);'
    '  var token = needsTemporal ? temporal : (definitive || temporal);'
    '  if (token) {'
    '    pm.request.auth.bearer = [{ key: "token", value: token, type: "string" }];'
    '  }'
    '})();'
)

function New-PostmanUrlRequest {
    param(
        [string]$Name,
        [string]$Method,
        [string]$RawUrl,
        [string]$HostVar = '{{base_url}}',
        [string[]]$PathSegments = @(),
        [switch]$UseBearer
    )
    $req = [ordered]@{
        name    = $Name
        request = [ordered]@{
            method = $Method
            header = @()
            url    = [ordered]@{
                raw  = $RawUrl
                host = @($HostVar)
                path = $PathSegments
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
    return [pscustomobject]$req
}

$folders = @()

$infraItems = @(
    (New-PostmanRequest 'GET gateway actuator/health' 'GET' '/actuator/health')
    (New-PostmanUrlRequest 'GET frontend (nginx)' 'GET' '{{frontend_url}}/' '{{frontend_url}}' @(''))
    (New-PostmanRequest 'GET core actuator/health' 'GET' '/api/core/actuator/health' -UseBearer)
    (New-PostmanRequest 'GET asistencia actuator/health' 'GET' '/api/asistencia/actuator/health')
    (New-PostmanRequest 'GET discovery eureka apps' 'GET' '/eureka/apps')
)
$folders += [pscustomobject]@{ name = '00 - Infraestructura (cronos)'; item = $infraItems }

foreach ($svcKey in $serviceConfig.Keys) {
    $cfg = $serviceConfig[$svcKey]
    $files = Get-ChildItem -Path (Join-Path $backend $cfg.pattern.Split('\')[0]) -Recurse -Filter '*Controller.java' |
        Where-Object { $_.FullName -match '\\controller\\' -or $_.FullName -match '\\controllers\\' }
    if ($svcKey -eq 'sync-service') {
        $workerControllers = Get-ChildItem -Path (Join-Path $backend 'sync-service\src\main\java') -Recurse -Filter '*Controller.java' |
            Where-Object { $_.FullName -match '\\worker\\controller\\' }
        $files = @($files) + @($workerControllers)
    }

    $byTable = @{}
    foreach ($file in $files) {
        foreach ($ep in (Parse-ControllerFile $file.FullName $svcKey)) {
            $tableKey = Get-TableGroupFromPath $ep.GatewayPath
            if (-not $byTable.ContainsKey($tableKey)) {
                $byTable[$tableKey] = @()
            }
            $byTable[$tableKey] += $ep
        }
    }

    $tableFolders = @()
    foreach ($tableKey in ($byTable.Keys | Sort-Object { Get-TableSortKey $_ $svcKey })) {
        $requests = @()
        foreach ($ep in ($byTable[$tableKey] | Sort-Object GatewayPath, Method)) {
            $path = $ep.GatewayPath
            $body = $sampleBodies[$path]
            $useBearer = -not (Test-PublicEndpoint $path $ep.Method)
            $useProvision = Test-ProvisionEndpoint $path
            $req = New-PostmanRequest -Name $ep.Name -Method $ep.Method -GatewayPath $path -Body $body -UseBearer:$useBearer -UseProvisionSecret:$useProvision -IsMultipart:$ep.IsMultipart

            if ($svcKey -eq 'seguridad-service') {
                if ($path -eq '/api/auth/login') {
                    $req | Add-Member -NotePropertyName event -NotePropertyValue @(
                        [pscustomobject]@{ listen = 'test'; script = [pscustomobject]@{ type = 'text/javascript'; exec = ($saveAuthTokensScript + $loginTestScript) } }
                    ) -Force
                }
                if ($path -eq '/api/auth/seleccionar-empresa') {
                    $req | Add-Member -NotePropertyName event -NotePropertyValue @(
                        [pscustomobject]@{ listen = 'test'; script = [pscustomobject]@{ type = 'text/javascript'; exec = ($saveAuthTokensScript + $selectEmpresaScript) } }
                    ) -Force
                }
                if ($path -eq '/api/auth/refresh') {
                    $req | Add-Member -NotePropertyName event -NotePropertyValue @(
                        [pscustomobject]@{ listen = 'test'; script = [pscustomobject]@{ type = 'text/javascript'; exec = $refreshTestScript } }
                    ) -Force
                }
            }
            $requests += $req
        }
        $folderName = Format-TableFolderName $tableKey $svcKey
        $tableFolders += [pscustomobject]@{ name = $folderName; item = $requests }
    }

    if ($svcKey -in @('almacen-service', 'compras-service', 'core-service')) {
        $healthPath = switch ($svcKey) {
            'almacen-service' { '/api/almacen/actuator/health' }
            'compras-service' { '/api/compras/actuator/health' }
            'core-service'    { '/api/core/actuator/health' }
        }
        if (-not ($tableFolders | Where-Object { $_.name -like 'actuator*' })) {
            $tableFolders = @(
                [pscustomobject]@{
                    name = 'actuator'
                    item = @((New-PostmanRequest 'GET actuator/health' 'GET' $healthPath -UseBearer))
                }
            ) + $tableFolders
        }
    }

    $folders += [pscustomobject]@{ name = $cfg.folder; item = $tableFolders }
}

$migrationMap = @(
    @('15 - activo-fijo-service', 'api/activos/actuator/health'),
    @('18 - auditoria-service', 'api/auditoria/actuator/health'),
    @('19 - sig-service reportes', 'api/reportes/actuator/health'),
    @('20 - aprovision-service notif', 'api/notificaciones/actuator/health'),
    @('21 - campo-service', 'api/campo/actuator/health'),
    @('22 - comedor-service', 'api/comedor/actuator/health'),
    @('23 - flota-service', 'api/flota/actuator/health'),
    @('24 - mantenimiento-service', 'api/mantenimiento/actuator/health'),
    @('25 - operaciones-service', 'api/operaciones/actuator/health'),
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
        description = 'Coleccion SIGRE Web generada desde controllers Java. Servidor cronos: API Gateway {{base_url}} (9080), frontend {{frontend_url}} (8080). Importar tambien el entorno SIGRE Web ERP - cronos.postman_environment.json.'
    }
    item = $folders
    event = @(
        [pscustomobject]@{
            listen = 'prerequest'
            script = [pscustomobject]@{ type = 'text/javascript'; exec = $collectionPreRequestScript }
        },
        [pscustomobject]@{
            listen = 'test'
            script = [pscustomobject]@{ type = 'text/javascript'; exec = @('') }
        }
    )
    variable = @(
        @{ key = 'base_url'; value = 'http://crisaor.serveftp.com:9080'; type = 'string' }
        @{ key = 'frontend_url'; value = 'http://crisaor.serveftp.com:8080'; type = 'string' }
        @{ key = 'base_url_local'; value = 'http://localhost:9080'; type = 'string' }
        @{ key = 'frontend_url_local'; value = 'http://localhost:8080'; type = 'string' }
        @{ key = 'host_cronos'; value = 'crisaor.serveftp.com'; type = 'string' }
        @{ key = 'postgres_host'; value = 'crisaor.serveftp.com'; type = 'string' }
        @{ key = 'postgres_port'; value = '5432'; type = 'string' }
        @{ key = 'asistencia_db_host'; value = 'crisaor.serveftp.com'; type = 'string' }
        @{ key = 'asistencia_db_port'; value = '5433'; type = 'string' }
        @{ key = 'sonarqube_url'; value = 'http://crisaor.serveftp.com:9001'; type = 'string' }
        @{ key = 'provision_secret'; value = 'dev-provision-cambiar-produccion'; type = 'string' }
        @{ key = 'jwt_temporal_token'; value = ''; type = 'string' }
        @{ key = 'jwt_definitive_token'; value = ''; type = 'string' }
        @{ key = 'refresh_token'; value = ''; type = 'string' }
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
