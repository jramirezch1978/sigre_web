#!/bin/sh
# Selecciona el perfil de empresa activo en tiempo de arranque del contenedor
# (NO en tiempo de build), para que la misma imagen sirva sin cambios en
# cualquier servidor (esta VM, cronos, futuros clientes, etc.).
#
# El frontend (ConfigService) lee assets/empresa-activa.json para saber que
# archivo cargar desde assets/empresas/<empresa>.json (nombre, logo, sector,
# sucursal, URL del API). Agregar una empresa nueva NO requiere tocar este
# script ni el codigo: solo crear su archivo en assets/empresas/ y apuntar
# EMPRESA_ACTIVA a ese nombre en el docker-compose del servidor.
set -e

EMPRESA_ACTIVA_FILE="/usr/share/nginx/html/assets/empresa-activa.json"

if [ -n "$EMPRESA_ACTIVA" ]; then
  if [ -f "/usr/share/nginx/html/assets/empresas/${EMPRESA_ACTIVA}.json" ]; then
    echo "[entrypoint] empresa activa -> $EMPRESA_ACTIVA"
    printf '{ "empresa": "%s" }\n' "$EMPRESA_ACTIVA" > "$EMPRESA_ACTIVA_FILE"
  else
    echo "[entrypoint] ADVERTENCIA: no existe assets/empresas/${EMPRESA_ACTIVA}.json, se mantiene $(cat "$EMPRESA_ACTIVA_FILE" 2>/dev/null || echo 'sin apuntador')"
  fi
else
  echo "[entrypoint] EMPRESA_ACTIVA no definida, se usa el valor por defecto de empresa-activa.json"
fi

exec "$@"
