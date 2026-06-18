# Multi-stage: build Angular + serve con nginx
# Uso: docker build -t restpe-frontend .
# La imagen resultante sirve el build en /usr/share/nginx/html
FROM node:20-alpine AS builder
WORKDIR /app

COPY package*.json .npmrc ./
RUN npm ci --legacy-peer-deps
RUN rm -f .npmrc

COPY . .
ENV NODE_OPTIONS="--max-old-space-size=4096"
RUN npm run build:prod

# Stage runtime: nginx
FROM nginx:1.27-alpine
COPY --from=builder /app/www /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
