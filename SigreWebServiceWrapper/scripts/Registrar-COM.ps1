# ============================================================
#   REGISTRAR DLL COMO COMPONENTE COM
#   SigreWebServiceWrapper para PowerBuilder 2025
# ============================================================
#
# IMPORTANTE: Ejecutar como Administrador
#
# ============================================================

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  REGISTRAR SIGRE WEB SERVICE WRAPPER COMO COM" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Verificar si se ejecuta como Administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ERROR: Este script debe ejecutarse como Administrador" -ForegroundColor Red
    Write-Host ""
    Write-Host "Haga clic derecho en PowerShell y seleccione 'Ejecutar como administrador'" -ForegroundColor Yellow
    Write-Host ""
    pause
    exit 1
}

# Rutas
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectDir = Split-Path -Parent $scriptDir
$dllDir = Join-Path $projectDir "dll"
$dllPath = Join-Path $dllDir "SigreWebServiceWrapper.dll"

# Verificar si existe el DLL
if (-not (Test-Path $dllPath)) {
    Write-Host "ERROR: No se encontro el DLL en: $dllPath" -ForegroundColor Red
    Write-Host ""
    Write-Host "Ejecute primero build.bat para compilar el proyecto" -ForegroundColor Yellow
    Write-Host ""
    pause
    exit 1
}

Write-Host "DLL encontrado: $dllPath" -ForegroundColor Green
Write-Host ""

# Buscar RegAsm
$regasm64 = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\RegAsm.exe"
$regasm32 = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe"

if (Test-Path $regasm64) {
    $regasm = $regasm64
    Write-Host "Usando RegAsm 64-bit" -ForegroundColor Gray
} elseif (Test-Path $regasm32) {
    $regasm = $regasm32
    Write-Host "Usando RegAsm 32-bit" -ForegroundColor Gray
} else {
    Write-Host "ERROR: No se encontro RegAsm.exe" -ForegroundColor Red
    Write-Host "Instale .NET Framework 4.8" -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host ""
Write-Host "Registrando componente COM..." -ForegroundColor Yellow
Write-Host ""

try {
    # Registrar con /codebase para que funcione sin GAC
    $output = & $regasm /codebase $dllPath 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "============================================================" -ForegroundColor Green
        Write-Host "  REGISTRO EXITOSO" -ForegroundColor Green
        Write-Host "============================================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "Componentes COM registrados:" -ForegroundColor White
        Write-Host "  - SigreWebServiceWrapper.ConsultaRUC (SOAP)" -ForegroundColor Gray
        Write-Host "  - SigreWebServiceWrapper.ConsultaRUCRest (REST + JWT)" -ForegroundColor Gray
        Write-Host "  - SigreWebServiceWrapper.EmailService (Email SMTP)" -ForegroundColor Gray
        Write-Host ""
        Write-Host "Ahora puede usar estos componentes desde PowerBuilder 2025" -ForegroundColor Cyan
    } else {
        Write-Host "ERROR durante el registro:" -ForegroundColor Red
        Write-Host $output -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
}

Write-Host ""
pause
