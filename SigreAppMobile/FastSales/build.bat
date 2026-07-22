@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM  FastSales (AppSIGRE) - Compilar APK/AAB firmados en APK\
REM  Firma: Signed_APK (keystore en app/build.gradle)
REM  Uso:
REM    build.bat              clean + assembleRelease + bundleRelease
REM    build.bat --skip-clean Solo assembleRelease + bundleRelease
REM    build.bat --apk-only   Solo APK firmado (AppSIGRE.apk)
REM    build.bat --aab-only   Solo AAB firmado (AppSIGRE.aab)
REM    build.bat --verify     Solo verifica prerequisitos
REM ============================================================

set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

set "OUTPUT_DIR=%SCRIPT_DIR%..\APK"
set "KEYSTORE=%SCRIPT_DIR%Signed_APK"
set "GRADLEW=%SCRIPT_DIR%gradlew.bat"

set "SKIP_CLEAN=0"
set "VERIFY_ONLY=0"
set "BUILD_APK=1"
set "BUILD_AAB=1"

:parse_args
if "%~1"=="" goto :args_done
if /i "%~1"=="--skip-clean" set "SKIP_CLEAN=1"
if /i "%~1"=="--verify" set "VERIFY_ONLY=1"
if /i "%~1"=="--apk-only" (
    set "BUILD_APK=1"
    set "BUILD_AAB=0"
)
if /i "%~1"=="--aab-only" (
    set "BUILD_APK=0"
    set "BUILD_AAB=1"
)
if /i "%~1"=="-h" goto :show_help
if /i "%~1"=="--help" goto :show_help
shift
goto :parse_args

:args_done

echo ============================================================
echo   FastSales (AppSIGRE) - BUILD APK/AAB FIRMADO
echo ============================================================
echo   Proyecto : %SCRIPT_DIR%
echo   Salida   : %OUTPUT_DIR%\
if "%BUILD_APK%"=="1" echo              AppSIGRE.apk
if "%BUILD_AAB%"=="1" echo              AppSIGRE.aab
echo   Firma    : %KEYSTORE%
echo ============================================================
echo.

set "ORIGINAL_JAVA_HOME=%JAVA_HOME%"
set "ORIGINAL_PATH=%PATH%"

call :setup_java
if errorlevel 1 goto :fail

call :setup_signing
if errorlevel 1 goto :fail

call :setup_gradle
if errorlevel 1 goto :fail

call :show_version
echo.

if "%VERIFY_ONLY%"=="1" (
    echo [OK] Prerequisitos verificados. Listo para compilar.
    goto :success_exit
)

echo [*] Compilando con Gradle ^(release firmado^)...
echo ------------------------------------------------------------

set "GRADLE_TASKS="
if "%SKIP_CLEAN%"=="0" set "GRADLE_TASKS=clean"
if "%BUILD_APK%"=="1" (
    if defined GRADLE_TASKS (
        set "GRADLE_TASKS=!GRADLE_TASKS! assembleRelease"
    ) else (
        set "GRADLE_TASKS=assembleRelease"
    )
)
if "%BUILD_AAB%"=="1" (
    if defined GRADLE_TASKS (
        set "GRADLE_TASKS=!GRADLE_TASKS! bundleRelease"
    ) else (
        set "GRADLE_TASKS=bundleRelease"
    )
)

call "%GRADLEW%" !GRADLE_TASKS!
if errorlevel 1 (
    echo.
    echo [ERROR] Fallo la compilacion Gradle.
    goto :fail
)

set "BUILD_OK=1"

if "%BUILD_APK%"=="1" call :verify_output "%OUTPUT_DIR%\AppSIGRE.apk" "APK"
if errorlevel 1 set "BUILD_OK=0"

if "%BUILD_AAB%"=="1" call :verify_output "%OUTPUT_DIR%\AppSIGRE.aab" "AAB"
if errorlevel 1 set "BUILD_OK=0"

if "!BUILD_OK!"=="0" goto :fail

echo.
echo [OK] Build Android completado.
goto :success_exit

:show_help
echo.
echo Uso:
echo   build.bat              Compila APK y AAB firmados ^(clean + release^)
echo   build.bat --skip-clean Compila sin clean
echo   build.bat --apk-only   Solo genera AppSIGRE.apk
echo   build.bat --aab-only   Solo genera AppSIGRE.aab
echo   build.bat --verify     Verifica Java, keystore y Gradle
echo.
echo Nota: app/build.gradle copia los artefactos a ..\APK\
echo       y puede incrementar version.properties al finalizar.
goto :success_exit

:setup_java
echo [1/4] Configurando Java para Android ^(JDK 17 recomendado^)...

set "JDK17=C:\Program Files\Java\jdk-17"
if not exist "%JDK17%\bin\java.exe" set "JDK17=C:\Program Files\Java\jdk-17.0.12"
if not exist "%JDK17%\bin\java.exe" set "JDK17=C:\Program Files\Eclipse Adoptium\jdk-17"

if exist "%JDK17%\bin\java.exe" (
    set "JAVA_HOME=%JDK17%"
    set "PATH=%JAVA_HOME%\bin;%ORIGINAL_PATH%"
    echo [OK] JAVA_HOME=%JAVA_HOME%
) else (
    echo [ADVERTENCIA] No se encontro JDK 17 en rutas conocidas.
    echo               Se usara Java del PATH actual.
)

java -version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Java no disponible en PATH.
    exit /b 1
)
java -version 2>&1 | findstr /i "version"
exit /b 0

:setup_signing
echo.
echo [2/4] Verificando keystore de firma...

if not exist "%KEYSTORE%" (
    echo [ERROR] No se encontro el keystore: %KEYSTORE%
    echo         La firma release usa Signed_APK ^(alias FastSales^).
    exit /b 1
)

for %%A in ("%KEYSTORE%") do set "KEYSTORE_SIZE=%%~zA"
echo [OK] Keystore encontrado ^(!KEYSTORE_SIZE! bytes^)
echo      Alias: FastSales ^(configurado en app/build.gradle^)
exit /b 0

:setup_gradle
echo.
echo [3/4] Verificando Gradle Wrapper...

if not exist "%GRADLEW%" (
    echo [ERROR] No se encontro gradlew.bat en %SCRIPT_DIR%
    exit /b 1
)

echo [OK] Gradle Wrapper: %GRADLEW%
exit /b 0

:show_version
echo [4/4] Version actual del proyecto...

set "VERSION_FILE=%SCRIPT_DIR%app\version.properties"
if not exist "%VERSION_FILE%" (
    echo [ADVERTENCIA] No se encontro app\version.properties
    exit /b 0
)

for /f "usebackq tokens=1,* delims==" %%A in ("%VERSION_FILE%") do (
    set "LINE=%%A"
    if not "!LINE!"=="" if not "!LINE:~0,1!"=="#" (
        if "%%A"=="VERSION_CODE" set "VER_CODE=%%B"
        if "%%A"=="VERSION_MAJOR" set "VER_MAJOR=%%B"
        if "%%A"=="VERSION_MINOR" set "VER_MINOR=%%B"
        if "%%A"=="VERSION_PATCH" set "VER_PATCH=%%B"
    )
)

if defined VER_CODE (
    echo [OK] Version: !VER_MAJOR!.!VER_MINOR!.!VER_PATCH! ^(code !VER_CODE!^)
) else (
    echo [ADVERTENCIA] No se pudo leer version.properties
)
exit /b 0

:verify_output
set "OUT_FILE=%~1"
set "OUT_LABEL=%~2"

if not exist "%OUT_FILE%" (
    echo.
    echo [ERROR] No se genero el %OUT_LABEL% esperado:
    echo         %OUT_FILE%
    exit /b 1
)

for %%A in ("%OUT_FILE%") do set "OUT_SIZE=%%~zA"
echo [OK] %OUT_LABEL% generado: %OUT_FILE%
echo      Tamano: !OUT_SIZE! bytes
exit /b 0

:fail
echo.
echo ============================================================
echo   BUILD FALLIDO
echo ============================================================
goto :restore_and_exit 1

:success_exit
echo.
echo ============================================================
echo   BUILD COMPLETADO
echo ============================================================
goto :restore_and_exit 0

:restore_and_exit
set "JAVA_HOME=%ORIGINAL_JAVA_HOME%"
set "PATH=%ORIGINAL_PATH%"
endlocal & exit /b %1
