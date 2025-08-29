# Asistencia Service - Microservicio SIGRE

## Descripción
Microservicio para el manejo de tiempo del servidor y lógica de raciones para el sistema SIGRE. Proporciona endpoints para obtener la hora actual del servidor y gestionar la disponibilidad de raciones según el horario.

## Características
- **Endpoint de tiempo**: Proporciona la hora actual del servidor en zona horaria Lima (America/Lima)
- **Gestión de raciones**: Lógica de disponibilidad según horario peruano
- **Integración con Eureka**: Registro automático en el discovery server
- **Base de datos PostgreSQL**: Persistencia de datos con zona horaria configurada
- **Health checks**: Monitoreo de salud del servicio
- **Zona horaria**: Configurado para "America/Lima" tanto en contenedor como en aplicación

## Tecnologías
- Spring Boot 3.0.6
- Java 17
- PostgreSQL 15.2
- Spring Data JPA
- Spring Cloud Netflix Eureka
- Docker & Docker Compose
- Maven

## Endpoints Disponibles

### Time Controller
- `GET /api/time/current` - Obtiene la hora actual del servidor
- `GET /api/time/health` - Health check del servicio

### Racion Controller
- `GET /api/raciones/disponibles` - Lista de raciones disponibles según horario
- `POST /api/raciones/seleccionar` - Seleccionar una ración
- `GET /api/raciones/horario-info` - Información sobre horarios disponibles

## Configuración

### Variables de Entorno
- `SERVER_PORT`: Puerto del servicio (default: 8084)
- `SPRING_DATASOURCE_URL`: URL de la base de datos
- `SPRING_DATASOURCE_USERNAME`: Usuario de la base de datos
- `SPRING_DATASOURCE_PASSWORD`: Contraseña de la base de datos
- `EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE`: URL del servidor Eureka

### Puertos
- **Aplicación**: 8084
- **Base de datos**: 5434 (mapeado a 5432 interno)

## Instalación y Ejecución

### Prerrequisitos
- Docker y Docker Compose instalados
- Java 17 (para desarrollo local)
- Maven 3.9+ (para desarrollo local)

### Opción 1: Docker Compose (Recomendado)

1. **Navegar al directorio del servicio**
   ```bash
   cd "03. backend/asistencia-service"
   ```

2. **Construir y ejecutar**
   ```bash
   docker-compose up --build -d
   ```

3. **Verificar estado**
   ```bash
   docker-compose ps
   docker-compose logs -f asistencia-service
   ```

4. **Probar endpoints**
   ```bash
   # Health check
   curl http://localhost:8084/api/time/health
   
   # Hora actual (zona horaria Lima)
   curl http://localhost:8084/api/time/current
   
   # Raciones disponibles según horario peruano
   curl http://localhost:8084/api/raciones/disponibles
   
   # Información de horarios
   curl http://localhost:8084/api/raciones/horario-info
   ```

5. **Verificar zona horaria**
   ```bash
   # Ver zona horaria del contenedor
   docker exec asistencia-service date
   
   # Ver zona horaria en logs
   docker-compose logs asistencia-service | grep -i timezone
   ```

### Opción 2: Construcción manual

1. **Construir imagen**
   ```bash
   docker build -t asistencia-service .
   ```

2. **Ejecutar con Docker**
   ```bash
   docker run -d \
     --name asistencia-service \
     -p 8084:8084 \
     -e SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5434/sigre_asistencia \
     asistencia-service
   ```

### Opción 3: Desarrollo local

1. **Instalar dependencias**
   ```bash
   mvn clean install
   ```

2. **Ejecutar aplicación**
   ```bash
   mvn spring-boot:run
   ```

## Comandos útiles

### Docker Compose
```bash
# Ver logs
docker-compose logs -f asistencia-service

# Reiniciar servicio
docker-compose restart asistencia-service

# Detener servicios
docker-compose down

# Limpiar volúmenes
docker-compose down -v
```

### Base de datos
```bash
# Conectar a PostgreSQL
docker exec -it db-asistencia psql -U sigre_user -d sigre_asistencia

# Ver tablas
\dt

# Salir
\q
```

### Testing
```bash
# Ejecutar tests
mvn test

# Test con cobertura
mvn test jacoco:report
```

## Lógica de Raciones

### Horarios
- **Desayuno**: 06:00 - 09:00 (solo disponible en ese horario)
- **Almuerzo**: Disponible hasta las 12:00 (mediodía)
- **Cena**: Disponible después de las 12:00 (mediodía)

### Reglas de Negocio
1. Hasta mediodía: trabajador puede elegir Almuerzo y/o Cena
2. Después de mediodía: solo disponible Cena
3. Desayuno solo disponible en horario específico (6:00-9:00)

## Estructura del Proyecto
```
src/
├── main/
│   ├── java/com/sigre/asistencia/
│   │   ├── controller/          # Controladores REST
│   │   ├── service/            # Lógica de negocio
│   │   ├── dto/               # Data Transfer Objects
│   │   └── AsistenciaServiceApplication.java
│   └── resources/
│       └── application.yml    # Configuración
├── Dockerfile                 # Configuración Docker
├── docker-compose.yml        # Orquestación de servicios
└── pom.xml                   # Dependencias Maven
```

## Integración con Frontend

El frontend Angular puede consumir estos endpoints:

```typescript
// Obtener hora del servidor
const timeResponse = await fetch('http://localhost:8084/api/time/current');

// Obtener raciones disponibles
const racionesResponse = await fetch('http://localhost:8084/api/raciones/disponibles');
```

## Monitoreo y Salud

### Health Checks
- **Aplicación**: `http://localhost:8084/api/time/health`
- **Actuator**: `http://localhost:8084/actuator/health`
- **Métricas**: `http://localhost:8084/actuator/metrics`

### Logs
```bash
# Ver logs en tiempo real
docker-compose logs -f asistencia-service

# Logs de la base de datos
docker-compose logs -f db-asistencia
```

## Solución de Problemas

### El servicio no inicia
```bash
# Verificar logs
docker-compose logs asistencia-service

# Verificar conectividad con la base de datos
docker-compose exec asistencia-service nc -z db-asistencia 5432
```

### Problemas de conexión a Eureka
```bash
# Verificar que discovery-server esté ejecutándose
curl http://localhost:8761/

# Ver logs de registro en Eureka
docker-compose logs asistencia-service | grep eureka
```

### Error de base de datos
```bash
# Reiniciar base de datos
docker-compose restart db-asistencia

# Limpiar datos y reiniciar
docker-compose down -v
docker-compose up --build -d
```

## Contribución

1. Fork del proyecto
2. Crear branch para feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit de cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push al branch (`git push origin feature/nueva-funcionalidad`)
5. Crear Pull Request

## Licencia

Este proyecto es parte del sistema SIGRE para empresa hidrobiológica.
