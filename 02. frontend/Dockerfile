# Etapa de construcción
FROM node:20-alpine AS builder

WORKDIR /app

# Copiar archivos de dependencias
COPY package*.json ./

# Instalar TODAS las dependencias (incluyendo devDependencies para el build)
RUN npm ci

# Verificar que Angular CLI esté instalado
RUN npx ng version

# Copiar código fuente
COPY . .

# Construir la aplicación
RUN npm run build:prod

# Etapa de producción
FROM nginx:alpine

# Instalar curl para health checks
RUN apk add --no-cache curl

# Copiar la aplicación construida
COPY --from=builder /app/dist/sigre-asistencia /usr/share/nginx/html

# Copiar configuración de nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Script que ajusta appsettings.json según las variables de entorno del
# contenedor (API_GATEWAY_URL, COMPANY_NAME, COMPANY_SUCURSAL) al arrancar,
# para que la misma imagen sirva en cualquier servidor sin recompilar.
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Exponer puerto
EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]

# Comando por defecto
CMD ["nginx", "-g", "daemon off;"]
