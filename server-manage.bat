@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion
for /f "delims=" %%t in ('powershell -NoProfile -Command "Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""') do set "SCRIPT_START_HUMAN=%%t"
echo [server-manage] Inicio: !SCRIPT_START_HUMAN!

REM ============================================================
REM SIGRE ERP — Gestion del servidor cronos (Oracle Linux 9)
REM ============================================================
REM Docker context: cronos
REM Stack: /home/jramirez/stack
REM ============================================================

set "REPO_ROOT=%~dp0"
if "%REPO_ROOT:~-1%"=="\" set "REPO_ROOT=%REPO_ROOT:~0,-1%"
set "CRONOS_DIR=%REPO_ROOT%\deploy\cronos"
set "COMPOSE_APP=%CRONOS_DIR%\docker-compose.app.yml"
set "COMPOSE_STACK=%CRONOS_DIR%\docker-compose.stack.yml"
set "ENV_FILE=%CRONOS_DIR%\.env"

set "DOCKER_CTX=cronos"
set "SSH_USER=jramirez"
set "SSH_HOST=crisaor.serveftp.com"
set "SERVER_IP=192.168.0.163"
set "REMOTE_STACK=/home/jramirez/stack"

for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "GREEN=%ESC%[92m"
set "RED=%ESC%[91m"
set "YELLOW=%ESC%[93m"
set "CYAN=%ESC%[96m"
set "RESET=%ESC%[0m"

if "%~1"=="" goto :showMenu
if /i "%~1"=="menu" goto :showMenu
if /i "%~1"=="status" goto :dockerStatus
if /i "%~1"=="ps" goto :dockerStatus
if /i "%~1"=="app-up" goto :appUp
if /i "%~1"=="app-down" goto :appDown
if /i "%~1"=="app-restart" goto :appRestart
if /i "%~1"=="stack-up" goto :stackUp
if /i "%~1"=="stack-down" goto :stackDown
if /i "%~1"=="sonarqube" goto :sonarqubeUp
if /i "%~1"=="portainer" goto :portainerUp
if /i "%~1"=="logs" goto :tailLogs
if /i "%~1"=="ssh" goto :openSsh
if /i "%~1"=="context" goto :setupContext
if /i "%~1"=="sync-compose" goto :syncCompose
if /i "%~1"=="disk" goto :diskUsage
if /i "%~1"=="help" goto :showHelp

echo %RED%Opcion desconocida: %~1%RESET%
goto :showHelp

:showMenu
echo.
echo %CYAN%============================================================%RESET%
echo %CYAN%  SIGRE ERP - Gestion cronos (%SSH_HOST%)%RESET%
echo %CYAN%  IP local: %SERVER_IP% ^| Stack: %REMOTE_STACK%%RESET%
echo %CYAN%============================================================%RESET%
echo.
echo   1. Estado contenedores (docker ps)
echo   2. Levantar aplicacion (compose app)
echo   3. Detener aplicacion
echo   4. Reiniciar aplicacion
echo   5. Levantar stack infra (PG — cuidado)
echo   6. Detener stack infra
echo   7. Levantar SonarQube (perfil tools)
echo   8. Ver logs de un servicio
echo   9. SSH al servidor
echo  10. Crear/verificar contexto Docker cronos
echo  11. Sincronizar compose a servidor
echo  12. Uso de disco remoto
echo   0. Salir
echo.
set /p "OPTION=  Seleccione: "
if "%OPTION%"=="1" goto :dockerStatus
if "%OPTION%"=="2" goto :appUp
if "%OPTION%"=="3" goto :appDown
if "%OPTION%"=="4" goto :appRestart
if "%OPTION%"=="5" goto :stackUp
if "%OPTION%"=="6" goto :stackDown
if "%OPTION%"=="7" goto :sonarqubeUp
if "%OPTION%"=="8" goto :tailLogs
if "%OPTION%"=="9" goto :openSsh
if "%OPTION%"=="10" goto :setupContext
if "%OPTION%"=="11" goto :syncCompose
if "%OPTION%"=="12" goto :diskUsage
if "%OPTION%"=="0" goto :endScript
goto :showMenu

:useRemoteContext
docker context use %DOCKER_CTX% >nul 2>&1
if errorlevel 1 (
    echo %RED%[ERROR]%RESET% Contexto '%DOCKER_CTX%' no existe. Ejecute: server-manage.bat context
    exit /b 1
)
exit /b 0

:ensureEnv
if not exist "!ENV_FILE!" (
    if exist "!CRONOS_DIR!\.env.example" copy "!CRONOS_DIR!\.env.example" "!ENV_FILE!" >nul
)
exit /b 0

:dockerStatus
call :useRemoteContext || goto :endScript
docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
goto :endScript

:appUp
call :ensureEnv
call :useRemoteContext || goto :endScript
docker compose -f "!COMPOSE_APP!" --env-file "!ENV_FILE!" up -d
goto :endScript

:appDown
call :useRemoteContext || goto :endScript
docker compose -f "!COMPOSE_APP!" --env-file "!ENV_FILE!" down
goto :endScript

:appRestart
call :useRemoteContext || goto :endScript
docker compose -f "!COMPOSE_APP!" --env-file "!ENV_FILE!" restart
goto :endScript

:stackUp
echo %CYAN%[STACK]%RESET% Levantar postgres17 + red stack_default (definido en Terraform)
echo %YELLOW%[INFO]%RESET% Para recrear desde cero: terraform apply + sync-compose + stack-up
echo %YELLOW%[WARN]%RESET% down -v borra postgres_data
set /p "CONFIRM=  Continuar stack-up? (SI): "
if /i not "!CONFIRM!"=="SI" goto :endScript
call :ensureEnv
call :useRemoteContext || goto :endScript
docker compose -f "!COMPOSE_STACK!" --env-file "!ENV_FILE!" up -d
goto :endScript

:stackDown
call :useRemoteContext || goto :endScript
docker compose -f "!COMPOSE_STACK!" --env-file "!ENV_FILE!" down
goto :endScript

:sonarqubeUp
call :ensureEnv
call :useRemoteContext || goto :endScript
docker compose -f "!COMPOSE_STACK!" --env-file "!ENV_FILE!" --profile tools up -d sonarqube
echo SonarQube: http://%SSH_HOST%:9001  (NAT; Portainer usa 9000 interno)
goto :endScript

:portainerUp
call :useRemoteContext || goto :endScript
docker start portainer 2>nul || echo %YELLOW%[INFO]%RESET% Portainer no encontrado; crear manualmente si aplica.
goto :endScript

:tailLogs
if "%~2"=="" (
    set /p "LOG_SVC=  Servicio (ej. api-gateway): "
) else (
    set "LOG_SVC=%~2"
)
call :useRemoteContext || goto :endScript
docker logs -f --tail 200 !LOG_SVC!
goto :endScript

:openSsh
ssh %SSH_USER%@%SSH_HOST%
goto :endScript

:setupContext
echo Contextos actuales:
docker context ls
echo.
docker context inspect %DOCKER_CTX% >nul 2>&1
if errorlevel 1 (
    echo Creando contexto cronos...
    docker context create cronos --docker "host=ssh://%SSH_USER%@%SSH_HOST%"
) else (
    echo %GREEN%[OK]%RESET% Contexto cronos ya existe.
)
goto :endScript

:syncCompose
echo %CYAN%[SYNC]%RESET% Copiando deploy/cronos a %SSH_USER%@%SSH_HOST%:%REMOTE_STACK%/...
scp -r "!CRONOS_DIR!\docker-compose.stack.yml" "!CRONOS_DIR!\docker-compose.app.yml" "!CRONOS_DIR!\init" "!CRONOS_DIR!\.env.example" %SSH_USER%@%SSH_HOST%:%REMOTE_STACK%/
if errorlevel 1 (
    echo %RED%[ERROR]%RESET% scp fallo. Verifique SSH.
) else (
    echo %GREEN%[OK]%RESET% Archivos sincronizados a %REMOTE_STACK%
)
goto :endScript

:diskUsage
ssh %SSH_USER%@%SSH_HOST% "df -h / /home/docker 2>/dev/null; echo '---'; docker system df 2>/dev/null"
goto :endScript

:showHelp
echo.
echo %CYAN%Uso:%RESET% server-manage.bat ^<comando^> [args]
echo.
echo   status / ps         Contenedores en cronos
echo   app-up / app-down / app-restart
echo   stack-up / stack-down   Infra PG + SonarQube (Terraform)
echo   sonarqube           Perfil tools SonarQube
echo   logs ^<servicio^>      docker logs -f
echo   ssh                 Conexion SSH
echo   context             Crear contexto Docker cronos
echo   sync-compose        scp compose a %REMOTE_STACK%
echo   disk                Espacio en disco remoto
echo   menu / help
echo.
goto :endScript

:endScript
docker context use default >nul 2>&1
for /f "delims=" %%t in ('powershell -NoProfile -Command "Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""') do set "SCRIPT_END_HUMAN=%%t"
echo [server-manage] Fin: !SCRIPT_END_HUMAN!
endlocal
