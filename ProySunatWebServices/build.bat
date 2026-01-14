@echo off
setlocal

REM Guardar JAVA_HOME y PATH originales
set "ORIGINAL_JAVA_HOME=%JAVA_HOME%"
set "ORIGINAL_PATH=%PATH%"

echo ============================================================
echo   COMPILACION SUNAT WEB SERVICES
echo ============================================================
echo.

REM Configurar Java 1.8 (tiene SSL actualizado, genera bytecode Java 7)
set "JAVA_HOME=C:\Program Files\Java\jdk1.8.0_202"
set "PATH=%JAVA_HOME%\bin;%ORIGINAL_PATH%"

REM Maven 3.2.5 en carpeta del proyecto
set "MAVEN_HOME=%~dp0maven-3.2.5"

echo Verificando Java...
java -version
echo.

REM Verificar si Maven 3.2.5 existe, si no descargarlo
if not exist "%MAVEN_HOME%\bin\mvn.bat" (
    echo Maven 3.2.5 no encontrado. Descargando...
    echo.
    powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://archive.apache.org/dist/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.zip' -OutFile 'maven-3.2.5.zip'}"
    if errorlevel 1 (
        echo ERROR: No se pudo descargar Maven 3.2.5
        pause
        exit /b 1
    )
    echo Extrayendo...
    if exist "%MAVEN_HOME%" rmdir /s /q "%MAVEN_HOME%"
    powershell -Command "Expand-Archive -Path 'maven-3.2.5.zip' -DestinationPath '.' -Force"
    if exist "apache-maven-3.2.5" ren apache-maven-3.2.5 maven-3.2.5
    del maven-3.2.5.zip 2>nul
    echo Maven 3.2.5 instalado.
    echo.
)

REM Crear carpeta war si no existe
if not exist "war" mkdir war

echo [*] Compilando WAR con Maven 3.2.5...
echo ------------------------------------------------------------

call "%MAVEN_HOME%\bin\mvn.bat" clean package -DskipTests

if errorlevel 1 (
    echo.
    echo ERROR: Fallo la compilacion
    echo.
    set "JAVA_HOME=%ORIGINAL_JAVA_HOME%"
    set "PATH=%ORIGINAL_PATH%"
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

set "JAVA_HOME=%ORIGINAL_JAVA_HOME%"
set "PATH=%ORIGINAL_PATH%"
pause
endlocal
