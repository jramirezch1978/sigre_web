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
REM   download-log.bat backend all
REM   download-log.bat backend discovery-server
REM   download-log.bat backend api-gateway asistencia-service
REM   download-log.bat frontend
REM   download-log.bat frontend sigre-frontend
REM ============================================================

set "DOCKER_CTX=cronos"
set "REPO_ROOT=%~dp0"
if "%REPO_ROOT:~-1%"=="\" set "REPO_ROOT=%REPO_ROOT:~0,-1%"
set "COMPOSE_FILE=%REPO_ROOT%\deploy\cronos\docker-compose.app.yml"
set "ENV_FILE=%REPO_ROOT%\deploy\cronos\.env"
set "LOG_DIR=%REPO_ROOT%\container-logs"

set "BACKEND_SERVICES=discovery-server config-server api-gateway asistencia-service sync-service"
set "FRONTEND_SERVICES=sigre-frontend"
set "ALL_SERVICES=%BACKEND_SERVICES% %FRONTEND_SERVICES%"

if "%~1"=="" goto :help

set "TARGET_SERVICES="

if /i "%~1"=="all" (
    set "TARGET_SERVICES=%ALL_SERVICES%"
    goto :download
)

if /i "%~1"=="backend" (
    if "%~2"=="" goto :help
    if /i "%~2"=="all" (
        set "TARGET_SERVICES=%BACKEND_SERVICES%"
        goto :download
    )
    for %%A in (%*) do (
        if /i not "%%A"=="backend" (
            call :validate_backend "%%A" || exit /b 1
            if defined TARGET_SERVICES (
                set "TARGET_SERVICES=!TARGET_SERVICES! %%A"
            ) else (
                set "TARGET_SERVICES=%%A"
            )
        )
    )
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
    for %%A in (%*) do (
        if /i not "%%A"=="frontend" (
            call :validate_frontend "%%A" || exit /b 1
            if defined TARGET_SERVICES (
                set "TARGET_SERVICES=!TARGET_SERVICES! %%A"
            ) else (
                set "TARGET_SERVICES=%%A"
            )
        )
    )
    goto :download
)

echo ERROR: Use backend ^<ms^>, frontend [servicio] o all
goto :help

:validate_backend
set "SVC=%~1"
for %%V in (%BACKEND_SERVICES%) do if /i "!SVC!"=="%%V" exit /b 0
echo ERROR: '!SVC!' no es un microservicio backend valido.
echo Backend: %BACKEND_SERVICES%
exit /b 1

:validate_frontend
set "SVC=%~1"
for %%V in (%FRONTEND_SERVICES%) do if /i "!SVC!"=="%%V" exit /b 0
echo ERROR: '!SVC!' no es un servicio frontend valido.
echo Frontend: %FRONTEND_SERVICES%
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
echo   DESCARGA DE LOGS: !TARGET_SERVICES!
echo   Destino: !LOG_DIR!
echo ========================================
echo.

set "OK_COUNT=0"
set "FAIL_COUNT=0"
for %%S in (!TARGET_SERVICES!) do (
    echo ^>^> [%%S] descargando log...
    if exist "!ENV_FILE!" (
        docker compose -f "!COMPOSE_FILE!" --env-file "!ENV_FILE!" logs --tail=5000 --no-color %%S > "!LOG_DIR!\%%S.log" 2>&1
    ) else (
        docker compose -f "!COMPOSE_FILE!" logs --tail=5000 --no-color %%S > "!LOG_DIR!\%%S.log" 2>&1
    )
    if errorlevel 1 (
        echo ^>^> [%%S] FALLO o contenedor no existe.
        set /a FAIL_COUNT+=1
    ) else (
        echo ^>^> [%%S] OK ^(!LOG_DIR!\%%S.log^)
        set /a OK_COUNT+=1
    )
)

echo.
echo ========================================
echo   RESULTADO
echo ========================================
echo   OK:    !OK_COUNT!
if !FAIL_COUNT! gtr 0 echo   FALLO: !FAIL_COUNT!
echo.
echo Logs guardados en: !LOG_DIR!\
goto :endScript

:help
echo.
echo Uso:
echo   %~nx0 all
echo   %~nx0 backend all
echo   %~nx0 backend discovery-server
echo   %~nx0 backend api-gateway asistencia-service
echo   %~nx0 frontend
echo   %~nx0 frontend sigre-frontend
echo.
echo Backend:  %BACKEND_SERVICES%
echo Frontend: %FRONTEND_SERVICES%
exit /b 1

:endScript
docker context use default >nul 2>&1
for /f "delims=" %%t in ('powershell -NoProfile -Command "Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""') do set "SCRIPT_END_HUMAN=%%t"
echo [download-log] Fin: !SCRIPT_END_HUMAN!
endlocal
