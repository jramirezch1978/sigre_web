@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion
for /f "delims=" %%t in ('powershell -NoProfile -Command "Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""') do set "SCRIPT_START_HUMAN=%%t"
for /f "delims=" %%t in ('powershell -NoProfile -Command "[DateTimeOffset]::Now.ToUnixTimeSeconds()"') do set "SCRIPT_START_EPOCH=%%t"
echo [build] Inicio: !SCRIPT_START_HUMAN!

REM ============================================================
REM SIGRE ERP — Build local (backend Maven + frontend Angular)
REM ============================================================
REM Compila en Windows. NO compilar en cronos (10 GB RAM).
REM Despliegue remoto: deploy.bat
REM ============================================================

set "REPO_ROOT=%~dp0"
if "%REPO_ROOT:~-1%"=="\" set "REPO_ROOT=%REPO_ROOT:~0,-1%"
set "BACKEND_DIR=%REPO_ROOT%\03. backend"
set "FRONTEND_DIR=%REPO_ROOT%\02. frontend"
set "JAVA_VERSION=17"
set "BUILD_LOG_DIR=%REPO_ROOT%\deploy-logs"
if not exist "!BUILD_LOG_DIR!" mkdir "!BUILD_LOG_DIR!"
for /f "delims=" %%t in ('powershell -NoProfile -Command "Get-Date -Format ddMMyyyy-HHmmss"') do set "BUILD_LOG_TS=%%t"

for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "GREEN=%ESC%[92m"
set "RED=%ESC%[91m"
set "YELLOW=%ESC%[93m"
set "CYAN=%ESC%[96m"
set "RESET=%ESC%[0m"

set "DEPLOY_BACKEND_MODULES=sigre-config-common sigre-common discovery-server api-gateway ms-auth-security asistencia-service"
set "INFRA_MODULES=discovery-server config-server api-gateway"
set "OPTIONAL_MODULES=sync-service inventory-service orders-service products-service"
set "ALL_BACKEND_MODULES=sigre-config-common sigre-common %INFRA_MODULES% ms-auth-security asistencia-service %OPTIONAL_MODULES%"

if "%~1"=="" goto :buildBackendAll
if /i "%~1"=="menu" goto :showMenu
if /i "%~1"=="backend" goto :buildBackendDeploy
if /i "%~1"=="backend-all" goto :buildBackendAll
if /i "%~1"=="infra" goto :buildInfra
if /i "%~1"=="module" goto :buildModule
if /i "%~1"=="frontend" goto :buildFrontend
if /i "%~1"=="all" goto :buildAll
if /i "%~1"=="clean" goto :cleanAll
if /i "%~1"=="test" goto :testAll
if /i "%~1"=="package" goto :packageAll
if /i "%~1"=="help" goto :showHelp

echo %RED%Opcion desconocida: %~1%RESET%
goto :showHelp

:showMenu
echo.
echo %CYAN%============================================================%RESET%
echo %CYAN%  SIGRE ERP - Build local (Windows)%RESET%
echo %CYAN%  Backend: Java %JAVA_VERSION% ^| Maven ^| Spring Boot 3%RESET%
echo %CYAN%  Frontend: Angular 18 ^| Node 20+%RESET%
echo %CYAN%============================================================%RESET%
echo.
echo   1. Compilar backend desplegable (discovery-server, api-gateway, asistencia-service)
echo   2. Compilar TODO el backend (mvn install)
echo   3. Compilar infraestructura (%INFRA_MODULES%)
echo   4. Compilar un modulo backend
echo   5. Compilar frontend (ng build:prod)
echo   6. Compilar backend + frontend
echo   7. Limpiar backend (mvn clean)
echo   0. Salir
echo.
set /p "OPTION=  Seleccione: "
if "%OPTION%"=="1" goto :buildBackendDeploy
if "%OPTION%"=="2" goto :buildBackendAll
if "%OPTION%"=="3" goto :buildInfra
if "%OPTION%"=="4" goto :selectModule
if "%OPTION%"=="5" goto :buildFrontend
if "%OPTION%"=="6" goto :buildAll
if "%OPTION%"=="7" goto :cleanAll
if "%OPTION%"=="0" goto :endScript
goto :showMenu

:checkJava
if exist "C:\Program Files\Java\jdk-17\bin\java.exe" (
    set "JAVA_HOME=C:\Program Files\Java\jdk-17"
) else if exist "C:\Program Files\Eclipse Adoptium\jdk-17*\bin\java.exe" (
    for /d %%j in ("C:\Program Files\Eclipse Adoptium\jdk-17*") do set "JAVA_HOME=%%j"
) else (
    echo %RED%[ERROR]%RESET% JDK 17 no encontrado.
    exit /b 1
)
set "PATH=%JAVA_HOME%\bin;%PATH%"
java -version >nul 2>&1 || exit /b 1
echo %GREEN%[OK]%RESET% Java listo: %JAVA_HOME%
exit /b 0

:checkMaven
where mvn >nul 2>&1 || (
    if exist "C:\Program Files\maven\bin\mvn.cmd" set "PATH=C:\Program Files\maven\bin;%PATH%"
)
call mvn --version >nul 2>&1 || (
    echo %RED%[ERROR]%RESET% Maven no encontrado.
    exit /b 1
)
echo %GREEN%[OK]%RESET% Maven disponible.
exit /b 0

:checkNode
where node >nul 2>&1 || (
    echo %RED%[ERROR]%RESET% Node.js no encontrado.
    exit /b 1
)
echo %GREEN%[OK]%RESET% Node: 
node -v
exit /b 0

:buildBackendAll
set "BUILD_LOG=!BUILD_LOG_DIR!\build-backend-all-!BUILD_LOG_TS!.log"
call :checkJava || goto :endScript
call :checkMaven || goto :endScript
echo %CYAN%[INFO]%RESET% Compilando backend completo...
echo [build] Log: !BUILD_LOG!
pushd "!BACKEND_DIR!"
call mvn clean install -DskipTests > "!BUILD_LOG!" 2>&1
if errorlevel 1 (
    echo %RED%[ERROR]%RESET% Fallo compilacion. Ver: !BUILD_LOG!
    popd
    goto :endScript
)
popd
echo %GREEN%[OK]%RESET% Backend compilado.
goto :endScript

:buildBackendDeploy
set "MODULES_TO_BUILD=%DEPLOY_BACKEND_MODULES%"
goto :buildModules

:buildInfra
set "MODULES_TO_BUILD=sigre-config-common %INFRA_MODULES%"
goto :buildModules

:selectModule
echo Modulos: %ALL_BACKEND_MODULES%
set /p "MOD_CHOICE=  Nombre del modulo: "
set "MODULES_TO_BUILD=%MOD_CHOICE%"
goto :buildModules

:buildModule
if "%~2"=="" (
    echo Uso: build.bat module ^<nombre^>
    goto :endScript
)
set "MODULES_TO_BUILD=%~2"
goto :buildModules

:buildModules
set "BUILD_LOG=!BUILD_LOG_DIR!\build-modules-!BUILD_LOG_TS!.log"
call :checkJava || goto :endScript
call :checkMaven || goto :endScript
echo [build] Log: !BUILD_LOG!
set "BUILD_FAILED=0"
for %%m in (%MODULES_TO_BUILD%) do (
    echo %CYAN%[BUILD]%RESET% %%m
    if exist "!BACKEND_DIR!\%%m" (
        pushd "!BACKEND_DIR!"
        call mvn clean install -DskipTests -pl %%m -am >> "!BUILD_LOG!" 2>&1
        if errorlevel 1 set "BUILD_FAILED=1"
        popd
    ) else (
        echo %RED%[ERROR]%RESET% No existe: %%m
        set "BUILD_FAILED=1"
    )
)
if "!BUILD_FAILED!"=="1" (
    echo %RED%[ERROR]%RESET% Ver: !BUILD_LOG!
) else (
    echo %GREEN%[OK]%RESET% Modulos compilados.
)
goto :endScript

:buildFrontend
set "BUILD_LOG=!BUILD_LOG_DIR!\build-frontend-!BUILD_LOG_TS!.log"
call :checkNode || goto :endScript
echo %CYAN%[INFO]%RESET% Compilando frontend Angular...
pushd "!FRONTEND_DIR!"
if not exist "node_modules" call npm ci >> "!BUILD_LOG!" 2>&1
call npm run build:prod >> "!BUILD_LOG!" 2>&1
if errorlevel 1 (
    echo %RED%[ERROR]%RESET% Fallo frontend. Ver: !BUILD_LOG!
    popd
    goto :endScript
)
popd
echo %GREEN%[OK]%RESET% Frontend compilado en 02. frontend\dist
goto :endScript

:buildAll
call :buildBackendAll
call :buildFrontend
goto :endScript

:testAll
call :checkJava || goto :endScript
call :checkMaven || goto :endScript
pushd "!BACKEND_DIR!"
call mvn test
popd
goto :endScript

:packageAll
call :checkJava || goto :endScript
call :checkMaven || goto :endScript
pushd "!BACKEND_DIR!"
call mvn package -DskipTests
popd
goto :endScript

:cleanAll
call :checkMaven || goto :endScript
pushd "!BACKEND_DIR!"
call mvn clean
popd
echo %GREEN%[OK]%RESET% Limpieza completada.
goto :endScript

:showHelp
echo.
echo %CYAN%Uso:%RESET% build.bat ^<comando^> [args]
echo.
echo   backend             Modulos desplegables (discovery-server, api-gateway, asistencia-service)
echo   backend-all         Compilar todo el backend Maven
echo   infra               discovery-server, config-server, api-gateway
echo   module ^<nombre^>     Un modulo backend
echo   frontend            ng build:prod
echo   all                 backend-all + frontend
echo   clean / test / package
echo   menu / help
echo.
goto :endScript

:endScript
for /f "delims=" %%t in ('powershell -NoProfile -Command "Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""') do set "SCRIPT_END_HUMAN=%%t"
echo [build] Fin: !SCRIPT_END_HUMAN!
endlocal
