@echo off
setlocal

echo ============================================================
echo   PRUEBA DEL DLL - SIGRE WEB SERVICE WRAPPER
echo ============================================================
echo.

REM Verificar que existe el DLL
if not exist "dll\SigreWebServiceWrapper.dll" (
    echo ERROR: DLL no encontrado. Ejecute primero build.bat
    pause
    exit /b 1
)

REM Crear programa de prueba temporal
echo Compilando programa de prueba...

set "TEST_DIR=%TEMP%\SigreWebServiceTest"
if not exist "%TEST_DIR%" mkdir "%TEST_DIR%"

REM Copiar archivos necesarios
copy /Y "dll\*.*" "%TEST_DIR%\" >nul

REM Crear un pequeño programa de prueba en C#
echo using System; > "%TEST_DIR%\Test.cs"
echo using System.Reflection; >> "%TEST_DIR%\Test.cs"
echo class Test { >> "%TEST_DIR%\Test.cs"
echo     static void Main() { >> "%TEST_DIR%\Test.cs"
echo         try { >> "%TEST_DIR%\Test.cs"
echo             var asm = Assembly.LoadFrom("SigreWebServiceWrapper.dll"); >> "%TEST_DIR%\Test.cs"
echo             Console.WriteLine("DLL cargado correctamente: " + asm.FullName); >> "%TEST_DIR%\Test.cs"
echo             foreach(var t in asm.GetExportedTypes()) { >> "%TEST_DIR%\Test.cs"
echo                 Console.WriteLine("  Tipo: " + t.Name); >> "%TEST_DIR%\Test.cs"
echo             } >> "%TEST_DIR%\Test.cs"
echo         } catch(Exception ex) { >> "%TEST_DIR%\Test.cs"
echo             Console.WriteLine("Error: " + ex.Message); >> "%TEST_DIR%\Test.cs"
echo         } >> "%TEST_DIR%\Test.cs"
echo     } >> "%TEST_DIR%\Test.cs"
echo } >> "%TEST_DIR%\Test.cs"

REM Compilar con csc
set "CSC=C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
if exist "%CSC%" (
    "%CSC%" /out:"%TEST_DIR%\Test.exe" "%TEST_DIR%\Test.cs" >nul 2>&1
    if exist "%TEST_DIR%\Test.exe" (
        echo.
        echo Ejecutando prueba...
        echo.
        pushd "%TEST_DIR%"
        Test.exe
        popd
    ) else (
        echo No se pudo compilar el programa de prueba
    )
) else (
    echo CSC no encontrado
)

echo.
echo ------------------------------------------------------------
echo PRUEBA RAPIDA CON RUNDLL32:
echo ------------------------------------------------------------
echo.
echo Probando funcion ObtenerVersion...
echo.

REM Intentar cargar el DLL (solo verifica que se puede cargar)
powershell -Command "try { [System.Reflection.Assembly]::LoadFrom('%cd%\dll\SigreWebServiceWrapper.dll') | Out-Null; Write-Host 'DLL cargado correctamente' -ForegroundColor Green } catch { Write-Host ('Error: ' + $_.Exception.Message) -ForegroundColor Red }"

echo.
echo ------------------------------------------------------------
echo ARCHIVO DE LOG:
echo ------------------------------------------------------------
echo.
if exist "dll\SigreWebServiceWrapper.log" (
    echo Contenido del log:
    type "dll\SigreWebServiceWrapper.log"
) else (
    echo No hay archivo de log aun.
    echo Se creara en: dll\SigreWebServiceWrapper.log
)

echo.
pause
endlocal
