# Script para desregistrar el DLL como componente COM
# IMPORTANTE: Ejecutar PowerShell como Administrador

param(
    [string]$Platform = "x64"  # Puede ser "x64" o "x86"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Desregistrando SigreWebServiceWrapper" -ForegroundColor Cyan
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
    exit 1
}

# Ruta del DLL
$dllPath = Join-Path $PSScriptRoot "bin\Release\net48\SigreWebServiceWrapper.dll"

# Verificar que el DLL existe
if (-not (Test-Path $dllPath)) {
    Write-Host "ADVERTENCIA: No se encuentra el DLL en: $dllPath" -ForegroundColor Yellow
    Write-Host "Se intentará desregistrar de todos modos..." -ForegroundColor Yellow
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

# Desregistrar el DLL
Write-Host "Desregistrando componente COM..." -ForegroundColor Green

try {
    & $regasm $dllPath /unregister /verbose
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "✓ Desregistro completado exitosamente" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host "ERROR: Falló el desregistro del componente" -ForegroundColor Red
        Write-Host "Código de salida: $LASTEXITCODE" -ForegroundColor Red
    }
} catch {
    Write-Host ""
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Read-Host "Presione Enter para salir"

