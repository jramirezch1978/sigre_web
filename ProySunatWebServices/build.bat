@echo off
setlocal

echo ============================================================
echo   COMPILACION SUNAT WEB SERVICES
echo ============================================================
echo.

REM Verificar Java
echo Verificando Java...
java -version
echo.

REM Verificar Maven
where mvn >nul 2>&1
if errorlevel 1 (
    echo ERROR: Maven no esta instalado o no esta en el PATH.
    pause
    exit /b 1
)

REM Crear carpeta war si no existe
if not exist "war" mkdir war

echo [*] Compilando WAR con Maven...
echo ------------------------------------------------------------

call mvn clean package -DskipTests -q

if errorlevel 1 (
    echo.
    echo ERROR: Fallo la compilacion
    echo.
    pause
    exit /b 1
)

echo.
echo ============================================================
echo   COMPILACION COMPLETADA EXITOSAMENTE
echo ============================================================
echo.
echo Archivo generado:
echo   war\SunatWebServices.war
echo.

pause
endlocal
