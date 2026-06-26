@echo off
setlocal enabledelayedexpansion

REM =============================================
REM  Genera diagramas ER con SchemaSpy
REM  por cada base de datos del proyecto
REM =============================================

REM Cargar conexion desde archivo local (no versionado)
if not exist "%~dp0db-connection.local.bat" (
    echo [ERROR] No se encuentra db-connection.local.bat
    echo Copia db-connection.local.bat.example como db-connection.local.bat
    echo y completa los datos de conexion.
    exit /b 1
)
call "%~dp0db-connection.local.bat"

set SCHEMASPY_JAR=%~dp0drivers\schemaspy-6.2.4.jar
set PG_DRIVER=%~dp0drivers\postgresql-42.7.4.jar
set OUTPUT_DIR=%~dp0docs-schema

REM Validar que los JARs existen
if not exist "%SCHEMASPY_JAR%" (
    echo [ERROR] No se encuentra %SCHEMASPY_JAR%
    echo Descargalo de: https://github.com/schemaspy/schemaspy/releases
    exit /b 1
)
if not exist "%PG_DRIVER%" (
    echo [ERROR] No se encuentra %PG_DRIVER%
    echo Descargalo de: https://jdbc.postgresql.org/download/
    exit /b 1
)

REM =============================================
REM 1. Base de datos: restaurant_pe_security
REM    Schemas: master, config, auth, ...
REM =============================================
echo ========================================
echo   Security: restaurant_pe_security
echo ========================================
java -jar "%SCHEMASPY_JAR%" ^
  -t pgsql -dp "%PG_DRIVER%" ^
  -db restaurant_pe_security ^
  -host %DB_HOST% -port %DB_PORT% ^
  -u %DB_USER% -p %DB_PASS% ^
  -o "%OUTPUT_DIR%\security" ^
  -vizjs -nopages -all

if %ERRORLEVEL% neq 0 (
    echo [ERROR] Fallo la generacion para restaurant_pe_security
) else (
    echo [OK] Diagramas generados en %OUTPUT_DIR%\security\
)

REM =============================================
REM 2. Base de datos: restaurant_pe_emp_cantabria
REM    Schemas: core, almacen, compras, ventas, ...
REM =============================================
echo ========================================
echo   Tenant: restaurant_pe_emp_cantabria
echo ========================================
java -jar "%SCHEMASPY_JAR%" ^
  -t pgsql -dp "%PG_DRIVER%" ^
  -db restaurant_pe_emp_cantabria ^
  -host %DB_HOST% -port %DB_PORT% ^
  -u %DB_USER% -p %DB_PASS% ^
  -schemas "activos,almacen,auditoria,auth,compras,contabilidad,core,finanzas,produccion,rrhh,ventas" ^
  -o "%OUTPUT_DIR%\tenant" ^
  -vizjs -nopages

if %ERRORLEVEL% neq 0 (
    echo [ERROR] Fallo la generacion para restaurant_pe_emp_cantabria
) else (
    echo [OK] Diagramas generados en %OUTPUT_DIR%\tenant\
)

REM =============================================
REM Resumen final
REM =============================================
echo ========================================
echo   GENERACION COMPLETADA
echo ========================================
echo.
echo Abri en tu navegador:
echo   %OUTPUT_DIR%\security\index.html
echo   %OUTPUT_DIR%\tenant\index.html
echo.
pause
