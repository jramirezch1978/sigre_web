@echo off
echo ============================================
echo   VERIFICAR CACHE EN TABLETS/CELULARES
echo ============================================
echo.

echo 🎯 COMO VERIFICAR QUE NO HAY CACHE (SIN F12):
echo.

echo 📱 MÉTODO 1: INDICADOR VISUAL EN PANTALLA
echo ------------------------------------------
echo ✅ Agregado indicador en esquina inferior izquierda
echo    Formato: "v2.1.4 | 24/09 19:30"
echo    
echo 🔍 Al hacer F5:
echo    - Si cambia el timestamp → ✅ SIN CACHE (correcto)
echo    - Si NO cambia → ❌ CON CACHE (problema)
echo.

echo 📱 MÉTODO 2: HARD REFRESH POR DISPOSITIVO
echo ------------------------------------------
echo 📋 ANDROID (Chrome):
echo    1. Menú (3 puntos) → Configuración
echo    2. Privacidad y seguridad → Borrar datos de navegación
echo    3. Seleccionar "Imágenes y archivos en caché"
echo    4. Borrar datos → Recargar página
echo.
echo 📋 ANDROID (Firefox):
echo    1. Menú → Configuración → Borrar datos de navegación
echo    2. Seleccionar "Cache" → Borrar ahora
echo.
echo 📋 iOS (Safari):
echo    1. Configuración → Safari
echo    2. Borrar historial y datos de sitios web
echo    3. Confirmar → Volver a la app
echo.
echo 📋 iPad (Safari):
echo    1. Configuración → Safari → Avanzado
echo    2. Datos de sitios web → Eliminar todos
echo.

echo 📊 MÉTODO 3: VERIFICAR DESDE LOGS DEL SERVIDOR
echo -----------------------------------------------
echo 🔍 Monitorear logs mientras usuario hace F5:
echo.
echo    docker logs sigre-frontend --follow
echo.
echo ✅ Debe aparecer:
echo    "GET /main.xxxxx.js HTTP/1.1" 200 xxxxx (descarga)
echo.
echo ❌ SI NO aparece nada:
echo    El dispositivo usa cache (problema)
echo.

echo 🛠️  APLICAR CONFIGURACIÓN SIN CACHE:
echo ------------------------------------
echo 1. Reiniciar frontend:
echo    docker compose restart sigre-frontend
echo.
echo 2. Verificar configuración:
echo    docker exec sigre-frontend cat /etc/nginx/nginx.conf ^| grep -A5 "Cache-Control"
echo.
echo 3. Forzar actualización en dispositivos:
echo    Seguir pasos de HARD REFRESH arriba
echo.

echo ⚡ CAMBIOS APLICADOS:
echo    - HTML: Cache-Control "no-cache, no-store, must-revalidate"
echo    - JS/CSS: Cache-Control "no-cache, no-store, must-revalidate" 
echo    - ETag: off (evita cache condicional)
echo    - Expires: -1 (expiración inmediata)
echo.

echo 🎯 RESULTADO:
echo    Cada F5 descargará la última versión
echo    Tablets/celulares verán correcciones inmediatas
echo.
pause
