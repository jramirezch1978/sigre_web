@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

echo ============================================================
echo   SIGRE - Compilar TestDllRuc.exe
echo   (Enlace en tiempo de ejecucion via LoadLibrary/GetProcAddress)
echo ============================================================
echo.

set "CSC=C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe"
set "DLL_DIR=%~dp0..\SigreWebServiceWrapper\dll\x86"
set "OUT_DIR=%~dp0bin"

if not exist "%CSC%" (
    echo [ERROR] No se encontro csc.exe en: %CSC%
    pause
    exit /b 1
)

if not exist "%DLL_DIR%\SigreWebServiceWrapper.dll" (
    echo [WARN] No se encontro SigreWebServiceWrapper.dll en %DLL_DIR%
    echo [WARN] Compile el DLL C++ con build.bat de SigreWebServiceWrapper primero.
    echo [WARN] Se compilara el exe pero sin copiar el DLL.
)

echo [OK] csc.exe encontrado
echo.

if not exist "%OUT_DIR%" mkdir "%OUT_DIR%"

echo Compilando TestDllRuc.exe...
"%CSC%" /nologo /target:winexe /platform:x86 ^
    /reference:System.dll ^
    /reference:System.Core.dll ^
    /reference:System.Drawing.dll ^
    /reference:System.Windows.Forms.dll ^
    /out:"%OUT_DIR%\TestDllRuc.exe" ^
    "%~dp0TestDllRuc.cs"

if !errorlevel! neq 0 (
    echo.
    echo [ERROR] Error de compilacion.
    pause
    exit /b 1
)

echo [OK] TestDllRuc.exe compilado.
echo.

echo Copiando DLL C++ y configuracion...
if exist "%DLL_DIR%\SigreWebServiceWrapper.dll" (
    copy /y "%DLL_DIR%\SigreWebServiceWrapper.dll" "%OUT_DIR%\" >nul
    echo [OK] SigreWebServiceWrapper.dll copiado
)
if exist "%DLL_DIR%\SigreWebServiceWrapper.ini" (
    copy /y "%DLL_DIR%\SigreWebServiceWrapper.ini" "%OUT_DIR%\" >nul
    echo [OK] SigreWebServiceWrapper.ini copiado
)

echo.
echo ============================================================
echo   Listo! %OUT_DIR%\TestDllRuc.exe
echo   El DLL C++ se carga en ejecucion (LoadLibrary/GetProcAddress)
echo ============================================================
echo.

set /p EJECUTAR="Ejecutar ahora? (S/N): "
if /i "%EJECUTAR%"=="S" (
    start "" "%OUT_DIR%\TestDllRuc.exe"
)

endlocal
