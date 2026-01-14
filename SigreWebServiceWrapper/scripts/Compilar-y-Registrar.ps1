# Script combinado: Compila y registra el DLL en un solo paso
# IMPORTANTE: Ejecutar PowerShell como Administrador

param(
    [string]$Platform = "x64"  # Puede ser "x64" o "x86"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Compilar y Registrar SigreWebServiceWrapper" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
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

# Paso 1: Compilar
Write-Host "Paso 1: Compilando el proyecto..." -ForegroundColor Yellow
Write-Host ""

# Subir un nivel desde scripts/ a la raíz del proyecto
$projectRoot = Split-Path -Parent $PSScriptRoot
$projectFile = Join-Path $projectRoot "SigreWebServiceWrapper.csproj"

$buildResult = dotnet build $projectFile -c Release

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "ERROR: Falló la compilación" -ForegroundColor Red
    Read-Host "Presione Enter para salir"
    exit 1
}

Write-Host ""
Write-Host "✓ Compilación exitosa" -ForegroundColor Green
Write-Host ""

# Paso 2: Registrar
Write-Host "Paso 2: Registrando componente COM..." -ForegroundColor Yellow
Write-Host ""

# Determinar la ruta de RegAsm según la plataforma
if ($Platform -eq "x64") {
    $regasm = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\regasm.exe"
    Write-Host "Plataforma: x64 (64-bit)" -ForegroundColor Cyan
} else {
    $regasm = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\regasm.exe"
    Write-Host "Plataforma: x86 (32-bit)" -ForegroundColor Cyan
}

$dllPath = Join-Path $projectRoot "bin\Release\net48\SigreWebServiceWrapper.dll"

try {
    & $regasm $dllPath /tlb /codebase /verbose
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "✓ TODO COMPLETADO EXITOSAMENTE" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "El componente está listo para usarse desde PowerBuilder 2025" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "ProgID registrado:" -ForegroundColor Yellow
        Write-Host "  - SigreWebServiceWrapper.ConsultaRUC" -ForegroundColor White
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host "ERROR: Falló el registro del componente" -ForegroundColor Red
    }
} catch {
    Write-Host ""
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Read-Host "Presione Enter para salir"

