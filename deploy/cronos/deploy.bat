@echo off
REM SIGRE ERP — Despliegue en cronos
REM Uso: deploy.bat [stack|app|all|sonarqube-up|sonarqube-down|status]

setlocal EnableExtensions
set CONTEXT=cronos
set STACK_DIR=/home/jramirez/stack
set DEPLOY_DIR=%~dp0

if "%1"=="" set ACTION=all
if not "%1"=="" set ACTION=%1

echo === SIGRE deploy cronos — accion: %ACTION% ===

docker context use %CONTEXT%
if errorlevel 1 exit /b 1

if /I "%ACTION%"=="stack" goto :stack
if /I "%ACTION%"=="app" goto :app
if /I "%ACTION%"=="all" goto :all
if /I "%ACTION%"=="sonarqube-up" goto :sonarqube_up
if /I "%ACTION%"=="sonarqube-down" goto :sonarqube_down
if /I "%ACTION%"=="status" goto :status
echo Accion no reconocida: %ACTION%
exit /b 1

:stack
echo Copiando stack infra a cronos...
scp -r "%DEPLOY_DIR%docker-compose.stack.yml" "%DEPLOY_DIR%init" jramirez@crisaor.serveftp.com:%STACK_DIR%/
ssh jramirez@crisaor.serveftp.com "cd %STACK_DIR% && docker compose -f docker-compose.stack.yml pull && docker compose -f docker-compose.stack.yml up -d"
goto :eof

:app
echo Copiando app compose a cronos...
scp "%DEPLOY_DIR%docker-compose.app.yml" "%DEPLOY_DIR%.env.example" jramirez@crisaor.serveftp.com:%STACK_DIR%/
ssh jramirez@crisaor.serveftp.com "test -f %STACK_DIR%/.env || cp %STACK_DIR%/.env.example %STACK_DIR%/.env"
ssh jramirez@crisaor.serveftp.com "cd %STACK_DIR% && docker compose --env-file .env -f docker-compose.app.yml pull && docker compose --env-file .env -f docker-compose.app.yml up -d"
goto :eof

:all
call "%~f0" stack
call "%~f0" app
goto :status

:sonarqube_up
ssh jramirez@crisaor.serveftp.com "cd %STACK_DIR% && docker compose --profile tools -f docker-compose.stack.yml up -d sonarqube"
goto :eof

:sonarqube_down
ssh jramirez@crisaor.serveftp.com "cd %STACK_DIR% && docker compose --profile tools -f docker-compose.stack.yml stop sonarqube"
goto :eof

:status
echo.
echo --- URLs publicas ---
echo Frontend:  http://crisaor.serveftp.com:8080
echo API GW:    http://crisaor.serveftp.com:9080/actuator/health
echo SonarQube: http://crisaor.serveftp.com:9000  (perfil tools)
echo.
ssh jramirez@crisaor.serveftp.com "docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
goto :eof
