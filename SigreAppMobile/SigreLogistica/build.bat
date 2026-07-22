@echo off
setlocal

REM ============================================================
REM   COMPILACION - SIGRE LOGISTICA (Android nativo)
REM   Proyecto independiente de FastSales/build_all.bat.
REM   Usa Java 17 (Gradle 8.9 / AGP 8.6), a diferencia de FastSales
REM   que no requiere el cambio de JDK 1.7 que usa el backend SOAP.
REM ============================================================

REM Posicionarse siempre en la carpeta del propio script (permite
REM invocarlo desde cualquier directorio, ej. build.bat del repo raiz).
cd /d "%~dp0"

REM Guardar JAVA_HOME y PATH originales para restaurar al final
set "ORIGINAL_JAVA_HOME=%JAVA_HOME%"
set "ORIGINAL_PATH=%PATH%"

REM Capturar el parametro (debug, release, clean)
set TARGET=%1
if "%TARGET%"=="" set TARGET=debug

REM Convertir a minusculas para comparacion
for %%i in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do call set TARGET=%%TARGET:%%i=%%i%%
set TARGET=%TARGET:A=a%
set TARGET=%TARGET:B=b%
set TARGET=%TARGET:C=c%
set TARGET=%TARGET:D=d%
set TARGET=%TARGET:E=e%
set TARGET=%TARGET:F=f%
set TARGET=%TARGET:G=g%
set TARGET=%TARGET:H=h%
set TARGET=%TARGET:I=i%
set TARGET=%TARGET:J=j%
set TARGET=%TARGET:K=k%
set TARGET=%TARGET:L=l%
set TARGET=%TARGET:M=m%
set TARGET=%TARGET:N=n%
set TARGET=%TARGET:O=o%
set TARGET=%TARGET:P=p%
set TARGET=%TARGET:Q=q%
set TARGET=%TARGET:R=r%
set TARGET=%TARGET:S=s%
set TARGET=%TARGET:T=t%
set TARGET=%TARGET:U=u%
set TARGET=%TARGET:V=v%
set TARGET=%TARGET:W=w%
set TARGET=%TARGET:X=x%
set TARGET=%TARGET:Y=y%
set TARGET=%TARGET:Z=z%

echo ============================================================
echo   COMPILACION SIGRE LOGISTICA (Android)
echo ============================================================
echo.

REM Validar parametro
if not "%TARGET%"=="debug" if not "%TARGET%"=="release" if not "%TARGET%"=="clean" (
    echo ERROR: Parametro invalido. Uso:
    echo   build.bat           - Compila APK debug ^(instalable directo, sin firma^)
    echo   build.bat debug     - Igual que sin parametro
    echo   build.bat release   - Compila APK+AAB release ^(sin firma configurada aun^)
    echo   build.bat clean     - Limpia el build ^(gradlew clean^)
    echo.
    pause
    exit /b 1
)

REM Buscar JDK 17 (requerido por compileOptions/kotlinOptions del proyecto)
set "JDK17=C:\Program Files\Java\jdk-17"
if not exist "%JDK17%\bin\java.exe" (
    echo ERROR: No se encontro JDK 17 en "%JDK17%".
    echo Ajusta la variable JDK17 en este script si esta en otra ruta.
    pause
    exit /b 1
)
set "JAVA_HOME=%JDK17%"
set "PATH=%JAVA_HOME%\bin;%ORIGINAL_PATH%"

echo Verificando Java...
java -version
echo.

REM NOTA: se invoca ".\gradlew.bat" (no "gradlew.bat" a secas) porque en
REM este entorno cmd.exe no resuelve el .bat del directorio actual sin el
REM prefijo de ruta explicito, aunque el archivo si este en el CWD.

if "%TARGET%"=="clean" (
    echo [*] Limpiando build...
    call .\gradlew.bat clean
    goto :restore_env
)

if "%TARGET%"=="debug" (
    echo [*] Compilando APK debug...
    echo ------------------------------------------------------------
    call .\gradlew.bat assembleDebug
    if errorlevel 1 goto :build_failed
    echo.
    echo [OK] APK debug compilado exitosamente
    echo   app\build\outputs\apk\debug\app-debug.apk
    goto :restore_env
)

if "%TARGET%"=="release" (
    echo [*] Compilando APK+AAB release...
    echo ------------------------------------------------------------
    echo NOTA: aun no hay signingConfig de release configurado en
    echo app\build.gradle.kts ^(sin keystore^) - el artefacto sale sin firmar.
    echo.
    call .\gradlew.bat assembleRelease bundleRelease
    if errorlevel 1 goto :build_failed
    echo.
    echo [OK] Release compilado exitosamente
    echo   app\build\outputs\apk\release\app-release-unsigned.apk
    echo   app\build\outputs\bundle\release\app-release.aab
    goto :restore_env
)

:build_failed
echo.
echo ERROR: Fallo la compilacion de SIGRE Logistica
echo.
set "JAVA_HOME=%ORIGINAL_JAVA_HOME%"
set "PATH=%ORIGINAL_PATH%"
pause
exit /b 1

:restore_env
set "JAVA_HOME=%ORIGINAL_JAVA_HOME%"
set "PATH=%ORIGINAL_PATH%"

echo.
echo ============================================================
echo   COMPILACION COMPLETADA
echo ============================================================
echo.
echo Variables de entorno restauradas.
pause
endlocal
