@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

:: ============================================================
:: Restaurant.pe ERP — Frontend Build Script
:: ============================================================
:: Angular 20 | Ionic 8 | Node.js >= 18
:: ============================================================

set "FRONTEND_DIR=%~dp0"
set "OUTPUT_DIR=www"

for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "GREEN=%ESC%[92m"
set "RED=%ESC%[91m"
set "YELLOW=%ESC%[93m"
set "CYAN=%ESC%[96m"
set "RESET=%ESC%[0m"

:: ── Punto de entrada ──────────────────────────────────────────
if "%~1"=="" goto :buildDev
if /i "%~1"=="menu"       goto :showMenu
if /i "%~1"=="dev"        goto :buildDev
if /i "%~1"=="prod"       goto :buildProd
if /i "%~1"=="serve"      goto :serve
if /i "%~1"=="serve-prod" goto :serveProd
if /i "%~1"=="test"       goto :runTests
if /i "%~1"=="lint"       goto :runLint
if /i "%~1"=="clean"      goto :clean
if /i "%~1"=="install"    goto :installDeps
if /i "%~1"=="help"       goto :showHelp

echo %RED%Opcion desconocida: %~1%RESET%
goto :showHelp

:: ════════════════════════════════════════════════════════════
:: MENU INTERACTIVO
:: ════════════════════════════════════════════════════════════
:showMenu
echo.
echo %CYAN%============================================================%RESET%
echo %CYAN%  Restaurant.pe ERP - Frontend Build%RESET%
echo %CYAN%  Angular 20 ^| Ionic 8 ^| Tailwind CSS%RESET%
echo %CYAN%============================================================%RESET%
echo.
echo   %GREEN%COMPILACION%RESET%
echo     1.  Compilar desarrollo (ng build)
echo     2.  Compilar produccion (ng build --configuration production)
echo.
echo   %GREEN%SERVIDOR LOCAL%RESET%
echo     3.  Servir desarrollo (ng serve)
echo     4.  Servir con config produccion (ng serve --configuration production)
echo.
echo   %GREEN%CALIDAD%RESET%
echo     5.  Ejecutar tests (ng test)
echo     6.  Ejecutar linter (ng lint)
echo.
echo   %GREEN%MANTENIMIENTO%RESET%
echo     7.  Instalar dependencias (npm install)
echo     8.  Limpiar build (eliminar %OUTPUT_DIR%/, .angular/)
echo.
echo     0.  Salir
echo.
set /p "OPTION=  Seleccione una opcion: "

if "%OPTION%"=="1" goto :buildDev
if "%OPTION%"=="2" goto :buildProd
if "%OPTION%"=="3" goto :serve
if "%OPTION%"=="4" goto :serveProd
if "%OPTION%"=="5" goto :runTests
if "%OPTION%"=="6" goto :runLint
if "%OPTION%"=="7" goto :installDeps
if "%OPTION%"=="8" goto :clean
if "%OPTION%"=="0" goto :exitScript
goto :showMenu

:: ════════════════════════════════════════════════════════════
:: VALIDACIONES
:: ════════════════════════════════════════════════════════════
:checkNode
echo %CYAN%[INFO]%RESET% Verificando Node.js...
node --version >nul 2>&1
if errorlevel 1 (
    echo %RED%[ERROR]%RESET% Node.js no encontrado. Instale Node.js ^>= 18.
    exit /b 1
)
for /f "tokens=*" %%v in ('node --version') do echo %GREEN%[OK]%RESET% Node.js: %%v
exit /b 0

:checkNpm
echo %CYAN%[INFO]%RESET% Verificando npm...
npm --version >nul 2>&1
if errorlevel 1 (
    echo %RED%[ERROR]%RESET% npm no encontrado.
    exit /b 1
)
for /f "tokens=*" %%v in ('npm --version') do echo %GREEN%[OK]%RESET% npm: %%v
exit /b 0

:checkNodeModules
if not exist "%FRONTEND_DIR%node_modules" (
    echo %YELLOW%[WARN]%RESET% node_modules no encontrado. Instalando dependencias...
    pushd "%FRONTEND_DIR%"
    npm install
    popd
)
exit /b 0

:: ════════════════════════════════════════════════════════════
:: COMPILACION
:: ════════════════════════════════════════════════════════════
:buildDev
call :checkNode
if errorlevel 1 goto :endScript
call :checkNpm
if errorlevel 1 goto :endScript
call :checkNodeModules

echo.
echo %CYAN%[INFO]%RESET% Compilando en modo DESARROLLO...
echo %YELLOW%─────────────────────────────────────────────%RESET%
pushd "%FRONTEND_DIR%"
ng build
if errorlevel 1 (
    echo %RED%[ERROR]%RESET% Fallo la compilacion.
    popd
    goto :endScript
)
popd
echo.
echo %GREEN%[OK]%RESET% Build de desarrollo completado. Salida: %OUTPUT_DIR%/
goto :endScript

:buildProd
call :checkNode
if errorlevel 1 goto :endScript
call :checkNpm
if errorlevel 1 goto :endScript
call :checkNodeModules

echo.
echo %CYAN%[INFO]%RESET% Compilando en modo PRODUCCION...
echo %YELLOW%─────────────────────────────────────────────%RESET%
pushd "%FRONTEND_DIR%"
ng build --configuration production
if errorlevel 1 (
    echo %RED%[ERROR]%RESET% Fallo la compilacion de produccion.
    popd
    goto :endScript
)
popd
echo.
echo %GREEN%[OK]%RESET% Build de produccion completado. Salida: %OUTPUT_DIR%/
goto :endScript

:: ════════════════════════════════════════════════════════════
:: SERVIDOR LOCAL
:: ════════════════════════════════════════════════════════════
:serve
call :checkNode
if errorlevel 1 goto :endScript
call :checkNodeModules

echo.
echo %CYAN%[INFO]%RESET% Iniciando servidor de desarrollo...
echo %YELLOW%  Ctrl+C para detener%RESET%
echo %YELLOW%─────────────────────────────────────────────%RESET%
pushd "%FRONTEND_DIR%"
ng serve --open
popd
goto :endScript

:serveProd
call :checkNode
if errorlevel 1 goto :endScript
call :checkNodeModules

echo.
echo %CYAN%[INFO]%RESET% Iniciando servidor con configuracion de produccion...
echo %YELLOW%  Ctrl+C para detener%RESET%
echo %YELLOW%─────────────────────────────────────────────%RESET%
pushd "%FRONTEND_DIR%"
ng serve --configuration production --open
popd
goto :endScript

:: ════════════════════════════════════════════════════════════
:: CALIDAD
:: ════════════════════════════════════════════════════════════
:runTests
call :checkNode
if errorlevel 1 goto :endScript
call :checkNodeModules

echo.
echo %CYAN%[INFO]%RESET% Ejecutando tests unitarios...
echo %YELLOW%─────────────────────────────────────────────%RESET%
pushd "%FRONTEND_DIR%"
ng test --watch=false --browsers=ChromeHeadless
if errorlevel 1 (
    echo %RED%[ERROR]%RESET% Algunos tests fallaron.
) else (
    echo %GREEN%[OK]%RESET% Todos los tests pasaron.
)
popd
goto :endScript

:runLint
call :checkNode
if errorlevel 1 goto :endScript
call :checkNodeModules

echo.
echo %CYAN%[INFO]%RESET% Ejecutando linter...
echo %YELLOW%─────────────────────────────────────────────%RESET%
pushd "%FRONTEND_DIR%"
ng lint
if errorlevel 1 (
    echo %YELLOW%[WARN]%RESET% Se encontraron problemas de linting.
) else (
    echo %GREEN%[OK]%RESET% Codigo limpio, sin errores de lint.
)
popd
goto :endScript

:: ════════════════════════════════════════════════════════════
:: MANTENIMIENTO
:: ════════════════════════════════════════════════════════════
:installDeps
call :checkNode
if errorlevel 1 goto :endScript
call :checkNpm
if errorlevel 1 goto :endScript

echo.
echo %CYAN%[INFO]%RESET% Instalando dependencias...
pushd "%FRONTEND_DIR%"
npm install
if errorlevel 1 (
    echo %RED%[ERROR]%RESET% Fallo la instalacion de dependencias.
) else (
    echo %GREEN%[OK]%RESET% Dependencias instaladas correctamente.
)
popd
goto :endScript

:clean
echo.
echo %CYAN%[INFO]%RESET% Limpiando artefactos de compilacion...
pushd "%FRONTEND_DIR%"
if exist "%OUTPUT_DIR%" (
    rmdir /s /q "%OUTPUT_DIR%"
    echo %GREEN%[OK]%RESET% Eliminado: %OUTPUT_DIR%/
)
if exist ".angular" (
    rmdir /s /q ".angular"
    echo %GREEN%[OK]%RESET% Eliminado: .angular/
)
popd
echo %GREEN%[OK]%RESET% Limpieza completada.
goto :endScript

:: ════════════════════════════════════════════════════════════
:: AYUDA
:: ════════════════════════════════════════════════════════════
:showHelp
echo.
echo %CYAN%Uso:%RESET% build.bat ^<comando^>
echo.
echo %GREEN%Comandos de compilacion:%RESET%
echo   dev              Compilar en modo desarrollo
echo   prod             Compilar en modo produccion (optimizado)
echo.
echo %GREEN%Servidor local:%RESET%
echo   serve            Iniciar servidor de desarrollo (puerto 4200)
echo   serve-prod       Iniciar servidor con config produccion
echo.
echo %GREEN%Calidad:%RESET%
echo   test             Ejecutar tests unitarios (Karma/Jasmine)
echo   lint             Ejecutar linter (ESLint)
echo.
echo %GREEN%Mantenimiento:%RESET%
echo   install          Instalar dependencias (npm install)
echo   clean            Limpiar artefactos de compilacion
echo.
echo %GREEN%Otros:%RESET%
echo   menu             Mostrar menu interactivo
echo   help             Mostrar esta ayuda
echo.
echo %CYAN%Ejemplos:%RESET%
echo   build.bat dev
echo   build.bat prod
echo   build.bat serve
echo   build.bat test
echo   build.bat menu
echo.
goto :endScript

:exitScript
echo.
echo %GREEN%Hasta luego!%RESET%
:endScript
endlocal
