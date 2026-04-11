@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

REM ============================================================
REM   verify.bat - Verificador completo de SigreWebServiceWrapper.dll
REM   Prueba: Version, IP, Configurar, Token, Consultar RUC
REM ============================================================

REM --- Detectar carpeta de la DLL ---
set "DLL_DIR=%~dp0"
if exist "%~dp0dll\x86\SigreWebServiceWrapper.dll" set "DLL_DIR=%~dp0dll\x86\"
if not "%~1"=="" if exist "%~1\SigreWebServiceWrapper.dll" set "DLL_DIR=%~1\"

REM --- Parametros de prueba ---
set "TEST_USUARIO=sigre"
set "TEST_CLAVE=sigre1234"
set "TEST_EMPRESA=TRANSMARINA"
set "TEST_RUC=10056450608"
set "TEST_RUC_ORIGEN=20100070970"

REM --- Generar script temporal ---
set "TEMP_PS=%TEMP%\verify_sigre_%RANDOM%.ps1"

> "%TEMP_PS%" (
echo $ErrorActionPreference = 'Continue'
echo.
echo Write-Host ''
echo Write-Host '============================================================' -ForegroundColor Cyan
echo Write-Host '  VERIFICADOR DE DLL - SigreWebServiceWrapper' -ForegroundColor Cyan
echo Write-Host '============================================================' -ForegroundColor Cyan
echo Write-Host ''
echo.
echo $dllDir = '%DLL_DIR%'.TrimEnd('\')
echo $dllPath = Join-Path $dllDir 'SigreWebServiceWrapper.dll'
echo $iniPath = Join-Path $dllDir 'SigreWebServiceWrapper.ini'
echo.
echo Write-Host "  Carpeta: $dllDir" -ForegroundColor Gray
echo Write-Host ''
echo.
echo # --- [1] Verificar archivos ---
echo Write-Host '[1] Verificando archivos...' -ForegroundColor Yellow
echo.
echo if (-not ^(Test-Path $dllPath^)^) {
echo     Write-Host '   [ERROR] SigreWebServiceWrapper.dll NO encontrado' -ForegroundColor Red
echo     exit 1
echo }
echo $fi = Get-Item $dllPath
echo $kb = [math]::Round^($fi.Length / 1KB, 1^)
echo Write-Host "   [OK] SigreWebServiceWrapper.dll ($kb KB, $($fi.LastWriteTime.ToString('yyyy-MM-dd HH:mm')))" -ForegroundColor Green
echo.
echo if ^(Test-Path $iniPath^) {
echo     Write-Host '   [OK] SigreWebServiceWrapper.ini encontrado' -ForegroundColor Green
echo } else {
echo     Write-Host '   [WARN] SigreWebServiceWrapper.ini no encontrado' -ForegroundColor Yellow
echo }
echo Write-Host ''
echo.
echo # --- [2] Cargar DLL via P/Invoke ---
echo Write-Host '[2] Cargando DLL via P/Invoke...' -ForegroundColor Yellow
echo.
echo $fullPath = ^(Resolve-Path $dllPath^).Path
echo $escaped = $fullPath.Replace('\', '\\')
echo.
echo $src = @"
echo using System;
echo using System.Runtime.InteropServices;
echo public class SigreV {
echo     [DllImport("$escaped", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Unicode)]
echo     public static extern IntPtr ObtenerVersion^(^);
echo     [DllImport("$escaped", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Unicode)]
echo     public static extern IntPtr ObtenerIpLocal^(^);
echo     [DllImport("$escaped", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Unicode)]
echo     public static extern IntPtr ObtenerConfiguracion^(^);
echo     [DllImport("$escaped", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Unicode)]
echo     public static extern IntPtr ConfigurarCredencialesRuc^(
echo         [MarshalAs(UnmanagedType.LPWStr)] string u,
echo         [MarshalAs(UnmanagedType.LPWStr)] string c,
echo         [MarshalAs(UnmanagedType.LPWStr)] string e2,
echo         [MarshalAs(UnmanagedType.LPWStr)] string ip,
echo         [MarshalAs(UnmanagedType.LPWStr)] string pc^);
echo     [DllImport("$escaped", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Unicode)]
echo     public static extern IntPtr ObtenerTokenRest^(
echo         [MarshalAs(UnmanagedType.LPWStr)] string u,
echo         [MarshalAs(UnmanagedType.LPWStr)] string c,
echo         [MarshalAs(UnmanagedType.LPWStr)] string e2,
echo         [MarshalAs(UnmanagedType.LPWStr)] string ip,
echo         [MarshalAs(UnmanagedType.LPWStr)] string pc^);
echo     [DllImport("$escaped", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Unicode)]
echo     public static extern IntPtr ConsultarRuc^(
echo         [MarshalAs(UnmanagedType.LPWStr)] string ruc,
echo         [MarshalAs(UnmanagedType.LPWStr)] string rucOrigen^);
echo     public static string R^(IntPtr p^) {
echo         if ^(p == IntPtr.Zero^) return "(null)";
echo         return Marshal.PtrToStringUni^(p^) ?? "(null)";
echo     }
echo }
echo "@
echo.
echo try {
echo     Add-Type -TypeDefinition $src -ErrorAction Stop
echo     Write-Host '   [OK] DLL cargada correctamente' -ForegroundColor Green
echo } catch {
echo     Write-Host "   [ERROR] No se pudo cargar: $($_.Exception.Message)" -ForegroundColor Red
echo     exit 1
echo }
echo Write-Host ''
echo.
echo # --- [3] Probar ObtenerVersion ---
echo Write-Host '[3] Probando ObtenerVersion...' -ForegroundColor Yellow
echo try {
echo     $ver = [SigreV]::R^([SigreV]::ObtenerVersion^(^)^)
echo     Write-Host "   Version: $ver" -ForegroundColor Green
echo } catch {
echo     Write-Host "   [ERROR] $($_.Exception.Message)" -ForegroundColor Red
echo }
echo Write-Host ''
echo.
echo # --- [4] Probar ObtenerIpLocal ---
echo Write-Host '[4] Probando ObtenerIpLocal...' -ForegroundColor Yellow
echo try {
echo     $ip = [SigreV]::R^([SigreV]::ObtenerIpLocal^(^)^)
echo     Write-Host "   IP Local: $ip" -ForegroundColor Green
echo } catch {
echo     Write-Host "   [ERROR] $($_.Exception.Message)" -ForegroundColor Red
echo     $ip = '127.0.0.1'
echo }
echo Write-Host ''
echo.
echo # --- [5] Configurar credenciales ---
echo Write-Host '[5] ConfigurarCredencialesRuc...' -ForegroundColor Yellow
echo $pc = $env:COMPUTERNAME
echo Write-Host "   Usuario:  %TEST_USUARIO%" -ForegroundColor Gray
echo Write-Host "   Empresa:  %TEST_EMPRESA%" -ForegroundColor Gray
echo Write-Host "   IP Local: $ip" -ForegroundColor Gray
echo Write-Host "   Equipo:   $pc" -ForegroundColor Gray
echo try {
echo     $r = [SigreV]::R^([SigreV]::ConfigurarCredencialesRuc^('%TEST_USUARIO%', '%TEST_CLAVE%', '%TEST_EMPRESA%', $ip, $pc^)^)
echo     Write-Host "   Resultado: $r" -ForegroundColor Green
echo } catch {
echo     Write-Host "   [ERROR] $($_.Exception.Message)" -ForegroundColor Red
echo }
echo Write-Host ''
echo.
echo # --- [6] Obtener Token JWT ---
echo Write-Host '[6] ObtenerTokenRest...' -ForegroundColor Yellow
echo try {
echo     $token = [SigreV]::R^([SigreV]::ObtenerTokenRest^('%TEST_USUARIO%', '%TEST_CLAVE%', '%TEST_EMPRESA%', $ip, $pc^)^)
echo     if ^($token.Length -gt 50^) {
echo         Write-Host "   Token obtenido: $($token.Substring(0, 50))..." -ForegroundColor Green
echo         Write-Host "   Token length: $($token.Length) caracteres" -ForegroundColor Gray
echo     } else {
echo         Write-Host "   Respuesta: $token" -ForegroundColor Yellow
echo     }
echo } catch {
echo     Write-Host "   [ERROR] $($_.Exception.Message)" -ForegroundColor Red
echo     $token = ''
echo }
echo Write-Host ''
echo.
echo # --- [7] Consultar RUC ---
echo Write-Host '[7] ConsultarRuc(%TEST_RUC%)...' -ForegroundColor Yellow
echo Write-Host "   RUC Consulta: %TEST_RUC%" -ForegroundColor Gray
echo Write-Host "   RUC Origen:   %TEST_RUC_ORIGEN%" -ForegroundColor Gray
echo try {
echo     $ruc = [SigreV]::R^([SigreV]::ConsultarRuc^('%TEST_RUC%', '%TEST_RUC_ORIGEN%'^)^)
echo     Write-Host ''
echo     if ^($ruc -match '"success"\s*:\s*true'^) {
echo         Write-Host '   [OK] RUC ENCONTRADO' -ForegroundColor Green
echo         try {
echo             $obj = $ruc ^| ConvertFrom-Json
echo             if ^($obj.data^) {
echo                 Write-Host "   RUC:          $($obj.data.ruc)" -ForegroundColor White
echo                 Write-Host "   Razon Social: $($obj.data.razonSocial)" -ForegroundColor White
echo                 Write-Host "   Estado:       $($obj.data.estado)" -ForegroundColor White
echo                 Write-Host "   Condicion:    $($obj.data.condicion)" -ForegroundColor White
echo                 Write-Host "   Departamento: $($obj.data.descDepartamento)" -ForegroundColor Gray
echo                 Write-Host "   Provincia:    $($obj.data.descProvincia)" -ForegroundColor Gray
echo                 Write-Host "   Distrito:     $($obj.data.descDistrito)" -ForegroundColor Gray
echo                 $dir = @($obj.data.tipoVia, $obj.data.nombreVia, $obj.data.numero^) -join ' '
echo                 Write-Host "   Direccion:    $($dir.Trim())" -ForegroundColor Gray
echo             }
echo         } catch {
echo             Write-Host "   JSON: $ruc" -ForegroundColor Gray
echo         }
echo     } elseif ^($ruc -match 'exitoso.*false' -or $ruc -match '"success"\s*:\s*false'^) {
echo         Write-Host '   [WARN] RUC no encontrado o error' -ForegroundColor Yellow
echo         Write-Host "   Respuesta: $ruc" -ForegroundColor Gray
echo     } else {
echo         Write-Host "   Respuesta: $ruc" -ForegroundColor Gray
echo     }
echo } catch {
echo     Write-Host "   [ERROR] $($_.Exception.Message)" -ForegroundColor Red
echo }
echo Write-Host ''
echo.
echo # --- [8] Configuracion INI ---
echo Write-Host '[8] Configuracion (SigreWebServiceWrapper.ini):' -ForegroundColor Yellow
echo Write-Host '   ----------------------------------------'
echo if ^(Test-Path $iniPath^) {
echo     Get-Content $iniPath ^| ForEach-Object {
echo         if ^($_ -match 'Password^|Secret^|Token^|AccessKey'^) {
echo             $parts = $_ -split '=', 2
echo             if ^($parts.Length -eq 2 -and $parts[1].Length -gt 4^) {
echo                 $masked = $parts[1].Substring^(0, 3^) + ^('*' * [Math]::Min^($parts[1].Length - 3, 10^)^)
echo                 Write-Host "   $($parts[0])=$masked" -ForegroundColor Gray
echo             } else { Write-Host "   $_" -ForegroundColor Gray }
echo         } else { Write-Host "   $_" -ForegroundColor Gray }
echo     }
echo } else { Write-Host '   Archivo INI no encontrado' -ForegroundColor Yellow }
echo Write-Host '   ----------------------------------------'
echo.
echo Write-Host ''
echo Write-Host '============================================================' -ForegroundColor Cyan
echo Write-Host '  VERIFICACION COMPLETADA' -ForegroundColor Cyan
echo Write-Host '============================================================' -ForegroundColor Cyan
echo Write-Host ''
)

REM --- Ejecutar script temporal ---
powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP_PS%"

REM --- Limpiar ---
del "%TEMP_PS%" >nul 2>&1

pause
endlocal
