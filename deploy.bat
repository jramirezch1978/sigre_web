@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion
for /f "delims=" %%t in ('powershell -NoProfile -Command "Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""') do set "SCRIPT_START_HUMAN=%%t"
echo [deploy] Inicio: !SCRIPT_START_HUMAN!

REM ============================================================
REM SIGRE ERP — Despliegue Docker en cronos (Oracle Linux 9)
REM ============================================================
REM Build LOCAL en Windows. Pull + up en cronos (contexto cronos).
REM NO compilar en el servidor (10 GB RAM).
REM Compose: deploy/cronos/docker-compose.app.yml
REM ============================================================

set "REPO_ROOT=%~dp0"
if "%REPO_ROOT:~-1%"=="\" set "REPO_ROOT=%REPO_ROOT:~0,-1%"
set "BACKEND_DIR=%REPO_ROOT%\03. backend"
set "FRONTEND_DIR=%REPO_ROOT%\02. frontend"
set "CRONOS_DIR=%REPO_ROOT%\deploy\cronos"
set "COMPOSE_APP=%CRONOS_DIR%\docker-compose.app.yml"
set "COMPOSE_STACK=%CRONOS_DIR%\docker-compose.stack.yml"
set "ENV_FILE=%CRONOS_DIR%\.env"
set "DEPLOY_LOG_DIR=%REPO_ROOT%\deploy-logs"
if not exist "!DEPLOY_LOG_DIR!" mkdir "!DEPLOY_LOG_DIR!"
for /f "delims=" %%t in ('powershell -NoProfile -Command "Get-Date -Format ddMMyyyy-HHmmss"') do set "DEPLOY_LOG_TS=%%t"

set "DOCKER_CTX=cronos"
set "DOCKER_CTX_LOCAL=default"
set "IMAGE_REGISTRY=ghcr.io/jramirezch1978/sigre"
set "IMAGE_TAG=latest"
set "SSH_USER=jramirez"
set "SSH_HOST=crisaor.serveftp.com"
set "REMOTE_STACK=/home/jramirez/stack"

set "BACKEND_SERVICES=discovery-server api-gateway asistencia-service"
set "FRONTEND_SERVICE=sigre-frontend"
set "ALL_APP_SERVICES=discovery-server config-server api-gateway asistencia-service sync-service sigre-frontend"

for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "GREEN=%ESC%[92m"
set "RED=%ESC%[91m"
set "YELLOW=%ESC%[93m"
set "CYAN=%ESC%[96m"
set "RESET=%ESC%[0m"

set "FORCE=0"
set "NO_PUSH=0"
set "NO_BUILD=0"
for %%a in (%*) do (
    if /i "%%a"=="--force" set "FORCE=1"
    if /i "%%a"=="--no-push" set "NO_PUSH=1"
    if /i "%%a"=="--no-build" set "NO_BUILD=1"
)

if "%~1"=="" goto :showMenu
if /i "%~1"=="menu" goto :showMenu
if /i "%~1"=="backend" goto :deployBackend
if /i "%~1"=="frontend" goto :deployFrontend
if /i "%~1"=="all" goto :deployAll
if /i "%~1"=="stack" goto :deployStack
if /i "%~1"=="pull" goto :pullRemote
if /i "%~1"=="status" goto :remoteStatus
if /i "%~1"=="context" goto :checkContext
if /i "%~1"=="help" goto :showHelp

REM Servicio individual
set "SERVICE=%~1"
goto :deployOneService

:showMenu
echo.
echo %CYAN%============================================================%RESET%
echo %CYAN%  SIGRE ERP - Deploy cronos (Docker context: %DOCKER_CTX%)%RESET%
echo %CYAN%  Registry: %IMAGE_REGISTRY%:%IMAGE_TAG%%RESET%
echo %CYAN%============================================================%RESET%
echo.
echo   1. Desplegar backend (%BACKEND_SERVICES%)
echo   2. Desplegar frontend (%FRONTEND_SERVICE%)
echo   3. Desplegar backend + frontend
echo   4. Desplegar un servicio
echo   5. Stack infra (PG + SonarQube)
echo   6. Pull remoto (sin build)
echo   7. Estado contenedores en cronos
echo   8. Verificar contexto Docker
echo   0. Salir
echo.
set /p "OPTION=  Seleccione: "
if "%OPTION%"=="1" goto :deployBackend
if "%OPTION%"=="2" goto :deployFrontend
if "%OPTION%"=="3" goto :deployAll
if "%OPTION%"=="4" goto :selectService
if "%OPTION%"=="5" goto :deployStack
if "%OPTION%"=="6" goto :pullRemote
if "%OPTION%"=="7" goto :remoteStatus
if "%OPTION%"=="8" goto :checkContext
if "%OPTION%"=="0" goto :endScript
goto :showMenu

:selectService
echo Servicios: %ALL_APP_SERVICES%
set /p "SERVICE=  Nombre: "
if "!SERVICE!"=="" goto :endScript
goto :deployOneService

:ensureEnv
if not exist "!ENV_FILE!" (
    if exist "!CRONOS_DIR!\.env.example" (
        echo %YELLOW%[WARN]%RESET% Copie .env.example a .env en deploy/cronos
        copy "!CRONOS_DIR!\.env.example" "!ENV_FILE!" >nul
    ) else (
        echo %RED%[ERROR]%RESET% Falta !ENV_FILE!
        exit /b 1
    )
)
exit /b 0

:useLocalContext
docker context use %DOCKER_CTX_LOCAL% >nul 2>&1
exit /b 0

:useRemoteContext
docker context use %DOCKER_CTX% >nul 2>&1
if errorlevel 1 (
    echo %RED%[ERROR]%RESET% Contexto '%DOCKER_CTX%' no existe.
    echo   docker context create cronos --docker "host=ssh://%SSH_USER%@%SSH_HOST%"
    exit /b 1
)
exit /b 0

:buildBackendImage
set "SVC=%~1"
set "DEPLOY_LOG=!DEPLOY_LOG_DIR!\deploy-build-!SVC!-!DEPLOY_LOG_TS!.log"
set "IMAGE=!IMAGE_REGISTRY!/!SVC!:!IMAGE_TAG!"
echo %CYAN%[BUILD LOCAL]%RESET% !SVC! -^> !IMAGE!
call :useLocalContext
if /i "!SVC!"=="sigre-frontend" (
    pushd "!FRONTEND_DIR!"
    docker build -t !IMAGE! . >> "!DEPLOY_LOG!" 2>&1
    set "BUILD_ERR=!errorlevel!"
    popd
) else (
    pushd "!BACKEND_DIR!"
    docker build -f "!SVC!\Dockerfile" -t !IMAGE! . >> "!DEPLOY_LOG!" 2>&1
    set "BUILD_ERR=!errorlevel!"
    popd
)
if !BUILD_ERR! neq 0 (
    echo %RED%[ERROR]%RESET% Build fallo. Ver: !DEPLOY_LOG!
    exit /b 1
)
echo %GREEN%[OK]%RESET% Imagen local: !IMAGE!
exit /b 0

:pushImage
set "SVC=%~1"
set "IMAGE=!IMAGE_REGISTRY!/!SVC!:!IMAGE_TAG!"
if "!NO_PUSH!"=="1" (
    echo %YELLOW%[SKIP]%RESET% Push omitido (--no-push). Imagen solo local.
    exit /b 0
)
echo %CYAN%[PUSH]%RESET% !IMAGE!
call :useLocalContext
docker push !IMAGE!
if errorlevel 1 (
    echo %RED%[ERROR]%RESET% Push fallo. Ejecute: docker login ghcr.io
    exit /b 1
)
exit /b 0

:remoteUp
set "SVC=%~1"
call :ensureEnv || exit /b 1
call :useRemoteContext || exit /b 1
set "DEPLOY_LOG=!DEPLOY_LOG_DIR!\deploy-up-!SVC!-!DEPLOY_LOG_TS!.log"
echo %CYAN%[CRONOS]%RESET% pull + up !SVC!...
docker compose -f "!COMPOSE_APP!" --env-file "!ENV_FILE!" pull !SVC! >> "!DEPLOY_LOG!" 2>&1
docker compose -f "!COMPOSE_APP!" --env-file "!ENV_FILE!" up -d !SVC! >> "!DEPLOY_LOG!" 2>&1
if errorlevel 1 (
    echo %RED%[ERROR]%RESET% Deploy remoto fallo. Ver: !DEPLOY_LOG!
    exit /b 1
)
echo %GREEN%[OK]%RESET% !SVC! activo en cronos.
exit /b 0

:deployOneService
set "SERVICE=%SERVICE%"
if "!NO_BUILD!"=="0" (
    call :buildBackendImage "!SERVICE!" || goto :endScript
    call :pushImage "!SERVICE!" || goto :endScript
)
call :remoteUp "!SERVICE!" || goto :endScript
goto :endScript

:deployBackend
echo %CYAN%[INFO]%RESET% Desplegando backend...
for %%s in (%BACKEND_SERVICES%) do (
    if "!NO_BUILD!"=="0" (
        call :buildBackendImage "%%s" || goto :endScript
        call :pushImage "%%s" || goto :endScript
    )
)
call :ensureEnv || goto :endScript
call :useRemoteContext || goto :endScript
set "DEPLOY_LOG=!DEPLOY_LOG_DIR!\deploy-backend-!DEPLOY_LOG_TS!.log"
docker compose -f "!COMPOSE_APP!" --env-file "!ENV_FILE!" pull %BACKEND_SERVICES% >> "!DEPLOY_LOG!" 2>&1
docker compose -f "!COMPOSE_APP!" --env-file "!ENV_FILE!" up -d %BACKEND_SERVICES% >> "!DEPLOY_LOG!" 2>&1
if errorlevel 1 (
    echo %RED%[ERROR]%RESET% Ver: !DEPLOY_LOG!
    goto :endScript
)
echo %GREEN%[OK]%RESET% Backend desplegado.
echo   API Gateway: http://%SSH_HOST%:9080
goto :endScript

:deployAll
echo %CYAN%[INFO]%RESET% Desplegando backend + frontend...
for %%s in (%BACKEND_SERVICES% %FRONTEND_SERVICE%) do (
    if "!NO_BUILD!"=="0" (
        call :buildBackendImage "%%s" || goto :endScript
        call :pushImage "%%s" || goto :endScript
    )
)
call :ensureEnv || goto :endScript
call :useRemoteContext || goto :endScript
set "DEPLOY_LOG=!DEPLOY_LOG_DIR!\deploy-all-!DEPLOY_LOG_TS!.log"
docker compose -f "!COMPOSE_APP!" --env-file "!ENV_FILE!" pull %BACKEND_SERVICES% %FRONTEND_SERVICE% >> "!DEPLOY_LOG!" 2>&1
docker compose -f "!COMPOSE_APP!" --env-file "!ENV_FILE!" up -d %BACKEND_SERVICES% %FRONTEND_SERVICE% >> "!DEPLOY_LOG!" 2>&1
if errorlevel 1 (
    echo %RED%[ERROR]%RESET% Ver: !DEPLOY_LOG!
    goto :endScript
)
echo %GREEN%[OK]%RESET% Backend + frontend desplegados.
echo   Frontend: http://%SSH_HOST%:8080
echo   API Gateway: http://%SSH_HOST%:9080
goto :endScript

:deployFrontend
set "SERVICE=%FRONTEND_SERVICE%"
goto :deployOneService

:deployStack
echo %CYAN%[STACK]%RESET% PostgreSQL 17 + SonarQube (Terraform / contexto.txt)
if "!FORCE!"=="0" (
    echo %YELLOW%[WARN]%RESET% Recrea infra. Para volumen limpio en cronos: docker compose down -v
    set /p "CONFIRM=  Continuar stack? (SI): "
    if /i not "!CONFIRM!"=="SI" goto :endScript
)
call :ensureEnv || goto :endScript
call :useRemoteContext || goto :endScript
set "DEPLOY_LOG=!DEPLOY_LOG_DIR!\deploy-stack-!DEPLOY_LOG_TS!.log"
docker compose -f "!COMPOSE_STACK!" --env-file "!ENV_FILE!" up -d >> "!DEPLOY_LOG!" 2>&1
if errorlevel 1 (
    echo %RED%[ERROR]%RESET% Ver: !DEPLOY_LOG!
    goto :endScript
)
echo %GREEN%[OK]%RESET% Stack levantado.
goto :endScript

:pullRemote
call :ensureEnv || goto :endScript
call :useRemoteContext || goto :endScript
if "%~2"=="" (
    docker compose -f "!COMPOSE_APP!" --env-file "!ENV_FILE!" pull
) else (
    docker compose -f "!COMPOSE_APP!" --env-file "!ENV_FILE!" pull %~2
)
goto :endScript

:remoteStatus
call :useRemoteContext || goto :endScript
echo %CYAN%Contenedores en cronos:%RESET%
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
goto :endScript

:checkContext
echo Contextos Docker:
docker context ls
echo.
call :useRemoteContext && docker info --format "{{.Name}}: {{.ServerVersion}}" 2>nul
goto :endScript

:showHelp
echo.
echo %CYAN%Uso:%RESET% deploy.bat ^<servicio^|comando^> [--force] [--no-push] [--no-build]
echo.
echo   backend             discovery-server, api-gateway, asistencia-service
echo   frontend            sigre-frontend
echo   all                 backend + frontend
echo   discovery-server    api-gateway  asistencia-service  sync-service  config-server
echo   stack               Infra PG + SonarQube (Terraform / deploy/cronos)
echo   pull [servicio]     Pull remoto sin build
echo   status              docker ps en cronos
echo   context             Verificar contexto cronos
echo.
echo %YELLOW%Flags:%RESET%
echo   --force     Sin confirmacion en stack
echo   --no-push   Build local sin push (solo pruebas)
echo   --no-build  Solo pull + up remoto
echo.
echo %YELLOW%Contexto cronos:%RESET%
echo   docker context create cronos --docker "host=ssh://%SSH_USER%@%SSH_HOST%"
echo.
goto :endScript

:endScript
call :useLocalContext >nul 2>&1
for /f "delims=" %%t in ('powershell -NoProfile -Command "Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""') do set "SCRIPT_END_HUMAN=%%t"
echo [deploy] Fin: !SCRIPT_END_HUMAN!
endlocal
