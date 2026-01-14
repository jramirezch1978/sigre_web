@echo off
setlocal

echo ============================================================
echo   COMPILACION SIGRE WEB SERVICE WRAPPER
echo   DLL para PowerBuilder 2025 (External Functions)
echo ============================================================
echo.

REM Configurar variables
set "PROJECT_DIR=%~dp0"
set "OUTPUT_DIR=%PROJECT_DIR%dll"
set "RELEASE_DIR=%PROJECT_DIR%bin\x64\Release\net48"

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

echo [2/4] Compilando proyecto en modo Release (x64)...
echo ------------------------------------------------------------
dotnet build -c Release -p:Platform=x64
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
    echo Buscando en: %RELEASE_DIR%
    pause
    exit /b 1
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
echo USO DESDE POWERBUILDER:
echo.
echo 1. Copie estos archivos a la carpeta de su aplicacion:
echo    - SigreWebServiceWrapper.dll
echo    - SigreWebServiceWrapper.dll.config
echo    - Newtonsoft.Json.dll
echo.
echo 2. Declare las funciones externas:
echo.
echo    FUNCTION string EnviarCorreo(string dest, string nombres, ^
echo        string asunto, string msg, boolean html, string adj) ^
echo        LIBRARY "SigreWebServiceWrapper.dll"
echo.
echo    FUNCTION string ObtenerTokenRest(string usuario, string clave, ^
echo        string empresa) LIBRARY "SigreWebServiceWrapper.dll"
echo.
echo    FUNCTION string ConsultarRucRest(string ruc, string rucOrigen, ^
echo        string computerName) LIBRARY "SigreWebServiceWrapper.dll"
echo.
echo ------------------------------------------------------------
echo.
pause
endlocal
