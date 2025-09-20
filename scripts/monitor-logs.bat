@echo off
echo ============================================
echo         MONITOR DE LOGS DE DOCKER
echo ============================================
echo.

:menu
echo 📋 OPCIONES:
echo 1. Ver tamaño de logs por container
echo 2. Ver últimas 50 líneas de api-gateway
echo 3. Ver últimas 50 líneas de asistencia-service
echo 4. Ver últimas 50 líneas de sync-service
echo 5. Ver todos los containers y su estado
echo 6. Seguir logs en tiempo real (api-gateway)
echo 7. Limpiar pantalla
echo 8. Salir
echo.
set /p choice="Selecciona una opción (1-8): "

if "%choice%"=="1" goto size
if "%choice%"=="2" goto api_logs
if "%choice%"=="3" goto asistencia_logs
if "%choice%"=="4" goto sync_logs
if "%choice%"=="5" goto status
if "%choice%"=="6" goto follow
if "%choice%"=="7" goto clear
if "%choice%"=="8" goto exit

echo Opción inválida. Intenta de nuevo.
goto menu

:size
echo.
echo 📊 TAMAÑO DE LOGS:
docker system df
echo.
echo 📏 ESPACIO USADO POR CONTAINERS:
for /f "tokens=1" %%i in ('docker ps --format "{{.Names}}" 2^>nul') do (
    echo.
    echo Container: %%i
    docker inspect %%i --format "  Log Path: {{.LogPath}}" 2>nul
    for /f %%s in ('powershell -command "if (Test-Path (docker inspect %%i --format '{{.LogPath}}' 2>nul)) { (Get-Item (docker inspect %%i --format '{{.LogPath}}' 2>nul)).Length / 1MB } else { 0 }"') do echo   Size: %%s MB
)
echo.
pause
goto menu

:api_logs
echo.
echo 📝 ÚLTIMAS 50 LÍNEAS - API GATEWAY:
echo ============================================
docker logs api-gateway --tail 50
echo.
pause
goto menu

:asistencia_logs
echo.
echo 📝 ÚLTIMAS 50 LÍNEAS - ASISTENCIA SERVICE:
echo ============================================
docker logs asistencia-service --tail 50
echo.
pause
goto menu

:sync_logs
echo.
echo 📝 ÚLTIMAS 50 LÍNEAS - SYNC SERVICE:
echo ============================================
docker logs sync-service --tail 50
echo.
pause
goto menu

:status
echo.
echo 📊 ESTADO DE CONTAINERS:
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.
echo 💾 USO DE SISTEMA:
docker system df
echo.
pause
goto menu

:follow
echo.
echo 🔄 SIGUIENDO LOGS DE API-GATEWAY (Ctrl+C para parar):
echo ============================================
docker logs api-gateway --follow
goto menu

:clear
cls
goto menu

:exit
echo.
echo 👋 ¡Hasta luego!
exit /b 0
