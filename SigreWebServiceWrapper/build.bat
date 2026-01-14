@echo off
setlocal

echo ============================================================
echo   COMPILACION SIGRE WEB SERVICE WRAPPER
echo   DLL COM para PowerBuilder 2025
echo ============================================================
echo.

REM Configurar variables
set "PROJECT_DIR=%~dp0"
set "OUTPUT_DIR=%PROJECT_DIR%dll"
set "RELEASE_DIR=%PROJECT_DIR%bin\Release\net48"

REM Verificar que dotnet está disponible
where dotnet >nul 2>&1
if errorlevel 1 (
    echo ERROR: dotnet no encontrado en el PATH
    echo Instale .NET SDK desde https://dotnet.microsoft.com/download
    pause
    exit /b 1
)

echo [1/4] Restaurando paquetes NuGet...
echo ------------------------------------------------------------
dotnet restore
if errorlevel 1 (
    echo ERROR: Fallo la restauracion de paquetes
    pause
    exit /b 1
)
echo.

echo [2/4] Compilando proyecto en modo Release...
echo ------------------------------------------------------------
dotnet build -c Release
if errorlevel 1 (
    echo ERROR: Fallo la compilacion
    pause
    exit /b 1
)
echo.

echo [3/4] Creando carpeta de salida...
echo ------------------------------------------------------------
if not exist "%OUTPUT_DIR%" (
    mkdir "%OUTPUT_DIR%"
    echo Carpeta dll creada.
) else (
    echo Carpeta dll ya existe.
)
echo.

echo [4/4] Copiando archivos a carpeta dll...
echo ------------------------------------------------------------

REM Copiar DLL principal
if exist "%RELEASE_DIR%\SigreWebServiceWrapper.dll" (
    copy /Y "%RELEASE_DIR%\SigreWebServiceWrapper.dll" "%OUTPUT_DIR%\"
    echo [OK] SigreWebServiceWrapper.dll
) else (
    echo [ERROR] No se encontro SigreWebServiceWrapper.dll
)

REM Copiar archivo de configuracion
if exist "%RELEASE_DIR%\SigreWebServiceWrapper.dll.config" (
    copy /Y "%RELEASE_DIR%\SigreWebServiceWrapper.dll.config" "%OUTPUT_DIR%\"
    echo [OK] SigreWebServiceWrapper.dll.config
) else (
    echo [WARN] No se encontro SigreWebServiceWrapper.dll.config
)

REM Copiar dependencia Newtonsoft.Json
if exist "%RELEASE_DIR%\Newtonsoft.Json.dll" (
    copy /Y "%RELEASE_DIR%\Newtonsoft.Json.dll" "%OUTPUT_DIR%\"
    echo [OK] Newtonsoft.Json.dll
) else (
    echo [WARN] No se encontro Newtonsoft.Json.dll
)

REM Copiar archivo PDB (simbolos de debug, opcional)
if exist "%RELEASE_DIR%\SigreWebServiceWrapper.pdb" (
    copy /Y "%RELEASE_DIR%\SigreWebServiceWrapper.pdb" "%OUTPUT_DIR%\"
    echo [OK] SigreWebServiceWrapper.pdb
)

echo.
echo ============================================================
echo   COMPILACION COMPLETADA EXITOSAMENTE
echo ============================================================
echo.
echo Archivos generados en: %OUTPUT_DIR%
echo.
dir "%OUTPUT_DIR%" /B
echo.
echo ------------------------------------------------------------
echo IMPORTANTE: Para usar desde PowerBuilder, registre el DLL:
echo.
echo   1. Abra PowerShell como Administrador
echo   2. Ejecute: .\Registrar-COM.ps1
echo.
echo O manualmente:
echo   C:\Windows\Microsoft.NET\Framework64\v4.0.30319\RegAsm.exe /codebase "%OUTPUT_DIR%\SigreWebServiceWrapper.dll"
echo ------------------------------------------------------------
echo.
pause
endlocal
