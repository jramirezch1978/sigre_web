@echo off
setlocal enabledelayedexpansion
for /f "delims=" %%t in ('powershell -NoProfile -Command "Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""') do set "SCRIPT_START_HUMAN=%%t"
for /f "delims=" %%t in ('powershell -NoProfile -Command "[DateTimeOffset]::Now.ToUnixTimeSeconds()"') do set "SCRIPT_START_EPOCH=%%t"
set "SCRIPT_EXIT_CODE=0"
echo [deploy-frontend] Inicio: !SCRIPT_START_HUMAN!

REM ============================================================
REM deploy.bat — Despliega frontend en servidor independiente
REM ============================================================
REM Servidor: 169.197.82.217 (n8n.restaurant.pe)
REM Docker Context SSH: erprest (erpadmin@169.197.82.217)
REM
REM Flujo:
REM   1) docker build: multi-stage (Node 20 + Nginx 1.27), contexto
REM      enviado via SSH al servidor remoto donde queda la imagen.
REM   2) docker compose up -d frontend (recrear contenedor)
REM
REM Uso:
REM   deploy.bat frontend              Build + deploy al servidor
REM   deploy.bat frontend --force      Igual + force-recreate
REM   deploy.bat status                Estado del contenedor frontend
REM   deploy.bat logs                  Ver logs del frontend
REM   deploy.bat help
REM ============================================================

set "DOCKER_CTX=erprest"
set "DOCKER_IMAGE=restpe/frontend"
set "DOCKER_TAG=latest"
set "FRONTEND_DIR=%~dp0"
if "%FRONTEND_DIR:~-1%"=="\" set "FRONTEND_DIR=%FRONTEND_DIR:~0,-1%"
set "BACKEND_DIR=%FRONTEND_DIR%\..\restpe-contabilidad-back-end"
set "COMPOSE_FILE=%BACKEND_DIR%\docker-compose.yml"
set "LOG_DIR=%FRONTEND_DIR%\deploy-logs"
if not exist "!LOG_DIR!" mkdir "!LOG_DIR!"

if "%~1"=="" goto :help
if /i "%~1"=="help" goto :help
if /i "%~1"=="-h" goto :help
if /i "%~1"=="/?" goto :help
if /i "%~1"=="frontend" goto :deploy_frontend
if /i "%~1"=="status" goto :do_status
if /i "%~1"=="logs" goto :do_logs

echo ERROR: Comando desconocido: %~1
echo.
goto :help

REM ============================================================
:deploy_frontend
set "DEPLOY_FORCE=0"
for %%A in (%*) do (
    if /i "%%A"=="--force" set "DEPLOY_FORCE=1"
    if /i "%%A"=="/force" set "DEPLOY_FORCE=1"
)

call :ensure_context
if errorlevel 1 (
    set "SCRIPT_EXIT_CODE=1"
    goto :script_exit
)

for /f "delims=" %%t in ('powershell -NoProfile -Command "Get-Date -Format ddMMyyyy-HHmmss"') do set "LOG_TS=%%t"
set "DEPLOY_LOG=!LOG_DIR!\deploy-frontend-!LOG_TS!.log"
(
echo ============================================================
echo DEPLOY Frontend Restaurant.pe — Servidor 169.197.82.217
echo Inicio: !SCRIPT_START_HUMAN!
echo Force recreate: !DEPLOY_FORCE!
echo ============================================================
) > "!DEPLOY_LOG!"

echo.
echo ========================================
echo   DEPLOY FRONTEND — Servidor Independiente
if "!DEPLOY_FORCE!"=="1" echo   Modo: --force ^(force-recreate^)
echo   Contexto Docker: %DOCKER_CTX%
echo   Servidor: 169.197.82.217
echo ========================================
echo.
echo ^>^> Log: !DEPLOY_LOG!

REM Paso 1: Docker build (multi-stage: node + nginx)
echo.
echo ^>^> [1/2] Docker build ^(Node 20 + Nginx 1.27, enviado via SSH^)...
set "TMP_BUILD=!DEPLOY_LOG!.build.tmp"
pushd "!FRONTEND_DIR!"
docker build --no-cache --progress=plain -t %DOCKER_IMAGE%:%DOCKER_TAG% . > "!TMP_BUILD!" 2>&1
set "BUILD_ERR=!ERRORLEVEL!"
popd

powershell -NoProfile -Command "if (Test-Path '!TMP_BUILD!') { Get-Content -LiteralPath '!TMP_BUILD!' -Raw | Add-Content -LiteralPath '!DEPLOY_LOG!' -Encoding utf8; Remove-Item -LiteralPath '!TMP_BUILD!' -Force -ErrorAction SilentlyContinue }"

if "!BUILD_ERR!" neq "0" (
    echo ^>^> [FALLO] Docker build fallo. Ultimas lineas:
    powershell -NoProfile -Command "Get-Content -LiteralPath '!DEPLOY_LOG!' -Tail 35"
    echo ^>^> Log completo: !DEPLOY_LOG!
    set "SCRIPT_EXIT_CODE=1"
    goto :script_exit
)
echo ^>^> [OK] Imagen %DOCKER_IMAGE%:%DOCKER_TAG% construida en servidor.

REM Paso 2: docker compose up
echo.
echo ^>^> [2/2] Levantando contenedor frontend...
(echo. & echo ----- compose up -----) >> "!DEPLOY_LOG!"

if "!DEPLOY_FORCE!"=="1" (
    docker compose -f "!COMPOSE_FILE!" up -d --force-recreate --no-deps frontend >> "!DEPLOY_LOG!" 2>&1
) else (
    docker compose -f "!COMPOSE_FILE!" up -d --no-deps frontend >> "!DEPLOY_LOG!" 2>&1
)
if errorlevel 1 (
    echo ^>^> [FALLO] compose up fallo. Ver: !DEPLOY_LOG!
    powershell -NoProfile -Command "Get-Content -LiteralPath '!DEPLOY_LOG!' -Tail 20"
    set "SCRIPT_EXIT_CODE=1"
    goto :script_exit
)

echo ^>^> [OK] Frontend desplegado.
echo.
echo ========================================
echo   Frontend desplegado exitosamente
echo   URL: http://169.197.82.217:8080
echo   Imagen: %DOCKER_IMAGE%:%DOCKER_TAG%
echo ========================================
echo.
echo ^>^> Estado:
docker compose -f "!COMPOSE_FILE!" ps frontend --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}" 2>nul
echo.
goto :script_exit

REM ============================================================
:do_status
call :ensure_context
if errorlevel 1 (set "SCRIPT_EXIT_CODE=1" & goto :script_exit)
echo.
docker compose -f "!COMPOSE_FILE!" ps frontend --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}" 2>nul
echo.
goto :script_exit

REM ============================================================
:do_logs
call :ensure_context
if errorlevel 1 (set "SCRIPT_EXIT_CODE=1" & goto :script_exit)
docker compose -f "!COMPOSE_FILE!" logs --tail=100 -f frontend
goto :script_exit

REM ============================================================
:ensure_context
for /f "tokens=*" %%c in ('docker context show') do set "CURRENT_CTX=%%c"
if /i not "!CURRENT_CTX!"=="%DOCKER_CTX%" (
    echo ^>^> Cambiando contexto Docker a %DOCKER_CTX%...
    docker context use %DOCKER_CTX% >nul 2>&1
    if errorlevel 1 (
        echo ERROR: No se pudo activar el contexto %DOCKER_CTX%.
        echo Crear con: server-manage.bat create-context
        exit /b 1
    )
)
docker info >nul 2>&1
if errorlevel 1 (
    echo ERROR: No se puede conectar al Docker del servidor via SSH.
    exit /b 1
)
exit /b 0

REM ============================================================
:help
echo.
echo Uso: deploy.bat ^<comando^> [argumentos]
echo.
echo   DESPLIEGUE:
echo     frontend              Build + deploy al servidor independiente
echo     frontend --force      Igual + force-recreate del contenedor
echo.
echo   GESTION:
echo     status                Estado del contenedor frontend
echo     logs                  Ver logs en tiempo real
echo     help                  Esta ayuda
echo.
echo   Servidor: 169.197.82.217 ^(contexto Docker: %DOCKER_CTX%^)
echo   URL: http://169.197.82.217:8080
echo.
goto :script_exit

:script_exit
for /f "delims=" %%t in ('powershell -NoProfile -Command "Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""') do set "SCRIPT_END_HUMAN=%%t"
for /f "delims=" %%t in ('powershell -NoProfile -Command "[DateTimeOffset]::Now.ToUnixTimeSeconds()"') do set "SCRIPT_END_EPOCH=%%t"
set /a SCRIPT_ELAPSED_SEC=!SCRIPT_END_EPOCH!-!SCRIPT_START_EPOCH!
if !SCRIPT_ELAPSED_SEC! lss 0 set "SCRIPT_ELAPSED_SEC=0"
for /f "delims=" %%t in ('powershell -NoProfile -Command "$s=[int]$env:SCRIPT_ELAPSED_SEC; [TimeSpan]::FromSeconds($s).ToString(\"hh\:mm\:ss\")"') do set "SCRIPT_ELAPSED_FMT=%%t"
echo [deploy-frontend] Fin: !SCRIPT_END_HUMAN!
echo [deploy-frontend] Duracion: !SCRIPT_ELAPSED_FMT! ^(!SCRIPT_ELAPSED_SEC! s^)
if defined DEPLOY_LOG if exist "!DEPLOY_LOG!" (
    (
    echo.
    echo Fin: !SCRIPT_END_HUMAN!
    echo Duracion: !SCRIPT_ELAPSED_FMT! ^(!SCRIPT_ELAPSED_SEC! s^)
    echo ============================================================
    ) >> "!DEPLOY_LOG!"
    echo [deploy-frontend] Log: !DEPLOY_LOG!
)
exit /b !SCRIPT_EXIT_CODE!
