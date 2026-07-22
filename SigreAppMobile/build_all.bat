@echo off
setlocal

echo ============================================================
echo   COMPILACION PROYECTO SIGRE - Android (Hermes)
echo ============================================================
echo.

REM La app nativa Android es "Hermes" (SigreAppMobile\Hermes). Delega la
REM compilacion a su propio build.bat, que ya resuelve JDK 17 y el keystore
REM de firma (Hermes\keystore.properties, git-ignorado - no viaja en el repo).
echo [*] Compilando Android (Hermes) APK/AAB firmados...
echo ------------------------------------------------------------
set "SIGRE_NESTED=1"
call "%~dp0Hermes\build.bat" release
set "SIGRE_NESTED="
if errorlevel 1 (
    echo ERROR: Fallo la compilacion de Android
    pause
    exit /b 1
)

if not exist "%~dp0APK" mkdir "%~dp0APK"
copy /y "%~dp0Hermes\app\build\outputs\apk\release\app-release.apk" "%~dp0APK\AppHermes.apk" >nul
copy /y "%~dp0Hermes\app\build\outputs\bundle\release\app-release.aab" "%~dp0APK\AppHermes.aab" >nul

echo [OK] Android (Hermes) compilado y copiado exitosamente
echo.

echo ============================================================
echo   COMPILACION COMPLETADA EXITOSAMENTE
echo ============================================================
echo.
echo Archivos generados:
echo   [Android] APK\AppHermes.apk
echo   [Android] APK\AppHermes.aab
echo.
endlocal
