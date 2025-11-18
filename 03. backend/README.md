# SIGRE 2.0 - Backend Microservicios

## Arquitectura de Microservicios - Java Spring Boot 3.x

Sistema ERP SIGRE 2.0 implementado como arquitectura de microservicios usando Spring Boot, Spring Cloud y Oracle 11gR2.

---

## 📋 Estructura de Microservicios

### Infraestructura (3 servicios)
- **api-gateway** - Gateway de entrada único
- **service-discovery** - Eureka Server
- **config-server** - Configuración centralizada

### Servicios de Negocio (20 microservicios)

| # | Microservicio | Puerto | Descripción |
|---|---------------|--------|-------------|
| 1 | **seguridad-service** | 8081 | Autenticación, autorización, usuarios |
| 2 | **corelibrary-service** | 8070 | Funciones comunes compartidas |
| 3 | **contabilidad-service** | 8082 | Contabilidad central, asientos, plan de cuentas |
| 4 | **finanzas-service** | 8083 | Tesorería, CxC, CxP, bancos |
| 5 | **almacen-service** | 8084 | Inventarios, kardex, movimientos |
| 6 | **rrhh-service** | 8085 | Planillas, trabajadores, beneficios |
| 7 | **produccion-service** | 8086 | Órdenes de trabajo, control de producción |
| 8 | **flota-service** | 8087 | Embarcaciones, capturas, zarpes |
| 9 | **comercializacion-service** | 8088 | Ventas, facturación, clientes |
| 10 | **compras-service** | 8089 | Órdenes de compra, proveedores |
| 11 | **aprovision-service** | 8090 | Aprovisionamiento, especies |
| 12 | **asistencia-service** | 8091 | Control de asistencia, horarios |
| 13 | **comedor-service** | 8092 | Gestión de comedores, menús |
| 14 | **mantenimiento-service** | 8093 | Mantenimiento preventivo/correctivo |
| 15 | **operaciones-service** | 8094 | Órdenes de trabajo operativas |
| 16 | **campo-service** | 8095 | Gestión agrícola |
| 17 | **activo-fijo-service** | 8096 | Control de activos fijos |
| 18 | **auditoria-service** | 8097 | Auditoría y controles |
| 19 | **sig-service** | 8098 | Sistema de información gerencial |
| 20 | **presupuesto-service** | 8099 | Presupuestos y control |

---

## 🏗️ Arquitectura General

```
                         ┌──────────────────┐
                         │   API GATEWAY    │ :8080
                         │  (Spring Cloud)  │
                         └────────┬─────────┘
                                  │
                    ┌─────────────┴──────────────┐
                    │                            │
            ┌───────┴────────┐          ┌───────┴────────┐
            │ Service Discovery│        │  Config Server │
            │   (Eureka)       │        │                │
            │     :8761        │        │     :8888      │
            └────────┬─────────┘        └────────────────┘
                     │
    ┌────────────────┴─────────────────────────┐
    │                                           │
┌───┴─────────┐  ┌──────────────┐  ┌──────────┴────┐
│ Seguridad   │  │Contabilidad  │  │   Finanzas    │
│   :8081     │  │   :8082      │  │    :8083      │
└─────────────┘  └──────────────┘  └───────────────┘

┌─────────────┐  ┌──────────────┐  ┌───────────────┐
│   Almacen   │  │    RRHH      │  │  Produccion   │
│   :8084     │  │   :8085      │  │    :8086      │
└─────────────┘  └──────────────┘  └───────────────┘

┌─────────────┐  ┌───────────────┐  ┌──────────────┐
│    Flota    │  │Comercializacion│ │   Compras    │
│   :8087     │  │    :8088       │  │   :8089      │
└─────────────┘  └────────────────┘  └──────────────┘

            [... 11 microservicios más ...]
```

---

## 💾 Base de Datos Oracle 11gR2

Todos los microservicios comparten la misma base de datos Oracle, manteniendo compatibilidad con el esquema actual de PowerBuilder.

### Tablas Principales por Módulo

**Contabilidad:**
- ASIENTO_CONTABLE
- PLAN_CUENTAS
- CENTRO_COSTOS
- MATRIZ_CONTABLE

**Finanzas:**
- DOC_X_PAGAR
- DOC_X_COBRAR
- CONCEPTO_FINANCIERO
- BANCO_CUENTA

**Almacén:**
- VALE_MOV_ALM
- ARTICULO
- SALDO_ARTICULO
- KARDEX

**RRHH:**
- TRABAJADOR
- RH_PLANILLA_CALCULO
- RH_CONCEPTO_CALCULO
- RH_ASISTENCIA

**Producción:**
- PD_OT
- PARTE_PISO
- CONTROL_CALIDAD
- PD_OT_PROD_FINAL

**Flota:**
- EMBARCACION
- ZARPE
- CAPTURA
- TRIPULANTE

---

## 🚀 Stack Tecnológico

### Core
- Java 17 LTS
- Spring Boot 3.2.x
- Spring Cloud 2023.0.x
- Maven 3.9.x

### Base de Datos
- Oracle 11gR2
- Spring Data JPA
- Hibernate 6.4.x
- HikariCP

### Comunicación
- REST APIs
- RabbitMQ (mensajería asíncrona)
- Feign Client

### Seguridad
- Spring Security 6.2.x
- JWT (JSON Web Tokens)
- OAuth2

### Cache & Storage
- Redis (cache distribuido)
- MongoDB (logs y auditoría)

### Monitoreo
- Prometheus
- Grafana
- ELK Stack
- Spring Actuator

---

## 📦 Instalación Rápida

### 1. Clonar y Compilar

```bash
cd Proyecto-SIGRE-2.0/03.\ backend

# Compilar todos los módulos
./build-all.sh
```

### 2. Levantar Infraestructura

```bash
# Solo infraestructura base (Oracle, Redis, RabbitMQ, etc)
docker-compose -f docker-compose-infra.yml up -d
```

### 3. Levantar Microservicios

```bash
# Opción 1: Todos los servicios con Docker
docker-compose up -d

# Opción 2: Desarrollo local (IDE)
# Ver orden de inicio en sección siguiente
```

---

## 🎮 Orden de Inicio de Servicios

### Fase 1: Infraestructura Base (30 seg espera)
```bash
cd service-discovery && mvn spring-boot:run
# Esperar que Eureka esté en http://localhost:8761
```

### Fase 2: Configuración (15 seg espera)
```bash
cd config-server && mvn spring-boot:run
```

### Fase 3: Gateway (15 seg espera)
```bash
cd api-gateway && mvn spring-boot:run
```

### Fase 4: Servicios Core
```bash
cd seguridad-service && mvn spring-boot:run
cd corelibrary-service && mvn spring-boot:run
```

### Fase 5: Servicios de Negocio (en paralelo)
```bash
cd contabilidad-service && mvn spring-boot:run &
cd finanzas-service && mvn spring-boot:run &
cd almacen-service && mvn spring-boot:run &
cd rrhh-service && mvn spring-boot:run &
# ... resto de servicios
```

---

## 🔌 Endpoints Principales

### Seguridad
```bash
POST /api/seguridad/login
POST /api/seguridad/refresh
GET  /api/seguridad/usuarios
POST /api/seguridad/usuarios
```

### Contabilidad
```bash
GET  /api/contabilidad/asientos
POST /api/contabilidad/asientos
GET  /api/contabilidad/plan-cuentas
GET  /api/contabilidad/centros-costos
POST /api/contabilidad/matrices
```

### Finanzas
```bash
GET  /api/finanzas/cuentas-pagar
POST /api/finanzas/cuentas-pagar
GET  /api/finanzas/cuentas-cobrar
POST /api/finanzas/documentos-pago
GET  /api/finanzas/bancos
```

### Almacén
```bash
GET  /api/almacen/movimientos
POST /api/almacen/movimientos
GET  /api/almacen/articulos
GET  /api/almacen/kardex/{articulo}
GET  /api/almacen/stock
```

### RRHH
```bash
GET  /api/rrhh/trabajadores
POST /api/rrhh/trabajadores
POST /api/rrhh/planilla/calcular
GET  /api/rrhh/planilla/{periodo}
POST /api/rrhh/asistencia
```

### Producción
```bash
GET  /api/produccion/ordenes-trabajo
POST /api/produccion/ordenes-trabajo
POST /api/produccion/parte-piso
GET  /api/produccion/control-calidad
```

---

## 🔒 Seguridad y JWT

### 1. Login
```bash
curl -X POST http://localhost:8080/api/seguridad/login \
  -H "Content-Type: application/json" \
  -d '{
    "usuario": "admin",
    "password": "admin123"
  }'
```

### 2. Response
```json
{
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "refreshToken": "...",
  "expiresIn": 3600,
  "usuario": "admin",
  "empresa": "EMPRESA01",
  "roles": ["ADMIN", "CONTABILIDAD"]
}
```

### 3. Usar Token
```bash
curl -X GET http://localhost:8080/api/contabilidad/asientos \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIs..."
```

---

## 📊 Monitoreo

### Eureka Dashboard
- URL: http://localhost:8761
- Ver todos los servicios registrados

### RabbitMQ Management
- URL: http://localhost:15672
- Usuario: admin / admin123

### Prometheus
- URL: http://localhost:9090
- Métricas de todos los servicios

### Grafana
- URL: http://localhost:3000
- Usuario: admin / admin123

---

## 📝 Swagger/OpenAPI

Cada microservicio expone su documentación:

- Seguridad: http://localhost:8081/swagger-ui.html
- Contabilidad: http://localhost:8082/swagger-ui.html
- Finanzas: http://localhost:8083/swagger-ui.html
- Almacén: http://localhost:8084/swagger-ui.html
- RRHH: http://localhost:8085/swagger-ui.html
- [... resto de servicios ...]

---

## 🛠️ Scripts de Utilidad

```bash
# Compilar todos los servicios
./build-all.sh

# Iniciar todos los servicios en orden
./start-all.sh

# Detener todos los servicios
./stop-all.sh

# Ver logs de un servicio
./logs.sh contabilidad-service

# Verificar salud de servicios
./health-check.sh
```

---

## 📚 Documentación Adicional

Ver carpetas individuales de cada microservicio para documentación específica:

- `seguridad-service/README.md`
- `contabilidad-service/README.md`
- `finanzas-service/README.md`
- etc.

---

**Última actualización**: Noviembre 2025
