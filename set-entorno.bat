@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM SIGRE ERP - Selector de entorno para build.bat / deploy.bat
REM ============================================================
REM Sin argumentos -> muestra un menu con los CONTEXTOS DOCKER
REM   que ya existen (docker context ls) para elegir uno.
REM Con argumento   -> set-entorno.bat <contexto>
REM   Solo acepta contextos que YA existen en `docker context ls`.
REM   Si no existe, muestra error y NO cambia nada (no crea contextos).
REM
REM La eleccion se guarda en deploy\entorno-activo.txt y deploy.bat
REM la lee para saber a que servidor construir/desplegar.
REM ============================================================

set "REPO_ROOT=%~dp0"
if "%REPO_ROOT:~-1%"=="\" set "REPO_ROOT=%REPO_ROOT:~0,-1%"
set "ENTORNO_FILE=%REPO_ROOT%\deploy\entorno-activo.txt"

set "ENTORNO_ACTUAL="
if exist "!ENTORNO_FILE!" set /p ENTORNO_ACTUAL=<"!ENTORNO_FILE!"

call :listarContextos
if "!CTX_COUNT!"=="0" (
    echo [ERROR] No se encontraron contextos Docker configurados.
    echo   Verifique con: docker context ls
    endlocal
    exit /b 1
)

if not "%~1"=="" goto :seleccionDirecta
goto :menu

REM ============================================================
set "REINTENTOS=0"
:menu
echo.
echo ============================================================
echo   SIGRE ERP - Seleccionar entorno activo (build.bat / deploy.bat)
echo ============================================================
if defined ENTORNO_ACTUAL (
    echo   Entorno activo actual: !ENTORNO_ACTUAL!
) else (
    echo   Entorno activo actual: ^(no configurado^)
)
echo.
echo   Contextos Docker disponibles:
for /l %%i in (1,1,!CTX_COUNT!) do (
    set "MARCA= "
    if /i "!CTX_%%i!"=="!ENTORNO_ACTUAL!" set "MARCA=*"
    echo     %%i. !CTX_%%i! !MARCA!
)
echo     0. Cancelar
echo.
set "OPCION="
set /p "OPCION=  Seleccione el numero de entorno: "
if "!OPCION!"=="0" goto :cancelado

set "ENTORNO="
for /l %%i in (1,1,!CTX_COUNT!) do (
    if "!OPCION!"=="%%i" set "ENTORNO=!CTX_%%i!"
)
if not defined ENTORNO (
    echo   [ERROR] Opcion invalida: '!OPCION!'
    set /a REINTENTOS+=1
    if !REINTENTOS! geq 5 (
        echo   Demasiados intentos invalidos, se cancela.
        goto :cancelado
    )
    goto :menu
)
goto :guardar

REM ============================================================
:seleccionDirecta
set "ENTORNO=%~1"
set "ENCONTRADO=0"
for /l %%i in (1,1,!CTX_COUNT!) do (
    if /i "!CTX_%%i!"=="!ENTORNO!" set "ENCONTRADO=1"
)
if "!ENCONTRADO!"=="0" (
    echo [ERROR] El contexto Docker '!ENTORNO!' no existe todavia.
    echo.
    echo   Contextos disponibles ^(docker context ls^):
    for /l %%i in (1,1,!CTX_COUNT!) do echo     - !CTX_%%i!
    echo.
    echo   Para crear el contexto primero:
    echo     docker context create !ENTORNO! --docker "host=tcp://IP:2375"
    echo     docker context create !ENTORNO! --docker "host=ssh://usuario@host"
    endlocal
    exit /b 1
)
goto :guardar

REM ============================================================
:guardar
if not exist "%REPO_ROOT%\deploy" mkdir "%REPO_ROOT%\deploy"
> "!ENTORNO_FILE!" echo !ENTORNO!
docker context use "!ENTORNO!" >nul 2>&1

echo.
echo [OK] Entorno activo: !ENTORNO!
if /i "!ENTORNO!"=="linux-vm" (
    echo   Compose   : docker-compose.yml ^(raiz del repo^)
    echo   Servicios : asistencia-service, sigre-frontend
) else if /i "!ENTORNO!"=="cronos" (
    echo   Compose   : deploy\cronos\docker-compose.app.yml
    echo   Servicios : stack completo SIGRE ERP
) else (
    echo   Contexto Docker generico: !ENTORNO! ^(deploy.bat usara el flujo de cronos por defecto^)
)
echo.
echo   Ya puede usar: build.bat  /  deploy.bat ^<servicio^> --force
endlocal
exit /b 0

:cancelado
echo Operacion cancelada. Entorno sin cambios.
endlocal
exit /b 1

REM ============================================================
:listarContextos
set "CTX_COUNT=0"
for /f "usebackq delims=" %%c in (`docker context ls --format "{{.Name}}" 2^>nul`) do (
    set /a CTX_COUNT+=1
    set "CTX_!CTX_COUNT!=%%c"
)
exit /b 0
