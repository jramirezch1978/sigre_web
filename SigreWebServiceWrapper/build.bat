@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"
set "PROJECT_DIR=%~dp0"

echo ============================================================
echo   COMPILACION DLL C++ PARA POWERBUILDER
echo ============================================================
echo.

REM --- Crear carpetas ---
if not exist "dll\x86" mkdir "dll\x86"
if not exist "dll\x64" mkdir "dll\x64"

REM --- Buscar Visual Studio con vswhere ---
echo [1/4] Buscando compilador de C++...

set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
set "VS_PATH="
set "VS_X64_VARS="
set "COMPILER_TYPE="

if exist "%VSWHERE%" (
    for /f "usebackq tokens=*" %%i in (`"%VSWHERE%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
        set "VS_PATH=%%i"
    )
)

if not "%VS_PATH%"=="" (
    echo    Visual Studio encontrado: %VS_PATH%
    
    if exist "%VS_PATH%\VC\Auxiliary\Build\vcvars32.bat" (
        set "COMPILER_TYPE=MSVC"
    ) else (
        echo ERROR: vcvars32.bat no encontrado.
        echo Instale "Desarrollo para escritorio con C++" desde Visual Studio Installer.
        goto :ERROR
    )
) else (
    echo ERROR: No se encontro Visual Studio con herramientas C++.
    echo.
    echo Por favor instale:
    echo   1. Abra Visual Studio Installer
    echo   2. Modifique Visual Studio 2022
    echo   3. Seleccione "Desarrollo para escritorio con C++"
    echo   4. Instale y reintente
    goto :ERROR
)

REM --- Compilar x86 ---
echo [2/4] Compilando DLL x86 (32 bits)...
call "%VS_PATH%\VC\Auxiliary\Build\vcvars32.bat" >nul 2>&1

cl /LD /EHsc /O2 /W3 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_USRDLL" ^
    /Fo"dll\x86\SigreWrapper.obj" /Fe"dll\x86\SigreWebServiceWrapper.dll" SigreWrapper.cpp ^
    /link /DEF:SigreWrapper.def winhttp.lib shlwapi.lib ole32.lib oleaut32.lib user32.lib

if errorlevel 1 (
    echo ERROR: Fallo la compilacion x86
    goto :ERROR
)
echo    [OK] DLL x86 compilada

REM --- Compilar x64 ---
echo [3/4] Compilando DLL x64 (64 bits)...
if exist "%VS_PATH%\VC\Auxiliary\Build\vcvars64.bat" (
    call "%VS_PATH%\VC\Auxiliary\Build\vcvars64.bat" >nul 2>&1
    
    cl /LD /EHsc /O2 /W3 /D "WIN64" /D "NDEBUG" /D "_WINDOWS" /D "_USRDLL" ^
        /Fo"dll\x64\SigreWrapper.obj" /Fe"dll\x64\SigreWebServiceWrapper.dll" SigreWrapper.cpp ^
        /link /DEF:SigreWrapper.def winhttp.lib shlwapi.lib ole32.lib oleaut32.lib user32.lib
    
    if errorlevel 1 (
        echo    [WARN] Fallo la compilacion x64
    ) else (
        echo    [OK] DLL x64 compilada
    )
) else (
    echo    [SKIP] vcvars64.bat no encontrado, saltando x64
)

REM --- Copiar INI y verify.bat ---
echo [4/4] Copiando archivos de configuracion...
if exist "SigreWebServiceWrapper.ini" (
    copy /Y "SigreWebServiceWrapper.ini" "dll\x86\" >nul
    copy /Y "SigreWebServiceWrapper.ini" "dll\x64\" >nul
    echo    [OK] Archivo INI copiado
)
if exist "verify.bat" (
    copy /Y "verify.bat" "dll\x86\" >nul
    copy /Y "verify.bat" "dll\x64\" >nul
    echo    [OK] Archivo verify.bat copiado
)

REM --- Verificar exportaciones ---
echo.
echo ============================================================
echo   VERIFICANDO EXPORTACIONES
echo ============================================================

where dumpbin >nul 2>&1
if errorlevel 1 (
    echo    [SKIP] dumpbin no disponible
) else (
    echo.
    echo --- DLL x86 ---
    dumpbin /exports "dll\x86\SigreWebServiceWrapper.dll" 2>nul | findstr /C:"ObtenerVersion" /C:"EnviarEmail" /C:"ConsultarRuc" /C:"ObtenerTokenRest" /C:"ObtenerConfiguracion" /C:"ConfigurarCredencialesRuc"
)

echo.
echo ============================================================
echo   COMPILACION EXITOSA
echo ============================================================
echo.
echo   Archivos generados:
echo     - dll\x86\SigreWebServiceWrapper.dll (32 bits)
echo     - dll\x64\SigreWebServiceWrapper.dll (64 bits)
echo     - dll\x86\SigreWebServiceWrapper.ini
echo     - dll\x64\SigreWebServiceWrapper.ini
echo     - dll\x86\verify.bat (verificador)
echo     - dll\x64\verify.bat (verificador)
echo.
echo   Para usar en PowerBuilder:
echo     1. Copie dll\x86\SigreWebServiceWrapper.dll a su carpeta EXE
echo     2. Copie dll\x86\SigreWebServiceWrapper.ini a la misma carpeta
echo     3. Configure el archivo INI con sus credenciales SMTP
echo.
goto :END

:ERROR
echo.
echo ============================================================
echo   ERROR EN LA COMPILACION
echo ============================================================
pause
exit /b 1

:END
pause
endlocal
