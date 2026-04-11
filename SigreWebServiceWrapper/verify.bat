@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

REM ============================================================
REM  verify.bat - Verificador de SigreWebServiceWrapper.dll
REM  Uso: verify.bat [x86|x64]
REM    x86 = forzar DLL 32-bit con PowerShell 32-bit
REM    x64 = forzar DLL 64-bit con PowerShell 64-bit
REM    (sin argumento = auto-detectar)
REM ============================================================

REM --- Procesar argumento x86/x64 (default: x86) ---
set "FORCE_ARCH=x86"
if /i "%~1"=="x64" set "FORCE_ARCH=x64"

REM --- Detectar carpeta de la DLL ---
set "DLL_DIR=%~dp0"
set "DLL_ARCH=unknown"

if "!FORCE_ARCH!"=="x86" (
    if exist "%~dp0dll\x86\SigreWebServiceWrapper.dll" (
        set "DLL_DIR=%~dp0dll\x86\"
        set "DLL_ARCH=x86"
    ) else (
        set "DLL_ARCH=x86"
    )
) else if "!FORCE_ARCH!"=="x64" (
    if exist "%~dp0dll\x64\SigreWebServiceWrapper.dll" (
        set "DLL_DIR=%~dp0dll\x64\"
        set "DLL_ARCH=x64"
    ) else (
        set "DLL_ARCH=x64"
    )
) else (
    if exist "%~dp0dll\x86\SigreWebServiceWrapper.dll" (
        set "DLL_DIR=%~dp0dll\x86\"
        set "DLL_ARCH=x86"
    )
    if exist "%~dp0dll\x64\SigreWebServiceWrapper.dll" (
        if "!DLL_ARCH!"=="unknown" (
            set "DLL_DIR=%~dp0dll\x64\"
            set "DLL_ARCH=x64"
        )
    )
)

REM --- Parametros de prueba (modificar segun entorno) ---
set "TEST_USUARIO=sigre"
set "TEST_CLAVE=sigre1234"
set "TEST_EMPRESA=TRANSMARINA"
set "TEST_RUC=10056450608"
set "TEST_RUC_ORIGEN=20100070970"

REM --- Extraer script PS1 embebido en este BAT ---
set "TEMP_PS=%TEMP%\verify_sigre_%RANDOM%.ps1"
set /a "SKIP=0"
for /f "delims=:" %%n in ('findstr /n /b /c:"#__PS1__" "%~f0"') do set /a "SKIP=%%n"
if !SKIP! equ 0 (
    echo ERROR: No se encontro el marcador del script PowerShell
    pause
    exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "(Get-Content -Path '%~f0' -Encoding Default) | Select-Object -Skip %SKIP% | Set-Content -Path '%TEMP_PS%' -Encoding UTF8"

REM --- Elegir PowerShell segun arquitectura de la DLL ---
REM    DLL x86 (PowerBuilder 32-bit) -> PowerShell 32-bit
REM    DLL x64 -> PowerShell 64-bit (default)
set "PS_EXE=powershell"
if "!DLL_ARCH!"=="x86" (
    if exist "%SystemRoot%\SysWOW64\WindowsPowerShell\v1.0\powershell.exe" (
        set "PS_EXE=%SystemRoot%\SysWOW64\WindowsPowerShell\v1.0\powershell.exe"
    )
)

"!PS_EXE!" -NoProfile -ExecutionPolicy Bypass -File "%TEMP_PS%"
set "PS_EXIT=!ERRORLEVEL!"

REM --- Fallback: si fallo por arquitectura (exit 2), reintentar con 32-bit ---
if !PS_EXIT! equ 2 (
    echo.
    echo    Reintentando con PowerShell 32-bit...
    echo.
    if exist "%SystemRoot%\SysWOW64\WindowsPowerShell\v1.0\powershell.exe" (
        "%SystemRoot%\SysWOW64\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "%TEMP_PS%"
    ) else (
        echo    ERROR: PowerShell 32-bit no encontrado
    )
)

del "%TEMP_PS%" >nul 2>&1
echo.
pause
endlocal
exit /b
#__PS1__
# ============================================================
#  Verify-Dll.ps1 (embebido en verify.bat)
#  NO MODIFICAR - este contenido se extrae automaticamente
# ============================================================

$dllDir   = $env:DLL_DIR.TrimEnd('\')
$usuario  = $env:TEST_USUARIO
$clave    = $env:TEST_CLAVE
$empresa  = $env:TEST_EMPRESA
$testRuc  = $env:TEST_RUC
$rucOrigen = $env:TEST_RUC_ORIGEN

$dllPath = Join-Path $dllDir 'SigreWebServiceWrapper.dll'
$iniPath = Join-Path $dllDir 'SigreWebServiceWrapper.ini'

Write-Host ''
Write-Host '============================================================' -ForegroundColor Cyan
Write-Host '  VERIFICADOR DE DLL - SigreWebServiceWrapper' -ForegroundColor Cyan
Write-Host '============================================================' -ForegroundColor Cyan
Write-Host ''
Write-Host "  Carpeta: $dllDir" -ForegroundColor Gray
Write-Host "  PowerShell: $($PSVersionTable.PSVersion) ($([IntPtr]::Size * 8)-bit)" -ForegroundColor Gray
Write-Host ''

# --- [1] Verificar archivos ---
Write-Host '[1] Verificando archivos...' -ForegroundColor Yellow

if (-not (Test-Path $dllPath)) {
    Write-Host '   [ERROR] SigreWebServiceWrapper.dll NO encontrado' -ForegroundColor Red
    Write-Host "   Buscado en: $dllDir" -ForegroundColor Red
    exit 1
}
$fi = Get-Item $dllPath
$kb = [math]::Round($fi.Length / 1KB, 1)
Write-Host "   [OK] SigreWebServiceWrapper.dll ($kb KB, $($fi.LastWriteTime.ToString('yyyy-MM-dd HH:mm')))" -ForegroundColor Green

if (Test-Path $iniPath) {
    Write-Host '   [OK] SigreWebServiceWrapper.ini encontrado' -ForegroundColor Green
} else {
    Write-Host '   [WARN] SigreWebServiceWrapper.ini no encontrado' -ForegroundColor Yellow
}
Write-Host ''

# --- [2] Cargar DLL via P/Invoke ---
Write-Host '[2] Cargando DLL via P/Invoke...' -ForegroundColor Yellow

$fullPath = (Resolve-Path $dllPath).Path
$escaped  = $fullPath.Replace('\', '\\')

$src = @"
using System;
using System.Runtime.InteropServices;

public class SigreV {

    [DllImport("$escaped", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Unicode)]
    public static extern IntPtr ObtenerVersion();

    [DllImport("$escaped", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Unicode)]
    public static extern IntPtr ObtenerIpLocal();

    [DllImport("$escaped", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Unicode)]
    public static extern IntPtr ObtenerConfiguracion();

    [DllImport("$escaped", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Unicode)]
    public static extern IntPtr ObtenerInfoToken();

    [DllImport("$escaped", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Unicode)]
    public static extern IntPtr ObtenerTokenRest(
        [MarshalAs(UnmanagedType.LPWStr)] string usuario,
        [MarshalAs(UnmanagedType.LPWStr)] string clave,
        [MarshalAs(UnmanagedType.LPWStr)] string empresa,
        [MarshalAs(UnmanagedType.LPWStr)] string ipLocal,
        [MarshalAs(UnmanagedType.LPWStr)] string computerName);

    [DllImport("$escaped", CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Unicode)]
    public static extern IntPtr ConsultarRuc(
        [MarshalAs(UnmanagedType.LPWStr)] string ruc,
        [MarshalAs(UnmanagedType.LPWStr)] string rucOrigen);

    public static string R(IntPtr p) {
        if (p == IntPtr.Zero) return "(null)";
        return Marshal.PtrToStringUni(p) ?? "(null)";
    }
}
"@

try {
    Add-Type -TypeDefinition $src -ErrorAction Stop
} catch {
    Write-Host "   [ERROR] $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Probar carga real de la DLL (Add-Type solo compila, no carga la DLL)
try {
    $null = [SigreV]::ObtenerVersion()
    Write-Host '   [OK] DLL cargada correctamente' -ForegroundColor Green
} catch {
    $msg = $_.Exception.Message
    if ($msg -match '0x8007000B' -or $msg -match 'formato incorrecto' -or $msg -match 'BadImageFormat') {
        $bits = [IntPtr]::Size * 8
        Write-Host "   [ERROR] DLL x86 no compatible con PowerShell ${bits}-bit" -ForegroundColor Red
        exit 2
    }
    Write-Host "   [ERROR] $msg" -ForegroundColor Red
    exit 1
}
Write-Host ''

# --- [3] ObtenerVersion() ---
Write-Host '[3] ObtenerVersion()' -ForegroundColor Yellow
# Ya se llamo en el probe, obtener resultado limpio
try {
    $ver = [SigreV]::R([SigreV]::ObtenerVersion())
    if ($ver -and $ver.Length -gt 0 -and $ver -ne '(null)') {
        Write-Host "   => $ver" -ForegroundColor Green
    } else {
        Write-Host '   => (vacio)' -ForegroundColor Yellow
    }
} catch {
    Write-Host "   [ERROR] $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ''

# --- [4] ObtenerIpLocal() ---
Write-Host '[4] ObtenerIpLocal()' -ForegroundColor Yellow
$ipLocal = '127.0.0.1'
try {
    $ipLocal = [SigreV]::R([SigreV]::ObtenerIpLocal())
    Write-Host "   => $ipLocal" -ForegroundColor Green
} catch {
    Write-Host "   [ERROR] $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ''

# --- [5] ObtenerConfiguracion() ---
Write-Host '[5] ObtenerConfiguracion()' -ForegroundColor Yellow
try {
    $cfgJson = [SigreV]::R([SigreV]::ObtenerConfiguracion())
    try {
        $cfg = $cfgJson | ConvertFrom-Json
        Write-Host "   apiHost:    $($cfg.apiHost)" -ForegroundColor Gray
        Write-Host "   apiPort:    $($cfg.apiPort)" -ForegroundColor Gray
        Write-Host "   smtpServer: $($cfg.smtpServer)" -ForegroundColor Gray
        Write-Host "   logEnabled: $($cfg.logEnabled)" -ForegroundColor Gray
        Write-Host "   version:    $($cfg.version)" -ForegroundColor Gray
    } catch {
        Write-Host "   => $cfgJson" -ForegroundColor Gray
    }
} catch {
    Write-Host "   [ERROR] $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ''

# --- [6] ObtenerTokenRest(usuario, clave, empresa, ipLocal, computerName) ---
$pc = $env:COMPUTERNAME
Write-Host "[6] ObtenerTokenRest('$usuario', '***', '$empresa', '$ipLocal', '$pc')" -ForegroundColor Yellow
$tokenOk = $false
try {
    $tokenResult = [SigreV]::R([SigreV]::ObtenerTokenRest($usuario, $clave, $empresa, $ipLocal, $pc))
    if ($tokenResult -match '^ERROR' -or $tokenResult -match '"exitoso"\s*:\s*false') {
        Write-Host "   [WARN] $tokenResult" -ForegroundColor Yellow
    } elseif ($tokenResult.Length -gt 50) {
        Write-Host "   => Token obtenido ($($tokenResult.Length) chars)" -ForegroundColor Green
        Write-Host "   => $($tokenResult.Substring(0, 60))..." -ForegroundColor Gray
        $tokenOk = $true
    } else {
        Write-Host "   => $tokenResult" -ForegroundColor Yellow
    }
} catch {
    Write-Host "   [ERROR] $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ''

# --- [7] ObtenerInfoToken() ---
Write-Host '[7] ObtenerInfoToken()' -ForegroundColor Yellow
try {
    $infoJson = [SigreV]::R([SigreV]::ObtenerInfoToken())
    try {
        $info = $infoJson | ConvertFrom-Json
        Write-Host "   tieneToken:   $($info.tieneToken)" -ForegroundColor $(if ($info.tieneToken) { 'Green' } else { 'Yellow' })
        if ($info.tieneToken) {
            Write-Host "   usuario:      $($info.usuario)" -ForegroundColor Gray
            Write-Host "   empresa:      $($info.empresa)" -ForegroundColor Gray
            Write-Host "   ipLocal:      $($info.ipLocal)" -ForegroundColor Gray
            Write-Host "   computerName: $($info.computerName)" -ForegroundColor Gray
            Write-Host "   tokenLength:  $($info.tokenLength)" -ForegroundColor Gray
        }
    } catch {
        Write-Host "   => $infoJson" -ForegroundColor Gray
    }
} catch {
    Write-Host "   [ERROR] $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ''

# --- [8] ConsultarRuc(ruc, rucOrigen) ---
Write-Host "[8] ConsultarRuc('$testRuc', '$rucOrigen')" -ForegroundColor Yellow

if (-not $tokenOk) {
    Write-Host '   [SKIP] No hay token valido - no se puede consultar' -ForegroundColor Yellow
    Write-Host '   El paso [6] debe obtener un token exitosamente' -ForegroundColor Gray
} else {
    try {
        $rucResult = [SigreV]::R([SigreV]::ConsultarRuc($testRuc, $rucOrigen))

        if ($rucResult -match '"success"\s*:\s*true') {
            Write-Host '   [OK] RUC ENCONTRADO' -ForegroundColor Green
            Write-Host ''
            try {
                $rucObj = $rucResult | ConvertFrom-Json
                $d = $rucObj.data
                Write-Host "   RUC:          $($d.ruc)" -ForegroundColor White
                Write-Host "   Razon Social: $($d.razonSocial)" -ForegroundColor White
                Write-Host "   Estado:       $($d.estado)" -ForegroundColor White
                Write-Host "   Condicion:    $($d.condicion)" -ForegroundColor White
                Write-Host "   Ubigeo:       $($d.ubigeo)" -ForegroundColor Gray

                $partes = @($d.tipoVia, $d.nombreVia, $d.numero) | Where-Object { $_ }
                $direccion = ($partes -join ' ').Trim()
                if ($direccion) {
                    Write-Host "   Direccion:    $direccion" -ForegroundColor Gray
                }

                if ($d.tipoZona -or $d.codigoZona) {
                    Write-Host "   Zona:         $($d.tipoZona) $($d.codigoZona)" -ForegroundColor Gray
                }

                Write-Host "   Departamento: $($d.descDepartamento)" -ForegroundColor Gray
                Write-Host "   Provincia:    $($d.descProvincia)" -ForegroundColor Gray
                Write-Host "   Distrito:     $($d.descDistrito)" -ForegroundColor Gray
            } catch {
                Write-Host "   JSON raw: $rucResult" -ForegroundColor Gray
            }

        } elseif ($rucResult -match '"exitoso"\s*:\s*false' -or $rucResult -match '"success"\s*:\s*false') {
            Write-Host '   [WARN] Consulta sin resultado' -ForegroundColor Yellow
            try {
                $err = ($rucResult | ConvertFrom-Json).mensaje
                Write-Host "   Mensaje: $err" -ForegroundColor Gray
            } catch {
                Write-Host "   => $rucResult" -ForegroundColor Gray
            }
        } else {
            Write-Host "   Respuesta: $rucResult" -ForegroundColor Gray
        }
    } catch {
        Write-Host "   [ERROR] $($_.Exception.Message)" -ForegroundColor Red
    }
}
Write-Host ''

# --- [9] Contenido del INI ---
Write-Host '[9] Configuracion INI:' -ForegroundColor Yellow
Write-Host '   ----------------------------------------'
if (Test-Path $iniPath) {
    Get-Content $iniPath | ForEach-Object {
        if ($_ -match '(?i)(Password|Secret|Token|AccessKey)') {
            $parts = $_ -split '=', 2
            if ($parts.Length -eq 2 -and $parts[1].Length -gt 4) {
                $masked = $parts[1].Substring(0, 3) + ('*' * [Math]::Min($parts[1].Length - 3, 10))
                Write-Host "   $($parts[0])=$masked" -ForegroundColor DarkGray
            } else {
                Write-Host "   $_" -ForegroundColor DarkGray
            }
        } else {
            Write-Host "   $_" -ForegroundColor Gray
        }
    }
} else {
    Write-Host '   Archivo INI no encontrado' -ForegroundColor Yellow
}
Write-Host '   ----------------------------------------'

Write-Host ''
Write-Host '============================================================' -ForegroundColor Cyan
Write-Host '  VERIFICACION COMPLETADA' -ForegroundColor Cyan
Write-Host '============================================================' -ForegroundColor Cyan
Write-Host ''
