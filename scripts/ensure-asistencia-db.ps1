param(
    [Parameter(Mandatory = $true)][string]$EnvFile,
    [Parameter(Mandatory = $true)][string]$DockerContext,
    [Parameter(Mandatory = $true)][string]$Container,
    [Parameter(Mandatory = $true)][string]$Database,
    [Parameter(Mandatory = $true)][string]$AppUser,
    [Parameter(Mandatory = $true)][string]$DdlFile,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

function Read-EnvValue([string]$Name, [string]$Default = '') {
    $line = Select-String -Path $EnvFile -Pattern "^$Name=" -ErrorAction SilentlyContinue
    if (-not $line) { return $Default }
    return $line.Line.Substring($line.Line.IndexOf('=') + 1).Trim().Trim('"')
}

function Invoke-ContainerPsql([string]$Db, [string]$Sql) {
    $Sql | docker --context $DockerContext exec -i $Container `
        psql -U $AppUser -d $Db -v ON_ERROR_STOP=1 | Out-Host
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

function Invoke-ContainerPsqlFile([string]$Db, [string]$FilePath) {
    Get-Content -Raw -Path $FilePath | docker --context $DockerContext exec -i $Container `
        psql -U $AppUser -d $Db -v ON_ERROR_STOP=1 | Out-Host
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

$appPwd = Read-EnvValue 'ASISTENCIA_DB_PASSWORD' 'S1greW3b@2025!'
$pgPwd = Read-EnvValue 'POSTGRES_PASSWORD'
if (-not $pgPwd) {
    Write-Error 'POSTGRES_PASSWORD no definida en deploy/cronos/.env'
}

docker context use $DockerContext | Out-Null
docker --context $DockerContext inspect $Container | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Error "Contenedor $Container no existe en $DockerContext. Ejecute: deploy.bat stack --force"
}

if ($Force) {
    Write-Host '>> --force: recreando BD db-sigre-web en contenedor...'
    Invoke-ContainerPsql 'postgres' "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$Database' AND pid <> pg_backend_pid();"
    Invoke-ContainerPsql 'postgres' 'DROP DATABASE IF EXISTS "db-sigre-web";'
}

$existsRaw = docker --context $DockerContext exec $Container `
    psql -U $AppUser -d postgres -t -A -c "SELECT 1 FROM pg_database WHERE datname = 'db-sigre-web';"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
$exists = if ($null -ne $existsRaw) { "$existsRaw".Trim() } else { '' }

if ($exists -ne '1') {
    Invoke-ContainerPsql 'postgres' 'CREATE DATABASE "db-sigre-web" WITH ENCODING ''UTF8'' LC_COLLATE ''en_US.utf8'' LC_CTYPE ''en_US.utf8'' TEMPLATE template0 OWNER "sigre-web";'
    Write-Host ">> BD $Database creada."
} elseif ($Force) {
    Invoke-ContainerPsql 'postgres' 'CREATE DATABASE "db-sigre-web" WITH ENCODING ''UTF8'' LC_COLLATE ''en_US.utf8'' LC_CTYPE ''en_US.utf8'' TEMPLATE template0 OWNER "sigre-web";'
    Write-Host ">> BD $Database recreada."
} else {
    Write-Host ">> BD $Database ya existe."
}

$pgPwdSql = $pgPwd.Replace("'", "''")
$roleSql = @"
DO `$`$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_roles WHERE rolname = 'postgres') THEN
    EXECUTE format('CREATE ROLE %I LOGIN SUPERUSER PASSWORD %L', 'postgres', '$pgPwdSql');
  ELSE
    EXECUTE format('ALTER ROLE %I WITH LOGIN SUPERUSER PASSWORD %L', 'postgres', '$pgPwdSql');
  END IF;
END `$`$;
"@
Invoke-ContainerPsql 'postgres' $roleSql
Write-Host '>> Rol postgres (superuser DBeaver): OK'

Invoke-ContainerPsqlFile $Database $DdlFile
Write-Host '>> Permisos schema public: OK'

Invoke-ContainerPsql $Database "SELECT current_database() AS db, current_user AS usr, version();" | Out-Host
