# SIGRE - Módulo de Asistencia Frontend

## Descripción
Aplicación Angular 18 para el módulo de asistencia de la empresa hidrobiológica SIGRE. Permite a los trabajadores registrar su asistencia y seleccionar raciones según el horario disponible.

## Características
- **Reloj digital** que muestra la hora del servidor
- **Sistema de raciones**: Desayuno, Almuerzo, Cena
- **Lógica de horarios**: Hasta mediodía puede elegir Almuerzo y/o Cena, después solo Cena
- **Lectura de tarjeta de proximidad** (simulada)
- **Interfaz responsive** para tablet
- **Diseño elegante** con tema hidrobiológico

## Tecnologías
- Angular 18
- Angular Material
- TypeScript
- SCSS
- Docker & Nginx

## Instalación y Ejecución

### Prerrequisitos
- Docker y Docker Compose instalados
- Acceso al servidor con IP: 10.100.14.102

### Opción 1: Ejecutar con Docker Compose (Recomendado)

1. **Clonar/Descargar el proyecto**
   ```bash
   cd "02. frontend"
   ```

2. **Construir y ejecutar con Docker Compose**
   ```bash
   docker-compose up --build -d
   ```

3. **Verificar el estado**
   ```bash
   docker-compose ps
   docker-compose logs -f
   ```

4. **Acceder a la aplicación**
   - URL: http://10.100.14.102:9080
   - Puerto: 9080 (configurado en docker-compose.yml)

### Opción 2: Construir imagen manualmente

1. **Construir la imagen**
   ```bash
   docker build -t sigre-asistencia-frontend .
   ```

2. **Ejecutar el contenedor**
   ```bash
   docker run -d \
     --name sigre-asistencia-frontend \
     -p 9080:80 \
     --restart unless-stopped \
     sigre-asistencia-frontend
   ```

### Opción 3: Desarrollo local (requiere Node.js)

1. **Instalar dependencias**
   ```bash
   npm install
   ```

2. **Ejecutar en modo desarrollo**
   ```bash
   npm start
   ```

3. **Construir para producción**
   ```bash
   npm run build:prod
   ```

## Comandos útiles de Docker

### Ver logs del contenedor
```bash
docker logs sigre-asistencia-frontend
docker logs -f sigre-asistencia-frontend
```

### Reiniciar el servicio
```bash
docker-compose restart
```

### Detener el servicio
```bash
docker-compose down
```

### Ver estado de los servicios
```bash
docker-compose ps
docker-compose top
```

### Limpiar recursos no utilizados
```bash
docker system prune -f
docker volume prune -f
```

## Estructura del Proyecto
```
src/
├── app/
│   ├── components/
│   │   ├── asistencia/          # Componente principal de asistencia
│   │   ├── racion-selection/    # Selección de raciones
│   │   └── clock/               # Reloj digital
│   ├── app.component.ts         # Componente raíz
│   └── app.routes.ts            # Configuración de rutas
├── styles.scss                  # Estilos globales
└── main.ts                      # Punto de entrada
```

## Configuración del Puerto
- **Puerto interno del contenedor**: 80 (nginx)
- **Puerto externo**: 9080 (configurado en docker-compose.yml)
- **URL de acceso**: http://10.100.14.102:9080

## Solución de Problemas

### El contenedor no inicia
```bash
# Ver logs detallados
docker-compose logs

# Verificar puerto disponible
netstat -tulpn | grep 9080

# Reiniciar Docker
sudo systemctl restart docker
```

### Error de permisos
```bash
# Dar permisos al directorio
sudo chown -R $USER:$USER .

# Ejecutar con sudo si es necesario
sudo docker-compose up --build -d
```

### Limpiar completamente
```bash
docker-compose down -v
docker system prune -af
docker volume prune -f
```

## Notas Importantes
- La aplicación está configurada para ejecutarse en el puerto **9080**
- El contenedor se reinicia automáticamente a menos que se detenga manualmente
- Los logs se pueden ver con `docker-compose logs -f`
- La aplicación es completamente responsive y optimizada para tablets

## Soporte
Para problemas técnicos, revisar los logs del contenedor y verificar la configuración del puerto 9080 en el servidor.
