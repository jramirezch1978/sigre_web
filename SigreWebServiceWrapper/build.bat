@echo off
setlocal

echo ============================================================
echo   COMPILACION SIGRE WEB SERVICE WRAPPER
echo   DLL para PowerBuilder 2025 (External Functions)
echo ============================================================
echo.

REM Configurar variables
set "PROJECT_DIR=%~dp0"
set "OUTPUT_DIR_X86=%PROJECT_DIR%dll\x86"
set "OUTPUT_DIR_X64=%PROJECT_DIR%dll\x64"
set "RELEASE_DIR_X86=%PROJECT_DIR%bin\x86\Release\net48"
set "RELEASE_DIR_X64=%PROJECT_DIR%bin\x64\Release\net48"

REM Verificar que dotnet está disponible
where dotnet >nul 2>&1
if errorlevel 1 (
    echo ERROR: dotnet no encontrado en el PATH
    echo Instale .NET SDK desde https://dotnet.microsoft.com/download
    pause
    exit /b 1
)

echo [1/6] Restaurando paquetes NuGet...
echo ------------------------------------------------------------
dotnet restore
if errorlevel 1 (
    echo ERROR: Fallo la restauracion de paquetes
    pause
    exit /b 1
)
echo.

echo [2/6] Compilando para x86 (32 bits - PowerBuilder)...
echo ------------------------------------------------------------
dotnet build -c Release -p:Platform=x86
if errorlevel 1 (
    echo ERROR: Fallo la compilacion x86
    pause
    exit /b 1
)
echo.

echo [3/6] Compilando para x64 (64 bits)...
echo ------------------------------------------------------------
dotnet build -c Release -p:Platform=x64
if errorlevel 1 (
    echo ERROR: Fallo la compilacion x64
    pause
    exit /b 1
)
echo.

echo [4/6] Creando carpetas de salida...
echo ------------------------------------------------------------
if not exist "%OUTPUT_DIR_X86%" mkdir "%OUTPUT_DIR_X86%"
if not exist "%OUTPUT_DIR_X64%" mkdir "%OUTPUT_DIR_X64%"
echo Carpetas creadas.
echo.

echo [5/6] Copiando archivos x86 (32 bits)...
echo ------------------------------------------------------------

if exist "%RELEASE_DIR_X86%\SigreWebServiceWrapper.dll" (
    copy /Y "%RELEASE_DIR_X86%\SigreWebServiceWrapper.dll" "%OUTPUT_DIR_X86%\"
    echo [OK] x86\SigreWebServiceWrapper.dll
) else (
    echo [ERROR] No se encontro SigreWebServiceWrapper.dll x86
)

if exist "%RELEASE_DIR_X86%\SigreWebServiceWrapper.dll.config" (
    copy /Y "%RELEASE_DIR_X86%\SigreWebServiceWrapper.dll.config" "%OUTPUT_DIR_X86%\"
    echo [OK] x86\SigreWebServiceWrapper.dll.config
)

if exist "%RELEASE_DIR_X86%\Newtonsoft.Json.dll" (
    copy /Y "%RELEASE_DIR_X86%\Newtonsoft.Json.dll" "%OUTPUT_DIR_X86%\"
    echo [OK] x86\Newtonsoft.Json.dll
)

if exist "%RELEASE_DIR_X86%\SigreWebServiceWrapper.pdb" (
    copy /Y "%RELEASE_DIR_X86%\SigreWebServiceWrapper.pdb" "%OUTPUT_DIR_X86%\"
    echo [OK] x86\SigreWebServiceWrapper.pdb
)
echo.

echo [6/6] Copiando archivos x64 (64 bits)...
echo ------------------------------------------------------------

if exist "%RELEASE_DIR_X64%\SigreWebServiceWrapper.dll" (
    copy /Y "%RELEASE_DIR_X64%\SigreWebServiceWrapper.dll" "%OUTPUT_DIR_X64%\"
    echo [OK] x64\SigreWebServiceWrapper.dll
) else (
    echo [ERROR] No se encontro SigreWebServiceWrapper.dll x64
)

if exist "%RELEASE_DIR_X64%\SigreWebServiceWrapper.dll.config" (
    copy /Y "%RELEASE_DIR_X64%\SigreWebServiceWrapper.dll.config" "%OUTPUT_DIR_X64%\"
    echo [OK] x64\SigreWebServiceWrapper.dll.config
)

if exist "%RELEASE_DIR_X64%\Newtonsoft.Json.dll" (
    copy /Y "%RELEASE_DIR_X64%\Newtonsoft.Json.dll" "%OUTPUT_DIR_X64%\"
    echo [OK] x64\Newtonsoft.Json.dll
)

if exist "%RELEASE_DIR_X64%\SigreWebServiceWrapper.pdb" (
    copy /Y "%RELEASE_DIR_X64%\SigreWebServiceWrapper.pdb" "%OUTPUT_DIR_X64%\"
    echo [OK] x64\SigreWebServiceWrapper.pdb
)
echo.

echo ============================================================
echo   COMPILACION COMPLETADA EXITOSAMENTE
echo ============================================================
echo.
echo Archivos generados:
echo.
echo   [32 bits - PARA POWERBUILDER]
echo   %OUTPUT_DIR_X86%
dir "%OUTPUT_DIR_X86%" /B 2>nul
echo.
echo   [64 bits]
echo   %OUTPUT_DIR_X64%
dir "%OUTPUT_DIR_X64%" /B 2>nul
echo.
echo ------------------------------------------------------------
echo IMPORTANTE PARA POWERBUILDER (32 bits):
echo.
echo Copie los archivos de la carpeta dll\x86 a la carpeta
echo donde esta el ejecutable de PowerBuilder:
echo.
echo   - SigreWebServiceWrapper.dll
echo   - SigreWebServiceWrapper.dll.config
echo   - Newtonsoft.Json.dll
echo.
echo ------------------------------------------------------------
echo.
pause
endlocal
