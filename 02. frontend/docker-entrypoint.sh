#!/bin/sh
# Ajusta appsettings.json con la configuración del entorno en tiempo de
# arranque del contenedor (NO en tiempo de build), para que la misma imagen
# sirva sin cambios en cualquier servidor (esta VM, cronos, etc.) según las
# variables de entorno definidas en el docker-compose de cada entorno.
set -e

APPSETTINGS="/usr/share/nginx/html/assets/appsettings.json"

if [ -f "$APPSETTINGS" ]; then
  # Usamos "variable definida" (aunque sea vacía) en vez de "variable no vacía",
  # para poder forzar valores vacíos (ej. sucursal="") en entornos multi-tenant
  # sin heredar el valor por defecto que trae el archivo.
  if [ "${API_GATEWAY_URL+isset}" = "isset" ]; then
    echo "[entrypoint] api.baseUrl -> $API_GATEWAY_URL"
    sed -i "s#\"baseUrl\"[[:space:]]*:[[:space:]]*\"[^\"]*\"#\"baseUrl\": \"$API_GATEWAY_URL\"#" "$APPSETTINGS"
  fi

  if [ "${COMPANY_NAME+isset}" = "isset" ]; then
    echo "[entrypoint] company.name -> $COMPANY_NAME"
    sed -i "s#\"name\"[[:space:]]*:[[:space:]]*\"[^\"]*\"#\"name\": \"$COMPANY_NAME\"#" "$APPSETTINGS"
  fi

  if [ "${COMPANY_SUCURSAL+isset}" = "isset" ]; then
    echo "[entrypoint] company.sucursal -> $COMPANY_SUCURSAL"
    sed -i "s#\"sucursal\"[[:space:]]*:[[:space:]]*\"[^\"]*\"#\"sucursal\": \"$COMPANY_SUCURSAL\"#" "$APPSETTINGS"
  fi

  if [ "${COMPANY_LOGO_PATH+isset}" = "isset" ]; then
    echo "[entrypoint] company.logoPath -> $COMPANY_LOGO_PATH"
    sed -i "s#\"logoPath\"[[:space:]]*:[[:space:]]*\"[^\"]*\"#\"logoPath\": \"$COMPANY_LOGO_PATH\"#" "$APPSETTINGS"
  fi
else
  echo "[entrypoint] ADVERTENCIA: no se encontró $APPSETTINGS, se omite la configuración por entorno"
fi

exec "$@"
