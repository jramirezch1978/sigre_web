# Script para registrar el DLL como componente COM
# IMPORTANTE: Ejecutar PowerShell como Administrador

param(
    [string]$Platform = "x64"  # Puede ser "x64" o "x86"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Registrando SigreWebServiceWrapper" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Determinar la ruta de RegAsm según la plataforma
if ($Platform -eq "x64") {
    $regasm = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\regasm.exe"
    Write-Host "Plataforma: x64 (64-bit)" -ForegroundColor Yellow
} else {
    $regasm = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\regasm.exe"
    Write-Host "Plataforma: x86 (32-bit)" -ForegroundColor Yellow
}

# Verificar que RegAsm existe
if (-not (Test-Path $regasm)) {
    Write-Host "ERROR: No se encuentra RegAsm.exe en: $regasm" -ForegroundColor Red
    Write-Host "Asegúrese de que .NET Framework 4.8 esté instalado." -ForegroundColor Red
    exit 1
}

# Ruta del DLL (subir un nivel desde scripts/ a la raíz del proyecto)
$projectRoot = Split-Path -Parent $PSScriptRoot
$dllPath = Join-Path $projectRoot "bin\Release\net48\SigreWebServiceWrapper.dll"

# Verificar que el DLL existe
if (-not (Test-Path $dllPath)) {
    Write-Host "ERROR: No se encuentra el DLL en: $dllPath" -ForegroundColor Red
    Write-Host "Asegúrese de compilar el proyecto primero con: dotnet build -c Release" -ForegroundColor Red
    exit 1
}

Write-Host "DLL: $dllPath" -ForegroundColor White
Write-Host ""

# Verificar que se está ejecutando como Administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ADVERTENCIA: Este script debe ejecutarse como Administrador" -ForegroundColor Red
    Write-Host "Clic derecho en PowerShell -> Ejecutar como Administrador" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Presione Enter para salir"
    exit 1
}

# Registrar el DLL
Write-Host "Registrando componente COM..." -ForegroundColor Green

try {
    & $regasm $dllPath /tlb /codebase /verbose
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "✓ Registro completado exitosamente" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "El componente está listo para usarse desde PowerBuilder 2025" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "ProgID registrado:" -ForegroundColor Yellow
        Write-Host "  - SigreWebServiceWrapper.ConsultaRUC" -ForegroundColor White
        Write-Host ""
        Write-Host "Uso en PowerBuilder:" -ForegroundColor Yellow
        Write-Host '  OLEObject lole_service' -ForegroundColor Gray
        Write-Host '  lole_service = CREATE OLEObject' -ForegroundColor Gray
        Write-Host '  lole_service.ConnectToNewObject("SigreWebServiceWrapper.ConsultaRUC")' -ForegroundColor Gray
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host "ERROR: Falló el registro del componente" -ForegroundColor Red
        Write-Host "Código de salida: $LASTEXITCODE" -ForegroundColor Red
    }
} catch {
    Write-Host ""
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Read-Host "Presione Enter para salir"

