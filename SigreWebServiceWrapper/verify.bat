@echo off
setlocal
cd /d "%~dp0"

echo ============================================================
echo   VERIFICADOR DE DLL - SigreWebServiceWrapper
echo ============================================================
echo.
echo   Carpeta: %CD%
echo.

REM --- Verificar archivos ---
echo [1] Verificando archivos...

if exist "SigreWebServiceWrapper.dll" (
    echo    [OK] SigreWebServiceWrapper.dll encontrado
) else (
    echo    [ERROR] SigreWebServiceWrapper.dll NO encontrado
    goto :END
)

if exist "SigreWebServiceWrapper.ini" (
    echo    [OK] SigreWebServiceWrapper.ini encontrado
) else (
    echo    [WARN] SigreWebServiceWrapper.ini no encontrado
)

REM --- Verificar exportaciones con rundll32 ---
echo.
echo [2] Verificando que el DLL carga correctamente...

rundll32.exe SigreWebServiceWrapper.dll,ObtenerVersion 2>nul
if errorlevel 1 (
    echo    [WARN] rundll32 retorno error (normal para funciones con retorno string)
) else (
    echo    [OK] DLL carga correctamente
)

REM --- Mostrar version usando PowerShell ---
echo.
echo [3] Probando funcion ObtenerVersion...

powershell -NoProfile -Command ^
    "$dll = Add-Type -MemberDefinition '[DllImport(\"SigreWebServiceWrapper.dll\", CharSet=CharSet.Unicode)] public static extern IntPtr ObtenerVersion();' -Name 'SigreAPI' -PassThru; $ptr = $dll::ObtenerVersion(); $ver = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($ptr); Write-Host '   Version: ' $ver" 2>nul

if errorlevel 1 (
    echo    [ERROR] No se pudo obtener la version
)

REM --- Mostrar configuracion ---
echo.
echo [4] Configuracion actual (SigreWebServiceWrapper.ini):
echo    ----------------------------------------
if exist "SigreWebServiceWrapper.ini" (
    for /f "tokens=*" %%a in ('type SigreWebServiceWrapper.ini ^| findstr /v "^;"') do (
        echo    %%a
    )
)
echo    ----------------------------------------

echo.
echo ============================================================
echo   VERIFICACION COMPLETADA
echo ============================================================
echo.
echo   Para usar en PowerBuilder:
echo     1. Copie SigreWebServiceWrapper.dll a la carpeta del EXE
echo     2. Copie SigreWebServiceWrapper.ini a la misma carpeta
echo     3. Configure las credenciales en el archivo INI
echo.

:END
pause
endlocal
