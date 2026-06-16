@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion
for /f "delims=" %%t in ('powershell -NoProfile -Command "Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""') do set "SCRIPT_START_HUMAN=%%t"
echo [download-log] Inicio: !SCRIPT_START_HUMAN!

REM ============================================================
REM download-log.bat — Descarga logs de contenedores (cronos)
REM ============================================================
REM Uso:
REM   download-log.bat all
REM   download-log.bat compose
REM   download-log.bat backend all
REM   download-log.bat backend core-service seguridad-service
REM   download-log.bat infra all
REM   download-log.bat core all
REM   download-log.bat commerce all
REM   download-log.bat domain all
REM   download-log.bat frontend
REM   download-log.bat stack all
REM ============================================================

set "DOCKER_CTX=cronos"
set "REPO_ROOT=%~dp0"
if "%REPO_ROOT:~-1%"=="\" set "REPO_ROOT=%REPO_ROOT:~0,-1%"
set "COMPOSE_APP=%REPO_ROOT%\deploy\cronos\docker-compose.app.yml"
set "COMPOSE_STACK=%REPO_ROOT%\deploy\cronos\docker-compose.stack.yml"
set "ENV_FILE=%REPO_ROOT%\deploy\cronos\.env"
set "LOG_DIR=%REPO_ROOT%\container-logs"

REM Alineado con deploy.bat — todos los microservicios del repositorio
set "INFRA_SERVICES=discovery-server config-server api-gateway"
set "CORE_SERVICES=seguridad-service core-service asistencia-service"
set "COMMERCE_SERVICES=inventory-service orders-service products-service sync-service"
set "DOMAIN_SERVICES=almacen-service compras-service contabilidad-service finanzas-service rrhh-service activo-fijo-service produccion-service auditoria-service comercializacion-service campo-service comedor-service flota-service mantenimiento-service operaciones-service presupuesto-service aprovision-service sig-service"
set "FRONTEND_SERVICES=sigre-frontend"
set "STACK_SERVICES=postgres17 sonarqube"

set "COMPOSE_APP_SERVICES=discovery-server api-gateway seguridad-service core-service asistencia-service almacen-service compras-service contabilidad-service finanzas-service rrhh-service produccion-service comercializacion-service sigre-frontend"

set "ALL_BACKEND_SERVICES=%INFRA_SERVICES% %CORE_SERVICES% %COMMERCE_SERVICES% %DOMAIN_SERVICES%"
set "ALL_SERVICES=%ALL_BACKEND_SERVICES% %FRONTEND_SERVICES%"
set "KNOWN_SERVICES=%ALL_SERVICES% %STACK_SERVICES%"

if "%~1"=="" goto :help

set "TARGET_SERVICES="

if /i "%~1"=="all" (
    set "TARGET_SERVICES=%ALL_SERVICES%"
    goto :download
)

if /i "%~1"=="compose" (
    set "TARGET_SERVICES=%COMPOSE_APP_SERVICES%"
    goto :download
)

if /i "%~1"=="infra" (
    if "%~2"=="" set "TARGET_SERVICES=%INFRA_SERVICES%" & goto :download
    if /i "%~2"=="all" set "TARGET_SERVICES=%INFRA_SERVICES%" & goto :download
    call :collect_args infra %*
    goto :download
)

if /i "%~1"=="core" (
    if "%~2"=="" set "TARGET_SERVICES=%CORE_SERVICES%" & goto :download
    if /i "%~2"=="all" set "TARGET_SERVICES=%CORE_SERVICES%" & goto :download
    call :collect_args core %*
    goto :download
)

if /i "%~1"=="commerce" (
    if "%~2"=="" set "TARGET_SERVICES=%COMMERCE_SERVICES%" & goto :download
    if /i "%~2"=="all" set "TARGET_SERVICES=%COMMERCE_SERVICES%" & goto :download
    call :collect_args commerce %*
    goto :download
)

if /i "%~1"=="domain" (
    if "%~2"=="" set "TARGET_SERVICES=%DOMAIN_SERVICES%" & goto :download
    if /i "%~2"=="all" set "TARGET_SERVICES=%DOMAIN_SERVICES%" & goto :download
    call :collect_args domain %*
    goto :download
)

if /i "%~1"=="stack" (
    if "%~2"=="" set "TARGET_SERVICES=%STACK_SERVICES%" & goto :download
    if /i "%~2"=="all" set "TARGET_SERVICES=%STACK_SERVICES%" & goto :download
    call :collect_args stack %*
    goto :download
)

if /i "%~1"=="backend" (
    if "%~2"=="" goto :help
    if /i "%~2"=="all" (
        set "TARGET_SERVICES=%ALL_BACKEND_SERVICES%"
        goto :download
    )
    call :collect_args backend %*
    goto :download
)

if /i "%~1"=="frontend" (
    if "%~2"=="" (
        set "TARGET_SERVICES=%FRONTEND_SERVICES%"
        goto :download
    )
    if /i "%~2"=="all" (
        set "TARGET_SERVICES=%FRONTEND_SERVICES%"
        goto :download
    )
    call :collect_args frontend %*
    goto :download
)

echo ERROR: Comando no reconocido. Use all, compose, backend, frontend, infra, core, commerce, domain o stack.
goto :help

:collect_args
shift
:collect_loop
if "%~1"=="" exit /b 0
call :validate_known "%~1" || exit /b 1
if defined TARGET_SERVICES (
    set "TARGET_SERVICES=!TARGET_SERVICES! %~1"
) else (
    set "TARGET_SERVICES=%~1"
)
shift
goto :collect_loop

:validate_known
set "SVC=%~1"
for %%V in (%KNOWN_SERVICES%) do if /i "!SVC!"=="%%V" exit /b 0
echo ERROR: '!SVC!' no es un servicio conocido del repositorio.
echo Ejecute: %~nx0 help
exit /b 1

:download
for /f "tokens=*" %%c in ('docker context show') do set "CURRENT_CTX=%%c"
if /i not "!CURRENT_CTX!"=="%DOCKER_CTX%" (
    docker context use %DOCKER_CTX% >nul 2>&1
    if errorlevel 1 (
        echo ERROR: Contexto '%DOCKER_CTX%' no disponible.
        exit /b 1
    )
)

if exist "!LOG_DIR!" (
    echo ^>^> Limpiando logs anteriores...
    rd /s /q "!LOG_DIR!"
)
mkdir "!LOG_DIR!"

echo.
echo ========================================
echo   DESCARGA DE LOGS ^(!TARGET_SERVICES!^)
echo   Destino: !LOG_DIR!
echo ========================================
echo.

set "OK_COUNT=0"
set "FAIL_COUNT=0"
set "EMPTY_COUNT=0"
for %%S in (!TARGET_SERVICES!) do (
    call :fetch_service_log "%%S"
)

echo.
echo ========================================
echo   RESULTADO
echo ========================================
echo   OK:      !OK_COUNT!
if !FAIL_COUNT! gtr 0 echo   FALLO:   !FAIL_COUNT!
if !EMPTY_COUNT! gtr 0 echo   VACIO:   !EMPTY_COUNT! ^(contenedor existe pero sin salida^)
echo.
echo Logs guardados en: !LOG_DIR!\
goto :endScript

:fetch_service_log
set "SVC=%~1"
set "LOG_FILE=!LOG_DIR!\!SVC!.log"
echo ^>^> [!SVC!] descargando log...

REM 1) docker logs directo por nombre de contenedor
docker logs --tail=5000 --no-color !SVC! > "!LOG_FILE!" 2>&1
if not errorlevel 1 goto :log_ok

REM 2) docker compose app
if exist "!ENV_FILE!" (
    docker compose -f "!COMPOSE_APP!" --env-file "!ENV_FILE!" logs --tail=5000 --no-color !SVC! > "!LOG_FILE!" 2>&1
) else (
    docker compose -f "!COMPOSE_APP!" logs --tail=5000 --no-color !SVC! > "!LOG_FILE!" 2>&1
)
if not errorlevel 1 goto :log_ok

REM 3) docker compose stack (postgres, sonarqube, etc.)
if exist "!ENV_FILE!" (
    docker compose -f "!COMPOSE_STACK!" --env-file "!ENV_FILE!" logs --tail=5000 --no-color !SVC! > "!LOG_FILE!" 2>&1
) else (
    docker compose -f "!COMPOSE_STACK!" logs --tail=5000 --no-color !SVC! > "!LOG_FILE!" 2>&1
)
if not errorlevel 1 goto :log_ok

echo ^>^> [!SVC!] FALLO — contenedor no existe o no esta en compose.
set /a FAIL_COUNT+=1
exit /b 0

:log_ok
for %%F in ("!LOG_FILE!") do set "LOG_SIZE=%%~zF"
if "!LOG_SIZE!"=="0" (
    echo ^>^> [!SVC!] OK vacio ^(!LOG_FILE!^)
    set /a OK_COUNT+=1
    set /a EMPTY_COUNT+=1
) else (
    echo ^>^> [!SVC!] OK ^(!LOG_FILE!^)
    set /a OK_COUNT+=1
)
exit /b 0

:help
echo.
echo Uso:
echo   %~nx0 all                  — Todos los microservicios + frontend del repo
echo   %~nx0 compose              — Solo servicios en docker-compose.app.yml ^(cronos^)
echo   %~nx0 backend all
echo   %~nx0 backend core-service seguridad-service
echo   %~nx0 infra ^| core ^| commerce ^| domain [all ^| servicio...]
echo   %~nx0 frontend
echo   %~nx0 stack all            — Infra stack ^(postgres17, sonarqube^)
echo.
echo Infra:    %INFRA_SERVICES%
echo Core:     %CORE_SERVICES%
echo Commerce: %COMMERCE_SERVICES%
echo Domain:   %DOMAIN_SERVICES%
echo Frontend: %FRONTEND_SERVICES%
echo Stack:    %STACK_SERVICES%
echo Compose:  %COMPOSE_APP_SERVICES%
exit /b 1

:endScript
docker context use default >nul 2>&1
for /f "delims=" %%t in ('powershell -NoProfile -Command "Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""') do set "SCRIPT_END_HUMAN=%%t"
echo [download-log] Fin: !SCRIPT_END_HUMAN!
endlocal
