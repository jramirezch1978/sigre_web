# SIGRE - Sistema Integral de Gestión de Recursos Empresariales

## Descripción
Sistema completo para empresa hidrobiológica que incluye un **Módulo de Asistencia** con interfaz responsive para tablets, reloj digital sincronizado con el servidor y sistema de gestión de raciones.

## Arquitectura del Proyecto

### 🏗️ Estructura
```
sigre_web/
├── 01. documentacion/           # Documentación del proyecto
├── 02. frontend/               # Frontend Angular 18
│   ├── src/                   # Código fuente Angular
│   ├── Dockerfile             # Configuración Docker
│   └── README.md              # Documentación frontend
├── 03. backend/               # Backend microservicios
│   ├── asistencia-service/    # Microservicio de asistencia
│   │   ├── src/              # Código fuente Spring Boot
│   │   ├── Dockerfile        # Configuración Docker
│   │   └── README.md         # Documentación microservicio
│   └── pom.xml               # Configuración Maven principal
├── docker-compose.yml        # ⭐ Orquestación completa del proyecto
└── README.md                 # Este archivo
```

### 🚀 Componentes
- **Frontend**: Angular 18 + Angular Material (Puerto 8080)
- **API Gateway**: Spring Cloud Gateway (Puerto 9080) - Sin autenticación, CORS abierto
- **Backend**: Spring Boot 3.0.6 + PostgreSQL (Puerto 8084)
- **Discovery Server**: Eureka Server (Puerto 8761)
- **Base de datos**: PostgreSQL 15.2 (Puerto 5432)
- **Zona horaria**: America/Lima configurada en todos los servicios

## 🎯 Funcionalidades

### Módulo de Asistencia
- ✅ **Reloj digital** sincronizado con servidor (formato hh:mm:ss am/pm)
- ✅ **Lectura de tarjeta de proximidad** (simulada)
- ✅ **Sistema de raciones**: Desayuno, Almuerzo, Cena
- ✅ **Lógica de horarios**: 
  - Hasta mediodía: puede elegir Almuerzo y/o Cena
  - Después de mediodía: solo Cena disponible
- ✅ **Interfaz responsive** optimizada para tablets
- ✅ **Diseño hidrobiológico** profesional y elegante

## 🐳 Instalación y Ejecución

### Prerrequisitos
- Docker y Docker Compose instalados
- Acceso al servidor: **10.100.14.102**
- Portainer disponible en: http://10.100.14.102:9000

### 🚀 Ejecución Completa (Recomendado)

1. **Clonar/Acceder al proyecto**
   ```bash
   cd /path/to/sigre_web
   ```

2. **Levantar todo el stack con un solo comando**
   ```bash
   docker-compose up --build -d
   ```

3. **Verificar estado de todos los servicios**
   ```bash
   docker-compose ps
   ```

4. **Ver logs de todos los servicios**
   ```bash
   docker-compose logs -f
   ```

5. **Acceder a la aplicación**
   - **Frontend**: http://10.100.14.102:8080
   - **API Gateway**: http://10.100.14.102:9080
   - **API Backend**: http://10.100.14.102:8084
   - **Eureka Server**: http://10.100.14.102:8761
   - **Portainer**: http://10.100.14.102:9000

### 🔍 Verificación de Servicios

```bash
# Estado de contenedores
docker-compose ps

# Salud de la base de datos
docker-compose exec db-sigre-web pg_isready -U sigre-web -d db-sigre-web

# Verificar zona horaria en contenedores
docker-compose exec asistencia-service date
docker-compose exec sigre-frontend date
docker-compose exec db-sigre-web date

# Probar endpoints a través del API Gateway
curl http://10.100.14.102:8080/api/asistencia/api/time/current
curl http://10.100.14.102:8080/api/asistencia/api/raciones/disponibles
curl http://10.100.14.102:8080/api/asistencia/api/time/health

# Probar endpoints directos (para debugging)
curl http://10.100.14.102:8084/api/time/current
curl http://10.100.14.102:8084/api/raciones/disponibles
```

### 📊 Monitoreo con Portainer

1. Acceder a: http://10.100.14.102:9000
2. Navegar a: **Stacks** → **sigre_web** (si se despliega como stack)
3. Ver estado de contenedores y logs en tiempo real

## 🛠️ Comandos de Gestión

### Operaciones Básicas
```bash
# Iniciar todos los servicios
docker-compose up -d

# Reconstruir e iniciar
docker-compose up --build -d

# Detener todos los servicios
docker-compose down

# Detener y eliminar volúmenes
docker-compose down -v

# Reiniciar un servicio específico
docker-compose restart asistencia-service
docker-compose restart sigre-frontend
```

### Logs y Debugging
```bash
# Ver logs de todos los servicios
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f asistencia-service
docker-compose logs -f sigre-frontend
docker-compose logs -f db-sigre-web

# Acceder a un contenedor
docker-compose exec asistencia-service bash
docker-compose exec sigre-frontend sh
docker-compose exec db-sigre-web bash
```

### Base de Datos
```bash
# Conectar a PostgreSQL
docker-compose exec db-sigre-web psql -U sigre-web -d db-sigre-web

# Backup de la base de datos
docker-compose exec db-sigre-web pg_dump -U sigre-web db-sigre-web > backup.sql

# Restaurar backup
docker-compose exec -T db-sigre-web psql -U sigre-web -d db-sigre-web < backup.sql
```

## ⚙️ Configuración

### Puertos Utilizados
- **9080**: Frontend Angular (HTTP)
- **8080**: API Gateway (HTTP) - Punto de entrada principal
- **8084**: Microservicio Asistencia (API REST)
- **8761**: Discovery Server (Eureka)
- **5432**: Base de datos PostgreSQL

### Variables de Entorno
- **TZ**: America/Lima (zona horaria)
- **POSTGRES_DB**: db-sigre-web
- **POSTGRES_USER**: sigre-web
- **POSTGRES_PASSWORD**: S1greW3b@2025!

### Red Docker
- **Nombre**: sigre-network
- **Tipo**: bridge
- **Comunicación interna**: Todos los servicios pueden comunicarse entre sí

## 🔧 Desarrollo

### Estructura de Desarrollo
```bash
# Desarrollo del frontend
cd "02. frontend"
npm install
npm start  # http://localhost:4200

# Desarrollo del backend
cd "03. backend/asistencia-service"
mvn spring-boot:run  # http://localhost:8084
```

### Hot Reload en Docker
```bash
# Solo para desarrollo - monta código fuente
docker-compose -f docker-compose.dev.yml up
```

## 🚨 Solución de Problemas

### El frontend no carga
```bash
# Verificar logs
docker-compose logs sigre-frontend

# Verificar conectividad
curl http://10.100.14.102:9080

# Reiniciar servicio
docker-compose restart sigre-frontend
```

### El microservicio no responde
```bash
# Verificar logs
docker-compose logs asistencia-service

# Verificar conectividad con BD
docker-compose exec asistencia-service nc -z db-sigre-web 5432

# Verificar endpoint
curl http://10.100.14.102:8084/api/time/health
```

### Problemas de base de datos
```bash
# Verificar estado
docker-compose exec db-sigre-web pg_isready -U sigre-web

# Reiniciar base de datos
docker-compose restart db-sigre-web

# Logs de PostgreSQL
docker-compose logs db-sigre-web
```

### Problemas de zona horaria
```bash
# Verificar TZ en contenedores
docker-compose exec asistencia-service date
docker-compose exec db-sigre-web date

# Reiniciar con configuración limpia
docker-compose down -v
docker-compose up --build -d
```

## 🔐 Seguridad

- Base de datos con usuario y contraseña específicos
- Red Docker aislada para comunicación interna
- Contenedores ejecutándose con usuarios no-root
- Health checks configurados para todos los servicios

## 📈 Escalabilidad

El proyecto está preparado para:
- Agregar más microservicios al `docker-compose.yml`
- Implementar load balancing
- Configurar múltiples instancias
- Integración con Kubernetes

## 🤝 Contribución

1. Fork del proyecto
2. Crear branch: `git checkout -b feature/nueva-funcionalidad`
3. Commit: `git commit -am 'Agregar funcionalidad'`
4. Push: `git push origin feature/nueva-funcionalidad`
5. Pull Request

## 📞 Soporte

Para problemas técnicos:
1. Revisar logs: `docker-compose logs -f`
2. Verificar Portainer: http://10.100.14.102:9000
3. Comprobar conectividad de red
4. Verificar zona horaria y sincronización

---

**SIGRE** - Sistema desarrollado para empresa hidrobiológica con tecnologías modernas y arquitectura de microservicios.
