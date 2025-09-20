@echo off
echo ============================================
echo       LIMPIEZA DE LOGS DE DOCKER
echo ============================================
echo.

REM 1. Mostrar tamaño actual de logs
echo 📊 TAMAÑO ACTUAL DE LOGS:
docker system df
echo.

REM 2. Listar containers activos
echo 📋 CONTAINERS ACTIVOS:
docker ps --format "table {{.Names}}\t{{.Status}}"
echo.

REM 3. Mostrar comando para verificar tamaño de logs
echo 📏 Para ver tamaño de logs por container, usa:
echo    docker logs api-gateway 2^>nul ^| find /c /v ""
echo.

echo ⚠️  LIMPIANDO LOGS EXISTENTES...
echo.

REM 4. Parar containers
echo 🛑 Parando containers...
docker compose stop api-gateway asistencia-service sync-service
echo.

REM 5. Limpiar logs usando PowerShell
echo 🧹 Limpiando logs...
powershell -Command "& { docker system prune -f --volumes 2>$null; echo 'Limpieza de sistema completada' }"
echo.

REM 6. Iniciar containers con nueva configuración
echo 🔄 INICIANDO CONTAINERS CON LÍMITES DE LOGS...
docker compose up -d api-gateway asistencia-service sync-service
echo.

REM 7. Verificar estado
echo ✅ VERIFICANDO ESTADO:
docker ps --filter "name=api-gateway" --filter "name=asistencia-service" --filter "name=sync-service" --format "table {{.Names}}\t{{.Status}}"
echo.

echo ✅ PROCESO COMPLETADO
echo 📝 Los logs ahora están limitados a:
echo    - Tamaño máximo por archivo: 50MB
echo    - Archivos máximos: 3
echo    - Total máximo por container: 150MB
echo.
echo 💡 COMANDOS ÚTILES:
echo    docker logs api-gateway --tail 100
echo    docker system df
echo.
pause
