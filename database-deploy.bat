@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion
for /f "delims=" %%t in ('powershell -NoProfile -Command "Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""') do set "SCRIPT_START_HUMAN=%%t"
echo [database-deploy] Inicio: !SCRIPT_START_HUMAN!

REM ============================================================
REM SIGRE ERP — database-deploy.bat (DDL, seed, clonar BD)
REM Servidor: cronos — psql via NAT (sin contexto SSH Docker)
REM ============================================================
REM   database-deploy.bat create
REM   database-deploy.bat create-security [--force]
REM   database-deploy.bat create-template [--force]
REM   database-deploy.bat create-asistencia [--force]
REM   database-deploy.bat insert
REM   database-deploy.bat clone <empresa> [--force]
REM   database-deploy.bat delete <nombre_bd> [--force]
REM   database-deploy.bat delete-dev [--force]
REM   database-deploy.bat tenant-grants <bd> <rol>
REM ============================================================

set "PGHOST="
set "PGPORT="
set "PGUSER="
set "PGPASSWORD="
set "PGDATABASE="

set "REPO_ROOT=%~dp0"
if "%REPO_ROOT:~-1%"=="\" set "REPO_ROOT=%REPO_ROOT:~0,-1%"
set "ENV_FILE=%REPO_ROOT%\deploy\cronos\.env"
set "DDL_DIR=%REPO_ROOT%\04. Base de datos\ddl"
set "DEPLOY_LOG_DIR=%REPO_ROOT%\deploy-logs"
if not exist "!DEPLOY_LOG_DIR!" mkdir "!DEPLOY_LOG_DIR!"

REM ---------- CONFIGURACION (credenciales en deploy\cronos\.env) ----------
set "PGHOST=crisaor.serveftp.com"
set "PGPORT=5432"
set "PGUSER=postgres"
set "PGMAINTDB=postgres"
set "PGSECURITY=sigre_security"
set "PGTEMPLATE=sigre_template"
set "PGDATABASE=%PGTEMPLATE%"
set "PGSQLIMG=postgres:17-alpine"
set "PGSSLMODE=disable"
set "PGASISTENCIA_HOST=crisaor.serveftp.com"
set "PGASISTENCIA_PORT=5433"
set "PGASISTENCIA_USER=sigre-web"
set "PGASISTENCIA_DB=db-sigre-web"
set "PGASISTENCIA_CONTAINER=db-sigre-web"
set "DOCKER_CTX=cronos"

if exist "!ENV_FILE!" (
    for /f "usebackq eol=# tokens=1,* delims==" %%a in ("!ENV_FILE!") do (
        if /i "%%a"=="POSTGRES_PASSWORD" set "PGPASSWORD=%%b"
        if /i "%%a"=="POSTGRES_USER" set "PGUSER=%%b"
        if /i "%%a"=="ASISTENCIA_DB_PASSWORD" set "PGASISTENCIA_PASSWORD=%%b"
        if /i "%%a"=="ASISTENCIA_DB_HOST" set "PGASISTENCIA_HOST=%%b"
        if /i "%%a"=="ASISTENCIA_DB_PORT" set "PGASISTENCIA_PORT=%%b"
    )
)
if defined PGASISTENCIA_PASSWORD set "PGASISTENCIA_PASSWORD=!PGASISTENCIA_PASSWORD:"=!"
if not defined PGASISTENCIA_PASSWORD set "PGASISTENCIA_PASSWORD=S1greW3b@2025!"
if defined PGPASSWORD set "PGPASSWORD=!PGPASSWORD:"=!"
if not defined PGPASSWORD (
    echo ERROR: POSTGRES_PASSWORD no definida en deploy\cronos\.env
    goto :fail
)
REM --------------------------------------

set "FORCE=0"
set "MODE="
set "ARG1="
set "ARG2="
for %%a in (%*) do (
    if /i "%%a"=="--force" (
        set "FORCE=1"
    ) else if not defined MODE (
        set "MODE=%%a"
    ) else if not defined ARG1 (
        set "ARG1=%%a"
    ) else (
        set "ARG2=%%a"
    )
)

for /f "delims=" %%t in ('powershell -NoProfile -Command "Get-Date -Format ddMMyyyy-HHmmss"') do set "DBDEPLOY_TS=%%t"
set "DBDEPLOY_SCOPE=general"
if /I "!MODE!"=="create-security" set "DBDEPLOY_SCOPE=security"
if /I "!MODE!"=="create-template" set "DBDEPLOY_SCOPE=template"
if /I "!MODE!"=="create-asistencia" set "DBDEPLOY_SCOPE=asistencia"
if /I "!MODE!"=="create" set "DBDEPLOY_SCOPE=security-template"
if /I "!MODE!"=="insert" set "DBDEPLOY_SCOPE=insert-template"
if /I "!MODE!"=="clone" set "DBDEPLOY_SCOPE=clone"
if /I "!MODE!"=="patch-bluecoast" set "DBDEPLOY_SCOPE=patch-bluecoast"
if /I "!MODE!"=="patch-cantabria" set "DBDEPLOY_SCOPE=patch-cantabria"
if /I "!MODE!"=="delete" set "DBDEPLOY_SCOPE=delete"
if /I "!MODE!"=="delete-dev" set "DBDEPLOY_SCOPE=delete-dev"
if /I "!MODE!"=="tenant-grants" set "DBDEPLOY_SCOPE=tenant-grants"

set "DBDEPLOY_LOG=!DEPLOY_LOG_DIR!\database-deploy-!DBDEPLOY_SCOPE!-!DBDEPLOY_TS!.log"
(
echo ============================================================
echo DATABASE DEPLOY SIGRE — !PGUSER!@!PGHOST!:!PGPORT!
echo Inicio: !SCRIPT_START_HUMAN!
echo Modo: !MODE!  Force: !FORCE!
echo ============================================================
) > "!DBDEPLOY_LOG!"

if "!MODE!"=="" goto :help

if /I "!MODE!"=="create" goto :route_create
if /I "!MODE!"=="create-security" goto :route_create_security
if /I "!MODE!"=="create-template" goto :route_create_template
if /I "!MODE!"=="create-asistencia" goto :route_create_asistencia
if /I "!MODE!"=="insert" goto :route_insert
if /I "!MODE!"=="clone" goto :route_clone
if /I "!MODE!"=="patch-bluecoast" goto :route_patch_bluecoast
if /I "!MODE!"=="patch-cantabria" goto :route_patch_cantabria
if /I "!MODE!"=="delete" goto :route_delete
if /I "!MODE!"=="delete-dev" goto :route_delete_dev
if /I "!MODE!"=="tenant-grants" goto :route_tenant_grants

echo ERROR: Comando desconocido: !MODE!
goto :help

:route_create
call :check_host_docker_ddl || goto :fail
echo.
echo ^>^> Modo: create  ^(security + template^)
echo ^>^> DDL: !DDL_ROOT!
echo ^>^> DDL mount Docker: !DDL_MOUNT!
echo.
echo ========== PASO 1/2: SECURITY ^(!PGSECURITY!^) ==========
call :do_create_security || goto :fail
echo.
echo ========== PASO 2/2: TEMPLATE ^(!PGTEMPLATE!^) ==========
call :do_create_template || goto :fail
goto :done

:route_create_security
call :check_host_docker_ddl || goto :fail
call :do_create_security || goto :fail
goto :done

:route_create_template
call :check_host_docker_ddl || goto :fail
call :do_create_template || goto :fail
goto :done

:route_create_asistencia
call :check_host_docker || goto :fail
call :do_create_asistencia || goto :fail
goto :done

:route_insert
call :check_host_docker_ddl || goto :fail
call :do_insert || goto :fail
goto :done

:route_clone
call :check_host_docker_ddl || goto :fail
if "!ARG1!"=="" (
    echo ERROR: Indique empresa. Ejemplo: %~nx0 clone cantabria
    goto :fail
)
call :do_clone "!ARG1!" || goto :fail
goto :done

:route_patch_bluecoast
call :check_host_docker_ddl || goto :fail
call :do_patch_bluecoast || goto :fail
goto :done

:route_patch_cantabria
call :check_host_docker_ddl || goto :fail
call :do_patch_cantabria || goto :fail
goto :done

:route_delete
call :check_host_docker || goto :fail
if "!ARG1!"=="" (
    echo ERROR: Indique nombre de BD. Ejemplo: %~nx0 delete sigre_emp_test
    goto :fail
)
call :do_delete "!ARG1!" || goto :fail
goto :done

:route_delete_dev
call :check_host_docker || goto :fail
call :do_delete_dev || goto :fail
goto :done

:route_tenant_grants
call :check_host_docker_ddl || goto :fail
if "!ARG1!"=="" (
    echo ERROR: tenant-grants requiere: nombre_bd rol_tenant
    goto :fail
)
if "!ARG2!"=="" (
    echo ERROR: tenant-grants requiere: nombre_bd rol_tenant
    goto :fail
)
call :do_tenant_grants "!ARG1!" "!ARG2!" || goto :fail
goto :done

REM ------------------------------------------------------------
:init_ddl_paths
set "DDL_ROOT="
set "DDL_MOUNT="
for /f "usebackq delims=" %%P in (`powershell -NoProfile -ExecutionPolicy Bypass -File "!REPO_ROOT!\resolve-ddl-mount.ps1" -RepoRoot "!REPO_ROOT!"`) do (
    if not defined DDL_ROOT (set "DDL_ROOT=%%P") else set "DDL_MOUNT=%%P"
)
if not defined DDL_ROOT exit /b 1
if not defined DDL_MOUNT set "DDL_MOUNT=!DDL_ROOT!"
exit /b 0

:check_host_docker
if not defined PGHOST goto :fail
if not defined PGPORT goto :fail
if not defined PGUSER goto :fail
if not defined PGPASSWORD goto :fail
where docker >nul 2>&1 || (
    echo ERROR: Docker no esta en el PATH ^(!PGSQLIMG!^)
    exit /b 1
)
set "DOCKER_CONTEXT=default"
exit /b 0

:check_host_docker_ddl
call :check_host_docker || exit /b 1
call :init_ddl_paths || exit /b 1
if not exist "!DDL_ROOT!\00-convenciones-generales.sql" (
    echo ERROR: No se encontro DDL en !DDL_ROOT!
    exit /b 1
)
exit /b 0

:psql_maint_cmd
set "SQLLINE=%~1"
docker run --rm -e "PGPASSWORD=!PGPASSWORD!" -e PGSSLMODE=!PGSSLMODE! !PGSQLIMG! psql -h "!PGHOST!" -p "!PGPORT!" -U "!PGUSER!" -d "!PGMAINTDB!" -v ON_ERROR_STOP=1 -c "!SQLLINE!"
exit /b %ERRORLEVEL%

:psql_db_cmd
set "SQLLINE=%~1"
set "TARGETDB=%~2"
docker run --rm -e "PGPASSWORD=!PGPASSWORD!" -e PGSSLMODE=!PGSSLMODE! !PGSQLIMG! psql -h "!PGHOST!" -p "!PGPORT!" -U "!PGUSER!" -d "!TARGETDB!" -v ON_ERROR_STOP=1 -c "!SQLLINE!"
exit /b %ERRORLEVEL%

:run_sql
set "REL=%~1"
set "REL=!REL:\=/!"
set "REL_UNIX=!REL!"
set "REL_WIN=!REL:/=\!"
if not exist "!DDL_ROOT!\!REL_WIN!" (
    echo ERROR: No existe !DDL_ROOT!\!REL_WIN!
    exit /b 1
)
echo ^>^> --- !REL_UNIX! ---
(echo ^>^> --- !REL_UNIX! ---)>> "!DBDEPLOY_LOG!"
docker run --rm -e "PGPASSWORD=!PGPASSWORD!" -e PGSSLMODE=!PGSSLMODE! --mount "type=bind,source=!DDL_MOUNT!,target=/ddl" !PGSQLIMG! psql -h "!PGHOST!" -p "!PGPORT!" -U "!PGUSER!" -d "!PGDATABASE!" -v ON_ERROR_STOP=1 -f "/ddl/!REL_UNIX!"
if errorlevel 1 exit /b 1
echo    OK
exit /b 0

:run_sql_tenant_grants
set "TGRANT_ROLE=%~1"
set "REL_UNIX=tenant/99-grants-tenant-role.sql"
echo ^>^> --- tenant/99-grants-tenant-role.sql ^(rol=!TGRANT_ROLE!^) ---
(echo ^>^> --- tenant/99-grants-tenant-role.sql ^(rol=!TGRANT_ROLE!^) ---)>> "!DBDEPLOY_LOG!"
docker run --rm -e "PGPASSWORD=!PGPASSWORD!" -e PGSSLMODE=!PGSSLMODE! --mount "type=bind,source=!DDL_MOUNT!,target=/ddl" !PGSQLIMG! psql -h "!PGHOST!" -p "!PGPORT!" -U "!PGUSER!" -d "!PGDATABASE!" -v ON_ERROR_STOP=1 -v tenant_role=!TGRANT_ROLE! -f "/ddl/!REL_UNIX!"
if errorlevel 1 exit /b 1
echo    OK
exit /b 0

:ensure_database
set "TARGETDB=%~1"
set "DBOWNER=%~2"
if "!DBOWNER!"=="" set "DBOWNER=!PGUSER!"
if "!FORCE!"=="1" (
    echo ^>^> --force: recreando !TARGETDB!...
    echo ^>^>   Cerrando conexiones activas...
    call :psql_maint_cmd "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '!TARGETDB!' AND pid ^<^> pg_backend_pid();"
    echo ^>^>   Eliminando BD existente...
    call :psql_maint_cmd "DROP DATABASE IF EXISTS !TARGETDB!;"
    echo ^>^>   Creando BD !TARGETDB! ^(owner: !DBOWNER!^)...
    call :psql_maint_cmd "CREATE DATABASE !TARGETDB! OWNER !DBOWNER!;"
    if errorlevel 1 (
        echo ERROR: No se pudo crear la BD !TARGETDB! ^(owner: !DBOWNER!^)
        exit /b 1
    )
    echo ^>^>   BD !TARGETDB! recreada: OK
) else (
    REM Verificar si la BD existe; si no existe, crearla
    docker run --rm -e "PGPASSWORD=!PGPASSWORD!" -e PGSSLMODE=!PGSSLMODE! !PGSQLIMG! psql -h "!PGHOST!" -p "!PGPORT!" -U "!PGUSER!" -d "!PGMAINTDB!" -t -A -c "SELECT 1 FROM pg_database WHERE datname = '!TARGETDB!';" | findstr "1" >nul 2>&1
    if errorlevel 1 (
        echo ^>^>   Creando BD !TARGETDB! ^(owner: !DBOWNER!^)...
        call :psql_maint_cmd "CREATE DATABASE !TARGETDB! OWNER !DBOWNER!;"
        if errorlevel 1 (
            echo ERROR: No se pudo crear la BD !TARGETDB! ^(owner: !DBOWNER!^)
            exit /b 1
        )
        echo ^>^>   BD !TARGETDB! creada: OK
    ) else (
        echo ^>^>   BD !TARGETDB! ya existe, ejecutando DDL sobre ella ^(schemas se recrean internamente^)...
    )
)
exit /b 0

:do_create_security
echo.
echo ^>^> Modo: create-security ^(!PGSECURITY!^)  Force: !FORCE!
echo ^>^> Conexion: !PGUSER!@!PGHOST!:!PGPORT!/!PGSECURITY!
echo ^>^> DDL: !DDL_ROOT!
echo ^>^> DDL mount Docker: !DDL_MOUNT!
echo.
set "SAVED_PGDATABASE=!PGDATABASE!"
call :ensure_database "!PGSECURITY!" "!PGUSER!" || exit /b 1
set "PGDATABASE=!PGSECURITY!"
echo ^>^> Ejecutando DDL + seed de seguridad...
call :run_sql "security/00-convenciones-security.sql" || exit /b 1
call :run_sql "security/01-master.sql" || exit /b 1
call :run_sql "security/02-config.sql" || exit /b 1
call :run_sql "security/03-auth.sql" || exit /b 1
call :run_sql "security/04-auditoria-schema-sync.sql" || exit /b 1
call :run_sql "security/99-auditoria-security.sql" || exit /b 1
call :run_sql "99-auditoria-global.sql" || exit /b 1
call :run_sql "99-auditoria-triggers-fechas.sql" || exit /b 1
call :run_sql "security/99-auditoria-security-post.sql" || exit /b 1
call :run_sql "seed/01-carga-inicial-security.sql" || exit /b 1
call :run_sql "patches/20260625-edicion-erp-contenido-modulos.sql" || exit /b 1
call :run_sql "patches/20260619-opciones-menu-completas.sql" || exit /b 1
set "PGDATABASE=!SAVED_PGDATABASE!"
echo.
echo ^>^> create-security: DDL de seguridad ejecutado en !PGSECURITY!
exit /b 0

:do_create_template
echo.
echo ^>^> Modo: create-template ^(!PGTEMPLATE!^)  Force: !FORCE!
echo ^>^> Conexion: !PGUSER!@!PGHOST!:!PGPORT!/!PGTEMPLATE!
echo ^>^> DDL: !DDL_ROOT!
echo ^>^> DDL mount Docker: !DDL_MOUNT!
echo.
call :ensure_database "!PGTEMPLATE!" "!PGUSER!" || exit /b 1
set "PGDATABASE=!PGTEMPLATE!"
echo ^>^> Ejecutando DDL + seed de plantilla tenant...
call :run_sql "00-convenciones-generales.sql" || exit /b 1
call :run_sql "security/00-convenciones-security.sql" || exit /b 1
call :run_sql "security/01-master.sql" || exit /b 1
call :run_sql "security/02-config.sql" || exit /b 1
call :run_sql "tenant/00-auth-usuario.sql" || exit /b 1
call :run_sql "tenant/01-auth.sql" || exit /b 1
call :run_sql "tenant/01-core.sql" || exit /b 1
call :run_sql "tenant/02-almacen.sql" || exit /b 1
call :run_sql "tenant/03-compras.sql" || exit /b 1
call :run_sql "tenant/04-ventas.sql" || exit /b 1
call :run_sql "tenant/05-finanzas.sql" || exit /b 1
call :run_sql "tenant/06-contabilidad.sql" || exit /b 1
call :run_sql "tenant/07-rrhh.sql" || exit /b 1
call :run_sql "tenant/08-activos.sql" || exit /b 1
call :run_sql "tenant/09-produccion.sql" || exit /b 1
call :run_sql "tenant/10-auditoria.sql" || exit /b 1
call :run_sql "tenant/11-auditoria-campos-obligatorios.sql" || exit /b 1
call :run_sql "tenant/12-funciones-procedimientos.sql" || exit /b 1
call :run_sql "99-auditoria-global.sql" || exit /b 1
call :run_sql "99-auditoria-triggers-fechas.sql" || exit /b 1
call :run_sql "seed/01-carga-inicial-maestros.sql" || exit /b 1
call :run_sql "seed/02-carga-sunat.sql" || exit /b 1
call :run_sql "seed/02-carga-concepto-matriz-financiera.sql" || exit /b 1
call :run_sql "seed/01-seed-grupo-conceptos-planilla-sigre.sql" || exit /b 1
call :run_sql "seed/02-concepto-planilla-sigre.sql" || exit /b 1
call :run_sql "seed/03-seed-tipo-doc-identidad-sigre.sql" || exit /b 1
call :run_sql "seed/04-seed-trabajador-maestro-sigre.sql" || exit /b 1
call :run_sql "seed/05-seed-catalogos-trabajador-sigre.sql" || exit /b 1
call :run_sql "seed/06-seed-fechas-proceso-sigre.sql" || exit /b 1
call :run_sql "seed/07-seed-grupo-calculo-sigre.sql" || exit /b 1
call :run_sql "seed/08-seed-grupo-calculo-det-sigre.sql" || exit /b 1
call :run_sql "seed/09-seed-rmv-tipo-trabaj-sigre.sql" || exit /b 1
call :run_sql "seed/10-seed-impuesto-renta-tramos-sigre.sql" || exit /b 1
call :run_sql "seed/11-seed-configuracion-rrhh-sigre.sql" || exit /b 1
call :run_sql "seed/12-seed-admin-afp-sigre.sql" || exit /b 1
call :run_sql "seed/13-seed-motor-planilla-emp-sigre.sql" || exit /b 1
call :run_sql "seed/14-seed-calculo-referencia-sigre.sql" || exit /b 1
set "PGDATABASE=!PGTEMPLATE!"
echo.
echo ^>^> create-template: DDL de plantilla ejecutado en !PGTEMPLATE!
exit /b 0

:do_create_asistencia
echo.
echo ^>^> Modo: create-asistencia ^(!PGASISTENCIA_DB!^)  Force: !FORCE!
echo ^>^> Contenedor: !PGASISTENCIA_CONTAINER! ^(contexto Docker !DOCKER_CTX!^)
echo ^>^> DBeaver NAT: !PGASISTENCIA_HOST!:!PGASISTENCIA_PORT! — usuarios: postgres ^| sigre-web
echo ^>^> App JDBC interno: !PGASISTENCIA_USER!@!PGASISTENCIA_CONTAINER!:5432/!PGASISTENCIA_DB!
echo ^>^> Esquema tablas: asistencia-service ^(hibernate ddl-auto=update^)
echo.
call :init_ddl_paths || exit /b 1
set "ASIST_DDL=!DDL_ROOT!\asistencia\01-create-database.sql"
if not exist "!ASIST_DDL!" (
    echo ERROR: No existe !ASIST_DDL!
    exit /b 1
)
set "ASIST_FORCE_ARG="
if "!FORCE!"=="1" set "ASIST_FORCE_ARG=-Force"
powershell -NoProfile -ExecutionPolicy Bypass -File "!REPO_ROOT!\scripts\ensure-asistencia-db.ps1" -EnvFile "!ENV_FILE!" -DockerContext "!DOCKER_CTX!" -Container "!PGASISTENCIA_CONTAINER!" -Database "!PGASISTENCIA_DB!" -AppUser "!PGASISTENCIA_USER!" -DdlFile "!ASIST_DDL!" !ASIST_FORCE_ARG!
if errorlevel 1 exit /b 1
echo.
echo ^>^> create-asistencia: BD y permisos OK en contenedor !PGASISTENCIA_CONTAINER!.
echo ^>^> Conexion DBeaver ^(requiere NAT 5433 o red LAN 192.168.0.163^):
echo        Host: !PGASISTENCIA_HOST!  Puerto: !PGASISTENCIA_PORT!
echo        BD: !PGASISTENCIA_DB!  Usuario app: !PGASISTENCIA_USER!
echo        Usuario admin DBeaver: postgres ^(misma clave POSTGRES_PASSWORD del .env^)
exit /b 0

:do_insert
echo.
echo ^>^> Modo: insert ^(seed en !PGDATABASE!^)
echo ^>^> Conexion: !PGUSER!@!PGHOST!:!PGPORT!/!PGDATABASE!
echo ^>^> DDL: !DDL_ROOT!
echo.
call :precheck_ddl_applied || exit /b 1
call :run_sql "seed/01-carga-inicial-maestros.sql" || exit /b 1
echo.
echo ^>^> insert: OK
exit /b 0

:precheck_ddl_applied
call :psql_db_cmd "SELECT 1 FROM master.empresa LIMIT 0;" "!PGDATABASE!"
if errorlevel 1 (
    echo ERROR: Falta DDL. Ejecute: %~nx0 create-template
    exit /b 1
)
exit /b 0

:resolve_clone_dbname
set "CLONE_ARG=%~1"
set "CLONE_NEWDB="
for /f "delims=" %%a in ('powershell -NoProfile -Command "$s=$env:CLONE_ARG; if([string]::IsNullOrWhiteSpace($s)){exit 2}; $s=$s.Trim().ToLower() -replace '[^a-z0-9_]','_'; $s=$s -replace '_+','_'; $s=$s.Trim('_'); if($s -notmatch '^sigre_emp_'){$s='sigre_emp_'+$s}; if($s.Length -gt 63){$s=$s.Substring(0,63)}; Write-Output $s"') do set "CLONE_NEWDB=%%a"
if not defined CLONE_NEWDB (
    echo ERROR: Nombre de empresa/BD invalido.
    exit /b 1
)
exit /b 0

:do_clone
call :resolve_clone_dbname "%~1"
if errorlevel 1 exit /b 1
echo.
echo ^>^> Modo: clone  Plantilla: !PGTEMPLATE!  Nueva BD: !CLONE_NEWDB!
if "!FORCE!"=="1" (
    call :psql_maint_cmd "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '!CLONE_NEWDB!' AND pid ^<^> pg_backend_pid();"
    call :psql_maint_cmd "DROP DATABASE IF EXISTS !CLONE_NEWDB!;"
)
call :psql_maint_cmd "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '!PGTEMPLATE!' AND pid ^<^> pg_backend_pid();"
call :psql_maint_cmd "CREATE DATABASE !CLONE_NEWDB! TEMPLATE !PGTEMPLATE! OWNER !PGUSER!;"
if errorlevel 1 exit /b 1
echo ^>^> clone: !CLONE_NEWDB! creada
if /I "!CLONE_NEWDB!"=="sigre_emp_bluecoast" (
    set "SAVED_PGDATABASE=!PGDATABASE!"
    set "PGDATABASE=!CLONE_NEWDB!"
    echo ^>^> Aplicando seed Blue Coast ^(sucursales + usuarios capacitacion^)...
    call :run_sql "seed/02-carga-inicial-bluecoast-tenant.sql" || (
        set "PGDATABASE=!SAVED_PGDATABASE!"
        exit /b 1
    )
    set "PGDATABASE=!SAVED_PGDATABASE!"
)
if /I "!CLONE_NEWDB!"=="sigre_emp_cantabria" (
    set "SAVED_PGDATABASE=!PGDATABASE!"
    set "PGDATABASE=!CLONE_NEWDB!"
    echo ^>^> Aplicando seed Cantabria ^(4 sucursales operativas^)...
    call :run_sql "seed/02-carga-inicial-cantabria-tenant.sql" || (
        set "PGDATABASE=!SAVED_PGDATABASE!"
        exit /b 1
    )
    set "PGDATABASE=!SAVED_PGDATABASE!"
)
set "CLONE_ROLE="
for /f "delims=" %%a in ('powershell -NoProfile -Command "$s='%~1'; if([string]::IsNullOrWhiteSpace($s)){exit 2}; $s=$s.Trim().ToLower() -replace '[^a-z0-9_]','_'; $s=$s -replace '_+','_'; $s=$s.Trim('_'); Write-Output $s"') do set "CLONE_ROLE=%%a"
if not defined CLONE_ROLE (
    echo ERROR: No se pudo derivar rol tenant desde: %~1
    exit /b 1
)
echo ^>^> Aplicando privilegios tenant ^(!CLONE_NEWDB! / !CLONE_ROLE!^)...
call :do_tenant_grants "!CLONE_NEWDB!" "!CLONE_ROLE!" || exit /b 1
exit /b 0

:do_patch_bluecoast
echo.
echo ^>^> Modo: patch-bluecoast ^(sigre_emp_bluecoast^)
set "SAVED_PGDATABASE=!PGDATABASE!"
set "PGDATABASE=sigre_emp_bluecoast"
call :run_sql "seed/02-carga-inicial-bluecoast-tenant.sql" || (
    set "PGDATABASE=!SAVED_PGDATABASE!"
    exit /b 1
)
set "PGDATABASE=!SAVED_PGDATABASE!"
echo ^>^> patch-bluecoast: OK
exit /b 0

:do_patch_cantabria
echo.
echo ^>^> Modo: patch-cantabria ^(sigre_emp_cantabria^)
set "SAVED_PGDATABASE=!PGDATABASE!"
set "PGDATABASE=sigre_emp_cantabria"
call :run_sql "seed/02-carga-inicial-cantabria-tenant.sql" || (
    set "PGDATABASE=!SAVED_PGDATABASE!"
    exit /b 1
)
set "PGDATABASE=!SAVED_PGDATABASE!"
echo ^>^> patch-cantabria: OK
exit /b 0

:is_protected_db
set "PDB=%~1"
powershell -NoProfile -Command "$d=$env:PDB.Trim().ToLower(); $x=@('postgres','template0','template1','sigre_security','sigre_template','sonarqube','db-sigre-web'); if($x -contains $d){exit 1}; exit 0"
exit /b %ERRORLEVEL%

:do_delete
set "DELDB=%~1"
call :is_protected_db "!DELDB!"
if errorlevel 1 (
    echo ERROR: BD protegida: !DELDB!
    exit /b 1
)
if "!FORCE!"=="0" (
    set /p DELCONF= Escribe SI para eliminar !DELDB!: 
    if /i not "!DELCONF!"=="SI" exit /b 1
)
call :psql_maint_cmd "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '!DELDB!' AND pid ^<^> pg_backend_pid();"
call :psql_maint_cmd "DROP DATABASE IF EXISTS !DELDB!;"
exit /b %ERRORLEVEL%

:do_delete_dev
echo ^>^> Modo: delete-dev ^(BDs que terminan en _dev^)
call :psql_maint_cmd "SELECT datname FROM pg_database WHERE datistemplate = false AND LENGTH(datname) >= 4 AND RIGHT(datname, 4) = '_dev' AND datname NOT IN ('postgres','template0','template1','sigre_security','sigre_template','sonarqube') ORDER BY 1;"
if "!FORCE!"=="0" (
    set /p DELCONF= Escribe SI para eliminar TODAS las bases _dev listadas: 
    if /i not "!DELCONF!"=="SI" exit /b 1
)
for /f "usebackq delims=" %%D in (`docker run --rm -e "PGPASSWORD=!PGPASSWORD!" -e PGSSLMODE=!PGSSLMODE! !PGSQLIMG! psql -h "!PGHOST!" -p "!PGPORT!" -U "!PGUSER!" -d "!PGMAINTDB!" -t -A -c "SELECT datname FROM pg_database WHERE datistemplate = false AND LENGTH(datname) >= 4 AND RIGHT(datname, 4) = '_dev' AND datname NOT IN ('postgres','template0','template1','sigre_security','sigre_template','sonarqube') ORDER BY 1;"`) do (
    if not "%%D"=="" (
        call :psql_maint_cmd "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '%%D' AND pid ^<^> pg_backend_pid();"
        call :psql_maint_cmd "DROP DATABASE IF EXISTS %%D;"
    )
)
exit /b 0

:do_tenant_grants
set "TGDB=%~1"
set "TGROLE=%~2"
call :psql_maint_cmd "GRANT CONNECT ON DATABASE !TGDB! TO !TGROLE!;"
set "SAVED_PGDATABASE=!PGDATABASE!"
set "PGDATABASE=!TGDB!"
call :run_sql_tenant_grants "!TGROLE!"
set "RC=!errorlevel!"
set "PGDATABASE=!SAVED_PGDATABASE!"
exit /b !RC!

:done
echo.
echo ^>^> Proceso completado exitosamente.
echo [database-deploy] Log: !DBDEPLOY_LOG!
for /f "delims=" %%t in ('powershell -NoProfile -Command "Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""') do echo [database-deploy] Fin: %%t
exit /b 0

:fail
echo.
echo ERROR: Fallo. Revise mensajes arriba y el log.
echo [database-deploy] Log: !DBDEPLOY_LOG!
for /f "delims=" %%t in ('powershell -NoProfile -Command "Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""') do echo [database-deploy] Fin: %%t
exit /b 1

:help
echo.
echo Uso:
echo   %~nx0 create                  DDL completo: security + template
echo   %~nx0 create-security         Solo !PGSECURITY!
echo   %~nx0 create-template         Solo !PGTEMPLATE!
echo   %~nx0 create-asistencia [--force]  Crea BD !PGASISTENCIA_DB! en postgres17 + rol sigre-web
echo   %~nx0 insert                  Solo seed ^(requiere create previo^)
echo   %~nx0 clone ^<empresa^>
echo   %~nx0 patch-bluecoast           Sucursales + usuarios Blue Coast en sigre_emp_bluecoast
echo   %~nx0 patch-cantabria           Restaura 4 sucursales en sigre_emp_cantabria
echo   %~nx0 delete ^<nombre_bd^>
echo   %~nx0 delete-dev              BDs que terminan en _dev
echo   %~nx0 tenant-grants ^<bd^> ^<rol^>
echo.
echo   --force   Recrea BD en create-security/create-template/clone
echo             Omite confirmacion en delete/delete-dev
echo.
echo Conexion: !PGUSER!@!PGHOST!:!PGPORT! ^(Docker local + psql, sin SSH^)
echo Credenciales: deploy\cronos\.env
exit /b 1
