# Arquitectura del Sistema — Restaurant.pe ERP

**Documento:** Arquitectura técnica completa del ERP Restaurant.pe  
**Versión:** 1.0  
**Fecha:** Febrero 2026  
**Stack tecnológico:** Java 21 / Spring Boot 3.x · Angular 20 · PostgreSQL 16 · Docker · RabbitMQ  

---

## Tabla de contenido

1. [Visión general del sistema](#1-visión-general-del-sistema)
2. [Principios de arquitectura](#2-principios-de-arquitectura)
3. [Stack tecnológico detallado](#3-stack-tecnológico-detallado)
4. [Arquitectura de microservicios](#4-arquitectura-de-microservicios)
5. [Catálogo de microservicios](#5-catálogo-de-microservicios)
6. [Arquitectura del backend (por microservicio)](#6-arquitectura-del-backend-por-microservicio)
7. [Arquitectura del frontend (Angular 20)](#7-arquitectura-del-frontend-angular-20)
8. [Base de datos — PostgreSQL](#8-base-de-datos--postgresql)
9. [Seguridad y control de acceso](#9-seguridad-y-control-de-acceso)
10. [Configuración jerárquica (4 niveles)](#10-configuración-jerárquica-4-niveles)
11. [Comunicación entre microservicios](#11-comunicación-entre-microservicios)
12. [Motor de pre-asientos contables](#12-motor-de-pre-asientos-contables)
13. [Auditoría y trazabilidad](#13-auditoría-y-trazabilidad)
14. [Reportes y exportación](#14-reportes-y-exportación)
15. [Notificaciones](#15-notificaciones)
16. [Infraestructura y DevOps](#16-infraestructura-y-devops)
17. [Entornos](#17-entornos)
18. [Estándares de API REST](#18-estándares-de-api-rest)
19. [Manejo de errores](#19-manejo-de-errores)
20. [Modelo de datos completo](#20-modelo-de-datos-completo)
21. [Patrones de diseño aplicados](#21-patrones-de-diseño-aplicados)
22. [Requisitos no funcionales](#22-requisitos-no-funcionales)
23. [Endpoints por microservicio](#23-endpoints-por-microservicio)
24. [Docker — Compose completo](#24-docker--compose-completo)
25. [Decisiones de arquitectura (ADR)](#25-decisiones-de-arquitectura-adr)
26. [Diagramas de arquitectura (C4 Model)](#26-diagramas-de-arquitectura-c4-model)
27. [Diagramas de entidades (ER) por microservicio — Resumen](#27-diagramas-de-entidades-er-por-microservicio--resumen) *(detalle en [`DISENO_BASE_DATOS.md`](./DISENO_BASE_DATOS.md))*
28. [Diagrama de comunicación entre microservicios](#28-diagrama-de-comunicación-entre-microservicios)
29. [Diagramas de interacción (secuencia)](#29-diagramas-de-interacción-secuencia)
30. [Diagramas de flujo de negocio](#30-diagramas-de-flujo-de-negocio)
31. [Diagramas de estado](#31-diagramas-de-estado)
32. [Estrategia de multitenancy — Database-per-Tenant](#32-estrategia-de-multitenancy--database-per-tenant)

---

## 1. Visión general del sistema

Restaurant.pe es un **ERP integral** para la industria gastronómica con capacidad **multipaís, multiempresa, multisucursal y multimoneda**. El sistema cubre 9 módulos funcionales que se integran nativamente con contabilidad.

```mermaid
flowchart TB
    subgraph Clientes
        WEB[Angular 20 - SPA]
        MOB[App Móvil - futuro]
        POS[POS Restaurant.pe]
    end
    subgraph Edge
        CDN[CDN / Archivos estáticos]
        LB[Load Balancer / Nginx]
    end
    subgraph Backend["Backend - Spring Boot Microservices"]
        GW[API Gateway]
        EU[Eureka Server]
        CFG[Config Server]
        subgraph Servicios_Negocio["Servicios de negocio"]
            AUTH[ms-auth-security]
            CORE[ms-core-maestros]
            ALM[ms-almacen]
            COM[ms-compras]
            FIN[ms-finanzas]
            CNT[ms-contabilidad]
            RRHH[ms-rrhh]
            AF[ms-activos-fijos]
            PROD[ms-produccion]
            VEN[ms-ventas]
        end
        subgraph Servicios_Soporte["Servicios de soporte"]
            AUD[ms-auditoria]
            RPT[ms-reportes]
            NOTIF[ms-notificaciones]
        end
    end
    subgraph Mensajería
        MQ[RabbitMQ]
    end
    subgraph Datos["Datos (Database-per-Tenant)"]
        PG_MASTER[(BD Master\nrestaurant_pe_master)]
        PG_TENANT[(BD por Empresa\nrestaurant_pe_emp_N)]
        REDIS[(Redis - Cache)]
        S3[Object Storage - archivos]
    end
    WEB --> LB
    MOB --> LB
    POS --> LB
    LB --> GW
    GW --> EU
    GW --> AUTH
    GW --> CORE
    GW --> ALM
    GW --> COM
    GW --> FIN
    GW --> CNT
    GW --> RRHH
    GW --> AF
    GW --> PROD
    GW --> VEN
    GW --> AUD
    GW --> RPT
    GW --> NOTIF
    AUTH --> PG_MASTER
    CORE --> PG_TENANT
    ALM --> PG_TENANT
    COM --> PG_TENANT
    FIN --> PG_TENANT
    CNT --> PG_TENANT
    RRHH --> PG_TENANT
    AF --> PG_TENANT
    PROD --> PG_TENANT
    VEN --> PG_TENANT
    AUD --> PG_TENANT
    ALM --> MQ
    COM --> MQ
    FIN --> MQ
    RRHH --> MQ
    AF --> MQ
    PROD --> MQ
    VEN --> MQ
    MQ --> CNT
    MQ --> AUD
    MQ --> NOTIF
    AUTH --> REDIS
    GW --> REDIS
```

### 1.1 Módulos funcionales

| # | Módulo | Descripción | HUs |
|---|--------|-------------|:---:|
| 1 | **Configuraciones** | Empresa, sucursales, países, monedas, impuestos, parámetros, roles, permisos | 21 |
| 2 | **Almacén** | Inventario, stock, kardex, movimientos, valorización, devoluciones, traslados | 28 |
| 3 | **Compras** | OC, OS, aprobaciones, recepción, planificación de abastecimiento | 17 |
| 4 | **Ventas** | Integración con POS, documentos de venta, notas de crédito/débito | 19 |
| 5 | **Finanzas** | CxP, CxC, tesorería, conciliaciones, adelantos, caja, flujo de caja | 45 |
| 6 | **Contabilidad** | Plan contable, asientos, pre-asientos, cierres, EEFF, libros electrónicos | 37 |
| 7 | **Activos Fijos** | Registro, depreciación, seguros, traslados, bajas, revaluación | 28 |
| 8 | **RRHH** | Trabajadores, contratos, asistencia, planilla, liquidaciones, regulatorios | 42 |
| 9 | **Producción** | Recetas, órdenes de producción, costeo, consumo de almacén | 42 |
| | **Total** | | **279** |

### 1.2 Características transversales

| Característica | Descripción |
|----------------|-------------|
| **Multipaís** | Soporte para diferentes normativas fiscales, tributarias y laborales (Perú, Colombia, Chile, Rep. Dominicana) |
| **Multiempresa** | Múltiples razones sociales en la misma instancia |
| **Multisucursal** | Gestión por local/sucursal con consolidación corporativa |
| **Multimoneda** | Operaciones en diferentes monedas con tipo de cambio diario |
| **Auditoría completa** | Log de auditoría en todas las operaciones (quién, cuándo, qué, desde dónde) |
| **Integración contable nativa** | Todos los módulos operativos generan pre-asientos hacia Contabilidad |
| **Control de acceso granular** | Roles dinámicos, permisos por opción de menú y acción, asignación individual |
| **Exportación universal** | Exportación a Excel/PDF en todos los reportes y listados |
| **Carga masiva** | Importación de datos vía Excel con validaciones |
| **Configuración jerárquica** | 4 niveles: empresa → país → sucursal → usuario |

---

## 2. Principios de arquitectura

| Principio | Aplicación |
|-----------|------------|
| **Separación de responsabilidades** | Un microservicio por dominio funcional. Cada servicio gestiona su propia lógica y datos |
| **Base de datos por servicio** | Esquemas PostgreSQL aislados por microservicio. Sin acceso directo a tablas de otro servicio |
| **API First** | Contratos OpenAPI/Swagger definidos antes de implementar. Versionado de API obligatorio |
| **Event-Driven** | Operaciones que cruzan dominios se comunican por eventos (RabbitMQ). Pre-asientos contables son eventos |
| **Stateless** | Los microservicios no almacenan estado de sesión. JWT viaja en cada request |
| **Fail-fast / Circuit Breaker** | Resilience4j para tolerancia a fallos entre servicios |
| **Configuración externalizada** | Spring Cloud Config centraliza configuración por entorno y por país |
| **Inmutabilidad de datos** | Soft delete en vez de eliminación física. Auditoría de cambios vía eventos |
| **Clean Architecture** | Capas: Controller → Service → Repository. Lógica de negocio en Service, nunca en Controller |
| **DRY / SOLID** | Código limpio, reutilizable, con inyección de dependencias y responsabilidad única |

---

## 3. Stack tecnológico detallado

### 3.1 Backend

| Tecnología | Versión | Uso |
|------------|:-------:|-----|
| **Java** | 21 (LTS) | Lenguaje principal del backend |
| **Spring Boot** | 3.x | Framework base de cada microservicio |
| **Spring Cloud Gateway** | latest | API Gateway: ruteo, rate limiting, CORS, balanceo |
| **Spring Cloud Netflix Eureka** | latest | Service discovery: registro y localización de servicios |
| **Spring Cloud Config** | latest | Configuración centralizada (perfiles dev/qa/prod, por país) |
| **Spring Security** | 6.x | Autenticación y autorización con JWT |
| **Spring Data JPA / Hibernate** | latest | ORM para acceso a datos |
| **Flyway** | latest | Versionado y migración de esquemas de BD |
| **OpenFeign** | latest | Cliente HTTP declarativo para comunicación entre servicios |
| **Resilience4j** | latest | Circuit breaker, retry, rate limiter |
| **RabbitMQ** | 3.13+ | Mensajería asincrónica (eventos, pre-asientos, auditoría, notificaciones) |
| **MapStruct** | latest | Mapeo de DTOs a entidades y viceversa |
| **Lombok** | latest | Reducción de boilerplate (getters, setters, builders) |
| **JasperReports** | latest | Generación de reportes PDF/Excel |
| **SpringDoc OpenAPI** | latest | Documentación automática de APIs (Swagger UI) |
| **JUnit 5 + Mockito** | latest | Testing unitario y de integración |
| **Testcontainers** | latest | Tests de integración con PostgreSQL y RabbitMQ reales |

### 3.2 Frontend

| Tecnología | Versión | Uso |
|------------|:-------:|-----|
| **Angular** | 20 | Framework SPA principal |
| **TypeScript** | 5.x | Lenguaje de desarrollo frontend |
| **Angular Material** | 20 | Componentes UI (tablas, formularios, diálogos, menú) |
| **NgRx** | latest | State management (estado global de la aplicación) |
| **RxJS** | latest | Programación reactiva |
| **Angular Router** | 20 | Ruteo con lazy loading por módulo |
| **HttpInterceptor** | nativo | Inyección automática de JWT y manejo de errores HTTP |
| **Chart.js / ngx-charts** | latest | Gráficos y dashboards |
| **ngx-translate** | latest | Internacionalización (i18n) |
| **Jasmine + Karma** | latest | Testing unitario de componentes |
| **Cypress** | latest | Testing e2e |

### 3.3 Base de datos e infraestructura

| Tecnología | Versión | Uso |
|------------|:-------:|-----|
| **PostgreSQL** | 16 | Base de datos relacional principal |
| **Redis** | 7.x | Caché de sesiones, tokens, tipo de cambio, configuraciones |
| **Docker** | latest | Containerización de todos los servicios |
| **Docker Compose** | latest | Orquestación local de servicios |
| **Nginx** | latest | Reverse proxy / load balancer / serving del SPA |
| **Git** | latest | Control de versiones |
| **GitHub Actions** | latest | CI/CD pipelines |
| **SonarQube** | latest | Análisis estático de código |
| **Prometheus + Grafana** | latest | Monitoreo y observabilidad |
| **ELK Stack** | latest | Centralización de logs (Elasticsearch + Logstash + Kibana) |

---

## 4. Arquitectura de microservicios

### 4.1 Diagrama de servicios y comunicación

```mermaid
flowchart TB
    subgraph Infraestructura["Infraestructura Spring Cloud"]
        EU[Eureka Server :8761]
        CFG[Config Server :8888]
        GW[API Gateway :8080]
    end
    subgraph Negocio["Microservicios de negocio"]
        AUTH[ms-auth-security :9001]
        CORE[ms-core-maestros :9002]
        ALM[ms-almacen :9003]
        COM[ms-compras :9004]
        FIN[ms-finanzas :9005]
        CNT[ms-contabilidad :9006]
        RRHH[ms-rrhh :9007]
        AF[ms-activos-fijos :9008]
        PROD[ms-produccion :9009]
        VEN[ms-ventas :9010]
    end
    subgraph Soporte["Microservicios de soporte"]
        AUD[ms-auditoria :9011]
        RPT[ms-reportes :9012]
        NOTIF[ms-notificaciones :9013]
    end
    subgraph Bus["Bus de eventos"]
        MQ[[RabbitMQ]]
    end
    GW -->|REST| AUTH
    GW -->|REST| CORE
    GW -->|REST| ALM
    GW -->|REST| COM
    GW -->|REST| FIN
    GW -->|REST| CNT
    GW -->|REST| RRHH
    GW -->|REST| AF
    GW -->|REST| PROD
    GW -->|REST| VEN
    GW -->|REST| RPT
    COM -->|OpenFeign| CORE
    COM -->|OpenFeign| ALM
    ALM -->|OpenFeign| CORE
    FIN -->|OpenFeign| CORE
    FIN -->|OpenFeign| COM
    CNT -->|OpenFeign| CORE
    RRHH -->|OpenFeign| CORE
    AF -->|OpenFeign| CORE
    PROD -->|OpenFeign| CORE
    PROD -->|OpenFeign| ALM
    VEN -->|OpenFeign| CORE
    VEN -->|OpenFeign| ALM
    VEN -->|OpenFeign| FIN
    ALM -->|evento| MQ
    COM -->|evento| MQ
    FIN -->|evento| MQ
    RRHH -->|evento| MQ
    AF -->|evento| MQ
    PROD -->|evento| MQ
    VEN -->|evento| MQ
    AUTH -->|evento tenant.created| MQ
    MQ -->|pre-asiento| CNT
    MQ -->|log| AUD
    MQ -->|alerta| NOTIF
    MQ -->|tenant.created| CORE & ALM & COM & FIN & CNT & RRHH & AF & PROD & VEN & AUD
    AUTH -.->|"GET /internal/tenants\n(provisión connection strings)"| CORE & ALM & COM & FIN & CNT & RRHH & AF & PROD & VEN & AUD
```

### 4.2 Flujo de una petición típica

```mermaid
sequenceDiagram
    participant U as Usuario
    participant FE as Angular 20
    participant GW as API Gateway
    participant EU as Eureka
    participant MS as Microservicio
    participant DB as PostgreSQL
    participant MQ as RabbitMQ
    participant AUD as ms-auditoria

    U->>FE: Acción (ej: crear OC)
    FE->>GW: POST /api/compras/ordenes (JWT en header)
    GW->>GW: Validar JWT (firma + expiración)
    GW->>EU: Resolver ms-compras
    EU-->>GW: IP:puerto de ms-compras
    GW->>MS: Forward request
    MS->>MS: Validar permisos del usuario
    MS->>DB: INSERT orden_compra
    DB-->>MS: OK
    MS->>MQ: Publicar evento "oc_creada"
    MQ-->>AUD: Consumir → registrar log auditoría
    MS-->>GW: 201 Created + OC
    GW-->>FE: Response
    FE-->>U: Mostrar confirmación
```

---

## 5. Catálogo de microservicios

### 5.1 Servicios de infraestructura (3)

| # | Servicio | Puerto | Responsabilidad |
|---|----------|:------:|-----------------|
| 1 | **eureka-server** | 8761 | Service discovery. Todos los servicios se registran aquí al iniciar. Permite descubrimiento dinámico sin hardcodear IPs |
| 2 | **config-server** | 8888 | Configuración centralizada. Almacena properties por servicio, por entorno (dev/qa/prod) y por país. Fuente: repositorio Git |
| 3 | **api-gateway** | 8080 | Punto de entrada único. Ruteo dinámico basado en Eureka. Rate limiting, CORS, balanceo de carga, validación de JWT |

### 5.2 Servicios de negocio (10)

| # | Servicio | Puerto | Esquema BD | Responsabilidad |
|---|----------|:------:|:----------:|-----------------|
| 4 | **ms-auth-security** | 9001 | `auth` | Autenticación (login/logout), generación y validación de JWT, gestión de usuarios, roles, opciones de menú, permisos granulares, asignación individual, sesiones |
| 5 | **ms-core-maestros** | 9002 | `core` | Maestros compartidos por todo el ERP: empresa, sucursal, país, moneda, tipo de cambio, relaciones comerciales (proveedor/cliente unificado), artículos, categorías, unidades de medida, impuestos, retenciones, detracciones, numeradores, condiciones de pago, formas de pago, configuración jerárquica (4 niveles) |
| 6 | **ms-almacen** | 9003 | `almacen` | Almacenes, tipos de movimiento, movimientos de inventario (ingreso/salida/traslado), kardex valorizado (promedio ponderado), stock en tiempo real, devoluciones a proveedor, inventario físico, ajustes, solicitudes de reposición, stock mínimo/máximo |
| 7 | **ms-compras** | 9004 | `compras` | Órdenes de compra, órdenes de servicio, workflow de aprobación multinivel (configurable por monto/tipo), recepción de mercadería con vinculación a OC, generación automática de movimiento de almacén, devoluciones, planificación de abastecimiento |
| 8 | **ms-finanzas** | 9005 | `finanzas` | Cuentas por pagar (desde OC y directas), cuentas por cobrar, tesorería, movimientos bancarios, conciliación bancaria, conciliación con pasarelas digitales (Niubiz, Yape, Plin), adelantos/órdenes de giro, fondo fijo, caja chica, flujo de caja, programación de pagos |
| 9 | **ms-contabilidad** | 9006 | `contabilidad` | Plan de cuentas contable jerárquico, centros de costo, asientos manuales y automáticos, motor de pre-asientos (recibe de todos los módulos), matrices contables, cierres mensuales y anuales, Estados Financieros (Balance, Resultados, Flujo de Efectivo, Patrimonio), libros electrónicos (PLE/SIRE) |
| 10 | **ms-rrhh** | 9007 | `rrhh` | Ficha del trabajador, contratos laborales, áreas y cargos, asistencia (POS/App/biométrico/GPS), conceptos de planilla, cálculo de planilla (sueldo, horas extra, CTS, gratificaciones, AFP, EsSalud), liquidaciones, beneficios sociales, propinas, recargo al consumo, archivos regulatorios (PLAME), boletas de pago |
| 11 | **ms-activos-fijos** | 9008 | `activos` | Registro de activos fijos vinculados a compra/factura, clasificación por clase/subclase, ubicación física jerárquica, depreciación mensual automática (lineal/decreciente/unidades), revaluación, seguros y pólizas, traslados con workflow, bajas |
| 12 | **ms-produccion** | 9009 | `produccion` | Recetas (BOM gastronómico) con merma, versiones de receta, órdenes de producción, consumo automático de almacén, costeo por receta (materia prima + mano de obra + indirectos) |
| 13 | **ms-ventas** | 9010 | `ventas` | Integración con POS (Restaurant.pe), documentos de venta (boletas, facturas electrónicas), notas de crédito/débito, cierre de caja, propinas, recargo al consumo, descuentos y promociones, mesas/órdenes/comandas, facturación electrónica (SUNAT/OSE), generación de CxC, pre-asientos contables de ventas |

### 5.3 Servicios de soporte (3)

| # | Servicio | Puerto | Esquema BD | Responsabilidad |
|---|----------|:------:|:----------:|-----------------|
| 14 | **ms-auditoria** | 9011 | `auditoria` | Registro centralizado de auditoría. Consume eventos de todos los servicios. Log: quién, cuándo, qué entidad, qué acción, datos anteriores/nuevos (JSON), IP, user-agent |
| 15 | **ms-reportes** | 9012 | — | Motor de reportes (JasperReports). Exportación PDF/Excel. Consulta datos de otros servicios vía OpenFeign. Reportes compartidos entre módulos |
| 16 | **ms-notificaciones** | 9013 | — | Envío de correos electrónicos, alertas del sistema, recordatorios, notificaciones push. Consume eventos de RabbitMQ |

---

## 6. Arquitectura del backend (por microservicio)

Cada microservicio sigue la misma estructura interna basada en **Clean Architecture** con 4 capas:

```mermaid
flowchart TB
    subgraph Microservicio["ms-{modulo}"]
        direction TB
        CTRL["Controller\n(REST API)"]
        SVC["Service\n(Lógica de negocio)"]
        REPO["Repository\n(Acceso a datos)"]
        ENT["Entity / Model\n(Entidades JPA)"]
        DTO["DTO\n(Request/Response)"]
        MAP["Mapper\n(MapStruct)"]
        EVT["Event Publisher\n(RabbitMQ)"]
        FEIGN["Feign Client\n(Otros servicios)"]
    end
    CTRL --> SVC
    SVC --> REPO
    SVC --> EVT
    SVC --> FEIGN
    REPO --> ENT
    CTRL --> DTO
    MAP --> DTO
    MAP --> ENT
```

### 6.1 Estructura de paquetes (convención)

```
com.restaurantpe.{modulo}
├── config/                  # Configuración del microservicio
│   ├── SecurityConfig.java
│   ├── RabbitConfig.java
│   ├── SwaggerConfig.java
│   └── FeignConfig.java
├── controller/              # REST Controllers
│   ├── OrdenCompraController.java
│   └── RecepcionController.java
├── dto/                     # Data Transfer Objects
│   ├── request/
│   │   └── OrdenCompraRequest.java
│   └── response/
│       └── OrdenCompraResponse.java
├── entity/                  # Entidades JPA
│   ├── OrdenCompra.java
│   └── OrdenCompraDetalle.java
├── enums/                   # Enumeraciones
│   └── EstadoOrdenCompra.java
├── exception/               # Excepciones personalizadas
│   ├── BusinessException.java
│   └── GlobalExceptionHandler.java
├── feign/                   # Clientes Feign para otros servicios
│   └── CoreMaestrosClient.java
├── mapper/                  # MapStruct mappers
│   └── OrdenCompraMapper.java
├── event/                   # Eventos RabbitMQ
│   ├── publisher/
│   │   └── ComprasEventPublisher.java
│   └── listener/
│       └── ComprasEventListener.java
├── repository/              # Spring Data JPA Repositories
│   └── OrdenCompraRepository.java
├── service/                 # Lógica de negocio
│   ├── OrdenCompraService.java
│   └── impl/
│       └── OrdenCompraServiceImpl.java
├── specification/           # Filtros dinámicos (JPA Specifications)
│   └── OrdenCompraSpecification.java
└── util/                    # Utilidades
    └── NumeradorUtil.java
```

### 6.2 Convenciones de código

| Aspecto | Convención |
|---------|------------|
| **Naming clases** | PascalCase: `OrdenCompraService`, `KardexRepository` |
| **Naming métodos** | camelCase: `crearOrdenCompra()`, `calcularStockDisponible()` |
| **Naming paquetes** | lowercase: `com.restaurantpe.compras.service` |
| **DTOs** | Sufijo `Request` / `Response`: `OrdenCompraRequest`, `OrdenCompraResponse` |
| **Entidades** | Sin sufijo, nombre de tabla: `OrdenCompra`, `MovimientoAlmacen` |
| **Repositories** | Sufijo `Repository`: `OrdenCompraRepository` |
| **Services** | Interfaz + implementación: `OrdenCompraService` / `OrdenCompraServiceImpl` |
| **Controllers** | Sufijo `Controller`: `OrdenCompraController` |
| **Constantes** | UPPER_SNAKE_CASE: `ESTADO_APROBADA`, `MAX_INTENTOS` |
| **Endpoints** | kebab-case plural: `/api/compras/ordenes-compra`, `/api/almacen/movimientos` |

### 6.3 Entidad base (herencia)

Todas las entidades heredan de `BaseEntity` para garantizar auditoría y multiempresa:

```java
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
public abstract class BaseEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "empresa_id", nullable = false)
    private Long empresaId;
    
    @Column(name = "activo", nullable = false)
    private Boolean activo = true;
    
    @CreatedBy
    @Column(name = "creado_por", updatable = false)
    private String creadoPor;
    
    @CreatedDate
    @Column(name = "creado_en", updatable = false)
    private LocalDateTime creadoEn;
    
    @LastModifiedBy
    @Column(name = "modificado_por")
    private String modificadoPor;
    
    @LastModifiedDate
    @Column(name = "modificado_en")
    private LocalDateTime modificadoEn;
}
```

---

## 7. Arquitectura del frontend (Angular 20)

### 7.1 Estructura del proyecto

```
restaurant-pe-frontend/
├── src/
│   ├── app/
│   │   ├── core/                        # Singleton: auth, interceptors, guards
│   │   │   ├── auth/
│   │   │   │   ├── auth.service.ts
│   │   │   │   ├── auth.guard.ts
│   │   │   │   └── jwt.interceptor.ts
│   │   │   ├── services/
│   │   │   │   ├── config.service.ts     # Configuración jerárquica
│   │   │   │   ├── empresa.service.ts    # Contexto empresa/sucursal
│   │   │   │   └── menu.service.ts       # Menú dinámico
│   │   │   └── models/
│   │   │       ├── usuario.model.ts
│   │   │       └── api-response.model.ts
│   │   ├── shared/                      # Componentes reutilizables
│   │   │   ├── components/
│   │   │   │   ├── data-table/           # Tabla con paginación, filtros, export
│   │   │   │   ├── form-field/           # Campos de formulario estandarizados
│   │   │   │   ├── search-dialog/        # Diálogos de búsqueda (proveedor, artículo)
│   │   │   │   ├── approval-badge/       # Badge de estado de aprobación
│   │   │   │   ├── file-upload/          # Carga de archivos/imágenes
│   │   │   │   └── confirm-dialog/       # Diálogos de confirmación
│   │   │   ├── directives/
│   │   │   │   ├── has-permission.directive.ts
│   │   │   │   └── currency-format.directive.ts
│   │   │   └── pipes/
│   │   │       ├── currency.pipe.ts
│   │   │       └── date-locale.pipe.ts
│   │   ├── layout/                      # Shell de la aplicación
│   │   │   ├── sidebar/                  # Menú lateral dinámico por módulo
│   │   │   ├── header/                   # Barra superior con empresa/sucursal
│   │   │   ├── footer/
│   │   │   └── breadcrumb/
│   │   ├── modules/                     # Módulos funcionales (lazy loaded)
│   │   │   ├── almacen/
│   │   │   │   ├── maestros/             # Almacenes, tipos movimiento
│   │   │   │   ├── operaciones/          # Movimientos, recepciones, traslados
│   │   │   │   ├── consultas/            # Kardex, stock, devoluciones
│   │   │   │   ├── reportes/             # Reportes del módulo
│   │   │   │   ├── almacen-routing.module.ts
│   │   │   │   └── almacen.module.ts
│   │   │   ├── compras/
│   │   │   ├── finanzas/
│   │   │   ├── contabilidad/
│   │   │   ├── rrhh/
│   │   │   ├── activos-fijos/
│   │   │   ├── produccion/
│   │   │   └── configuraciones/
│   │   ├── store/                       # NgRx State Management
│   │   │   ├── auth/
│   │   │   ├── empresa/
│   │   │   └── menu/
│   │   ├── app.component.ts
│   │   ├── app.routes.ts
│   │   └── app.config.ts
│   ├── assets/
│   │   ├── i18n/                        # Archivos de traducción
│   │   │   ├── es.json
│   │   │   ├── en.json
│   │   │   └── pt.json
│   │   └── images/
│   ├── environments/
│   │   ├── environment.ts
│   │   ├── environment.qa.ts
│   │   └── environment.prod.ts
│   └── styles/
│       ├── _variables.scss
│       ├── _theme.scss
│       └── styles.scss
├── angular.json
├── package.json
└── tsconfig.json
```

### 7.2 Flujo de carga del menú dinámico

```mermaid
flowchart TB
    A[Login exitoso] --> B[Recibir JWT + menú permitido]
    B --> C[Guardar en NgRx Store]
    C --> D[Filtrar módulos con opciones]
    D --> E[Renderizar sidebar dinámico]
    E --> F[Usuario navega a opción]
    F --> G{¿Tiene permiso?}
    G -->|Sí| H[Cargar módulo lazy]
    G -->|No| I[Redirigir a 403]
    H --> J[Renderizar pantalla]
    J --> K[Verificar acciones permitidas]
    K --> L[Habilitar/deshabilitar botones]
```

### 7.3 Interceptor JWT

Todas las peticiones HTTP pasan por un interceptor que:

1. Agrega el token JWT al header `Authorization: Bearer {token}`.
2. Si recibe **401**, intenta renovar el token (refresh token).
3. Si falla la renovación, redirige al login.
4. Agrega `X-Empresa-Id` y `X-Sucursal-Id` como headers de contexto.

### 7.4 Guard de permisos

Cada ruta del frontend está protegida por un `AuthGuard` que verifica:

1. Que el usuario esté autenticado (JWT válido).
2. Que la opción de menú correspondiente a la ruta esté en su rol o asignada individualmente.
3. Que tenga la acción requerida (ver, crear, editar, etc.).

---

## 8. Base de datos — PostgreSQL (Database-per-Tenant)

### 8.1 Estrategia de multitenancy: Database-per-Tenant

El sistema utiliza el patrón **Database-per-Tenant** de PostgreSQL, aprovechando la función nativa `CREATE DATABASE ... TEMPLATE`. Cada empresa (tenant) tiene su **propia base de datos**, lo que garantiza aislamiento total de datos.

```mermaid
flowchart TB
    subgraph PostgreSQL_Server["PostgreSQL 16 Server"]
        subgraph Master["restaurant_pe_master"]
            direction LR
            M_AUTH["schema: auth\n(usuarios, roles, permisos,\nopciones de menú)"]
            M_TENANT["schema: master\n(registro de tenants,\nconnection strings)"]
        end
        subgraph Template["restaurant_pe_template"]
            direction LR
            T1["schema: core"]
            T2["schema: almacen"]
            T3["schema: compras"]
            T4["schema: ventas"]
            T5["schema: finanzas"]
            T6["schema: contabilidad"]
            T7["schema: rrhh"]
            T8["schema: activos"]
            T9["schema: produccion"]
            T10["schema: auditoria"]
        end
        subgraph Emp1["restaurant_pe_emp_1"]
            direction LR
            E1["Clon exacto del template\n(Restaurante Lima SAC)"]
        end
        subgraph Emp2["restaurant_pe_emp_2"]
            direction LR
            E2["Clon exacto del template\n(Restaurante Bogotá SAS)"]
        end
        subgraph EmpN["restaurant_pe_emp_N"]
            direction LR
            EN["Clon exacto del template\n(N empresas...)"]
        end
        Template -.->|TEMPLATE| Emp1
        Template -.->|TEMPLATE| Emp2
        Template -.->|TEMPLATE| EmpN
    end
```

### 8.2 Estructura de bases de datos

| Base de datos | Propósito | Esquemas | Quién conecta |
|---------------|-----------|----------|---------------|
| `restaurant_pe_master` | BD administrativa central | `auth`, `master` | Solo **ms-auth-security** |
| `restaurant_pe_template` | Modelo/plantilla (nunca se usa en producción) | `core`, `almacen`, `compras`, `ventas`, `finanzas`, `contabilidad`, `rrhh`, `activos`, `produccion`, `auditoria` | Solo Flyway (migraciones) |
| `restaurant_pe_emp_{id}` | BD de cada empresa (clon del template) | Mismos 10 esquemas del template | **Todos los ms de negocio** (excepto auth) |

#### BD Master — Esquemas `master` y `auth`

- **`master`:** Contiene la tabla `tenant` con el registro de todas las empresas y sus connection strings (db_name, db_host, db_port, db_username, db_password encriptado).
- **`auth`:** Contiene las tablas de seguridad centralizadas (usuario, rol, modulo, opcion_menu, permisos, sesiones). La tabla `usuario_empresa` vincula cada usuario con las empresas a las que tiene acceso, asignando **un rol por empresa**.

> **Detalle:** Las definiciones SQL completas de estas tablas se encuentran en [`DISENO_BASE_DATOS.md`](./DISENO_BASE_DATOS.md), secciones 3 y 4.

> **Nota:** Un usuario tiene **un rol por empresa**. Al hacer login, selecciona la empresa y el sistema carga el rol correspondiente a esa empresa.

### 8.3 Flujo de resolución de tenant

```mermaid
sequenceDiagram
    participant U as Usuario
    participant FE as Angular 20
    participant GW as API Gateway
    participant AUTH as ms-auth-security
    participant MASTER as BD Master
    participant MS as ms-compras / ms-almacen / etc.
    participant TENANT_DB as BD Empresa (tenant)

    U->>FE: Login (usuario + contraseña)
    FE->>GW: POST /api/auth/login
    GW->>AUTH: Forward
    AUTH->>MASTER: Verificar credenciales (schema auth)
    MASTER-->>AUTH: Usuario + empresas disponibles
    AUTH-->>FE: JWT parcial + lista de empresas

    U->>FE: Selecciona empresa
    FE->>GW: POST /api/auth/seleccionar-empresa
    GW->>AUTH: Forward
    AUTH->>MASTER: Obtener rol + permisos + connection string
    MASTER-->>AUTH: Rol, permisos, tenant info
    AUTH->>AUTH: Generar JWT completo (con empresaId)
    AUTH-->>FE: JWT definitivo + menú dinámico

    Note over FE,TENANT_DB: Peticiones de negocio posteriores

    FE->>GW: GET /api/compras/ordenes (Header: Authorization + X-Empresa-Id)
    GW->>MS: Forward (con JWT validado)
    MS->>MS: TenantFilter → TenantContext.set(empresaId)
    MS->>MS: TenantRoutingDataSource → selecciona pool
    MS->>TENANT_DB: SELECT * FROM compras.orden_compra
    TENANT_DB-->>MS: Datos (solo de esa empresa)
    MS-->>FE: Response
```

### 8.4 Provisión de connection strings vía ms-auth-security

**ms-auth-security** es el **único microservicio** que conecta directamente a `restaurant_pe_master`. Los demás microservicios obtienen la información de tenants a través de un endpoint interno:

```java
// ms-auth-security expone endpoint interno para otros microservicios
@RestController
@RequestMapping("/internal/tenants")
public class TenantInternalController {

    @Autowired
    private TenantService tenantService;

    // Endpoint que retorna todos los tenants activos con sus connection strings
    @GetMapping("/active")
    public ResponseEntity<List<TenantConnectionInfo>> getActiveTenants() {
        return ResponseEntity.ok(tenantService.getActiveTenantsWithConnection());
    }

    // Endpoint para obtener un tenant específico
    @GetMapping("/{empresaId}")
    public ResponseEntity<TenantConnectionInfo> getTenant(
            @PathVariable Long empresaId) {
        return ResponseEntity.ok(tenantService.getTenantConnection(empresaId));
    }
}
```

```java
// DTO que retorna ms-auth a los otros microservicios
@Data
public class TenantConnectionInfo {
    private Long empresaId;
    private String codigo;
    private String nombre;
    private String jdbcUrl;     // jdbc:postgresql://host:port/db_name
    private String username;
    private String password;    // desencriptado
    private boolean activo;
}
```

Los microservicios de negocio consumen este endpoint al **arrancar**:

```java
// Cada microservicio de negocio obtiene tenants del ms-auth
@FeignClient(name = "ms-auth-security")
public interface TenantFeignClient {

    @GetMapping("/internal/tenants/active")
    List<TenantConnectionInfo> getActiveTenants();
}
```

### 8.5 Ruteo dinámico con AbstractRoutingDataSource

Cada microservicio de negocio crea un pool de conexiones (HikariCP) por cada tenant y usa `AbstractRoutingDataSource` para elegir dinámicamente:

```java
// 1. Contexto del tenant (ThreadLocal por request)
public class TenantContext {
    private static final ThreadLocal<Long> CURRENT_TENANT = new ThreadLocal<>();

    public static void setEmpresaId(Long empresaId) {
        CURRENT_TENANT.set(empresaId);
    }

    public static Long getEmpresaId() {
        return CURRENT_TENANT.get();
    }

    public static void clear() {
        CURRENT_TENANT.remove();
    }
}

// 2. Filtro que intercepta cada request y setea el tenant
@Component
public class TenantFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                     HttpServletResponse response,
                                     FilterChain chain) throws Exception {
        String empresaId = request.getHeader("X-Empresa-Id");
        if (empresaId != null) {
            TenantContext.setEmpresaId(Long.parseLong(empresaId));
        }
        try {
            chain.doFilter(request, response);
        } finally {
            TenantContext.clear();
        }
    }
}

// 3. DataSource que elige la BD según el tenant
public class TenantRoutingDataSource extends AbstractRoutingDataSource {

    @Override
    protected Object determineCurrentLookupKey() {
        return TenantContext.getEmpresaId();
    }
}

// 4. Configuración del DataSource con pools por tenant
@Configuration
public class TenantDataSourceConfig {

    @Autowired
    private TenantFeignClient tenantClient;

    @Bean
    public DataSource dataSource() {
        TenantRoutingDataSource routingDS = new TenantRoutingDataSource();
        Map<Object, Object> dataSources = new HashMap<>();

        for (TenantConnectionInfo tenant : tenantClient.getActiveTenants()) {
            HikariDataSource ds = new HikariDataSource();
            ds.setJdbcUrl(tenant.getJdbcUrl());
            ds.setUsername(tenant.getUsername());
            ds.setPassword(tenant.getPassword());
            ds.setMaximumPoolSize(10);
            ds.setMinimumIdle(2);
            ds.setPoolName("pool-tenant-" + tenant.getEmpresaId());
            dataSources.put(tenant.getEmpresaId(), ds);
        }

        routingDS.setTargetDataSources(dataSources);
        return routingDS;
    }
}
```

#### Flujo de un request de negocio

```
Cajero (Empresa 2, Bogotá) → POST /api/ventas/documentos
    │
    ├── Header: Authorization: Bearer <JWT>
    ├── Header: X-Empresa-Id: 2
    │
    ▼
API Gateway → Valida JWT → Forward a ms-ventas
    │
    ▼
TenantFilter → TenantContext.set(2)
    │
    ▼
TenantRoutingDataSource → empresaId=2 → pool: restaurant_pe_emp_2
    │
    ▼
VentaService.confirmarDocumento()
    │
    ├── UPDATE ventas.secuencia_documento SET ...  (en restaurant_pe_emp_2)
    ├── INSERT ventas.documento_venta ...           (en restaurant_pe_emp_2)
    └── COMMIT  ← Todo en la misma BD, misma transacción
```

### 8.6 Evento de nuevo tenant (sincronización dinámica)

Cuando se crea una nueva empresa, **ms-auth-security** publica un evento en RabbitMQ para que los demás microservicios actualicen su pool de conexiones **sin reinicio**:

```java
// ms-auth-security publica cuando se crea/modifica un tenant
@Service
public class TenantProvisioningService {

    @Autowired
    private RabbitTemplate rabbitTemplate;

    public void crearNuevoTenant(CrearEmpresaRequest request) {
        // 1. Crear BD clonando el template
        jdbcTemplate.execute(
            "CREATE DATABASE restaurant_pe_emp_" + request.getId()
            + " TEMPLATE restaurant_pe_template");

        // 2. Registrar en master.tenant
        tenantRepository.save(new Tenant(
            request.getCodigo(), request.getNombre(),
            "restaurant_pe_emp_" + request.getId()));

        // 3. Ejecutar migraciones Flyway en la nueva BD
        flywayMigrator.migrate("restaurant_pe_emp_" + request.getId());

        // 4. Notificar a todos los microservicios
        rabbitTemplate.convertAndSend(
            "tenant-exchange", "tenant.created",
            new TenantCreatedEvent(request.getId()));
    }
}

// Cada ms de negocio escucha y agrega el pool dinámicamente
@Component
public class TenantEventListener {

    @Autowired
    private TenantRoutingDataSource routingDataSource;

    @RabbitListener(queues = "#{tenantQueue.name}")
    public void onTenantCreated(TenantCreatedEvent event) {
        TenantConnectionInfo info = authClient.getTenant(event.getEmpresaId());
        routingDataSource.addTenantDataSource(
            event.getEmpresaId(), createDataSource(info));
    }
}
```

### 8.7 Ventajas del enfoque Database-per-Tenant

| Aspecto | Con `empresa_id` (enfoque anterior) | Database-per-Tenant (enfoque actual) |
|---------|--------------------------------------|--------------------------------------|
| **Aislamiento de datos** | Depende de `WHERE` y RLS | Total — son BDs separadas |
| **`empresa_id` en cada tabla** | Obligatorio en TODAS las tablas | **No necesario** (la BD ya es de una empresa) |
| **Queries** | `WHERE empresa_id = X` siempre | Query limpio, sin filtro adicional |
| **Riesgo de ver datos ajenos** | Posible si se olvida el `WHERE` | Imposible por diseño |
| **Backup/Restore** | Todo junto, difícil aislar | Backup independiente por empresa |
| **Performance** | Una empresa grande afecta a todas | Cada empresa tiene sus propios índices |
| **Eliminar una empresa** | `DELETE` masivo + riesgo de FK | `DROP DATABASE` y listo |
| **Numeración** | Necesita `empresa_id` en secuencia | Secuencia simple, sin `empresa_id` |
| **Escalabilidad** | Vertical (más potencia al servidor) | Horizontal (mover BD a otro servidor) |
| **Regulaciones (GDPR, etc.)** | Difícil aislar datos de un tenant | Total control, BD aislada |

### 8.8 Detalle completo de la base de datos

Las siguientes definiciones se encuentran en el documento [`DISENO_BASE_DATOS.md`](./DISENO_BASE_DATOS.md):

| Sección | Contenido |
|---------|-----------|
| **5. Convenciones** | Naming, PKs, FKs, soft delete, timestamps, enums |
| **6. Índices** | Estrategia sin `empresa_id`, parciales, multisucursal |
| **7. Flyway Multi-Tenant** | `MultiTenantMigrationRunner`, carpeta de migraciones |
| **8. Numeración atómica** | Tabla `secuencia_documento`, función `siguiente_numero()` |
| **9. Alta de nueva empresa** | `CREATE DATABASE ... TEMPLATE`, seed data |
| **10. Reportes cruzados** | Consolidación entre BDs, Data Warehouse futuro |
| **11. ER detallados** | Diagramas con todas las columnas por microservicio |
| **12. Conteo de tablas** | 94+ tablas distribuidas en 10 esquemas |

---

## 9. Seguridad y control de acceso

### 9.1 Modelo de seguridad

```mermaid
flowchart TB
    subgraph Entidades
        USR[Usuario]
        ROL[Rol]
        MENU[Opción de menú]
        MOD[Módulo]
        ACC[Acción]
    end
    USR -->|N:1 un usuario tiene un solo rol| ROL
    ROL -->|N:M| MENU
    MENU -->|N:1| MOD
    MENU -->|1:N| ACC
    USR -.->|N:M extraordinario| MENU
```

**Cardinalidades:**

- Un usuario tiene **un solo** rol (FK directo `rol_id` en tabla `usuario`).
- Un rol tiene **muchas** opciones de menú; una opción puede estar en **muchos** roles (N:M vía `rol_opcion_menu`).
- Una opción de menú pertenece a **un solo** módulo.
- Un usuario puede tener opciones de menú asignadas de forma **individual/extraordinaria** (N:M vía `usuario_opcion_menu`).

### 9.2 Flujo de autenticación (con selección de empresa)

El flujo se divide en **dos pasos**: primero se autentica al usuario y luego se selecciona la empresa.

```mermaid
sequenceDiagram
    participant U as Usuario
    participant FE as Angular 20
    participant GW as API Gateway
    participant AUTH as ms-auth-security
    participant MASTER as BD Master
    participant REDIS as Redis

    rect rgb(240, 248, 255)
        Note over U,MASTER: PASO 1 — Autenticación
        U->>FE: Login (usuario + contraseña)
        FE->>GW: POST /api/auth/login
        GW->>AUTH: Forward
        AUTH->>MASTER: Verificar credenciales (auth.usuario)
        MASTER-->>AUTH: Usuario válido
        AUTH->>MASTER: Obtener empresas del usuario (auth.usuario_empresa)
        MASTER-->>AUTH: Lista de empresas [{id, nombre, rol}]
        AUTH-->>FE: Token temporal + lista de empresas
    end

    rect rgb(255, 248, 240)
        Note over U,REDIS: PASO 2 — Selección de empresa
        U->>FE: Selecciona empresa (ej: "Restaurante Lima SAC")
        FE->>GW: POST /api/auth/seleccionar-empresa {empresaId: 1}
        GW->>AUTH: Forward (con token temporal)
        AUTH->>MASTER: Obtener rol + permisos + opciones de menú para esa empresa
        MASTER-->>AUTH: Rol, permisos del rol, opciones individuales, connection string
        AUTH->>AUTH: Generar JWT completo (access + refresh)
        AUTH->>REDIS: Almacenar sesión activa
        AUTH->>MASTER: Registrar log_acceso (LOGIN, empresaId)
        AUTH-->>GW: JWT definitivo + estructura de menú dinámico
        GW-->>FE: Response
        FE->>FE: Guardar JWT en memoria (NgRx)
        FE->>FE: Renderizar menú dinámico según permisos
    end
```

> Si el usuario solo tiene acceso a **una empresa**, el paso 2 se ejecuta automáticamente.

### 9.3 Estructura del JWT

```json
{
  "sub": "jramirez",
  "userId": 42,
  "empresaId": 1,
  "empresaCodigo": "LIMA_SAC",
  "sucursalId": 3,
  "rolId": 7,
  "rolCodigo": "JEFE_ALMACEN",
  "permisos": ["ALM_MOV_VER", "ALM_MOV_CREAR", "COM_OC_VER"],
  "iat": 1738886400,
  "exp": 1738972800
}
```

| Campo | Descripción |
|-------|-------------|
| `sub` | Username del usuario |
| `userId` | ID del usuario |
| `empresaId` | ID de la empresa seleccionada (tenant) — se usa como `X-Empresa-Id` |
| `empresaCodigo` | Código de la empresa (para display) |
| `sucursalId` | Sucursal seleccionada dentro de la empresa |
| `rolId` | ID del rol asignado **en esa empresa** |
| `rolCodigo` | Código del rol (para validaciones rápidas) |
| `permisos` | Array de códigos de permiso (opción_menú + acción) |
| `exp` | Expiración (configurable, default: 24 horas) |

> **Nota:** El `empresaId` del JWT se propaga como header `X-Empresa-Id` en todas las llamadas internas entre microservicios, permitiendo el ruteo dinámico del `TenantRoutingDataSource`.

### 9.4 Validación de permisos en el backend

Cada endpoint del backend valida permisos usando una anotación personalizada:

```java
@RestController
@RequestMapping("/api/compras/ordenes-compra")
public class OrdenCompraController {

    @PostMapping
    @RequirePermission(modulo = "COM", opcion = "OC", accion = "CREAR")
    public ResponseEntity<OrdenCompraResponse> crear(
            @RequestBody @Valid OrdenCompraRequest request) {
        // ...
    }

    @GetMapping
    @RequirePermission(modulo = "COM", opcion = "OC", accion = "VER")
    public ResponseEntity<Page<OrdenCompraResponse>> listar(
            @RequestParam Map<String, String> filtros, Pageable pageable) {
        // ...
    }
}
```

### 9.5 Tablas de seguridad (esquema `auth` en BD Master)

Todas las tablas de seguridad residen en `restaurant_pe_master.auth`, ya que son transversales a todas las empresas:

| Tabla | Propósito |
|-------|-----------|
| `usuario` | Credenciales, 2FA, bloqueo, último acceso |
| `usuario_empresa` | Vincula usuario ↔ empresa, con **un rol por empresa** |
| `rol` | Roles globales (ADMIN, JEFE_COMPRAS, AUDITOR, etc.) |
| `modulo` | Módulos del sistema (Compras, Almacén, Ventas, etc.) |
| `opcion_menu` | Opciones de menú jerárquicas vinculadas a módulos |
| `accion` | Acciones granulares (VER, CREAR, EDITAR, ELIMINAR, APROBAR, IMPRIMIR) |
| `rol_opcion_menu` | Relación N:M entre roles y opciones de menú |
| `usuario_opcion_menu` | Opciones individuales extraordinarias por usuario/empresa |
| `sesion` | Control de sesiones activas con empresa seleccionada |
| `log_acceso` | Registro de login, logout, intentos fallidos |
| `tenant` *(esquema `master`)* | Registro de empresas con connection strings para sus BDs |

> **Detalle completo** de columnas, tipos y relaciones en [`DISENO_BASE_DATOS.md`](./DISENO_BASE_DATOS.md), sección 4.

---

## 10. Configuración jerárquica (4 niveles)

El sistema maneja configuraciones con **herencia y sobreescritura**. El valor más específico siempre prevalece.

```mermaid
flowchart BT
    CE["config_empresa\n(global)"] --> CP["config_pais\n(por país)"]
    CP --> CS["config_sucursal\n(por sucursal)"]
    CS --> CU["config_usuario\n(por usuario)"]
```

**Resolución:** `config_usuario` → `config_sucursal` → `config_pais` → `config_empresa` → `config_clave.valor_default`

| Nivel | Tabla | Ejemplo |
|-------|-------|---------|
| **Empresa (global)** | `config_empresa` | Moneda base, logo, política de aprobaciones |
| **País** | `config_pais` | IGV vs IVA vs ITBIS, formato RUC/NIT, regulaciones laborales |
| **Sucursal** | `config_sucursal` | Almacén por defecto, impresora, turno, caja |
| **Usuario** | `config_usuario` | Idioma, tema visual, formato fecha, sucursal preferida |

### Implementación en backend

```java
@Service
public class ConfigService {
    
    public String getConfig(String clave, Long empresaId, 
                           Long paisId, Long sucursalId, Long usuarioId) {
        // 1. Buscar en config_usuario
        Optional<String> valor = configUsuarioRepo.findByClave(usuarioId, clave);
        if (valor.isPresent()) return valor.get();
        
        // 2. Buscar en config_sucursal
        valor = configSucursalRepo.findByClave(sucursalId, clave);
        if (valor.isPresent()) return valor.get();
        
        // 3. Buscar en config_pais
        valor = configPaisRepo.findByClave(empresaId, paisId, clave);
        if (valor.isPresent()) return valor.get();
        
        // 4. Buscar en config_empresa
        valor = configEmpresaRepo.findByClave(empresaId, clave);
        if (valor.isPresent()) return valor.get();
        
        // 5. Valor por defecto del catálogo
        return configClaveRepo.findDefaultByClave(clave);
    }
}
```

---

## 11. Comunicación entre microservicios

### 11.1 Comunicación sincrónica (REST + OpenFeign)

Para consultas directas entre servicios que requieren respuesta inmediata.

```java
// En ms-compras: cliente Feign para consultar maestros
@FeignClient(name = "ms-core-maestros")
public interface CoreMaestrosClient {
    
    @GetMapping("/api/core/relaciones-comerciales/{id}")
    RelacionComercialResponse obtenerProveedor(@PathVariable Long id);
    
    @GetMapping("/api/core/articulos/{id}")
    ArticuloResponse obtenerArticulo(@PathVariable Long id);
    
    @PostMapping("/api/core/numeradores/siguiente")
    String obtenerSiguienteNumero(@RequestBody NumeradorRequest request);
}
```

| Origen | Destino | Uso |
|--------|---------|-----|
| ms-compras | ms-core-maestros | Validar proveedor, artículo, obtener numeración |
| ms-compras | ms-almacen | Verificar stock, crear movimiento por recepción |
| ms-almacen | ms-core-maestros | Obtener datos de artículo, unidades de medida |
| ms-finanzas | ms-core-maestros | Validar relación comercial, moneda, tipo de cambio |
| ms-finanzas | ms-compras | Vincular factura con OC |
| ms-rrhh | ms-core-maestros | Obtener datos de empresa, sucursal, moneda |
| ms-activos-fijos | ms-core-maestros | Obtener datos de proveedor, artículo |
| ms-produccion | ms-almacen | Consumir stock de insumos |
| ms-produccion | ms-core-maestros | Obtener artículos, recetas |
| ms-reportes | todos | Consultar datos para generar reportes |

### 11.2 Comunicación asincrónica (RabbitMQ)

Para operaciones que no requieren respuesta inmediata y cruzan dominios.

```mermaid
flowchart LR
    subgraph Productores
        ALM[ms-almacen]
        COM[ms-compras]
        FIN[ms-finanzas]
        RRHH[ms-rrhh]
        AF[ms-activos]
        PROD[ms-produccion]
    end
    subgraph RabbitMQ
        EX_PRE[exchange: pre-asientos]
        EX_AUD[exchange: auditoria]
        EX_NOT[exchange: notificaciones]
    end
    subgraph Consumidores
        CNT[ms-contabilidad]
        AUD[ms-auditoria]
        NOTIF[ms-notificaciones]
    end
    ALM --> EX_PRE
    COM --> EX_PRE
    FIN --> EX_PRE
    RRHH --> EX_PRE
    AF --> EX_PRE
    PROD --> EX_PRE
    EX_PRE --> CNT
    ALM --> EX_AUD
    COM --> EX_AUD
    FIN --> EX_AUD
    RRHH --> EX_AUD
    EX_AUD --> AUD
    COM --> EX_NOT
    FIN --> EX_NOT
    RRHH --> EX_NOT
    EX_NOT --> NOTIF
```

#### Exchanges y colas

| Exchange | Tipo | Cola | Consumidor | Evento |
|----------|------|------|------------|--------|
| `pre-asientos` | topic | `q.contabilidad.pre-asientos` | ms-contabilidad | Todos los módulos envían pre-asientos |
| `auditoria` | fanout | `q.auditoria.logs` | ms-auditoria | CRUD de cualquier entidad |
| `notificaciones` | topic | `q.notificaciones.email` | ms-notificaciones | Aprobaciones pendientes, alertas de stock, vencimientos |
| `notificaciones` | topic | `q.notificaciones.push` | ms-notificaciones | Alertas en tiempo real |

#### Estructura de un evento

```json
{
  "eventId": "uuid-v4",
  "eventType": "MOVIMIENTO_ALMACEN_CONFIRMADO",
  "timestamp": "2026-03-15T10:30:00Z",
  "empresaId": 1,
  "sucursalId": 3,
  "usuarioId": 42,
  "moduloOrigen": "ALMACEN",
  "payload": {
    "movimientoId": 1234,
    "tipoMovimiento": "INGRESO",
    "almacenId": 5,
    "totalValorizado": 15000.00,
    "monedaId": 1,
    "detalles": [
      { "articuloId": 100, "cantidad": 50, "costoUnitario": 300.00 }
    ]
  }
}
```

---

## 12. Motor de pre-asientos contables

Todos los módulos operativos generan **pre-asientos** que Contabilidad procesa para convertir en asientos contables.

### 12.1 Flujo

```mermaid
flowchart LR
    A[Módulo operativo] -->|1. Confirma operación| B[Genera pre-asiento]
    B -->|2. Publica evento| C[RabbitMQ]
    C -->|3. Consume| D[ms-contabilidad]
    D -->|4. Busca matriz contable| E[matriz_contable]
    E -->|5. Genera asiento| F[asiento + asiento_detalle]
    D -->|Error| G[pre_asiento estado=ERROR]
```

### 12.2 Matriz contable (reglas de contabilización)

| Módulo | Operación | Cuenta Debe | Cuenta Haber |
|--------|-----------|-------------|--------------|
| Almacén | Ingreso por compra | 20 - Mercaderías | 61 - Variación existencias |
| Almacén | Salida por consumo | 61 - Variación existencias | 20 - Mercaderías |
| Compras | Factura proveedor | 60 - Compras | 42 - CxP comerciales |
| Finanzas | Pago a proveedor | 42 - CxP comerciales | 10 - Efectivo |
| Finanzas | Cobro a cliente | 10 - Efectivo | 12 - CxC comerciales |
| RRHH | Planilla mensual | 62 - Gastos personal | 41 - Remuneraciones por pagar |
| Activos | Depreciación mensual | 68 - Depreciación | 39 - Depreciación acumulada |
| Producción | Consumo de insumos | 92 - Costo producción | 20 - Mercaderías |

### 12.3 Tabla pre_asiento

```sql
-- En cada BD de empresa (restaurant_pe_emp_{id})
CREATE TABLE contabilidad.pre_asiento (
    id              BIGSERIAL PRIMARY KEY,
    -- No necesita empresa_id (la BD ya es de una sola empresa)
    modulo_origen   VARCHAR(20) NOT NULL,    -- ALMACEN, COMPRAS, FINANZAS...
    tipo_operacion  VARCHAR(50) NOT NULL,    -- INGRESO_ALMACEN, FACTURA_PROVEEDOR...
    documento_tipo  VARCHAR(20),             -- OC, FACTURA, PLANILLA...
    documento_id    BIGINT,
    fecha           DATE NOT NULL,
    estado          VARCHAR(20) DEFAULT 'PENDIENTE', -- PENDIENTE/PROCESADO/ERROR
    datos_json      JSONB NOT NULL,          -- Payload completo del evento
    asiento_id      BIGINT,                  -- FK al asiento generado (si procesado)
    error_mensaje   TEXT,                    -- Detalle del error si falla
    creado_en       TIMESTAMP DEFAULT NOW()
);
```

---

## 13. Auditoría y trazabilidad

### 13.1 Dos niveles de auditoría

| Nivel | Mecanismo | Datos |
|-------|-----------|-------|
| **Por registro** | Columnas en cada tabla | `creado_por`, `creado_en`, `modificado_por`, `modificado_en` |
| **Por operación** | Servicio centralizado (ms-auditoria) | Quién, cuándo, qué entidad, qué acción, datos antes/después, IP, user-agent |

### 13.2 Flujo de auditoría

```mermaid
flowchart LR
    A[Cualquier microservicio] -->|Evento CRUD| B[RabbitMQ - exchange auditoria]
    B --> C[ms-auditoria]
    C --> D[(tabla log_auditoria)]
```

### 13.3 Estructura del log

```json
{
  "empresaId": 1,
  "usuarioId": 42,
  "username": "jramirez",
  "modulo": "COMPRAS",
  "entidad": "orden_compra",
  "entidadId": 1234,
  "accion": "CREAR",
  "datosAnteriores": null,
  "datosNuevos": { "numero": "OC-2026-001", "total": 15000.00, "estado": "BORRADOR" },
  "ip": "192.168.1.100",
  "userAgent": "Mozilla/5.0...",
  "fecha": "2026-03-15T10:30:00Z"
}
```

---

## 14. Reportes y exportación

### 14.1 Arquitectura del motor de reportes

| Componente | Tecnología | Uso |
|------------|------------|-----|
| **Motor** | JasperReports | Generación de reportes PDF |
| **Excel** | Apache POI | Exportación a Excel (.xlsx) |
| **Plantillas** | .jrxml | Diseño de reportes (se almacenan en ms-reportes) |
| **Datos** | OpenFeign | ms-reportes consulta datos de otros microservicios |

### 14.2 Reportes por módulo

| Módulo | Reportes |
|--------|----------|
| **Almacén** | Stock actual, kardex, movimientos por período, valorización, inventario físico, artículos bajo stock mínimo |
| **Compras** | OC pendientes, compras por proveedor, compras por período, recepciones |
| **Finanzas** | Estado de cuenta proveedor/cliente, flujo de caja, antigüedad de saldos, conciliación bancaria |
| **Contabilidad** | Balance General, Estado de Resultados, Flujo de Efectivo, Estado de Patrimonio, libros electrónicos |
| **RRHH** | Planilla, asistencia, headcount, rotación, boletas de pago, PLAME |
| **Activos** | Depreciación acumulada, activos por ubicación, seguros vigentes |
| **Producción** | Costos por receta, consumos, rendimiento |

---

## 15. Notificaciones

### 15.1 Tipos de notificación

| Tipo | Canal | Ejemplo |
|------|-------|---------|
| **Email** | SMTP / SendGrid | Notificación de OC pendiente de aprobación |
| **Push** | WebSocket (STOMP) | Alerta de stock bajo mínimo en tiempo real |
| **In-app** | Base de datos + polling | Recordatorios de tareas pendientes |
| **Archivos** | Generación automática | Boletas de pago (PDF), PLAME (TXT) |

### 15.2 Eventos que disparan notificaciones

| Evento | Notificación | Destinatario |
|--------|-------------|--------------|
| OC creada pendiente aprobación | Email + push | Aprobador(es) del nivel |
| OC aprobada/rechazada | Email | Creador de la OC |
| Stock bajo punto de reorden | Push in-app | Responsable de almacén |
| Vencimiento de contrato laboral | Email | Jefe RRHH + trabajador |
| Póliza de seguro próxima a vencer | Email | Responsable de activos |
| Planilla calculada lista para aprobación | Email + push | Gerente RRHH |
| Cierre contable completado | Email | Contador principal |

---

## 16. Infraestructura y DevOps

### 16.1 Contenedores Docker

Cada microservicio tiene su propio `Dockerfile`:

```dockerfile
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY target/ms-compras-*.jar app.jar
EXPOSE 9004
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### 16.2 Docker Compose (desarrollo local)

```yaml
services:
  # Infraestructura
  postgres:
    image: postgres:16-alpine
    ports: ["5432:5432"]
    volumes: [pgdata:/var/lib/postgresql/data]
    
  rabbitmq:
    image: rabbitmq:3-management-alpine
    ports: ["5672:5672", "15672:15672"]
    
  redis:
    image: redis:7-alpine
    ports: ["6379:6379"]

  # Spring Cloud
  eureka-server:
    build: ./eureka-server
    ports: ["8761:8761"]
    
  config-server:
    build: ./config-server
    ports: ["8888:8888"]
    depends_on: [eureka-server]
    
  api-gateway:
    build: ./api-gateway
    ports: ["8080:8080"]
    depends_on: [eureka-server, config-server]

  # Microservicios de negocio
  ms-auth-security:
    build: ./ms-auth-security
    ports: ["9001:9001"]
    depends_on: [postgres, eureka-server, config-server, redis]
    
  ms-core-maestros:
    build: ./ms-core-maestros
    ports: ["9002:9002"]
    depends_on: [postgres, eureka-server, config-server]

  # ... (demás microservicios)
```

### 16.3 CI/CD Pipeline (GitHub Actions)

```mermaid
flowchart LR
    A[Push / PR] --> B[Build + Test]
    B --> C[SonarQube Analysis]
    C --> D{¿Quality Gate OK?}
    D -->|Sí| E[Build Docker Image]
    D -->|No| F[Fallar pipeline]
    E --> G[Push a Registry]
    G --> H{¿Branch?}
    H -->|develop| I[Deploy a DEV]
    H -->|release| J[Deploy a QA]
    H -->|main| K[Deploy a PROD]
```

### 16.4 Monitoreo

| Herramienta | Uso |
|-------------|-----|
| **Spring Boot Actuator** | Health checks, métricas por servicio |
| **Prometheus** | Recolección de métricas |
| **Grafana** | Dashboards de monitoreo (CPU, memoria, latencia, errores) |
| **ELK Stack** | Centralización de logs (Elasticsearch + Logstash + Kibana) |
| **Spring Sleuth + Zipkin** | Tracing distribuido entre microservicios |

---

## 17. Entornos

| Entorno | Propósito | Infraestructura | Base de datos |
|---------|-----------|-----------------|---------------|
| **DEV** | Desarrollo y pruebas de integración | Docker Compose local | PostgreSQL local (datos de prueba) |
| **QA** | Pruebas funcionales, UAT, regresión | Docker en servidor de staging | PostgreSQL con datos de prueba realistas |
| **PROD** | Producción | Docker / Kubernetes en cloud | PostgreSQL dedicado con backup automático |

Cada entorno tiene su perfil de Spring Cloud Config:

```
application-dev.yml     # Configuración desarrollo
application-qa.yml      # Configuración QA
application-prod.yml    # Configuración producción
application-PE.yml      # Configuración Perú
application-CO.yml      # Configuración Colombia
```

---

## 18. Estándares de API REST

### 18.1 Estructura de URLs

```
/api/{modulo}/{recurso}                    # Colección
/api/{modulo}/{recurso}/{id}               # Recurso específico
/api/{modulo}/{recurso}/{id}/{sub-recurso} # Sub-recurso

Ejemplos:
GET    /api/compras/ordenes-compra              # Listar OC
POST   /api/compras/ordenes-compra              # Crear OC
GET    /api/compras/ordenes-compra/123           # Obtener OC 123
PUT    /api/compras/ordenes-compra/123           # Actualizar OC 123
DELETE /api/compras/ordenes-compra/123           # Desactivar OC 123 (soft delete)
GET    /api/compras/ordenes-compra/123/detalle   # Detalle de OC 123
POST   /api/compras/ordenes-compra/123/aprobar   # Acción: aprobar OC 123
```

### 18.2 Paginación

```json
GET /api/almacen/movimientos?page=0&size=20&sort=fecha,desc

{
  "content": [...],
  "page": {
    "number": 0,
    "size": 20,
    "totalElements": 156,
    "totalPages": 8
  }
}
```

### 18.3 Filtrado

```
GET /api/compras/ordenes-compra?proveedorId=15&estado=APROBADA&fechaDesde=2026-03-01&fechaHasta=2026-03-31
```

### 18.4 Response estándar

```json
{
  "success": true,
  "data": { ... },
  "message": "Orden de compra creada exitosamente",
  "timestamp": "2026-03-15T10:30:00Z"
}
```

### 18.5 Versionado de API

```
/api/v1/compras/ordenes-compra    # Versión 1 (default)
/api/v2/compras/ordenes-compra    # Versión 2 (cuando sea necesario)
```

---

## 19. Manejo de errores

### 19.1 Códigos HTTP

| Código | Uso |
|:------:|-----|
| `200` | OK — consulta exitosa |
| `201` | Created — recurso creado |
| `204` | No Content — eliminación exitosa |
| `400` | Bad Request — validación fallida |
| `401` | Unauthorized — sin autenticación |
| `403` | Forbidden — sin permisos |
| `404` | Not Found — recurso no encontrado |
| `409` | Conflict — conflicto de negocio (ej: stock insuficiente) |
| `422` | Unprocessable Entity — error de regla de negocio |
| `500` | Internal Server Error — error no controlado |
| `503` | Service Unavailable — servicio caído (circuit breaker abierto) |

### 19.2 Estructura de error

```json
{
  "success": false,
  "error": {
    "code": "COM-001",
    "message": "No se puede aprobar una OC con monto cero",
    "details": [
      { "field": "total", "message": "El total debe ser mayor a 0" }
    ],
    "timestamp": "2026-03-15T10:30:00Z",
    "path": "/api/compras/ordenes-compra/123/aprobar"
  }
}
```

### 19.3 Códigos de error por módulo

| Prefijo | Módulo |
|---------|--------|
| `AUTH-xxx` | Autenticación y seguridad |
| `CORE-xxx` | Maestros compartidos |
| `ALM-xxx` | Almacén |
| `COM-xxx` | Compras |
| `FIN-xxx` | Finanzas |
| `CNT-xxx` | Contabilidad |
| `RRHH-xxx` | Recursos Humanos |
| `AF-xxx` | Activos Fijos |
| `PROD-xxx` | Producción |

### 19.4 Exception Handler global

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ApiError> handleBusinessException(BusinessException ex) {
        return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY)
            .body(ApiError.of(ex.getCode(), ex.getMessage()));
    }

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ApiError> handleNotFound(ResourceNotFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
            .body(ApiError.of("NOT_FOUND", ex.getMessage()));
    }

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ApiError> handleAccessDenied(AccessDeniedException ex) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN)
            .body(ApiError.of("AUTH-003", "No tiene permisos para esta operación"));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiError> handleValidation(MethodArgumentNotValidException ex) {
        List<FieldError> errors = ex.getBindingResult().getFieldErrors().stream()
            .map(f -> new FieldError(f.getField(), f.getDefaultMessage()))
            .toList();
        return ResponseEntity.badRequest()
            .body(ApiError.of("VALIDATION", "Error de validación", errors));
    }
}
```

---

## 20. Modelo de datos completo

### 20.1 Diagrama ER resumen

```mermaid
erDiagram
    EMPRESA ||--o{ SUCURSAL : tiene
    SUCURSAL }o--|| PAIS : pertenece
    SUCURSAL ||--o{ ALMACEN : tiene
    USUARIO }o--o{ SUCURSAL : asignado
    USUARIO }o--|| ROL : "tiene un solo"
    ROL }o--o{ OPCION_MENU : asigna
    OPCION_MENU }o--|| MODULO : pertenece
    USUARIO }o--o{ OPCION_MENU : "individual"
    EMPRESA ||--o{ RELACION_COMERCIAL : tiene
    EMPRESA ||--o{ ARTICULO : tiene
    ARTICULO }o--|| CATEGORIA : pertenece
    ARTICULO }o--|| UNIDAD_MEDIDA : usa
    RELACION_COMERCIAL }o--o{ ARTICULO_PROVEEDOR : suministra
    ALMACEN ||--o{ STOCK : contiene
    STOCK }o--|| ARTICULO : de
    ALMACEN ||--o{ MOVIMIENTO_ALMACEN : registra
    MOVIMIENTO_ALMACEN }o--|| TIPO_MOVIMIENTO : es
    RELACION_COMERCIAL ||--o{ ORDEN_COMPRA : recibe
    ORDEN_COMPRA ||--o{ RECEPCION : genera
    RECEPCION ||--o{ MOVIMIENTO_ALMACEN : genera
    RELACION_COMERCIAL ||--o{ DOCUMENTO_PAGAR : genera
    RELACION_COMERCIAL ||--o{ DOCUMENTO_COBRAR : genera
    DOCUMENTO_PAGAR ||--o{ PAGO : recibe
    DOCUMENTO_COBRAR ||--o{ COBRO : recibe
    EMPRESA ||--o{ CUENTA_CONTABLE : tiene
    ASIENTO ||--o{ ASIENTO_DETALLE : contiene
    CUENTA_CONTABLE ||--o{ ASIENTO_DETALLE : en
    EMPRESA ||--o{ TRABAJADOR : emplea
    TRABAJADOR }o--|| CARGO : ocupa
    PLANILLA ||--o{ PLANILLA_DETALLE : contiene
    EMPRESA ||--o{ ACTIVO_FIJO : posee
    ACTIVO_FIJO }o--|| CLASE_ACTIVO : es
    ACTIVO_FIJO ||--o{ DEPRECIACION : calcula
    RECETA ||--o{ RECETA_DETALLE : contiene
    RECETA_DETALLE }o--|| ARTICULO : usa
    ORDEN_PRODUCCION }o--|| RECETA : ejecuta
    CONFIG_CLAVE ||--o{ CONFIG_EMPRESA : configura
    CONFIG_CLAVE ||--o{ CONFIG_PAIS : configura
    CONFIG_CLAVE ||--o{ CONFIG_SUCURSAL : configura
    CONFIG_CLAVE ||--o{ CONFIG_USUARIO : configura
```

### 20.2 Conteo de tablas por esquema

| Esquema | Tablas | Descripción |
|---------|:------:|-------------|
| `auth` *(BD Master)* | 11 | Usuarios, roles, permisos, menú, sesiones |
| `master` *(BD Master)* | 1 | Registro de tenants |
| `core` | 25+ | Empresa, sucursal, país, moneda, artículos, categorías, impuestos, configuración |
| `almacen` | 7 | Movimientos, kardex, stock, inventario físico |
| `compras` | 7 | OC, OS, aprobaciones, recepción |
| `ventas` | 14 | Documentos de venta, mesas, comandas, facturación electrónica |
| `finanzas` | 12 | CxP, CxC, tesorería, conciliación, adelantos |
| `contabilidad` | 7 | Asientos, pre-asientos, matrices, cierres |
| `rrhh` | 11 | Trabajadores, planilla, asistencia, liquidaciones |
| `activos` | 7 | Activos, depreciación, seguros, traslados |
| `produccion` | 5 | Recetas, órdenes, costeo |
| `auditoria` | 2 | Log de auditoría |
| **Total** | **94+** | |

> **Detalle completo:** Diagramas ER con todas las columnas y relaciones en [`DISENO_BASE_DATOS.md`](./DISENO_BASE_DATOS.md), sección 11.

---

## 21. Patrones de diseño aplicados

| Patrón | Dónde se aplica | Justificación |
|--------|----------------|---------------|
| **API Gateway** | Spring Cloud Gateway | Punto de entrada único, desacopla frontend de microservicios |
| **Service Discovery** | Eureka Server | Los servicios se descubren dinámicamente sin hardcodear IPs |
| **Circuit Breaker** | Resilience4j | Tolerancia a fallos cuando un servicio no responde |
| **Event-Driven** | RabbitMQ | Pre-asientos contables, auditoría, notificaciones |
| **CQRS (parcial)** | Separación lectura/escritura en reportes | ms-reportes solo lee, no escribe |
| **Repository Pattern** | Spring Data JPA | Abstracción de acceso a datos |
| **DTO Pattern** | Request/Response DTOs | Nunca se exponen entidades JPA directamente |
| **Strategy Pattern** | Métodos de costeo (promedio, PEPS, UEPS) | Algoritmo intercambiable por configuración |
| **Observer Pattern** | Eventos RabbitMQ | Publicar/suscribir entre módulos desacoplados |
| **Template Method** | BaseEntity | Auditoría y multiempresa heredada por todas las entidades |
| **Builder Pattern** | Lombok @Builder | Construcción fluida de objetos complejos |
| **Specification Pattern** | JPA Specifications | Filtros dinámicos en consultas (reportes, listados) |
| **Decorator** | JWT Interceptor (Angular) | Agrega headers de autenticación a todas las peticiones |
| **Lazy Loading** | Angular Modules | Carga de módulos bajo demanda para performance |

---

## 22. Requisitos no funcionales

| Requisito | Especificación |
|-----------|---------------|
| **Disponibilidad** | 99.5% uptime en horario operativo (6am–12am) |
| **Tiempo de respuesta** | < 2 segundos para operaciones CRUD, < 5 segundos para reportes |
| **Concurrencia** | Soporte para 200+ usuarios simultáneos |
| **Escalabilidad** | Horizontal: cada microservicio puede escalar independientemente |
| **Seguridad** | JWT con expiración, HTTPS obligatorio, passwords hasheados (BCrypt), rate limiting |
| **Backup** | PostgreSQL: backup diario automático, retención 30 días |
| **Recuperación** | RPO: 1 hora, RTO: 4 horas |
| **Idiomas** | Español (default), inglés, portugués (i18n en frontend) |
| **Navegadores** | Chrome 90+, Firefox 90+, Edge 90+, Safari 15+ |
| **Resolución** | Responsive: 1024px mínimo, optimizado para 1366px y 1920px |
| **Accesibilidad** | WCAG 2.1 nivel AA |
| **Datos** | Retención mínima: 5 años de datos transaccionales |
| **Logs** | Retención: 90 días en Elasticsearch, 1 año en almacenamiento frío |

---

## 23. Endpoints por microservicio

A continuación se detallan **todos los endpoints REST** de cada microservicio. Convención: `{id}` = path variable, query params para filtros y paginación.

> **Headers obligatorios en todas las peticiones (excepto login):**  
> `Authorization: Bearer {jwt_token}`  
> `X-Empresa-Id: {empresaId}`  
> `X-Sucursal-Id: {sucursalId}`

---

### 23.1 ms-auth-security (:9001)

#### Autenticación

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| POST | `/api/auth/login` | Iniciar sesión (devuelve JWT + menú) |
| POST | `/api/auth/refresh` | Renovar token con refresh token |
| POST | `/api/auth/logout` | Cerrar sesión (invalidar token) |
| GET | `/api/auth/me` | Obtener datos del usuario autenticado |
| PUT | `/api/auth/cambiar-password` | Cambiar contraseña del usuario autenticado |

#### Usuarios

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/auth/usuarios` | Listar usuarios (paginado, filtros) |
| GET | `/api/auth/usuarios/{id}` | Obtener usuario por ID |
| POST | `/api/auth/usuarios` | Crear usuario |
| PUT | `/api/auth/usuarios/{id}` | Actualizar usuario |
| DELETE | `/api/auth/usuarios/{id}` | Desactivar usuario (soft delete) |
| PUT | `/api/auth/usuarios/{id}/reset-password` | Resetear contraseña |
| GET | `/api/auth/usuarios/{id}/sucursales` | Sucursales asignadas al usuario |
| PUT | `/api/auth/usuarios/{id}/sucursales` | Asignar sucursales al usuario |
| GET | `/api/auth/usuarios/{id}/opciones-menu` | Opciones de menú individuales del usuario |
| PUT | `/api/auth/usuarios/{id}/opciones-menu` | Asignar opciones de menú individuales |

#### Roles

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/auth/roles` | Listar roles |
| GET | `/api/auth/roles/{id}` | Obtener rol por ID |
| POST | `/api/auth/roles` | Crear rol |
| PUT | `/api/auth/roles/{id}` | Actualizar rol |
| DELETE | `/api/auth/roles/{id}` | Desactivar rol |
| GET | `/api/auth/roles/{id}/opciones-menu` | Opciones de menú del rol |
| PUT | `/api/auth/roles/{id}/opciones-menu` | Asignar opciones de menú al rol |
| GET | `/api/auth/roles/{id}/permisos` | Permisos granulares del rol |
| PUT | `/api/auth/roles/{id}/permisos` | Asignar permisos al rol |

#### Módulos y menú

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/auth/modulos` | Listar módulos del ERP |
| GET | `/api/auth/opciones-menu` | Listar todas las opciones de menú |
| GET | `/api/auth/opciones-menu/arbol` | Árbol jerárquico de opciones por módulo |
| GET | `/api/auth/acciones` | Listar acciones posibles (VER, CREAR, EDITAR...) |

#### Sesiones

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/auth/sesiones` | Listar sesiones activas |
| DELETE | `/api/auth/sesiones/{id}` | Cerrar sesión específica |

---

### 23.2 ms-core-maestros (:9002)

#### Empresa y estructura organizacional

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/core/empresas` | Listar empresas |
| GET | `/api/core/empresas/{id}` | Obtener empresa |
| POST | `/api/core/empresas` | Crear empresa |
| PUT | `/api/core/empresas/{id}` | Actualizar empresa |
| GET | `/api/core/sucursales` | Listar sucursales (filtro por empresa) |
| GET | `/api/core/sucursales/{id}` | Obtener sucursal |
| POST | `/api/core/sucursales` | Crear sucursal |
| PUT | `/api/core/sucursales/{id}` | Actualizar sucursal |

#### Geografía

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/core/paises` | Listar países |
| GET | `/api/core/paises/{id}/departamentos` | Departamentos de un país |
| GET | `/api/core/departamentos/{id}/provincias` | Provincias de un departamento |
| GET | `/api/core/provincias/{id}/distritos` | Distritos de una provincia |

#### Monedas y tipo de cambio

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/core/monedas` | Listar monedas |
| POST | `/api/core/monedas` | Crear moneda |
| PUT | `/api/core/monedas/{id}` | Actualizar moneda |
| GET | `/api/core/tipos-cambio` | Listar tipos de cambio (filtro por fecha, moneda) |
| GET | `/api/core/tipos-cambio/fecha/{fecha}` | Tipo de cambio de una fecha |
| POST | `/api/core/tipos-cambio` | Registrar tipo de cambio |

#### Relaciones comerciales (proveedor/cliente unificado)

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/core/relaciones-comerciales` | Listar (filtro: esProveedor, esCliente, documento) |
| GET | `/api/core/relaciones-comerciales/{id}` | Obtener relación comercial |
| POST | `/api/core/relaciones-comerciales` | Crear relación comercial |
| PUT | `/api/core/relaciones-comerciales/{id}` | Actualizar relación comercial |
| DELETE | `/api/core/relaciones-comerciales/{id}` | Desactivar |
| GET | `/api/core/relaciones-comerciales/{id}/contactos` | Contactos de la relación |
| POST | `/api/core/relaciones-comerciales/{id}/contactos` | Agregar contacto |
| GET | `/api/core/relaciones-comerciales/{id}/cuentas-bancarias` | Cuentas bancarias |
| POST | `/api/core/relaciones-comerciales/{id}/cuentas-bancarias` | Agregar cuenta bancaria |
| GET | `/api/core/tipos-documento-identidad` | Listar tipos (RUC, DNI, NIT...) |

#### Artículos y clasificación

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/core/articulos` | Listar artículos (paginado, filtros) |
| GET | `/api/core/articulos/{id}` | Obtener artículo completo |
| POST | `/api/core/articulos` | Crear artículo |
| PUT | `/api/core/articulos/{id}` | Actualizar artículo |
| DELETE | `/api/core/articulos/{id}` | Desactivar artículo |
| GET | `/api/core/articulos/{id}/proveedores` | Proveedores del artículo |
| POST | `/api/core/articulos/{id}/proveedores` | Asociar proveedor a artículo |
| GET | `/api/core/articulos/{id}/almacenes` | Config de stock por almacén |
| POST | `/api/core/articulos/{id}/almacenes` | Configurar artículo en almacén |
| GET | `/api/core/categorias` | Listar categorías (jerárquico) |
| GET | `/api/core/categorias/arbol` | Árbol completo de categorías |
| POST | `/api/core/categorias` | Crear categoría |
| PUT | `/api/core/categorias/{id}` | Actualizar categoría |
| GET | `/api/core/unidades-medida` | Listar unidades de medida |
| POST | `/api/core/unidades-medida` | Crear unidad |
| GET | `/api/core/conversiones-unidad` | Listar conversiones |
| POST | `/api/core/conversiones-unidad` | Crear conversión |
| GET | `/api/core/naturalezas-contables` | Listar naturalezas contables |
| POST | `/api/core/naturalezas-contables` | Crear naturaleza contable |

#### Impuestos y retenciones

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/core/impuestos` | Listar impuestos (filtro por país) |
| POST | `/api/core/impuestos` | Crear impuesto |
| PUT | `/api/core/impuestos/{id}` | Actualizar impuesto |
| GET | `/api/core/retenciones` | Listar retenciones |
| POST | `/api/core/retenciones` | Crear retención |
| GET | `/api/core/detracciones` | Listar detracciones |
| POST | `/api/core/detracciones` | Crear detracción |

#### Numeradores, condiciones y formas de pago

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/core/numeradores` | Listar numeradores |
| POST | `/api/core/numeradores` | Crear numerador |
| POST | `/api/core/numeradores/siguiente` | Obtener siguiente número |
| GET | `/api/core/condiciones-pago` | Listar condiciones de pago |
| POST | `/api/core/condiciones-pago` | Crear condición de pago |
| GET | `/api/core/formas-pago` | Listar formas de pago |
| POST | `/api/core/formas-pago` | Crear forma de pago |

#### Configuración jerárquica

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/core/config/claves` | Catálogo de claves de configuración |
| GET | `/api/core/config/resolver?clave={clave}` | Resolver valor (busca en los 4 niveles) |
| GET | `/api/core/config/empresa` | Configuraciones a nivel empresa |
| PUT | `/api/core/config/empresa` | Guardar configuración empresa |
| GET | `/api/core/config/pais/{paisId}` | Configuraciones a nivel país |
| PUT | `/api/core/config/pais/{paisId}` | Guardar configuración país |
| GET | `/api/core/config/sucursal/{sucursalId}` | Configuraciones a nivel sucursal |
| PUT | `/api/core/config/sucursal/{sucursalId}` | Guardar configuración sucursal |
| GET | `/api/core/config/usuario/{usuarioId}` | Configuraciones a nivel usuario |
| PUT | `/api/core/config/usuario/{usuarioId}` | Guardar configuración usuario |

#### Tablas auxiliares

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/core/ejercicios-periodos` | Listar ejercicios y períodos |
| POST | `/api/core/ejercicios-periodos` | Crear ejercicio/período |
| PUT | `/api/core/ejercicios-periodos/{id}` | Actualizar estado (ABIERTO/CERRADO) |
| GET | `/api/core/parametros-sistema` | Listar parámetros del sistema |
| PUT | `/api/core/parametros-sistema` | Actualizar parámetros |

---

### 23.3 ms-almacen (:9003)

#### Almacenes

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/almacen/almacenes` | Listar almacenes (filtro por sucursal, tipo) |
| GET | `/api/almacen/almacenes/{id}` | Obtener almacén con ubicaciones |
| POST | `/api/almacen/almacenes` | Crear almacén |
| PUT | `/api/almacen/almacenes/{id}` | Actualizar almacén |
| DELETE | `/api/almacen/almacenes/{id}` | Desactivar almacén |

#### Ubicaciones dentro de almacén

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/almacen/almacenes/{id}/ubicaciones` | Listar ubicaciones (pasillos, estantes, niveles) |
| POST | `/api/almacen/almacenes/{id}/ubicaciones` | Crear ubicación |
| PUT | `/api/almacen/ubicaciones/{id}` | Actualizar ubicación |
| DELETE | `/api/almacen/ubicaciones/{id}` | Eliminar ubicación (si no tiene stock) |

#### Tipos de movimiento

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/almacen/tipos-movimiento` | Listar tipos de movimiento |
| GET | `/api/almacen/tipos-movimiento/{id}` | Obtener tipo de movimiento |
| POST | `/api/almacen/tipos-movimiento` | Crear tipo de movimiento |
| PUT | `/api/almacen/tipos-movimiento/{id}` | Actualizar tipo |
| DELETE | `/api/almacen/tipos-movimiento/{id}` | Desactivar tipo |

#### Movimientos de almacén

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/almacen/movimientos` | Listar movimientos (paginado, filtros: almacén, fecha, tipo, estado) |
| GET | `/api/almacen/movimientos/{id}` | Obtener movimiento con detalle completo |
| POST | `/api/almacen/movimientos` | Crear movimiento (borrador) |
| PUT | `/api/almacen/movimientos/{id}` | Actualizar movimiento (solo borrador) |
| POST | `/api/almacen/movimientos/{id}/confirmar` | Confirmar movimiento (actualiza stock y kardex) |
| POST | `/api/almacen/movimientos/{id}/anular` | Anular movimiento (genera contra-movimiento) |
| POST | `/api/almacen/movimientos/importar` | Importar movimientos desde Excel |
| GET | `/api/almacen/movimientos/exportar` | Exportar movimientos a Excel |
| GET | `/api/almacen/movimientos/{id}/pdf` | Descargar movimiento en PDF |

#### Stock y kardex

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/almacen/stock` | Consultar stock consolidado (filtros: almacén, artículo, categoría) |
| GET | `/api/almacen/stock/{articuloId}/almacen/{almacenId}` | Stock de un artículo en un almacén |
| GET | `/api/almacen/stock/{articuloId}/todos-almacenes` | Stock del artículo en todos los almacenes |
| GET | `/api/almacen/stock/bajo-minimo` | Artículos con stock bajo mínimo |
| GET | `/api/almacen/stock/sobre-maximo` | Artículos con stock sobre máximo |
| GET | `/api/almacen/stock/sin-movimiento` | Artículos sin movimiento (N días) |
| POST | `/api/almacen/stock/reprocesar` | Reprocesar saldos de inventario |
| GET | `/api/almacen/kardex` | Consultar kardex (filtros: artículo, almacén, fechaDesde, fechaHasta) |
| GET | `/api/almacen/kardex/valorizado` | Kardex valorizado (promedio ponderado) |
| GET | `/api/almacen/kardex/exportar` | Exportar kardex a Excel |

#### Lotes y series

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/almacen/lotes` | Listar lotes (filtro: artículo, almacén) |
| GET | `/api/almacen/lotes/{id}` | Detalle de lote |
| GET | `/api/almacen/lotes/por-vencer` | Lotes próximos a vencer |
| GET | `/api/almacen/lotes/vencidos` | Lotes vencidos |

#### Reservas de stock

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/almacen/reservas` | Listar reservas activas |
| POST | `/api/almacen/reservas` | Crear reserva de stock |
| DELETE | `/api/almacen/reservas/{id}` | Liberar reserva |
| GET | `/api/almacen/stock/{articuloId}/disponible` | Stock disponible (total - reservado) |

#### Inventario físico

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/almacen/inventarios-fisicos` | Listar tomas de inventario |
| GET | `/api/almacen/inventarios-fisicos/{id}` | Obtener inventario con detalle |
| POST | `/api/almacen/inventarios-fisicos` | Iniciar toma de inventario (bloquea almacén) |
| PUT | `/api/almacen/inventarios-fisicos/{id}/detalle` | Registrar conteo físico |
| POST | `/api/almacen/inventarios-fisicos/{id}/segundo-conteo` | Registrar segundo conteo (verificación) |
| POST | `/api/almacen/inventarios-fisicos/{id}/comparar` | Comparar físico vs sistema |
| POST | `/api/almacen/inventarios-fisicos/{id}/ajustar` | Aplicar ajustes de inventario |
| POST | `/api/almacen/inventarios-fisicos/{id}/cerrar` | Cerrar toma y desbloquear almacén |
| GET | `/api/almacen/inventarios-fisicos/{id}/diferencias` | Informe de diferencias |

#### Traslados entre almacenes

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/almacen/traslados` | Listar traslados |
| GET | `/api/almacen/traslados/{id}` | Detalle de traslado |
| POST | `/api/almacen/traslados` | Crear traslado entre almacenes |
| POST | `/api/almacen/traslados/{id}/despachar` | Despachar traslado (salida origen) |
| POST | `/api/almacen/traslados/{id}/confirmar-recepcion` | Confirmar recepción (ingreso destino) |
| POST | `/api/almacen/traslados/{id}/anular` | Anular traslado |
| GET | `/api/almacen/traslados/{id}/guia-remision` | Generar guía de remisión |

#### Devoluciones a proveedor

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/almacen/devoluciones` | Consultar devoluciones |
| GET | `/api/almacen/devoluciones/{id}` | Detalle de devolución |
| POST | `/api/almacen/devoluciones` | Registrar devolución a proveedor |
| POST | `/api/almacen/devoluciones/{id}/confirmar` | Confirmar devolución (salida de almacén) |
| POST | `/api/almacen/devoluciones/{id}/anular` | Anular devolución |

#### Solicitudes de reposición

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/almacen/solicitudes-reposicion` | Listar solicitudes |
| POST | `/api/almacen/solicitudes-reposicion/generar-automatica` | Generar solicitudes automáticas por stock mínimo |
| POST | `/api/almacen/solicitudes-reposicion/{id}/aprobar` | Aprobar solicitud |
| POST | `/api/almacen/solicitudes-reposicion/{id}/convertir-oc` | Convertir a OC en ms-compras |

#### Reportes

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/almacen/reportes/stock-actual` | Reporte de stock actual por almacén |
| GET | `/api/almacen/reportes/stock-consolidado` | Stock consolidado todos los almacenes |
| GET | `/api/almacen/reportes/kardex` | Reporte de kardex valorizado |
| GET | `/api/almacen/reportes/movimientos` | Reporte de movimientos por período |
| GET | `/api/almacen/reportes/valorizacion` | Valorización económica del stock |
| GET | `/api/almacen/reportes/rotacion` | Rotación de inventario (ABC) |
| GET | `/api/almacen/reportes/stock-bajo-minimo` | Artículos bajo mínimo |
| GET | `/api/almacen/reportes/lotes-por-vencer` | Lotes próximos a vencer |
| GET | `/api/almacen/reportes/guias-remision` | Guías de remisión emitidas |

---

### 23.4 ms-compras (:9004)

#### Solicitudes de compra

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/compras/solicitudes` | Listar solicitudes de compra |
| GET | `/api/compras/solicitudes/{id}` | Obtener solicitud con detalle |
| POST | `/api/compras/solicitudes` | Crear solicitud de compra |
| PUT | `/api/compras/solicitudes/{id}` | Actualizar solicitud |
| POST | `/api/compras/solicitudes/{id}/enviar` | Enviar solicitud para cotización |
| POST | `/api/compras/solicitudes/{id}/aprobar` | Aprobar solicitud |
| POST | `/api/compras/solicitudes/{id}/rechazar` | Rechazar solicitud |
| DELETE | `/api/compras/solicitudes/{id}` | Anular solicitud |

#### Cotizaciones a proveedores

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/compras/cotizaciones` | Listar cotizaciones |
| GET | `/api/compras/cotizaciones/{id}` | Obtener cotización con detalle |
| POST | `/api/compras/cotizaciones` | Registrar cotización recibida |
| PUT | `/api/compras/cotizaciones/{id}` | Actualizar cotización |
| POST | `/api/compras/cotizaciones/{id}/seleccionar` | Seleccionar cotización ganadora |
| GET | `/api/compras/cotizaciones/comparativo` | Cuadro comparativo de cotizaciones (por solicitud) |
| POST | `/api/compras/cotizaciones/{id}/convertir-oc` | Convertir cotización en OC |

#### Órdenes de compra

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/compras/ordenes-compra` | Listar OC (paginado, filtros: estado, proveedor, fecha) |
| GET | `/api/compras/ordenes-compra/{id}` | Obtener OC con detalle completo |
| POST | `/api/compras/ordenes-compra` | Crear OC |
| PUT | `/api/compras/ordenes-compra/{id}` | Actualizar OC (solo borrador) |
| POST | `/api/compras/ordenes-compra/{id}/enviar-aprobacion` | Enviar a aprobación |
| POST | `/api/compras/ordenes-compra/{id}/aprobar` | Aprobar OC |
| POST | `/api/compras/ordenes-compra/{id}/rechazar` | Rechazar OC (con motivo) |
| POST | `/api/compras/ordenes-compra/{id}/devolver` | Devolver OC para corrección |
| POST | `/api/compras/ordenes-compra/{id}/anular` | Anular OC |
| GET | `/api/compras/ordenes-compra/{id}/historial-aprobaciones` | Historial de aprobaciones |
| GET | `/api/compras/ordenes-compra/{id}/recepciones` | Recepciones vinculadas |
| GET | `/api/compras/ordenes-compra/{id}/saldo-pendiente` | Saldo pendiente de recepción |
| GET | `/api/compras/ordenes-compra/{id}/pdf` | Descargar OC en PDF |
| POST | `/api/compras/ordenes-compra/{id}/enviar-proveedor` | Enviar OC al proveedor por email |
| GET | `/api/compras/ordenes-compra/pendientes-aprobacion` | Bandeja de aprobación |
| GET | `/api/compras/ordenes-compra/exportar` | Exportar OC a Excel |

#### Órdenes de servicio

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/compras/ordenes-servicio` | Listar OS |
| GET | `/api/compras/ordenes-servicio/{id}` | Obtener OS con detalle |
| POST | `/api/compras/ordenes-servicio` | Crear OS |
| PUT | `/api/compras/ordenes-servicio/{id}` | Actualizar OS |
| POST | `/api/compras/ordenes-servicio/{id}/enviar-aprobacion` | Enviar a aprobación |
| POST | `/api/compras/ordenes-servicio/{id}/aprobar` | Aprobar OS |
| POST | `/api/compras/ordenes-servicio/{id}/rechazar` | Rechazar OS |
| POST | `/api/compras/ordenes-servicio/{id}/completar` | Marcar servicio como completado |
| POST | `/api/compras/ordenes-servicio/{id}/anular` | Anular OS |
| GET | `/api/compras/ordenes-servicio/{id}/pdf` | Descargar OS en PDF |

#### Contratos marco

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/compras/contratos-marco` | Listar contratos marco |
| GET | `/api/compras/contratos-marco/{id}` | Obtener contrato con detalle |
| POST | `/api/compras/contratos-marco` | Crear contrato marco |
| PUT | `/api/compras/contratos-marco/{id}` | Actualizar contrato |
| GET | `/api/compras/contratos-marco/{id}/oc-generadas` | OC generadas bajo el contrato |
| GET | `/api/compras/contratos-marco/por-vencer` | Contratos próximos a vencer |

#### Recepción de mercadería

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/compras/recepciones` | Listar recepciones |
| GET | `/api/compras/recepciones/{id}` | Obtener recepción con detalle |
| POST | `/api/compras/recepciones` | Crear recepción (vinculada a OC) |
| PUT | `/api/compras/recepciones/{id}` | Actualizar recepción (borrador) |
| POST | `/api/compras/recepciones/{id}/confirmar` | Confirmar recepción (genera mov. almacén + CxP) |
| POST | `/api/compras/recepciones/{id}/anular` | Anular recepción |
| GET | `/api/compras/recepciones/{id}/pdf` | Descargar recepción en PDF |

#### Evaluación de proveedores

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/compras/evaluacion-proveedores` | Listar evaluaciones |
| GET | `/api/compras/evaluacion-proveedores/{proveedorId}` | Evaluación de un proveedor |
| POST | `/api/compras/evaluacion-proveedores` | Registrar evaluación del período |
| GET | `/api/compras/evaluacion-proveedores/ranking` | Ranking de proveedores (A, B, C, D) |

#### Planificación de abastecimiento

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/compras/abastecimiento/sugerencias` | Sugerencias de compra (basado en stock mínimo y consumo) |
| POST | `/api/compras/abastecimiento/generar-solicitudes` | Generar solicitudes de compra automáticas |
| GET | `/api/compras/abastecimiento/proyeccion` | Proyección de abastecimiento (N semanas) |

#### Reportes

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/compras/reportes/oc-pendientes` | OC pendientes de recepción |
| GET | `/api/compras/reportes/compras-por-proveedor` | Compras agrupadas por proveedor |
| GET | `/api/compras/reportes/compras-por-periodo` | Compras por período |
| GET | `/api/compras/reportes/compras-por-articulo` | Compras por artículo |
| GET | `/api/compras/reportes/cumplimiento-proveedores` | Cumplimiento de entregas |
| GET | `/api/compras/reportes/comparativo-precios` | Comparativo de precios (histórico) |
| GET | `/api/compras/reportes/contratos-vigentes` | Contratos marco vigentes |
| GET | `/api/compras/reportes/aprobaciones-pendientes` | Resumen de aprobaciones pendientes |

---

### 23.5 ms-finanzas (:9005)

#### Cuentas por pagar (CxP)

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/finanzas/cuentas-pagar` | Listar documentos por pagar |
| GET | `/api/finanzas/cuentas-pagar/{id}` | Obtener documento |
| POST | `/api/finanzas/cuentas-pagar` | Registrar factura/documento |
| PUT | `/api/finanzas/cuentas-pagar/{id}` | Actualizar documento |
| POST | `/api/finanzas/cuentas-pagar/{id}/anular` | Anular documento |
| GET | `/api/finanzas/cuentas-pagar/{id}/pagos` | Pagos aplicados al documento |

#### Cuentas por cobrar (CxC)

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/finanzas/cuentas-cobrar` | Listar documentos por cobrar |
| GET | `/api/finanzas/cuentas-cobrar/{id}` | Obtener documento |
| POST | `/api/finanzas/cuentas-cobrar` | Registrar documento |
| PUT | `/api/finanzas/cuentas-cobrar/{id}` | Actualizar documento |
| GET | `/api/finanzas/cuentas-cobrar/{id}/cobros` | Cobros aplicados |

#### Pagos

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/finanzas/pagos` | Listar pagos realizados |
| GET | `/api/finanzas/pagos/{id}` | Detalle de pago |
| POST | `/api/finanzas/pagos` | Registrar pago a proveedor |
| POST | `/api/finanzas/pagos/masivo` | Pago masivo (múltiples documentos) |
| POST | `/api/finanzas/pagos/{id}/anular` | Anular pago |
| GET | `/api/finanzas/pagos/{id}/voucher` | Generar voucher de pago PDF |

#### Cobros

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/finanzas/cobros` | Listar cobros realizados |
| GET | `/api/finanzas/cobros/{id}` | Detalle de cobro |
| POST | `/api/finanzas/cobros` | Registrar cobro a cliente |
| POST | `/api/finanzas/cobros/{id}/anular` | Anular cobro |
| GET | `/api/finanzas/cobros/{id}/recibo` | Generar recibo de cobro PDF |

#### Letras (CxC)

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/finanzas/letras` | Listar letras por cobrar |
| POST | `/api/finanzas/letras/canje` | Canjear documentos por letras |
| POST | `/api/finanzas/letras/{id}/renovar` | Renovar letra |
| POST | `/api/finanzas/letras/{id}/protestar` | Protestar letra |
| POST | `/api/finanzas/letras/{id}/cobrar` | Registrar cobro de letra |

#### Tesorería

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/finanzas/cuentas-bancarias` | Listar cuentas bancarias |
| GET | `/api/finanzas/cuentas-bancarias/{id}` | Detalle de cuenta bancaria |
| POST | `/api/finanzas/cuentas-bancarias` | Crear cuenta bancaria |
| PUT | `/api/finanzas/cuentas-bancarias/{id}` | Actualizar cuenta |
| GET | `/api/finanzas/cuentas-bancarias/{id}/saldo` | Saldo actual de cuenta |
| GET | `/api/finanzas/movimientos-bancarios` | Listar movimientos bancarios |
| GET | `/api/finanzas/movimientos-bancarios/{id}` | Detalle de movimiento |
| POST | `/api/finanzas/movimientos-bancarios` | Registrar movimiento manual |
| POST | `/api/finanzas/movimientos-bancarios/importar-extracto` | Importar extracto bancario (Excel/CSV) |
| GET | `/api/finanzas/movimientos-bancarios/exportar` | Exportar movimientos a Excel |

#### Cajas y fondo fijo

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/finanzas/cajas` | Listar cajas |
| POST | `/api/finanzas/cajas` | Crear caja |
| PUT | `/api/finanzas/cajas/{id}` | Actualizar caja |
| GET | `/api/finanzas/fondos-fijos` | Listar fondos fijos |
| POST | `/api/finanzas/fondos-fijos` | Crear fondo fijo |
| PUT | `/api/finanzas/fondos-fijos/{id}` | Actualizar fondo fijo |
| GET | `/api/finanzas/fondos-fijos/{id}/rendiciones` | Listar rendiciones del fondo |
| POST | `/api/finanzas/fondos-fijos/{id}/rendiciones` | Registrar rendición de gasto |
| POST | `/api/finanzas/fondos-fijos/{id}/rendiciones/{rendId}/aprobar` | Aprobar rendición |
| POST | `/api/finanzas/fondos-fijos/{id}/reponer` | Solicitar reposición de fondo |

#### Conciliación bancaria

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/finanzas/conciliaciones` | Listar conciliaciones |
| GET | `/api/finanzas/conciliaciones/{id}` | Detalle de conciliación |
| POST | `/api/finanzas/conciliaciones` | Iniciar conciliación (cuenta + período) |
| POST | `/api/finanzas/conciliaciones/{id}/comparar-automatico` | Comparación automática |
| PUT | `/api/finanzas/conciliaciones/{id}/partidas` | Marcar/desmarcar partidas manualmente |
| POST | `/api/finanzas/conciliaciones/{id}/finalizar` | Finalizar conciliación |
| GET | `/api/finanzas/conciliaciones/{id}/diferencias` | Detalle de diferencias |

#### Conciliación con pasarelas digitales

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| POST | `/api/finanzas/conciliacion-pasarelas/importar` | Importar movimientos de pasarela (Niubiz/Yape/Plin) |
| POST | `/api/finanzas/conciliacion-pasarelas/conciliar` | Conciliar pagos de pasarela vs ventas |
| GET | `/api/finanzas/conciliacion-pasarelas/diferencias` | Diferencias encontradas |

#### Adelantos y órdenes de giro

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/finanzas/adelantos` | Listar adelantos |
| GET | `/api/finanzas/adelantos/{id}` | Detalle de adelanto |
| POST | `/api/finanzas/adelantos` | Crear solicitud de adelanto |
| POST | `/api/finanzas/adelantos/{id}/aprobar` | Aprobar adelanto |
| POST | `/api/finanzas/adelantos/{id}/desembolsar` | Registrar desembolso |
| POST | `/api/finanzas/adelantos/{id}/liquidar` | Liquidar adelanto |

#### Programación de pagos

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/finanzas/programacion-pagos` | Listar programaciones |
| POST | `/api/finanzas/programacion-pagos` | Crear programación de pagos |
| PUT | `/api/finanzas/programacion-pagos/{id}` | Editar programación |
| POST | `/api/finanzas/programacion-pagos/{id}/ejecutar` | Ejecutar programación |
| GET | `/api/finanzas/programacion-pagos/sugerencia` | Sugerencia automática (documentos por vencer) |

#### Reportes

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/finanzas/reportes/estado-cuenta-proveedor` | Estado de cuenta por proveedor |
| GET | `/api/finanzas/reportes/estado-cuenta-cliente` | Estado de cuenta por cliente |
| GET | `/api/finanzas/reportes/flujo-caja` | Flujo de caja real |
| GET | `/api/finanzas/reportes/flujo-caja-proyectado` | Flujo de caja proyectado |
| GET | `/api/finanzas/reportes/antiguedad-saldos-pagar` | Antigüedad saldos CxP |
| GET | `/api/finanzas/reportes/antiguedad-saldos-cobrar` | Antigüedad saldos CxC |
| GET | `/api/finanzas/reportes/programacion-pagos` | Programación de pagos pendientes |
| GET | `/api/finanzas/reportes/movimientos-bancarios` | Resumen movimientos bancarios |
| GET | `/api/finanzas/reportes/cxp-por-vencer` | CxP por vencer (próximos N días) |
| GET | `/api/finanzas/reportes/cxc-vencidas` | CxC vencidas |
| GET | `/api/finanzas/reportes/letras-cartera` | Cartera de letras |
| GET | `/api/finanzas/reportes/fondos-fijos-pendientes` | Fondos fijos con rendiciones pendientes |

---

### 23.6 ms-contabilidad (:9006)

#### Plan contable

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/contabilidad/cuentas-contables` | Listar cuentas (jerárquico) |
| GET | `/api/contabilidad/cuentas-contables/arbol` | Árbol completo del plan |
| POST | `/api/contabilidad/cuentas-contables` | Crear cuenta |
| PUT | `/api/contabilidad/cuentas-contables/{id}` | Actualizar cuenta |
| GET | `/api/contabilidad/centros-costo` | Listar centros de costo |
| POST | `/api/contabilidad/centros-costo` | Crear centro de costo |
| GET | `/api/contabilidad/libros-contables` | Listar libros contables |

#### Asientos contables

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/contabilidad/asientos` | Listar asientos (filtros: período, libro, tipo) |
| GET | `/api/contabilidad/asientos/{id}` | Obtener asiento con detalle |
| POST | `/api/contabilidad/asientos` | Crear asiento manual |
| PUT | `/api/contabilidad/asientos/{id}` | Actualizar asiento (solo borrador) |
| POST | `/api/contabilidad/asientos/{id}/confirmar` | Confirmar asiento |
| POST | `/api/contabilidad/asientos/{id}/anular` | Anular asiento |

#### Pre-asientos

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/contabilidad/pre-asientos` | Listar pre-asientos (filtros: estado, módulo) |
| POST | `/api/contabilidad/pre-asientos/procesar` | Procesar pre-asientos pendientes |
| POST | `/api/contabilidad/pre-asientos/{id}/reprocesar` | Reprocesar un pre-asiento con error |

#### Matrices contables

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/contabilidad/matrices` | Listar matrices contables |
| POST | `/api/contabilidad/matrices` | Crear regla de contabilización |
| PUT | `/api/contabilidad/matrices/{id}` | Actualizar regla |

#### Cierres

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| POST | `/api/contabilidad/cierres/mensual` | Ejecutar cierre mensual |
| POST | `/api/contabilidad/cierres/anual` | Ejecutar cierre anual |
| POST | `/api/contabilidad/cierres/{periodoId}/reabrir` | Reabrir período cerrado (requiere auditoría) |
| GET | `/api/contabilidad/cierres/estado` | Estado de cierre por período |
| GET | `/api/contabilidad/cierres/validar-pre-cierre` | Validar pre-requisitos de cierre |
| POST | `/api/contabilidad/cierres/asiento-apertura` | Generar asiento de apertura |

#### Balance de comprobación

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/contabilidad/balance-comprobacion` | Balance de comprobación (filtros: período, nivel) |
| GET | `/api/contabilidad/balance-comprobacion/exportar` | Exportar a Excel |
| GET | `/api/contabilidad/analisis-cuenta/{cuentaId}` | Análisis de cuenta (movimientos) |
| GET | `/api/contabilidad/mayor-analitico` | Mayor analítico |
| GET | `/api/contabilidad/hoja-trabajo` | Hoja de trabajo |

#### Reportes / EEFF

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/contabilidad/reportes/balance-general` | Balance General |
| GET | `/api/contabilidad/reportes/estado-resultados` | Estado de Resultados |
| GET | `/api/contabilidad/reportes/flujo-efectivo` | Flujo de Efectivo |
| GET | `/api/contabilidad/reportes/patrimonio` | Estado de Cambios en el Patrimonio |
| GET | `/api/contabilidad/reportes/notas-eeff` | Notas a los Estados Financieros |
| GET | `/api/contabilidad/reportes/libro-diario` | Libro diario |
| GET | `/api/contabilidad/reportes/libro-mayor` | Libro mayor |
| GET | `/api/contabilidad/reportes/libro-caja-bancos` | Libro caja y bancos |
| GET | `/api/contabilidad/reportes/registro-compras` | Registro de compras |
| GET | `/api/contabilidad/reportes/registro-ventas` | Registro de ventas |
| GET | `/api/contabilidad/reportes/balance-comprobacion` | Balance de comprobación PDF |
| GET | `/api/contabilidad/reportes/comparativo-periodos` | Comparativo entre períodos |
| GET | `/api/contabilidad/reportes/presupuesto-vs-real` | Presupuesto vs ejecución real |
| POST | `/api/contabilidad/reportes/libros-electronicos/ple` | Generar PLE (Programa de Libros Electrónicos) |
| POST | `/api/contabilidad/reportes/libros-electronicos/sire` | Generar SIRE (Sistema Integrado de Registros Electrónicos) |
| GET | `/api/contabilidad/reportes/libros-electronicos/estado` | Estado de generación de libros |

---

### 23.7 ms-rrhh (:9007)

#### Trabajadores

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/rrhh/trabajadores` | Listar trabajadores (paginado, filtros) |
| GET | `/api/rrhh/trabajadores/{id}` | Obtener ficha completa |
| POST | `/api/rrhh/trabajadores` | Crear trabajador |
| PUT | `/api/rrhh/trabajadores/{id}` | Actualizar trabajador |
| POST | `/api/rrhh/trabajadores/{id}/cesar` | Registrar cese |
| GET | `/api/rrhh/trabajadores/{id}/contratos` | Contratos del trabajador |
| POST | `/api/rrhh/trabajadores/{id}/contratos` | Crear contrato |
| PUT | `/api/rrhh/trabajadores/{id}/contratos/{contratoId}/renovar` | Renovar contrato |

#### Estructura organizacional

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/rrhh/areas` | Listar áreas (jerárquico) |
| POST | `/api/rrhh/areas` | Crear área |
| GET | `/api/rrhh/cargos` | Listar cargos |
| POST | `/api/rrhh/cargos` | Crear cargo |
| GET | `/api/rrhh/afps` | Listar AFPs |

#### Asistencia

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/rrhh/asistencias` | Consultar asistencias (filtros: trabajador, fecha) |
| POST | `/api/rrhh/asistencias/marcar` | Registrar marcación (entrada/salida) |
| POST | `/api/rrhh/asistencias/carga-masiva` | Carga masiva desde Excel |
| GET | `/api/rrhh/asistencias/resumen-mensual` | Resumen mensual por trabajador |

#### Planilla

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/rrhh/conceptos-planilla` | Listar conceptos de planilla |
| POST | `/api/rrhh/conceptos-planilla` | Crear concepto |
| GET | `/api/rrhh/planillas` | Listar planillas |
| POST | `/api/rrhh/planillas` | Crear planilla (período + tipo) |
| POST | `/api/rrhh/planillas/{id}/calcular` | Calcular planilla |
| POST | `/api/rrhh/planillas/{id}/aprobar` | Aprobar planilla |
| POST | `/api/rrhh/planillas/{id}/pagar` | Registrar pago de planilla |
| POST | `/api/rrhh/planillas/{id}/cerrar` | Cerrar planilla |
| GET | `/api/rrhh/planillas/{id}/detalle` | Detalle por trabajador y concepto |

#### Horarios y turnos

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/rrhh/horarios` | Listar horarios |
| POST | `/api/rrhh/horarios` | Crear horario |
| PUT | `/api/rrhh/horarios/{id}` | Actualizar horario |
| POST | `/api/rrhh/trabajadores/{id}/asignar-horario` | Asignar horario a trabajador |

#### Permisos y licencias

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/rrhh/permisos-licencias` | Listar permisos y licencias |
| GET | `/api/rrhh/permisos-licencias/{id}` | Detalle de permiso/licencia |
| POST | `/api/rrhh/permisos-licencias` | Solicitar permiso/licencia |
| POST | `/api/rrhh/permisos-licencias/{id}/aprobar` | Aprobar permiso |
| POST | `/api/rrhh/permisos-licencias/{id}/rechazar` | Rechazar permiso |

#### Horas extra y subsidios

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/rrhh/horas-extra` | Listar horas extra registradas |
| POST | `/api/rrhh/horas-extra` | Registrar horas extra |
| POST | `/api/rrhh/horas-extra/{id}/aprobar` | Aprobar horas extra |
| GET | `/api/rrhh/subsidios` | Listar subsidios |
| POST | `/api/rrhh/subsidios` | Registrar subsidio |

#### Préstamos

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/rrhh/prestamos` | Listar préstamos |
| GET | `/api/rrhh/prestamos/{id}` | Detalle de préstamo con cuotas |
| POST | `/api/rrhh/prestamos` | Crear préstamo a trabajador |
| POST | `/api/rrhh/prestamos/{id}/aprobar` | Aprobar préstamo |
| GET | `/api/rrhh/prestamos/{id}/cuotas` | Listar cuotas del préstamo |

#### Liquidaciones y beneficios

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| POST | `/api/rrhh/liquidaciones` | Calcular liquidación de beneficios |
| GET | `/api/rrhh/liquidaciones/{id}` | Obtener liquidación detallada |
| POST | `/api/rrhh/liquidaciones/{id}/aprobar` | Aprobar liquidación |
| POST | `/api/rrhh/liquidaciones/{id}/pagar` | Registrar pago de liquidación |
| GET | `/api/rrhh/liquidaciones/{id}/pdf` | Descargar liquidación en PDF |
| GET | `/api/rrhh/vacaciones` | Consultar saldos de vacaciones |
| POST | `/api/rrhh/vacaciones` | Programar goce vacacional |
| POST | `/api/rrhh/vacaciones/{id}/aprobar` | Aprobar vacaciones |
| GET | `/api/rrhh/cts` | Consultar CTS acumulada por trabajador |
| POST | `/api/rrhh/cts/calcular` | Calcular CTS del semestre |
| GET | `/api/rrhh/gratificaciones` | Consultar gratificaciones |
| POST | `/api/rrhh/gratificaciones/calcular` | Calcular gratificaciones del período |

#### Propinas y recargo al consumo

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/rrhh/propinas` | Listar distribución de propinas |
| POST | `/api/rrhh/propinas/distribuir` | Distribuir propinas del período |
| GET | `/api/rrhh/recargo-consumo` | Listar distribución de recargo al consumo |
| POST | `/api/rrhh/recargo-consumo/distribuir` | Distribuir recargo del período |

#### Reportes y regulatorios

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/rrhh/reportes/planilla` | Reporte de planilla |
| GET | `/api/rrhh/reportes/planilla-resumen` | Resumen de planilla por concepto |
| GET | `/api/rrhh/reportes/asistencia` | Reporte de asistencia |
| GET | `/api/rrhh/reportes/asistencia-consolidado` | Asistencia consolidada mensual |
| GET | `/api/rrhh/reportes/headcount` | Reporte de headcount |
| GET | `/api/rrhh/reportes/rotacion` | Índice de rotación de personal |
| GET | `/api/rrhh/reportes/costos-laborales` | Costos laborales por área/sucursal |
| GET | `/api/rrhh/reportes/horas-extra` | Reporte de horas extra |
| GET | `/api/rrhh/reportes/vacaciones-pendientes` | Vacaciones pendientes |
| GET | `/api/rrhh/reportes/cts-depositos` | CTS pendientes de depósito |
| GET | `/api/rrhh/reportes/prestamos-activos` | Préstamos activos |
| POST | `/api/rrhh/reportes/plame` | Generar archivo PLAME |
| POST | `/api/rrhh/reportes/t-registro` | Generar T-Registro |
| POST | `/api/rrhh/reportes/boletas-pago` | Generar boletas de pago (PDF masivo) |
| POST | `/api/rrhh/reportes/boletas-pago/{trabajadorId}` | Generar boleta individual |
| POST | `/api/rrhh/reportes/certificado-trabajo/{trabajadorId}` | Generar certificado de trabajo |
| POST | `/api/rrhh/reportes/constancia-ingresos/{trabajadorId}` | Constancia de ingresos 5ta categoría |

---

### 23.8 ms-activos-fijos (:9008)

#### Clases y clasificación

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/activos/clases-activo` | Listar clases de activo |
| GET | `/api/activos/clases-activo/{id}` | Obtener clase |
| POST | `/api/activos/clases-activo` | Crear clase (con cuentas contables y tasa depreciación) |
| PUT | `/api/activos/clases-activo/{id}` | Actualizar clase |

#### Ubicaciones físicas

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/activos/ubicaciones` | Listar ubicaciones físicas (jerárquico) |
| GET | `/api/activos/ubicaciones/arbol` | Árbol completo de ubicaciones |
| POST | `/api/activos/ubicaciones` | Crear ubicación |
| PUT | `/api/activos/ubicaciones/{id}` | Actualizar ubicación |

#### Activos fijos

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/activos/activos-fijos` | Listar activos fijos (paginado, filtros: clase, ubicación, estado) |
| GET | `/api/activos/activos-fijos/{id}` | Obtener ficha completa del activo |
| POST | `/api/activos/activos-fijos` | Registrar activo (vinculado a compra/factura) |
| PUT | `/api/activos/activos-fijos/{id}` | Actualizar activo |
| POST | `/api/activos/activos-fijos/{id}/baja` | Dar de baja activo (venta/donación/siniestro) |
| POST | `/api/activos/activos-fijos/{id}/revaluar` | Revaluar activo |
| GET | `/api/activos/activos-fijos/{id}/historial` | Historial completo (depreciación, traslados, mejoras) |
| GET | `/api/activos/activos-fijos/{id}/componentes` | Listar componentes del activo |
| POST | `/api/activos/activos-fijos/{id}/componentes` | Agregar componente |
| GET | `/api/activos/activos-fijos/{id}/qr` | Generar código QR del activo |
| GET | `/api/activos/activos-fijos/buscar-qr/{codigo}` | Buscar activo por código QR |
| POST | `/api/activos/activos-fijos/importar` | Importar activos desde Excel |
| GET | `/api/activos/activos-fijos/exportar` | Exportar activos a Excel |

#### Mejoras de activos

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/activos/mejoras` | Listar mejoras registradas |
| POST | `/api/activos/activos-fijos/{id}/mejoras` | Registrar mejora (incrementa valor del activo) |
| PUT | `/api/activos/mejoras/{id}` | Actualizar mejora |

#### Depreciación

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| POST | `/api/activos/depreciacion/ejecutar` | Ejecutar depreciación mensual masiva |
| POST | `/api/activos/depreciacion/simular` | Simular depreciación (sin aplicar) |
| GET | `/api/activos/depreciacion/{activoId}` | Historial de depreciación de un activo |
| GET | `/api/activos/depreciacion/resumen-mensual` | Resumen de depreciación del mes |
| GET | `/api/activos/depreciacion/proyeccion/{activoId}` | Proyección de depreciación futura |

#### Seguros y pólizas

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/activos/aseguradoras` | Listar aseguradoras |
| POST | `/api/activos/aseguradoras` | Crear aseguradora |
| PUT | `/api/activos/aseguradoras/{id}` | Actualizar aseguradora |
| GET | `/api/activos/polizas` | Listar pólizas |
| GET | `/api/activos/polizas/{id}` | Detalle de póliza con activos cubiertos |
| POST | `/api/activos/polizas` | Crear póliza |
| PUT | `/api/activos/polizas/{id}` | Actualizar póliza |
| POST | `/api/activos/polizas/{id}/activos` | Agregar activos a la póliza |
| DELETE | `/api/activos/polizas/{id}/activos/{activoId}` | Remover activo de la póliza |
| GET | `/api/activos/polizas/por-vencer` | Pólizas próximas a vencer |

#### Traslados

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/activos/traslados` | Listar traslados |
| GET | `/api/activos/traslados/{id}` | Detalle de traslado |
| POST | `/api/activos/traslados` | Solicitar traslado de activo |
| POST | `/api/activos/traslados/{id}/aprobar` | Aprobar traslado |
| POST | `/api/activos/traslados/{id}/rechazar` | Rechazar traslado |
| POST | `/api/activos/traslados/{id}/ejecutar` | Ejecutar traslado (cambiar ubicación) |

#### Mantenimientos

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/activos/mantenimientos` | Listar mantenimientos |
| POST | `/api/activos/mantenimientos` | Programar mantenimiento |
| PUT | `/api/activos/mantenimientos/{id}` | Actualizar mantenimiento |
| POST | `/api/activos/mantenimientos/{id}/completar` | Marcar como completado |
| GET | `/api/activos/mantenimientos/proximos` | Mantenimientos próximos (próximos N días) |

#### Inventario de activos

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| POST | `/api/activos/inventario/iniciar` | Iniciar toma de inventario de activos |
| PUT | `/api/activos/inventario/{id}/registrar` | Registrar activo encontrado (por QR) |
| POST | `/api/activos/inventario/{id}/comparar` | Comparar inventario vs sistema |
| POST | `/api/activos/inventario/{id}/cerrar` | Cerrar toma de inventario |

#### Reportes

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/activos/reportes/depreciacion-acumulada` | Reporte depreciación acumulada |
| GET | `/api/activos/reportes/depreciacion-mensual` | Depreciación del mes |
| GET | `/api/activos/reportes/activos-por-ubicacion` | Activos por ubicación |
| GET | `/api/activos/reportes/activos-por-clase` | Activos por clase |
| GET | `/api/activos/reportes/seguros-vigentes` | Seguros vigentes |
| GET | `/api/activos/reportes/bajas-periodo` | Bajas del período |
| GET | `/api/activos/reportes/valor-patrimonial` | Valor patrimonial total |
| GET | `/api/activos/reportes/mantenimientos-pendientes` | Mantenimientos pendientes |
| GET | `/api/activos/reportes/activos-totalmente-depreciados` | Activos totalmente depreciados |

---

### 23.9 ms-produccion (:9009)

#### Recetas (BOM gastronómico)

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/produccion/recetas` | Listar recetas (filtros: tipo, estado, artículo) |
| GET | `/api/produccion/recetas/{id}` | Obtener receta con detalle de insumos |
| POST | `/api/produccion/recetas` | Crear receta |
| PUT | `/api/produccion/recetas/{id}` | Actualizar receta |
| DELETE | `/api/produccion/recetas/{id}` | Desactivar receta |
| POST | `/api/produccion/recetas/{id}/nueva-version` | Crear nueva versión de receta |
| GET | `/api/produccion/recetas/{id}/versiones` | Listar versiones de una receta |
| GET | `/api/produccion/recetas/{id}/costo-estimado` | Calcular costo estimado actual |
| POST | `/api/produccion/recetas/{id}/duplicar` | Duplicar receta (para variantes) |
| GET | `/api/produccion/recetas/{id}/subrecetas` | Listar sub-recetas incluidas |
| POST | `/api/produccion/recetas/{id}/subrecetas` | Agregar sub-receta |
| GET | `/api/produccion/recetas/{id}/insumos-alternativos` | Listar insumos alternativos |
| POST | `/api/produccion/recetas/{id}/insumos-alternativos` | Registrar insumo alternativo |
| POST | `/api/produccion/recetas/importar` | Importar recetas desde Excel |
| GET | `/api/produccion/recetas/exportar` | Exportar recetas a Excel |

#### Órdenes de producción

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/produccion/ordenes-produccion` | Listar órdenes (filtros: estado, fecha, receta) |
| GET | `/api/produccion/ordenes-produccion/{id}` | Obtener orden con detalle completo |
| POST | `/api/produccion/ordenes-produccion` | Crear orden de producción |
| PUT | `/api/produccion/ordenes-produccion/{id}` | Actualizar orden (solo PLANIFICADA) |
| POST | `/api/produccion/ordenes-produccion/{id}/iniciar` | Iniciar producción |
| POST | `/api/produccion/ordenes-produccion/{id}/completar` | Completar producción (consume almacén, ingresa PT) |
| POST | `/api/produccion/ordenes-produccion/{id}/cancelar` | Cancelar orden |
| GET | `/api/produccion/ordenes-produccion/{id}/costeo` | Costeo detallado (MP + MO + CI) |
| GET | `/api/produccion/ordenes-produccion/{id}/insumos-consumidos` | Insumos realmente consumidos |
| GET | `/api/produccion/ordenes-produccion/{id}/merma` | Detalle de merma |
| POST | `/api/produccion/ordenes-produccion/{id}/registrar-merma` | Registrar merma real |

#### Control de calidad

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/produccion/control-calidad` | Listar inspecciones |
| POST | `/api/produccion/control-calidad` | Registrar inspección de calidad |
| GET | `/api/produccion/control-calidad/{ordenId}` | Inspecciones de una orden |
| PUT | `/api/produccion/control-calidad/{id}` | Actualizar resultado de inspección |

#### Programación de producción

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/produccion/programacion` | Listar programación (filtros: fecha, sucursal, turno) |
| POST | `/api/produccion/programacion` | Crear programación |
| PUT | `/api/produccion/programacion/{id}` | Actualizar programación |
| DELETE | `/api/produccion/programacion/{id}` | Cancelar programación |
| POST | `/api/produccion/programacion/{id}/ejecutar` | Ejecutar (generar orden de producción) |
| GET | `/api/produccion/programacion/semanal` | Vista semanal de programación |
| POST | `/api/produccion/programacion/generar-automatica` | Generar programación automática (basada en ventas históricas) |

#### Costeo

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/produccion/costeo/resumen` | Resumen de costeo por receta (período) |
| GET | `/api/produccion/costeo/comparativo` | Costo estimado vs real |
| GET | `/api/produccion/costeo/tendencia/{recetaId}` | Tendencia de costo (últimos N meses) |
| POST | `/api/produccion/costeo/recalcular` | Recalcular costos estimados (con precios actuales) |

#### Reportes

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/produccion/reportes/costos-por-receta` | Reporte de costos por receta |
| GET | `/api/produccion/reportes/consumos` | Reporte de consumos de insumos |
| GET | `/api/produccion/reportes/rendimiento` | Reporte de rendimiento vs esperado |
| GET | `/api/produccion/reportes/merma` | Reporte de merma por receta/período |
| GET | `/api/produccion/reportes/produccion-diaria` | Producción diaria por sucursal |
| GET | `/api/produccion/reportes/eficiencia` | Eficiencia de producción (tiempo, merma, rendimiento) |
| GET | `/api/produccion/reportes/insumos-mas-consumidos` | Top insumos más consumidos |
| GET | `/api/produccion/reportes/costo-por-plato` | Food cost por plato |
| GET | `/api/produccion/reportes/recetas-sin-uso` | Recetas sin producción (N días) |

---

### 23.10 ms-ventas (:9010)

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/ventas/documentos` | Listar documentos de venta (filtros: fecha, sucursal, tipo, estado) |
| GET | `/api/ventas/documentos/{id}` | Obtener documento de venta con detalle |
| POST | `/api/ventas/documentos` | Crear documento de venta (boleta/factura) |
| POST | `/api/ventas/documentos/{id}/anular` | Anular documento de venta |
| POST | `/api/ventas/notas-credito` | Emitir nota de crédito |
| POST | `/api/ventas/notas-debito` | Emitir nota de débito |
| GET | `/api/ventas/mesas` | Listar mesas con estado (libre/ocupada/reservada) |
| POST | `/api/ventas/mesas` | Crear/configurar mesa |
| PUT | `/api/ventas/mesas/{id}` | Actualizar mesa |
| PUT | `/api/ventas/mesas/{id}/estado` | Cambiar estado de mesa |
| GET | `/api/ventas/ordenes` | Listar órdenes activas |
| GET | `/api/ventas/ordenes/{id}` | Obtener orden con comandas |
| POST | `/api/ventas/ordenes` | Crear orden (apertura de mesa) |
| POST | `/api/ventas/ordenes/{id}/cerrar` | Cerrar orden (generar documento de venta) |
| POST | `/api/ventas/ordenes/{id}/comandas` | Agregar comanda a orden |
| PUT | `/api/ventas/ordenes/{id}/comandas/{comandaId}` | Modificar comanda |
| DELETE | `/api/ventas/ordenes/{id}/comandas/{comandaId}` | Eliminar comanda |
| POST | `/api/ventas/ordenes/{id}/dividir-cuenta` | Dividir cuenta entre comensales |
| POST | `/api/ventas/ordenes/{id}/unir-mesas` | Unir mesas en una sola cuenta |
| GET | `/api/ventas/cierres-caja` | Listar cierres de caja |
| GET | `/api/ventas/cierres-caja/{id}` | Detalle de cierre de caja |
| POST | `/api/ventas/cierres-caja/abrir` | Abrir caja (inicio de turno) |
| POST | `/api/ventas/cierres-caja/{id}/cerrar` | Cerrar caja (arqueo final) |
| GET | `/api/ventas/cierres-caja/{id}/arqueo` | Obtener arqueo detallado de caja |
| GET | `/api/ventas/descuentos` | Listar descuentos y promociones |
| POST | `/api/ventas/descuentos` | Crear descuento/promoción |
| PUT | `/api/ventas/descuentos/{id}` | Actualizar descuento/promoción |
| POST | `/api/ventas/descuentos/{id}/activar` | Activar descuento |
| POST | `/api/ventas/descuentos/{id}/desactivar` | Desactivar descuento |
| POST | `/api/ventas/facturacion-electronica/enviar/{documentoId}` | Enviar documento a OSE/SUNAT |
| GET | `/api/ventas/facturacion-electronica/estado/{documentoId}` | Consultar estado de facturación electrónica |
| GET | `/api/ventas/facturacion-electronica/cdr/{documentoId}` | Descargar CDR (Constancia de Recepción) |
| GET | `/api/ventas/propinas` | Listar propinas (filtros: fecha, trabajador) |
| POST | `/api/ventas/propinas` | Registrar propina |
| GET | `/api/ventas/recargos-consumo` | Listar recargos al consumo |
| GET | `/api/ventas/reportes/ventas-diarias` | Reporte de ventas del día por sucursal |
| GET | `/api/ventas/reportes/ventas-por-articulo` | Ventas agrupadas por artículo |
| GET | `/api/ventas/reportes/ventas-por-mesero` | Ventas por mesero/vendedor |
| GET | `/api/ventas/reportes/cierre-caja-resumen` | Resumen de cierre de caja |
| GET | `/api/ventas/reportes/propinas-periodo` | Propinas por período |

---

### 23.11 Servicios de soporte

#### ms-auditoria (:9011)

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/auditoria/logs` | Consultar logs de auditoría (filtros: usuario, módulo, entidad, fecha, acción) |
| GET | `/api/auditoria/logs/{id}` | Detalle de un log (datos antes/después en JSON) |
| GET | `/api/auditoria/logs/entidad/{entidad}/{entidadId}` | Historial de cambios de una entidad específica |
| GET | `/api/auditoria/accesos` | Consultar logs de acceso (login/logout/fallos) |
| GET | `/api/auditoria/accesos/sesiones-activas` | Sesiones activas en el sistema |
| GET | `/api/auditoria/reportes/actividad-usuario` | Actividad por usuario (período) |
| GET | `/api/auditoria/reportes/actividad-modulo` | Actividad por módulo |
| GET | `/api/auditoria/reportes/accesos-fallidos` | Intentos de acceso fallidos |
| GET | `/api/auditoria/reportes/cambios-criticos` | Cambios en entidades críticas (usuarios, roles, config) |
| GET | `/api/auditoria/reportes/operaciones-por-periodo` | Resumen de operaciones por período |
| GET | `/api/auditoria/exportar` | Exportar logs a Excel/CSV |

#### ms-reportes (:9012)

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| POST | `/api/reportes/generar` | Generar reporte (params: módulo, tipo, filtros, formato PDF/Excel) |
| GET | `/api/reportes/plantillas` | Listar plantillas de reportes disponibles |
| GET | `/api/reportes/plantillas/{modulo}` | Plantillas por módulo |
| GET | `/api/reportes/descargar/{id}` | Descargar reporte generado |
| GET | `/api/reportes/historial` | Historial de reportes generados |
| DELETE | `/api/reportes/{id}` | Eliminar reporte generado |
| POST | `/api/reportes/programar` | Programar generación automática de reporte |
| GET | `/api/reportes/programados` | Listar reportes programados |
| DELETE | `/api/reportes/programados/{id}` | Cancelar programación |
| POST | `/api/reportes/favoritos/{plantillaId}` | Marcar plantilla como favorita |

#### ms-notificaciones (:9013)

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/api/notificaciones` | Listar notificaciones del usuario (paginado) |
| GET | `/api/notificaciones/{id}` | Detalle de notificación |
| PUT | `/api/notificaciones/{id}/leer` | Marcar como leída |
| PUT | `/api/notificaciones/leer-todas` | Marcar todas como leídas |
| DELETE | `/api/notificaciones/{id}` | Eliminar notificación |
| GET | `/api/notificaciones/no-leidas/count` | Contador de no leídas |
| GET | `/api/notificaciones/preferencias` | Obtener preferencias de notificación del usuario |
| PUT | `/api/notificaciones/preferencias` | Actualizar preferencias (qué recibir, cómo) |
| POST | `/api/notificaciones/enviar-correo` | Enviar correo manual (admin) |
| POST | `/api/notificaciones/enviar-masivo` | Envío masivo (admin) |
| GET | `/api/notificaciones/correos-enviados` | Historial de correos enviados |

---

## 24. Docker — Compose completo

Archivo `docker-compose.yml` para levantar **todo el ecosistema** en entorno local de desarrollo:

```yaml
version: '3.9'

services:
  # ============================================================
  # INFRAESTRUCTURA
  # ============================================================
  
  postgres:
    image: postgres:16-alpine
    container_name: rpe-postgres
    environment:
      POSTGRES_DB: restaurant_pe_master
      POSTGRES_USER: rpe_admin
      POSTGRES_PASSWORD: rpe_secret_2026
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
      - ./docker/postgres/init-databases.sql:/docker-entrypoint-initdb.d/01-init-databases.sql
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U rpe_admin -d restaurant_pe_master"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - rpe-network

  rabbitmq:
    image: rabbitmq:3-management-alpine
    container_name: rpe-rabbitmq
    environment:
      RABBITMQ_DEFAULT_USER: rpe_mq
      RABBITMQ_DEFAULT_PASS: rpe_mq_2026
    ports:
      - "5672:5672"     # AMQP
      - "15672:15672"   # Management UI
    volumes:
      - rabbitmqdata:/var/lib/rabbitmq
    healthcheck:
      test: ["CMD", "rabbitmq-diagnostics", "check_running"]
      interval: 15s
      timeout: 10s
      retries: 5
    networks:
      - rpe-network

  redis:
    image: redis:7-alpine
    container_name: rpe-redis
    ports:
      - "6379:6379"
    command: redis-server --requirepass rpe_redis_2026
    volumes:
      - redisdata:/data
    healthcheck:
      test: ["CMD", "redis-cli", "-a", "rpe_redis_2026", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - rpe-network

  # ============================================================
  # SPRING CLOUD INFRASTRUCTURE
  # ============================================================

  eureka-server:
    build:
      context: ./eureka-server
      dockerfile: Dockerfile
    container_name: rpe-eureka
    ports:
      - "8761:8761"
    environment:
      SPRING_PROFILES_ACTIVE: docker
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8761/actuator/health"]
      interval: 15s
      timeout: 10s
      retries: 5
    networks:
      - rpe-network

  config-server:
    build:
      context: ./config-server
      dockerfile: Dockerfile
    container_name: rpe-config
    ports:
      - "8888:8888"
    environment:
      SPRING_PROFILES_ACTIVE: docker
      EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://rpe-eureka:8761/eureka
    depends_on:
      eureka-server:
        condition: service_healthy
    networks:
      - rpe-network

  api-gateway:
    build:
      context: ./api-gateway
      dockerfile: Dockerfile
    container_name: rpe-gateway
    ports:
      - "8080:8080"
    environment:
      SPRING_PROFILES_ACTIVE: docker
      EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://rpe-eureka:8761/eureka
      SPRING_CLOUD_CONFIG_URI: http://rpe-config:8888
      SPRING_DATA_REDIS_HOST: rpe-redis
      SPRING_DATA_REDIS_PASSWORD: rpe_redis_2026
    depends_on:
      eureka-server:
        condition: service_healthy
      config-server:
        condition: service_started
      redis:
        condition: service_healthy
    networks:
      - rpe-network

  # ============================================================
  # MICROSERVICIOS DE NEGOCIO
  # ============================================================

  ms-auth-security:
    build:
      context: ./ms-auth-security
      dockerfile: Dockerfile
    container_name: rpe-auth
    ports:
      - "9001:9001"
    environment:
      SPRING_PROFILES_ACTIVE: docker
      EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://rpe-eureka:8761/eureka
      SPRING_CLOUD_CONFIG_URI: http://rpe-config:8888
      # Conecta SOLO a la BD Master (auth + tenant registry)
      SPRING_DATASOURCE_URL: jdbc:postgresql://rpe-postgres:5432/restaurant_pe_master
      SPRING_DATASOURCE_USERNAME: rpe_admin
      SPRING_DATASOURCE_PASSWORD: rpe_secret_2026
      SPRING_JPA_PROPERTIES_HIBERNATE_DEFAULT_SCHEMA: auth
      SPRING_DATA_REDIS_HOST: rpe-redis
      SPRING_DATA_REDIS_PASSWORD: rpe_redis_2026
      SPRING_RABBITMQ_HOST: rpe-rabbitmq
      SPRING_RABBITMQ_USERNAME: rpe_mq
      SPRING_RABBITMQ_PASSWORD: rpe_mq_2026
    depends_on:
      postgres:
        condition: service_healthy
      eureka-server:
        condition: service_healthy
      rabbitmq:
        condition: service_healthy
      redis:
        condition: service_healthy
    networks:
      - rpe-network

  ms-core-maestros:
    build:
      context: ./ms-core-maestros
      dockerfile: Dockerfile
    container_name: rpe-core
    ports:
      - "9002:9002"
    environment:
      SPRING_PROFILES_ACTIVE: docker
      EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://rpe-eureka:8761/eureka
      SPRING_CLOUD_CONFIG_URI: http://rpe-config:8888
      # Conexión dinámica via TenantRoutingDataSource (obtiene tenants de ms-auth)
      RPE_TENANT_PROVIDER_URL: http://rpe-auth:9001/internal/tenants/active
      RPE_DEFAULT_SCHEMA: core
      SPRING_RABBITMQ_HOST: rpe-rabbitmq
      SPRING_RABBITMQ_USERNAME: rpe_mq
      SPRING_RABBITMQ_PASSWORD: rpe_mq_2026
    depends_on:
      postgres:
        condition: service_healthy
      eureka-server:
        condition: service_healthy
    networks:
      - rpe-network

  ms-almacen:
    build:
      context: ./ms-almacen
      dockerfile: Dockerfile
    container_name: rpe-almacen
    ports:
      - "9003:9003"
    environment:
      SPRING_PROFILES_ACTIVE: docker
      EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://rpe-eureka:8761/eureka
      SPRING_CLOUD_CONFIG_URI: http://rpe-config:8888
      RPE_TENANT_PROVIDER_URL: http://rpe-auth:9001/internal/tenants/active
      RPE_DEFAULT_SCHEMA: almacen
      SPRING_RABBITMQ_HOST: rpe-rabbitmq
      SPRING_RABBITMQ_USERNAME: rpe_mq
      SPRING_RABBITMQ_PASSWORD: rpe_mq_2026
    depends_on:
      postgres:
        condition: service_healthy
      ms-auth-security:
        condition: service_started
      eureka-server:
        condition: service_healthy
      rabbitmq:
        condition: service_healthy
    networks:
      - rpe-network

  ms-compras:
    build:
      context: ./ms-compras
      dockerfile: Dockerfile
    container_name: rpe-compras
    ports:
      - "9004:9004"
    environment:
      SPRING_PROFILES_ACTIVE: docker
      EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://rpe-eureka:8761/eureka
      SPRING_CLOUD_CONFIG_URI: http://rpe-config:8888
      RPE_TENANT_PROVIDER_URL: http://rpe-auth:9001/internal/tenants/active
      RPE_DEFAULT_SCHEMA: compras
      SPRING_RABBITMQ_HOST: rpe-rabbitmq
      SPRING_RABBITMQ_USERNAME: rpe_mq
      SPRING_RABBITMQ_PASSWORD: rpe_mq_2026
    depends_on:
      postgres:
        condition: service_healthy
      eureka-server:
        condition: service_healthy
      rabbitmq:
        condition: service_healthy
    networks:
      - rpe-network

  ms-finanzas:
    build:
      context: ./ms-finanzas
      dockerfile: Dockerfile
    container_name: rpe-finanzas
    ports:
      - "9005:9005"
    environment:
      SPRING_PROFILES_ACTIVE: docker
      EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://rpe-eureka:8761/eureka
      SPRING_CLOUD_CONFIG_URI: http://rpe-config:8888
      RPE_TENANT_PROVIDER_URL: http://rpe-auth:9001/internal/tenants/active
      RPE_DEFAULT_SCHEMA: finanzas
      SPRING_RABBITMQ_HOST: rpe-rabbitmq
      SPRING_RABBITMQ_USERNAME: rpe_mq
      SPRING_RABBITMQ_PASSWORD: rpe_mq_2026
    depends_on:
      postgres:
        condition: service_healthy
      eureka-server:
        condition: service_healthy
      rabbitmq:
        condition: service_healthy
    networks:
      - rpe-network

  ms-contabilidad:
    build:
      context: ./ms-contabilidad
      dockerfile: Dockerfile
    container_name: rpe-contabilidad
    ports:
      - "9006:9006"
    environment:
      SPRING_PROFILES_ACTIVE: docker
      EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://rpe-eureka:8761/eureka
      SPRING_CLOUD_CONFIG_URI: http://rpe-config:8888
      RPE_TENANT_PROVIDER_URL: http://rpe-auth:9001/internal/tenants/active
      RPE_DEFAULT_SCHEMA: contabilidad
      SPRING_RABBITMQ_HOST: rpe-rabbitmq
      SPRING_RABBITMQ_USERNAME: rpe_mq
      SPRING_RABBITMQ_PASSWORD: rpe_mq_2026
    depends_on:
      postgres:
        condition: service_healthy
      eureka-server:
        condition: service_healthy
      rabbitmq:
        condition: service_healthy
    networks:
      - rpe-network

  ms-rrhh:
    build:
      context: ./ms-rrhh
      dockerfile: Dockerfile
    container_name: rpe-rrhh
    ports:
      - "9007:9007"
    environment:
      SPRING_PROFILES_ACTIVE: docker
      EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://rpe-eureka:8761/eureka
      SPRING_CLOUD_CONFIG_URI: http://rpe-config:8888
      RPE_TENANT_PROVIDER_URL: http://rpe-auth:9001/internal/tenants/active
      RPE_DEFAULT_SCHEMA: rrhh
      SPRING_RABBITMQ_HOST: rpe-rabbitmq
      SPRING_RABBITMQ_USERNAME: rpe_mq
      SPRING_RABBITMQ_PASSWORD: rpe_mq_2026
    depends_on:
      postgres:
        condition: service_healthy
      eureka-server:
        condition: service_healthy
      rabbitmq:
        condition: service_healthy
    networks:
      - rpe-network

  ms-activos-fijos:
    build:
      context: ./ms-activos-fijos
      dockerfile: Dockerfile
    container_name: rpe-activos
    ports:
      - "9008:9008"
    environment:
      SPRING_PROFILES_ACTIVE: docker
      EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://rpe-eureka:8761/eureka
      SPRING_CLOUD_CONFIG_URI: http://rpe-config:8888
      RPE_TENANT_PROVIDER_URL: http://rpe-auth:9001/internal/tenants/active
      RPE_DEFAULT_SCHEMA: activos
      SPRING_RABBITMQ_HOST: rpe-rabbitmq
      SPRING_RABBITMQ_USERNAME: rpe_mq
      SPRING_RABBITMQ_PASSWORD: rpe_mq_2026
    depends_on:
      postgres:
        condition: service_healthy
      eureka-server:
        condition: service_healthy
      rabbitmq:
        condition: service_healthy
    networks:
      - rpe-network

  ms-produccion:
    build:
      context: ./ms-produccion
      dockerfile: Dockerfile
    container_name: rpe-produccion
    ports:
      - "9009:9009"
    environment:
      SPRING_PROFILES_ACTIVE: docker
      EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://rpe-eureka:8761/eureka
      SPRING_CLOUD_CONFIG_URI: http://rpe-config:8888
      RPE_TENANT_PROVIDER_URL: http://rpe-auth:9001/internal/tenants/active
      RPE_DEFAULT_SCHEMA: produccion
      SPRING_RABBITMQ_HOST: rpe-rabbitmq
      SPRING_RABBITMQ_USERNAME: rpe_mq
      SPRING_RABBITMQ_PASSWORD: rpe_mq_2026
    depends_on:
      postgres:
        condition: service_healthy
      eureka-server:
        condition: service_healthy
      rabbitmq:
        condition: service_healthy
    networks:
      - rpe-network

  ms-ventas:
    build:
      context: ./ms-ventas
      dockerfile: Dockerfile
    container_name: rpe-ventas
    ports:
      - "9010:9010"
    environment:
      SPRING_PROFILES_ACTIVE: docker
      EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://rpe-eureka:8761/eureka
      SPRING_CLOUD_CONFIG_URI: http://rpe-config:8888
      RPE_TENANT_PROVIDER_URL: http://rpe-auth:9001/internal/tenants/active
      RPE_DEFAULT_SCHEMA: ventas
      SPRING_DATA_REDIS_HOST: rpe-redis
      SPRING_DATA_REDIS_PASSWORD: rpe_redis_2026
      SPRING_RABBITMQ_HOST: rpe-rabbitmq
      SPRING_RABBITMQ_USERNAME: rpe_mq
      SPRING_RABBITMQ_PASSWORD: rpe_mq_2026
    depends_on:
      postgres:
        condition: service_healthy
      eureka-server:
        condition: service_healthy
      rabbitmq:
        condition: service_healthy
      redis:
        condition: service_healthy
    networks:
      - rpe-network

  # ============================================================
  # MICROSERVICIOS DE SOPORTE
  # ============================================================

  ms-auditoria:
    build:
      context: ./ms-auditoria
      dockerfile: Dockerfile
    container_name: rpe-auditoria
    ports:
      - "9011:9011"
    environment:
      SPRING_PROFILES_ACTIVE: docker
      EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://rpe-eureka:8761/eureka
      SPRING_CLOUD_CONFIG_URI: http://rpe-config:8888
      RPE_TENANT_PROVIDER_URL: http://rpe-auth:9001/internal/tenants/active
      RPE_DEFAULT_SCHEMA: auditoria
      SPRING_RABBITMQ_HOST: rpe-rabbitmq
      SPRING_RABBITMQ_USERNAME: rpe_mq
      SPRING_RABBITMQ_PASSWORD: rpe_mq_2026
    depends_on:
      postgres:
        condition: service_healthy
      eureka-server:
        condition: service_healthy
      rabbitmq:
        condition: service_healthy
    networks:
      - rpe-network

  ms-reportes:
    build:
      context: ./ms-reportes
      dockerfile: Dockerfile
    container_name: rpe-reportes
    ports:
      - "9012:9012"
    environment:
      SPRING_PROFILES_ACTIVE: docker
      EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://rpe-eureka:8761/eureka
      SPRING_CLOUD_CONFIG_URI: http://rpe-config:8888
    depends_on:
      eureka-server:
        condition: service_healthy
    networks:
      - rpe-network

  ms-notificaciones:
    build:
      context: ./ms-notificaciones
      dockerfile: Dockerfile
    container_name: rpe-notificaciones
    ports:
      - "9013:9013"
    environment:
      SPRING_PROFILES_ACTIVE: docker
      EUREKA_CLIENT_SERVICEURL_DEFAULTZONE: http://rpe-eureka:8761/eureka
      SPRING_CLOUD_CONFIG_URI: http://rpe-config:8888
      SPRING_RABBITMQ_HOST: rpe-rabbitmq
      SPRING_RABBITMQ_USERNAME: rpe_mq
      SPRING_RABBITMQ_PASSWORD: rpe_mq_2026
      SPRING_MAIL_HOST: smtp.gmail.com
      SPRING_MAIL_PORT: 587
      SPRING_MAIL_USERNAME: ${MAIL_USERNAME}
      SPRING_MAIL_PASSWORD: ${MAIL_PASSWORD}
    depends_on:
      eureka-server:
        condition: service_healthy
      rabbitmq:
        condition: service_healthy
    networks:
      - rpe-network

  # ============================================================
  # FRONTEND
  # ============================================================

  frontend:
    build:
      context: ./restaurant-pe-frontend
      dockerfile: Dockerfile
    container_name: rpe-frontend
    ports:
      - "4200:80"
    depends_on:
      api-gateway:
        condition: service_started
    networks:
      - rpe-network

# ============================================================
# VOLÚMENES Y REDES
# ============================================================

volumes:
  pgdata:
    driver: local
  rabbitmqdata:
    driver: local
  redisdata:
    driver: local

networks:
  rpe-network:
    driver: bridge
    name: rpe-network
```

### Script de inicialización de bases de datos (Database-per-Tenant)

Archivo `docker/postgres/init-databases.sql`:

```sql
-- ============================================================
-- Restaurant.pe ERP — Inicialización Database-per-Tenant
-- ============================================================

-- =============================================
-- 1. BD MASTER (ya creada por POSTGRES_DB env)
--    Contiene: auth + registro de tenants
-- =============================================

-- Esquema auth (usuarios, roles, permisos, menú)
CREATE SCHEMA IF NOT EXISTS auth;
GRANT ALL PRIVILEGES ON SCHEMA auth TO rpe_admin;

-- Esquema master (registro de tenants y connection strings)
CREATE SCHEMA IF NOT EXISTS master;
GRANT ALL PRIVILEGES ON SCHEMA master TO rpe_admin;

-- Tabla de tenants (empresas registradas)
CREATE TABLE master.tenant (
    id              BIGSERIAL PRIMARY KEY,
    codigo          VARCHAR(20) NOT NULL UNIQUE,
    nombre          VARCHAR(200) NOT NULL,
    db_name         VARCHAR(100) NOT NULL UNIQUE,
    db_host         VARCHAR(200) NOT NULL DEFAULT 'rpe-postgres',
    db_port         INT NOT NULL DEFAULT 5432,
    db_username     VARCHAR(100) NOT NULL DEFAULT 'rpe_admin',
    db_password     VARCHAR(200) NOT NULL DEFAULT 'rpe_secret_2026',
    activo          BOOLEAN NOT NULL DEFAULT true,
    fecha_creacion  TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    creado_por      VARCHAR(100)
);

-- =============================================
-- 2. BD TEMPLATE (modelo para clonar empresas)
--    Contiene: esquemas de negocio vacíos
-- =============================================

CREATE DATABASE restaurant_pe_template OWNER rpe_admin;

-- Conectar al template para crear esquemas
\connect restaurant_pe_template;

CREATE SCHEMA IF NOT EXISTS core;
CREATE SCHEMA IF NOT EXISTS almacen;
CREATE SCHEMA IF NOT EXISTS compras;
CREATE SCHEMA IF NOT EXISTS ventas;
CREATE SCHEMA IF NOT EXISTS finanzas;
CREATE SCHEMA IF NOT EXISTS contabilidad;
CREATE SCHEMA IF NOT EXISTS rrhh;
CREATE SCHEMA IF NOT EXISTS activos;
CREATE SCHEMA IF NOT EXISTS produccion;
CREATE SCHEMA IF NOT EXISTS auditoria;

GRANT ALL PRIVILEGES ON SCHEMA core TO rpe_admin;
GRANT ALL PRIVILEGES ON SCHEMA almacen TO rpe_admin;
GRANT ALL PRIVILEGES ON SCHEMA compras TO rpe_admin;
GRANT ALL PRIVILEGES ON SCHEMA ventas TO rpe_admin;
GRANT ALL PRIVILEGES ON SCHEMA finanzas TO rpe_admin;
GRANT ALL PRIVILEGES ON SCHEMA contabilidad TO rpe_admin;
GRANT ALL PRIVILEGES ON SCHEMA rrhh TO rpe_admin;
GRANT ALL PRIVILEGES ON SCHEMA activos TO rpe_admin;
GRANT ALL PRIVILEGES ON SCHEMA produccion TO rpe_admin;
GRANT ALL PRIVILEGES ON SCHEMA auditoria TO rpe_admin;

-- =============================================
-- 3. BD para empresa demo (desarrollo local)
-- =============================================

\connect restaurant_pe_master;

-- Clonar template para empresa demo
CREATE DATABASE restaurant_pe_emp_1 TEMPLATE restaurant_pe_template OWNER rpe_admin;

-- Registrar en el catálogo de tenants
INSERT INTO master.tenant (codigo, nombre, db_name, db_host, db_port, db_username, db_password)
VALUES ('DEMO', 'Restaurante Demo SAC', 'restaurant_pe_emp_1', 'rpe-postgres', 5432, 'rpe_admin', 'rpe_secret_2026');
```

### Resumen de puertos

| Puerto | Servicio | Tipo |
|:------:|----------|------|
| 5432 | PostgreSQL | Base de datos |
| 5672 | RabbitMQ (AMQP) | Mensajería |
| 15672 | RabbitMQ (Management) | UI admin |
| 6379 | Redis | Caché |
| 8761 | Eureka Server | Service Discovery |
| 8888 | Config Server | Configuración |
| 8080 | API Gateway | Entry point backend |
| 9001 | ms-auth-security | Auth y seguridad |
| 9002 | ms-core-maestros | Maestros |
| 9003 | ms-almacen | Almacén |
| 9004 | ms-compras | Compras |
| 9005 | ms-finanzas | Finanzas |
| 9006 | ms-contabilidad | Contabilidad |
| 9007 | ms-rrhh | RRHH |
| 9008 | ms-activos-fijos | Activos Fijos |
| 9009 | ms-produccion | Producción |
| 9010 | ms-ventas | Ventas |
| 9011 | ms-auditoria | Auditoría |
| 9012 | ms-reportes | Reportes |
| 9013 | ms-notificaciones | Notificaciones |
| 4200 | Frontend Angular | SPA |

### Comandos útiles

```bash
# Levantar todo el ecosistema
docker compose up -d

# Ver logs de un servicio específico
docker compose logs -f ms-compras

# Reconstruir un servicio después de cambios
docker compose up -d --build ms-compras

# Ver estado de todos los servicios
docker compose ps

# Detener todo
docker compose down

# Detener todo y eliminar volúmenes (CUIDADO: borra datos)
docker compose down -v
```

---

## 25. Decisiones de arquitectura (ADR)

### ADR-001: Microservicios vs Monolito

**Decisión:** Microservicios  
**Justificación:** 9 módulos funcionales con equipos paralelos. Cada módulo tiene ciclo de vida independiente. Escalabilidad horizontal requerida. Múltiples equipos de desarrollo simultáneos.  
**Consecuencia:** Mayor complejidad operativa, requiere DevOps dedicado y service discovery.

### ADR-002: Database-per-Tenant (multitenancy)

**Decisión:** Patrón Database-per-Tenant con PostgreSQL `TEMPLATE`  
**Justificación:** Aislamiento total de datos entre empresas. Elimina la necesidad de `empresa_id` en todas las tablas. Permite backup, restore y escalado independiente por empresa. Cumple con regulaciones de privacidad (GDPR). PostgreSQL soporta nativamente `CREATE DATABASE ... TEMPLATE` para clonación instantánea.  
**Consecuencia:** Mayor complejidad operativa (múltiples BDs). Requiere `AbstractRoutingDataSource` para ruteo dinámico y pool de conexiones por tenant. Los reportes cruzados entre empresas requieren iteración sobre BDs o un Data Warehouse.  
**Mitigación:** ms-auth-security centraliza el registro de tenants y provee connection strings. Los eventos RabbitMQ sincronizan dinámicamente los pools al crear nuevas empresas.

### ADR-003: RabbitMQ vs Kafka

**Decisión:** RabbitMQ  
**Justificación:** Volumen de eventos moderado (ERP, no streaming). RabbitMQ es más simple de operar, tiene mejor soporte para routing por topic, y es suficiente para pre-asientos contables y auditoría. Kafka sería sobredimensionado.  
**Consecuencia:** Si en el futuro el volumen crece significativamente, podría requerirse migración a Kafka.

### ADR-004: JWT vs Session-based

**Decisión:** JWT (stateless)  
**Justificación:** Microservicios stateless, no se necesita almacenar sesión en cada servicio. JWT permite validación local en el Gateway. Redis se usa solo para blacklist de tokens invalidados y caché de sesiones activas.  
**Consecuencia:** Tokens no se pueden invalidar inmediatamente (hasta que expiren). Se mitiga con refresh token corto y blacklist en Redis.

### ADR-005: Maestro unificado proveedor/cliente

**Decisión:** Tabla única `relacion_comercial` con flags `es_proveedor`, `es_cliente`, `es_empleado`  
**Justificación:** En el SIGRE, proveedores y clientes compartían la misma entidad ("Código de Relación"). Esto evita duplicación de datos cuando una empresa es proveedor y cliente simultáneamente.  
**Consecuencia:** La tabla es más grande pero simplifica las consultas y evita inconsistencias.

### ADR-006: Soft delete universal

**Decisión:** `activo BOOLEAN DEFAULT true` en lugar de DELETE físico  
**Justificación:** Auditoría y trazabilidad son requisitos del negocio. Los datos eliminados pueden necesitarse para reportes históricos, auditorías fiscales o cierres contables.  
**Consecuencia:** Las tablas crecen indefinidamente. Se mitiga con índices parciales (`WHERE activo = true`) y archivado periódico.

### ADR-007: Angular 20 con lazy loading por módulo

**Decisión:** Cada módulo ERP es un módulo Angular con lazy loading  
**Justificación:** El ERP tiene 9 módulos; cargar todos al inicio sería lento. Lazy loading carga solo el módulo que el usuario necesita, mejorando el tiempo de carga inicial.  
**Consecuencia:** La navegación entre módulos tiene un pequeño delay la primera vez. Se mitiga con prefetching de módulos frecuentes.

---

---

## 26. Diagramas de arquitectura (C4 Model)

### 26.1 Nivel 1 — Diagrama de contexto

Muestra el sistema Restaurant.pe ERP, los actores y los sistemas externos con los que interactúa.

```mermaid
flowchart TB
    subgraph Actores
        ADM["👤 Administrador ERP\n(Configuración, maestros,\npermisos, cierres)"]
        OPE["👤 Operador\n(Compras, almacén,\nventas, producción)"]
        CONT["👤 Contador\n(Contabilidad, EEFF,\nlibros electrónicos)"]
        RRHH_U["👤 Analista RRHH\n(Planilla, asistencia,\nbeneficios)"]
        GER["👤 Gerente\n(Reportes, dashboards,\naprobaciones)"]
    end
    subgraph Sistema["Restaurant.pe ERP"]
        ERP["🏢 Restaurant.pe ERP\n\nPlataforma integral de gestión\nempresarial para la industria\ngastronómica\n\n10 microservicios de negocio\n3 microservicios de soporte"]
    end
    subgraph Externos["Sistemas externos"]
        SUNAT["🏛️ SUNAT / OSE\nFacturación electrónica\n(envío CPE, CDR)"]
        BANCOS["🏦 Bancos\nExtractos bancarios\n(importación)"]
        PASARELAS["💳 Pasarelas de pago\nNiubiz, Yape, Plin\n(conciliación)"]
        POS_EXT["🖥️ POS Restaurant.pe\nPunto de venta existente\n(integración ventas)"]
        SMTP["📧 Servidor SMTP\nEnvío de correos\n(notificaciones, boletas)"]
        BIOMETRICO["🔒 Dispositivo biométrico\nMarcación de asistencia\n(importación)"]
    end
    ADM --> ERP
    OPE --> ERP
    CONT --> ERP
    RRHH_U --> ERP
    GER --> ERP
    ERP --> SUNAT
    ERP <--> BANCOS
    ERP <--> PASARELAS
    ERP <--> POS_EXT
    ERP --> SMTP
    ERP <-- BIOMETRICO
```

### 26.2 Nivel 2 — Diagrama de contenedores

Detalla los contenedores (aplicaciones, servicios, almacenes de datos) que componen el sistema.

```mermaid
flowchart TB
    subgraph Frontend
        SPA["Angular 20 SPA\n(puerto 4200)\nUI responsive,\nlazy loading por módulo"]
    end
    subgraph Edge_Layer["Capa Edge"]
        NGINX["Nginx / CDN\nArchivos estáticos,\nSSL termination"]
    end
    subgraph Spring_Cloud["Spring Cloud (infraestructura)"]
        GW["API Gateway\n:8080\nRuteo, rate limiting,\nvalidación JWT, CORS"]
        EU["Eureka Server\n:8761\nService Discovery,\nregistro dinámico"]
        CFG["Config Server\n:8888\nConfiguración centralizada\n(Git-backed)"]
    end
    subgraph Negocio["Microservicios de negocio (10)"]
        AUTH["ms-auth-security\n:9001\nJWT, usuarios,\nroles, permisos"]
        CORE["ms-core-maestros\n:9002\nEmpresas, maestros,\nconfiguración"]
        ALM["ms-almacen\n:9003\nInventario, kardex,\nstock, traslados"]
        COM["ms-compras\n:9004\nOC, OS, recepción,\naprobaciones"]
        VEN["ms-ventas\n:9010\nPOS, documentos,\nmesas, cierres"]
        FIN["ms-finanzas\n:9005\nCxP, CxC, tesorería,\nconciliación"]
        CNT["ms-contabilidad\n:9006\nAsientos, EEFF,\nlibros, cierres"]
        RRHH["ms-rrhh\n:9007\nPlanilla, asistencia,\ncontratos"]
        AF["ms-activos-fijos\n:9008\nActivos, depreciación,\nseguros"]
        PROD["ms-produccion\n:9009\nRecetas, órdenes,\ncosteo"]
    end
    subgraph Soporte["Microservicios de soporte (3)"]
        AUD["ms-auditoria\n:9011\nLogs de auditoría"]
        RPT["ms-reportes\n:9012\nJasperReports,\nPDF/Excel"]
        NOTIF["ms-notificaciones\n:9013\nCorreos, alertas,\npush"]
    end
    subgraph Datos["Almacenes de datos (Database-per-Tenant)"]
        PG_MASTER[("BD Master\nrestaurant_pe_master\n:5432\nauth + tenant registry")]
        PG_TENANT[("BD por Empresa\nrestaurant_pe_emp_N\n:5432\n10 schemas de negocio")]
        REDIS[("Redis 7\n:6379\nCaché, sesiones,\nblacklist JWT")]
    end
    subgraph Mensajeria["Mensajería"]
        MQ[["RabbitMQ 3\n:5672\nEventos asincrónicos\npre-asientos, auditoría,\ntenant.created"]]
    end
    SPA --> NGINX --> GW
    GW --> EU
    GW --> AUTH & CORE & ALM & COM & VEN & FIN & CNT & RRHH & AF & PROD & RPT
    AUTH --> PG_MASTER
    CORE & ALM & COM & VEN & FIN & CNT & RRHH & AF & PROD & AUD --> PG_TENANT
    AUTH & GW --> REDIS
    ALM & COM & VEN & FIN & RRHH & AF & PROD --> MQ
    MQ --> CNT & AUD & NOTIF
    EU --> CFG
```

### 26.3 Nivel 3 — Componentes internos de un microservicio típico

```mermaid
flowchart TB
    subgraph ms_compras["ms-compras (ejemplo representativo)"]
        subgraph API["Capa API (Controller)"]
            OCC[OrdenCompraController]
            OSC[OrdenServicioController]
            RECC[RecepcionController]
            RPTC[ReporteComprasController]
        end
        subgraph Service["Capa Servicio (Business Logic)"]
            OCS[OrdenCompraService]
            OSS[OrdenServicioService]
            RECS[RecepcionService]
            APRS[AprobacionService]
            VALIDS[ValidacionService]
        end
        subgraph Event["Capa Eventos"]
            PUB[EventPublisher\nRabbitMQ]
            SUB[EventListener\nRecibe eventos]
        end
        subgraph Integration["Capa Integración"]
            CORE_F[CoreMaestrosFeign\nConsulta proveedores,\nartículos]
            ALM_F[AlmacenFeign\nValida stock,\ngenera movimientos]
        end
        subgraph Persistence["Capa Persistencia"]
            OCR[OrdenCompraRepository]
            OSR[OrdenServicioRepository]
            RECR[RecepcionRepository]
            SPEC[JPA Specifications\nFiltros dinámicos]
        end
        subgraph Domain["Capa Dominio"]
            OCE[OrdenCompra\nEntity]
            OSE[OrdenServicio\nEntity]
            RECE[Recepcion\nEntity]
            DTO[DTOs\nRequest/Response]
            MAP[MapStruct\nMappers]
        end
    end
    OCC --> OCS
    OSC --> OSS
    RECC --> RECS
    OCS --> VALIDS
    OCS --> APRS
    OCS --> CORE_F
    RECS --> ALM_F
    OCS --> PUB
    RECS --> PUB
    OCS --> OCR
    OSS --> OSR
    RECS --> RECR
    OCR --> OCE
    OCS --> MAP
    MAP --> DTO
```

---

## 27. Diagramas de entidades (ER) por microservicio — Resumen

> Las entidades de negocio (27.2 a 27.10) residen en la **BD por Empresa** (`restaurant_pe_emp_{id}`) y **no tienen `empresa_id`**. La sección 27.1 corresponde a la **BD Master** (`restaurant_pe_master`).
>
> **Diagramas ER completos con todas las columnas:** [`DISENO_BASE_DATOS.md`](./DISENO_BASE_DATOS.md), sección 11.

### 27.1 ms-auth-security — BD Master (esquemas `auth` + `master`)

```mermaid
erDiagram
    TENANT ||--o{ USUARIO_EMPRESA : "tiene usuarios"
    USUARIO ||--o{ USUARIO_EMPRESA : "accede a"
    USUARIO_EMPRESA }o--|| ROL : "un rol por empresa"
    USUARIO ||--o{ SESION : "tiene"
    USUARIO ||--o{ LOG_ACCESO : "registra"
    USUARIO }o--o{ OPCION_MENU : "individual"
    ROL }o--o{ OPCION_MENU : "asigna"
    ROL }o--o{ ACCION : "permite"
    OPCION_MENU }o--|| MODULO : "pertenece"
    OPCION_MENU }o--o| OPCION_MENU : "hijo de"
```

### 27.2 ms-core-maestros — Esquema `core` (BD por Empresa)

```mermaid
erDiagram
    EMPRESA ||--o{ SUCURSAL : tiene
    SUCURSAL }o--|| PAIS : pertenece
    EMPRESA ||--o{ RELACION_COMERCIAL : tiene
    EMPRESA ||--o{ ARTICULO : tiene
    ARTICULO }o--|| CATEGORIA : pertenece
    ARTICULO }o--|| UNIDAD_MEDIDA : usa
    ARTICULO }o--|| IMPUESTO : aplica
    RELACION_COMERCIAL ||--o{ CONTACTO : tiene
    RELACION_COMERCIAL ||--o{ CUENTA_BANCARIA_RC : tiene
    RELACION_COMERCIAL }o--|| CONDICION_PAGO : "condición default"
    MONEDA ||--o{ TIPO_CAMBIO : origen
    CONFIG_CLAVE ||--o{ CONFIG_EMPRESA : configura
    CONFIG_CLAVE ||--o{ CONFIG_PAIS : configura
    CONFIG_CLAVE ||--o{ CONFIG_SUCURSAL : configura
    CONFIG_CLAVE ||--o{ CONFIG_USUARIO : configura
    CATEGORIA }o--o| CATEGORIA : "padre"
```

### 27.3 ms-almacen — Esquema `almacen` (BD por Empresa)

```mermaid
erDiagram
    ALMACEN ||--o{ UBICACION_ALMACEN : contiene
    ALMACEN ||--o{ STOCK : registra
    ALMACEN ||--o{ MOVIMIENTO_ALMACEN : tiene
    MOVIMIENTO_ALMACEN }o--|| TIPO_MOVIMIENTO : es
    MOVIMIENTO_ALMACEN ||--o{ MOVIMIENTO_DETALLE : contiene
    MOVIMIENTO_DETALLE --> KARDEX : genera
    STOCK }o--|| ARTICULO : de
    ALMACEN ||--o{ INVENTARIO_FISICO : ejecuta
    INVENTARIO_FISICO ||--o{ INVENTARIO_FISICO_DETALLE : contiene
    ALMACEN ||--o{ RESERVA_STOCK : tiene
```

### 27.4 ms-compras — Esquema `compras` (BD por Empresa)

```mermaid
erDiagram
    SOLICITUD_COMPRA ||--o{ SOLICITUD_COMPRA_DETALLE : contiene
    SOLICITUD_COMPRA ||--o{ COTIZACION : genera
    COTIZACION ||--o{ COTIZACION_DETALLE : contiene
    COTIZACION }o--o| ORDEN_COMPRA : "se convierte en"
    ORDEN_COMPRA ||--o{ ORDEN_COMPRA_DETALLE : contiene
    ORDEN_COMPRA ||--o{ RECEPCION : genera
    ORDEN_COMPRA ||--o{ APROBACION : requiere
    RECEPCION ||--o{ RECEPCION_DETALLE : contiene
```

### 27.5 ms-ventas — Esquema `ventas` (BD por Empresa)

```mermaid
erDiagram
    ZONA ||--o{ MESA : contiene
    MESA ||--o{ ORDEN_VENTA : atiende
    ORDEN_VENTA ||--o{ COMANDA : contiene
    ORDEN_VENTA ||--o| DOCUMENTO_VENTA : genera
    DOCUMENTO_VENTA ||--o{ DOCUMENTO_VENTA_DETALLE : contiene
    DOCUMENTO_VENTA ||--o{ PAGO_VENTA : recibe
    DOCUMENTO_VENTA ||--o| NOTA_CREDITO_VENTA : "puede tener"
    DOCUMENTO_VENTA ||--o| NOTA_DEBITO_VENTA : "puede tener"
    DOCUMENTO_VENTA ||--o| FACTURACION_ELECTRONICA : "se envía"
    DOCUMENTO_VENTA ||--o{ PROPINA : registra
    TURNO ||--o{ ORDEN_VENTA : contiene
    TURNO ||--o| CIERRE_CAJA : genera
```

### 27.6 ms-finanzas — Esquema `finanzas` (BD por Empresa)

```mermaid
erDiagram
    CUENTA_BANCARIA ||--o{ MOVIMIENTO_BANCARIO : tiene
    CUENTA_BANCARIA ||--o{ CONCILIACION_BANCARIA : genera
    CONCILIACION_BANCARIA ||--o{ CONCILIACION_DETALLE : contiene
    DOCUMENTO_PAGAR ||--o{ PAGO : recibe
    DOCUMENTO_COBRAR ||--o{ COBRO : recibe
    PROGRAMACION_PAGO ||--o{ PROGRAMACION_PAGO_DETALLE : contiene
    FONDO_FIJO ||--o{ RENDICION_GASTO : registra
```

### 27.7 ms-contabilidad — Esquema `contabilidad` (BD por Empresa)

```mermaid
erDiagram
    CUENTA_CONTABLE }o--o| CUENTA_CONTABLE : "padre"
    CENTRO_COSTO }o--o| CENTRO_COSTO : "padre"
    ASIENTO }o--|| LIBRO_CONTABLE : "registrado en"
    ASIENTO ||--o{ ASIENTO_DETALLE : contiene
    ASIENTO_DETALLE }o--|| CUENTA_CONTABLE : "debita/acredita"
    ASIENTO_DETALLE }o--o| CENTRO_COSTO : asigna
    PRE_ASIENTO }o--o| ASIENTO : "genera"
    MATRIZ_CONTABLE }o--|| CUENTA_CONTABLE : "cuenta debe"
```

### 27.8 ms-rrhh — Esquema `rrhh` (BD por Empresa)

```mermaid
erDiagram
    TRABAJADOR ||--o{ CONTRATO : tiene
    TRABAJADOR }o--|| AREA : pertenece
    TRABAJADOR }o--|| CARGO : ocupa
    TRABAJADOR }o--o| AFP : "aporta a"
    TRABAJADOR ||--o{ ASISTENCIA : registra
    TRABAJADOR ||--o{ PERMISO_LICENCIA : solicita
    TRABAJADOR ||--o{ VACACION : tiene
    TRABAJADOR ||--o| LIQUIDACION : "puede tener"
    TRABAJADOR ||--o{ PRESTAMO : tiene
    PLANILLA ||--o{ PLANILLA_DETALLE : contiene
    PLANILLA_DETALLE }o--|| TRABAJADOR : de
    PLANILLA_DETALLE }o--|| CONCEPTO_PLANILLA : aplica
    AREA }o--o| AREA : "padre"
```

### 27.9 ms-activos-fijos — Esquema `activos` (BD por Empresa)

```mermaid
erDiagram
    ACTIVO_FIJO }o--|| CLASE_ACTIVO : es
    ACTIVO_FIJO }o--|| UBICACION_FISICA : "ubicado en"
    ACTIVO_FIJO ||--o{ COMPONENTE_ACTIVO : tiene
    ACTIVO_FIJO ||--o{ DEPRECIACION : calcula
    ACTIVO_FIJO ||--o{ MEJORA_ACTIVO : recibe
    ACTIVO_FIJO ||--o{ REVALUACION : "se revalúa"
    ACTIVO_FIJO ||--o{ TRASLADO_ACTIVO : "se traslada"
    ACTIVO_FIJO ||--o{ MANTENIMIENTO_ACTIVO : requiere
    POLIZA_SEGURO }o--|| ASEGURADORA : emite
    POLIZA_SEGURO ||--o{ POLIZA_ACTIVO : cubre
    POLIZA_ACTIVO }o--|| ACTIVO_FIJO : asegura
    UBICACION_FISICA }o--o| UBICACION_FISICA : "padre"
```

### 27.10 ms-produccion — Esquema `produccion` (BD por Empresa)

```mermaid
erDiagram
    RECETA ||--o{ RECETA_DETALLE : contiene
    RECETA ||--o{ RECETA_SUBRECETA : "incluye sub-recetas"
    RECETA ||--o{ ORDEN_PRODUCCION : ejecuta
    ORDEN_PRODUCCION ||--o{ ORDEN_PRODUCCION_INSUMO : consume
    ORDEN_PRODUCCION ||--o| COSTEO_PRODUCCION : genera
    ORDEN_PRODUCCION ||--o{ CONTROL_CALIDAD : verifica
    RECETA ||--o{ PROGRAMACION_PRODUCCION : programa
```

---

## 28. Diagrama de comunicación entre microservicios

### 28.1 Matriz de comunicación sincrónica (REST / OpenFeign)

```mermaid
flowchart LR
    subgraph Consumidor["Consumidor (quien llama)"]
        COM_C[ms-compras]
        ALM_C[ms-almacen]
        VEN_C[ms-ventas]
        FIN_C[ms-finanzas]
        CNT_C[ms-contabilidad]
        RRHH_C[ms-rrhh]
        AF_C[ms-activos-fijos]
        PROD_C[ms-produccion]
        RPT_C[ms-reportes]
    end
    subgraph Proveedor["Proveedor (quien responde)"]
        CORE_P[ms-core-maestros]
        ALM_P[ms-almacen]
        AUTH_P[ms-auth-security]
        FIN_P[ms-finanzas]
    end
    COM_C -->|"proveedor, artículo,\nimpuesto, moneda"| CORE_P
    COM_C -->|"validar stock,\ngenerar ingreso"| ALM_P
    ALM_C -->|"artículo, unidad,\ncategoría"| CORE_P
    VEN_C -->|"cliente, artículo,\nimpuesto, moneda"| CORE_P
    VEN_C -->|"validar stock\ndisponible"| ALM_P
    VEN_C -->|"generar CxC"| FIN_P
    FIN_C -->|"proveedor, cliente,\nmoneda, TC"| CORE_P
    FIN_C -->|"datos OC"| COM_C
    CNT_C -->|"empresa, moneda"| CORE_P
    RRHH_C -->|"trabajador como RC,\nsucursal"| CORE_P
    AF_C -->|"proveedor, moneda,\nsucursal"| CORE_P
    PROD_C -->|"artículo, unidad"| CORE_P
    PROD_C -->|"stock, consumir\ninsumos"| ALM_P
    RPT_C -->|"datos de cualquier\nmicroservicio"| CORE_P
    RPT_C -->|"datos"| ALM_P
    RPT_C -->|"datos"| FIN_P
```

### 28.2 Flujo de eventos asincrónicos (RabbitMQ)

```mermaid
flowchart TB
    subgraph Productores["Productores de eventos"]
        ALM_E["ms-almacen\n• movimiento.confirmado\n• stock.bajo_minimo\n• traslado.completado"]
        COM_E["ms-compras\n• oc.aprobada\n• recepcion.confirmada\n• oc.completada"]
        VEN_E["ms-ventas\n• venta.emitida\n• venta.anulada\n• cierre_caja.completado\n• nc.emitida"]
        FIN_E["ms-finanzas\n• pago.registrado\n• cobro.registrado\n• adelanto.liquidado\n• conciliacion.cerrada"]
        RRHH_E["ms-rrhh\n• planilla.cerrada\n• liquidacion.pagada\n• asistencia.procesada"]
        AF_E["ms-activos\n• depreciacion.ejecutada\n• activo.baja\n• activo.revaluado"]
        PROD_E["ms-produccion\n• produccion.completada\n• produccion.cancelada"]
    end
    subgraph RMQ["RabbitMQ (Exchange: rpe.events)"]
        EX{{"Topic Exchange\nrpe.events"}}
    end
    subgraph Consumidores["Consumidores"]
        CNT_CON["ms-contabilidad\n(routing: *.pre_asiento)\nGenera asientos automáticos"]
        AUD_CON["ms-auditoria\n(routing: #)\nRegistra TODO en log"]
        NOTIF_CON["ms-notificaciones\n(routing: *.alerta.*)\nEnvía correos y alertas"]
        ALM_CON["ms-almacen\n(routing: produccion.*)\nConsume insumos"]
        FIN_CON["ms-finanzas\n(routing: venta.emitida)\nGenera CxC automático"]
    end
    ALM_E --> EX
    COM_E --> EX
    VEN_E --> EX
    FIN_E --> EX
    RRHH_E --> EX
    AF_E --> EX
    PROD_E --> EX
    EX --> CNT_CON
    EX --> AUD_CON
    EX --> NOTIF_CON
    EX --> ALM_CON
    EX --> FIN_CON
```

### 28.3 Catálogo de eventos

| Evento | Productor | Consumidores | Datos principales |
|--------|-----------|-------------|-------------------|
| `movimiento.confirmado` | ms-almacen | ms-contabilidad, ms-auditoria | almacen_id, tipo, artículos, costos |
| `stock.bajo_minimo` | ms-almacen | ms-notificaciones | artículo, almacén, stock_actual, stock_minimo |
| `oc.aprobada` | ms-compras | ms-auditoria, ms-notificaciones | oc_id, proveedor, monto |
| `recepcion.confirmada` | ms-compras | ms-contabilidad, ms-almacen, ms-auditoria | recepcion_id, oc_id, artículos |
| `venta.emitida` | ms-ventas | ms-contabilidad, ms-finanzas, ms-auditoria | documento_id, tipo, monto, cliente |
| `venta.anulada` | ms-ventas | ms-contabilidad, ms-finanzas, ms-auditoria | documento_id, motivo |
| `nc.emitida` | ms-ventas | ms-contabilidad, ms-finanzas | nc_id, documento_original, monto |
| `cierre_caja.completado` | ms-ventas | ms-contabilidad, ms-auditoria | turno_id, totales por forma de pago |
| `pago.registrado` | ms-finanzas | ms-contabilidad, ms-auditoria | pago_id, proveedor, monto, cuenta |
| `cobro.registrado` | ms-finanzas | ms-contabilidad, ms-auditoria | cobro_id, cliente, monto |
| `conciliacion.cerrada` | ms-finanzas | ms-auditoria | cuenta, periodo, diferencias |
| `planilla.cerrada` | ms-rrhh | ms-contabilidad, ms-auditoria | planilla_id, periodo, totales |
| `liquidacion.pagada` | ms-rrhh | ms-contabilidad, ms-auditoria | trabajador, montos |
| `depreciacion.ejecutada` | ms-activos | ms-contabilidad, ms-auditoria | periodo, total_depreciacion |
| `activo.baja` | ms-activos | ms-contabilidad, ms-auditoria | activo_id, valor_neto |
| `produccion.completada` | ms-produccion | ms-contabilidad, ms-almacen, ms-auditoria | orden_id, receta, costos |

---

## 29. Diagramas de interacción (secuencia)

### 29.1 Flujo completo de compra

```mermaid
sequenceDiagram
    participant U as Usuario
    participant FE as Angular
    participant GW as Gateway
    participant COM as ms-compras
    participant CORE as ms-core
    participant ALM as ms-almacen
    participant FIN as ms-finanzas
    participant MQ as RabbitMQ
    participant CNT as ms-contabilidad
    participant AUD as ms-auditoria

    U->>FE: Crear Orden de Compra
    FE->>GW: POST /api/compras/ordenes-compra
    GW->>COM: Forward
    COM->>CORE: GET proveedor + artículos + impuestos
    CORE-->>COM: Datos validados
    COM->>COM: Crear OC (estado: BORRADOR)
    COM-->>FE: 201 Created

    U->>FE: Enviar a aprobación
    FE->>GW: POST /api/compras/ordenes-compra/{id}/enviar-aprobacion
    GW->>COM: Forward
    COM->>COM: Cambiar estado → PENDIENTE_APROBACION
    COM->>MQ: Publicar "oc.pendiente_aprobacion"
    MQ-->>AUD: Log auditoría

    Note over COM: Aprobador recibe notificación

    U->>FE: Aprobar OC
    FE->>GW: POST /api/compras/ordenes-compra/{id}/aprobar
    GW->>COM: Forward
    COM->>COM: Validar nivel de aprobación
    COM->>COM: Estado → APROBADA
    COM->>MQ: Publicar "oc.aprobada"
    MQ-->>AUD: Log auditoría

    Note over COM: Llega la mercadería

    U->>FE: Registrar recepción
    FE->>GW: POST /api/compras/recepciones
    GW->>COM: Forward
    COM->>ALM: POST generar movimiento de ingreso
    ALM->>ALM: Actualizar stock + kardex
    ALM->>MQ: Publicar "movimiento.confirmado"
    MQ-->>CNT: Generar pre-asiento (ingreso almacén)
    COM-->>FE: 201 Recepción creada

    Note over FIN: Proveedor envía factura

    U->>FE: Registrar factura CxP
    FE->>GW: POST /api/finanzas/cuentas-pagar
    GW->>FIN: Forward (vinculada a OC)
    FIN->>FIN: Crear documento por pagar
    FIN->>MQ: Publicar "cxp.registrada"
    MQ-->>CNT: Pre-asiento (CxP)

    U->>FE: Registrar pago
    FE->>GW: POST /api/finanzas/pagos
    GW->>FIN: Forward
    FIN->>FIN: Aplicar pago al documento
    FIN->>MQ: Publicar "pago.registrado"
    MQ-->>CNT: Pre-asiento (pago)
    MQ-->>AUD: Log auditoría
```

### 29.2 Flujo completo de venta (restaurante)

```mermaid
sequenceDiagram
    participant M as Mesero
    participant POS as POS/Angular
    participant GW as Gateway
    participant VEN as ms-ventas
    participant ALM as ms-almacen
    participant CORE as ms-core
    participant MQ as RabbitMQ
    participant FIN as ms-finanzas
    participant CNT as ms-contabilidad
    participant SUNAT as SUNAT/OSE

    M->>POS: Abrir mesa (4 comensales)
    POS->>GW: POST /api/ventas/ordenes
    GW->>VEN: Forward
    VEN->>VEN: Crear orden + cambiar mesa → OCUPADA
    VEN-->>POS: Orden #123 creada

    M->>POS: Tomar pedido
    POS->>GW: POST /api/ventas/ordenes/123/comandas
    GW->>VEN: Forward
    VEN->>ALM: Validar stock de artículos
    ALM-->>VEN: Stock OK
    VEN->>VEN: Agregar comanda (estado: PENDIENTE)
    VEN-->>POS: Comanda registrada

    Note over VEN: Cocina prepara, mesero sirve

    M->>POS: Pedir la cuenta
    POS->>GW: POST /api/ventas/ordenes/123/cerrar
    GW->>VEN: Forward
    VEN->>CORE: GET datos cliente + impuestos
    VEN->>VEN: Generar documento de venta (factura/boleta)
    VEN->>VEN: Calcular subtotal + IGV + propina + recargo

    M->>POS: Registrar pago (efectivo + Yape)
    POS->>GW: POST /api/ventas/documentos/{id}/pagar
    GW->>VEN: Forward
    VEN->>VEN: Registrar pagos (split payment)
    VEN->>VEN: Estado → EMITIDA, mesa → LIBRE

    VEN->>MQ: Publicar "venta.emitida"
    MQ-->>ALM: Descontar stock (salida automática)
    MQ-->>FIN: Generar CxC (si es crédito)
    MQ-->>CNT: Pre-asiento contable de venta
    MQ-->>SUNAT: Enviar CPE a OSE/SUNAT

    SUNAT-->>VEN: CDR (aceptado/rechazado)
    VEN->>VEN: Actualizar estado facturación electrónica
```

### 29.3 Flujo de producción

```mermaid
sequenceDiagram
    participant U as Jefe Producción
    participant FE as Angular
    participant GW as Gateway
    participant PROD as ms-produccion
    participant CORE as ms-core
    participant ALM as ms-almacen
    participant RRHH as ms-rrhh
    participant MQ as RabbitMQ
    participant CNT as ms-contabilidad

    U->>FE: Crear orden de producción
    FE->>GW: POST /api/produccion/ordenes-produccion
    GW->>PROD: Forward
    PROD->>CORE: GET receta + insumos
    PROD->>ALM: Validar stock de insumos
    ALM-->>PROD: Stock disponible
    PROD->>ALM: Reservar insumos
    PROD->>PROD: Crear orden (PLANIFICADA)
    PROD-->>FE: Orden creada

    U->>FE: Iniciar producción
    FE->>GW: POST /api/produccion/ordenes-produccion/{id}/iniciar
    GW->>PROD: Forward
    PROD->>PROD: Estado → EN_PROCESO
    PROD->>PROD: Registrar hora inicio

    Note over PROD: Proceso de producción...

    U->>FE: Completar producción
    FE->>GW: POST /api/produccion/ordenes-produccion/{id}/completar
    GW->>PROD: Forward
    PROD->>ALM: Consumir insumos (salida)
    ALM->>ALM: Actualizar stock + kardex
    PROD->>ALM: Registrar ingreso producto terminado
    PROD->>RRHH: Consultar costo mano de obra
    PROD->>PROD: Calcular costeo (MP + MO + CI)
    PROD->>PROD: Estado → COMPLETADA
    PROD->>MQ: Publicar "produccion.completada"
    MQ-->>CNT: Pre-asiento (producción)
    PROD-->>FE: Producción completada + costeo
```

### 29.4 Flujo contable (pre-asientos → cierre)

```mermaid
sequenceDiagram
    participant MOD as Módulo operativo
    participant MQ as RabbitMQ
    participant CNT as ms-contabilidad
    participant DB as PostgreSQL
    participant CONT as Contador

    MOD->>MQ: Publicar evento con data contable
    MQ->>CNT: Consumir evento
    CNT->>CNT: Crear pre-asiento (PENDIENTE)
    CNT->>DB: INSERT pre_asiento

    Note over CNT: Procesamiento batch (configurable)

    CNT->>CNT: Buscar matriz contable
    alt Matriz encontrada
        CNT->>CNT: Aplicar regla de contabilización
        CNT->>CNT: Generar asiento (CONFIRMADO)
        CNT->>DB: INSERT asiento + detalles
        CNT->>CNT: Pre-asiento → PROCESADO
    else Sin matriz
        CNT->>CNT: Pre-asiento → ERROR
        CNT->>MQ: Publicar "pre_asiento.error"
    end

    Note over CONT: Fin de mes

    CONT->>CNT: POST /cierres/mensual
    CNT->>CNT: Verificar pre-asientos pendientes
    CNT->>CNT: Validar cuadre debe = haber
    CNT->>CNT: Generar asiento de cierre
    CNT->>DB: Marcar período como CERRADO
    CNT-->>CONT: Cierre exitoso

    CONT->>CNT: GET /reportes/balance-general
    CNT->>DB: Consultar saldos por cuenta
    CNT-->>CONT: Balance General PDF/Excel
```

### 29.5 Flujo de planilla RRHH

```mermaid
sequenceDiagram
    participant RH as Analista RRHH
    participant FE as Angular
    participant GW as Gateway
    participant RRHH as ms-rrhh
    participant CORE as ms-core
    participant MQ as RabbitMQ
    participant CNT as ms-contabilidad
    participant FIN as ms-finanzas

    RH->>FE: Crear planilla del mes
    FE->>GW: POST /api/rrhh/planillas
    GW->>RRHH: Forward
    RRHH->>RRHH: Crear planilla (BORRADOR)

    RH->>FE: Calcular planilla
    FE->>GW: POST /api/rrhh/planillas/{id}/calcular
    GW->>RRHH: Forward
    RRHH->>RRHH: Obtener trabajadores activos
    RRHH->>RRHH: Procesar asistencias del mes
    RRHH->>RRHH: Calcular horas extra
    RRHH->>RRHH: Aplicar conceptos de ingreso
    RRHH->>RRHH: Calcular descuentos (AFP, quinta, préstamos)
    RRHH->>RRHH: Calcular aportes empleador (EsSalud)
    RRHH->>RRHH: Estado → CALCULADA
    RRHH-->>FE: Planilla calculada + resumen

    RH->>FE: Aprobar planilla
    FE->>GW: POST /api/rrhh/planillas/{id}/aprobar
    GW->>RRHH: Forward
    RRHH->>RRHH: Estado → APROBADA

    RH->>FE: Registrar pago
    FE->>GW: POST /api/rrhh/planillas/{id}/pagar
    GW->>RRHH: Forward
    RRHH->>RRHH: Estado → PAGADA

    RH->>FE: Cerrar planilla
    FE->>GW: POST /api/rrhh/planillas/{id}/cerrar
    GW->>RRHH: Forward
    RRHH->>RRHH: Estado → CERRADA
    RRHH->>MQ: Publicar "planilla.cerrada"
    MQ-->>CNT: Pre-asiento contable de planilla
    MQ-->>FIN: Generar CxP de nómina
    RRHH-->>FE: Planilla cerrada
```

---

## 30. Diagramas de flujo de negocio

### 30.1 Proceso de aprobación multinivel

```mermaid
flowchart TD
    A[Documento creado\nBORRADOR] --> B{¿Enviar a\naprobación?}
    B -->|No| A
    B -->|Sí| C[PENDIENTE_APROBACIÓN]
    C --> D{¿Determinar nivel\nde aprobación?}
    D -->|"Monto ≤ 5,000"| E[Nivel 1:\nJefe de área]
    D -->|"5,000 < Monto ≤ 20,000"| F[Nivel 2:\nGerente de área]
    D -->|"Monto > 20,000"| G[Nivel 3:\nGerente general]
    E --> H{¿Decisión?}
    F --> H
    G --> H
    H -->|Aprobar| I{¿Requiere\nnivel superior?}
    H -->|Rechazar| J[RECHAZADO]
    I -->|Sí| D
    I -->|No| K[APROBADO]
    J --> L{¿Reenviar?}
    L -->|Sí| M[Corregir\ndocumento] --> B
    L -->|No| N[Fin]
    K --> O[Procesar\ndocumento]
```

### 30.2 Proceso de conciliación bancaria

```mermaid
flowchart TD
    A[Inicio: Seleccionar\ncuenta + período] --> B[Importar extracto\nbancario]
    B --> C[Cargar movimientos\ndel sistema]
    C --> D[Comparación\nautomática]
    D --> E{¿Coincidencia\nexacta?}
    E -->|Sí| F[Marcar como\nconciliado ✓]
    E -->|No| G{¿Coincidencia\nparcial?}
    G -->|Sí| H[Mostrar\nsugerencia]
    H --> I{¿Usuario\nconfirma?}
    I -->|Sí| F
    I -->|No| J[Marcar como\npendiente ⚠]
    G -->|No| J
    J --> K{¿Todas las\npartidas revisadas?}
    F --> K
    K -->|No| D
    K -->|Sí| L[Calcular\ndiferencias]
    L --> M{¿Diferencia\n= 0?}
    M -->|Sí| N[Estado:\nCONCILIADO ✓]
    M -->|No| O[Registrar partidas\npendientes]
    O --> P{¿Generar ajuste\ncontable?}
    P -->|Sí| Q[Crear asiento\nde ajuste]
    P -->|No| R[Dejar pendiente\npara siguiente mes]
    N --> S[Cerrar\nconciliación]
    Q --> S
```

### 30.3 Proceso de facturación electrónica

```mermaid
flowchart TD
    A[Documento de venta\nemitido] --> B[Generar XML\nUBL 2.1]
    B --> C[Firmar XML\ncon certificado digital]
    C --> D[Enviar a\nOSE/SUNAT]
    D --> E{¿Respuesta?}
    E -->|Timeout| F[Reintentar\nmáx 3 veces]
    F --> D
    E -->|CDR recibido| G{¿Estado CDR?}
    G -->|Aceptado| H[Estado:\nACEPTADO ✓]
    G -->|Observado| I[Estado:\nOBSERVADO ⚠\nGuardar observaciones]
    G -->|Rechazado| J[Estado:\nRECHAZADO ✗]
    J --> K{¿Error\ncorregible?}
    K -->|Sí| L[Corregir datos\ny reenviar]
    L --> B
    K -->|No| M[Emitir nota\nde crédito]
    H --> N[Guardar CDR\nen repositorio]
    I --> N
    N --> O[Enviar CPE\nal cliente por email]
    O --> P[Fin]
```

### 30.4 Proceso de cierre contable mensual

```mermaid
flowchart TD
    A[Inicio: Seleccionar\nperíodo a cerrar] --> B{¿Existen pre-asientos\nPENDIENTES?}
    B -->|Sí| C[Procesar pre-asientos\npendientes]
    C --> D{¿Alguno con\nERROR?}
    D -->|Sí| E[Corregir matrices\no reprocesar]
    E --> C
    D -->|No| F[Todos procesados ✓]
    B -->|No| F
    F --> G[Verificar cuadre:\nDebe = Haber\npor libro]
    G --> H{¿Cuadrado?}
    H -->|No| I[Identificar\ndescuadres]
    I --> J[Generar asiento\nde ajuste]
    J --> G
    H -->|Sí| K[Calcular saldos\nacumulados por cuenta]
    K --> L[Generar asiento\nde cierre mensual]
    L --> M[Generar Balance\nde Comprobación]
    M --> N[Marcar período\ncomo CERRADO]
    N --> O[Bloquear registro\nen período cerrado]
    O --> P{¿Es diciembre?}
    P -->|Sí| Q[Proceso de\ncierre anual]
    Q --> R[Asiento de cierre\nde resultados]
    R --> S[Generar EEFF\nanuales]
    S --> T[Asiento de\napertura nuevo año]
    P -->|No| U[Fin cierre mensual]
    T --> U
```

### 30.5 Proceso de inventario físico

```mermaid
flowchart TD
    A[Iniciar toma\nde inventario] --> B[Seleccionar almacén\ny fecha de corte]
    B --> C[Bloquear movimientos\nen el almacén]
    C --> D[Generar listado\nde artículos a contar]
    D --> E[Asignar equipos\nde conteo]
    E --> F[Primer conteo\n"Conteo ciego"]
    F --> G[Registrar cantidades\nfísicas]
    G --> H[Segundo conteo\n"Verificación"]
    H --> I{¿Coincide con\nprimer conteo?}
    I -->|No| J[Tercer conteo\n"Desempate"]
    J --> G
    I -->|Sí| K[Comparar: Sistema\nvs Físico]
    K --> L{¿Hay\ndiferencias?}
    L -->|No| M[Inventario OK ✓]
    L -->|Sí| N[Generar informe\nde diferencias]
    N --> O{¿Aprobar\najustes?}
    O -->|Sí| P[Generar movimientos\nde ajuste]
    P --> Q[Actualizar stock\nen sistema]
    Q --> R[Generar pre-asiento\nde ajuste inventario]
    O -->|No| S[Investigar\ncausas]
    S --> O
    M --> T[Desbloquear\nalmacén]
    R --> T
    T --> U[Cerrar toma\nde inventario]
```

---

## 31. Diagramas de estado

### 31.1 Estados de una Orden de Compra

```mermaid
stateDiagram-v2
    [*] --> BORRADOR: Crear OC
    BORRADOR --> BORRADOR: Editar
    BORRADOR --> PENDIENTE_APROBACION: Enviar a aprobación
    BORRADOR --> ANULADA: Anular
    PENDIENTE_APROBACION --> APROBADA: Aprobar (último nivel)
    PENDIENTE_APROBACION --> RECHAZADA: Rechazar
    PENDIENTE_APROBACION --> BORRADOR: Devolver para corrección
    RECHAZADA --> BORRADOR: Corregir y reenviar
    RECHAZADA --> ANULADA: Descartar
    APROBADA --> RECEPCION_PARCIAL: Recepción parcial
    APROBADA --> COMPLETADA: Recepción total
    APROBADA --> ANULADA: Anular OC aprobada
    RECEPCION_PARCIAL --> RECEPCION_PARCIAL: Otra recepción parcial
    RECEPCION_PARCIAL --> COMPLETADA: Última recepción
    COMPLETADA --> [*]
    ANULADA --> [*]
```

### 31.2 Estados de un Documento de Venta

```mermaid
stateDiagram-v2
    [*] --> EMITIDA: Generar boleta/factura
    EMITIDA --> ENVIADA_SUNAT: Enviar a OSE/SUNAT
    ENVIADA_SUNAT --> ACEPTADA: CDR aceptado
    ENVIADA_SUNAT --> OBSERVADA: CDR con observaciones
    ENVIADA_SUNAT --> RECHAZADA: CDR rechazado
    OBSERVADA --> ACEPTADA: Subsanada
    RECHAZADA --> CORREGIDA: Corregir y reenviar
    CORREGIDA --> ENVIADA_SUNAT: Reenviar
    ACEPTADA --> ANULADA: Emitir NC completa
    ACEPTADA --> CON_NC_PARCIAL: Emitir NC parcial
    CON_NC_PARCIAL --> ANULADA: NC por saldo restante
    EMITIDA --> ANULADA: Anular (mismo día)
    ANULADA --> [*]
    ACEPTADA --> [*]
```

### 31.3 Estados de una Orden de Producción

```mermaid
stateDiagram-v2
    [*] --> PLANIFICADA: Crear orden
    PLANIFICADA --> PLANIFICADA: Editar
    PLANIFICADA --> EN_PROCESO: Iniciar producción
    PLANIFICADA --> CANCELADA: Cancelar
    EN_PROCESO --> EN_CONTROL_CALIDAD: Producción terminada
    EN_CONTROL_CALIDAD --> COMPLETADA: QC aprobado
    EN_CONTROL_CALIDAD --> EN_PROCESO: QC rechazado (reproceso)
    EN_PROCESO --> CANCELADA: Cancelar en proceso
    COMPLETADA --> [*]
    CANCELADA --> [*]

    note right of EN_PROCESO
        Al iniciar:
        - Reservar insumos
        - Registrar hora inicio
    end note

    note right of COMPLETADA
        Al completar:
        - Consumir insumos (almacén)
        - Ingresar producto terminado
        - Calcular costeo real
        - Emitir pre-asiento
    end note
```

### 31.4 Estados de un Asiento Contable

```mermaid
stateDiagram-v2
    [*] --> BORRADOR: Crear asiento manual
    [*] --> CONFIRMADO: Asiento automático\n(desde pre-asiento)
    BORRADOR --> BORRADOR: Editar
    BORRADOR --> CONFIRMADO: Confirmar\n(validar Debe=Haber)
    BORRADOR --> ELIMINADO: Eliminar borrador
    CONFIRMADO --> ANULADO: Anular\n(genera contra-asiento)
    CONFIRMADO --> [*]: Cierre de período
    ANULADO --> [*]
    ELIMINADO --> [*]

    note right of CONFIRMADO
        Validaciones:
        - Debe = Haber
        - Cuentas de movimiento
        - Período abierto
        - Centro de costo si requerido
    end note
```

### 31.5 Estados de un Activo Fijo

```mermaid
stateDiagram-v2
    [*] --> ACTIVO: Registrar activo
    ACTIVO --> ACTIVO: Depreciación mensual
    ACTIVO --> EN_MANTENIMIENTO: Enviar a mantenimiento
    ACTIVO --> EN_TRASLADO: Solicitar traslado
    ACTIVO --> REVALUADO: Revaluar
    ACTIVO --> BAJA: Dar de baja
    EN_MANTENIMIENTO --> ACTIVO: Mantenimiento completado
    EN_TRASLADO --> ACTIVO: Traslado ejecutado\n(nueva ubicación)
    REVALUADO --> ACTIVO: Continuar depreciación\ncon nuevo valor
    BAJA --> [*]

    note right of BAJA
        Tipos de baja:
        - Venta
        - Donación
        - Siniestro
        - Obsolescencia
        Genera pre-asiento
    end note
```

### 31.6 Estados de una Planilla

```mermaid
stateDiagram-v2
    [*] --> BORRADOR: Crear planilla
    BORRADOR --> CALCULADA: Calcular\n(procesar conceptos)
    CALCULADA --> BORRADOR: Recalcular\n(ajustes manuales)
    CALCULADA --> APROBADA: Aprobar
    APROBADA --> PAGADA: Registrar pago
    PAGADA --> CERRADA: Cerrar planilla
    CERRADA --> [*]

    note right of CALCULADA
        Procesa:
        - Días trabajados (asistencia)
        - Horas extra
        - Ingresos fijos y variables
        - Descuentos legales
        - Aportes empleador
    end note

    note right of CERRADA
        Al cerrar:
        - Emite pre-asiento contable
        - Genera boletas de pago
        - Bloquea edición
    end note
```

### 31.7 Estados de un Documento CxP / CxC

```mermaid
stateDiagram-v2
    [*] --> PENDIENTE: Registrar documento
    PENDIENTE --> PARCIAL: Pago/cobro parcial
    PARCIAL --> PARCIAL: Otro pago/cobro parcial
    PARCIAL --> PAGADO_COBRADO: Pago/cobro total
    PENDIENTE --> PAGADO_COBRADO: Pago/cobro total
    PENDIENTE --> EN_LETRAS: Canje por letras\n(solo CxC)
    EN_LETRAS --> PAGADO_COBRADO: Letra pagada
    EN_LETRAS --> PROTESTADA: Letra protestada
    PROTESTADA --> PAGADO_COBRADO: Regularización
    PENDIENTE --> ANULADO: Anular documento
    PAGADO_COBRADO --> [*]
    ANULADO --> [*]
```

---

## 32. Estrategia de multitenancy — Database-per-Tenant

### 32.1 Visión general

Restaurant.pe implementa el patrón **Database-per-Tenant** para lograr aislamiento total de datos entre empresas. PostgreSQL soporta nativamente este patrón mediante `CREATE DATABASE ... TEMPLATE`, permitiendo clonar bases de datos de forma instantánea.

```mermaid
flowchart TB
    subgraph Usuarios["Usuarios del sistema"]
        U1["👤 Admin Empresa 1\n(Lima SAC)"]
        U2["👤 Admin Empresa 2\n(Bogotá SAS)"]
        U3["👤 Superadmin\n(acceso a ambas)"]
    end

    subgraph Frontend["Angular 20"]
        FE["SPA\n(selección de empresa en login)"]
    end

    subgraph Gateway["API Gateway :8080"]
        GW["Ruteo + validación JWT\nPropaga X-Empresa-Id"]
    end

    subgraph Auth_Service["ms-auth-security :9001"]
        AUTH["Autenticación\nGestión de tenants\nProvisión de connections"]
    end

    subgraph Business_Services["Microservicios de negocio"]
        MS1["ms-compras"]
        MS2["ms-almacen"]
        MS3["ms-ventas"]
        MSN["... otros ms"]
    end

    subgraph Routing["TenantRoutingDataSource"]
        TR["Pool HikariCP\npor cada tenant\n(dinámico)"]
    end

    subgraph PostgreSQL["PostgreSQL 16 Server"]
        MASTER["restaurant_pe_master\n━━━━━━━━━━━━━━\nschema: auth\n(usuarios, roles, permisos)\n━━━━━━━━━━━━━━\nschema: master\n(tenant registry +\nconnection strings)"]

        TEMPLATE["restaurant_pe_template\n━━━━━━━━━━━━━━\nMODELO — No se usa\nen producción\n━━━━━━━━━━━━━━\n10 schemas de negocio"]

        DB1["restaurant_pe_emp_1\n━━━━━━━━━━━━━━\nLima SAC\n(clon del template)"]

        DB2["restaurant_pe_emp_2\n━━━━━━━━━━━━━━\nBogotá SAS\n(clon del template)"]
    end

    U1 --> FE
    U2 --> FE
    U3 --> FE
    FE --> GW
    GW --> AUTH
    GW --> MS1
    GW --> MS2
    GW --> MS3
    GW --> MSN

    AUTH -->|"conexión directa"| MASTER
    AUTH -.->|"GET /internal/tenants"| MS1
    AUTH -.->|"GET /internal/tenants"| MS2
    AUTH -.->|"GET /internal/tenants"| MS3

    MS1 --> TR
    MS2 --> TR
    MS3 --> TR
    MSN --> TR

    TR -->|"X-Empresa-Id: 1"| DB1
    TR -->|"X-Empresa-Id: 2"| DB2

    TEMPLATE -.->|"CREATE DATABASE ... TEMPLATE"| DB1
    TEMPLATE -.->|"CREATE DATABASE ... TEMPLATE"| DB2

    style MASTER fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px
    style TEMPLATE fill:#fff3e0,stroke:#ef6c00,stroke-width:2px
    style DB1 fill:#e3f2fd,stroke:#1565c0
    style DB2 fill:#e3f2fd,stroke:#1565c0
```

### 32.2 Arquitectura de la BD Master

La BD `restaurant_pe_master` es la **única base de datos administrativa** del sistema. Contiene dos esquemas:

- **`master`:** Tabla `tenant` con el registro de empresas y sus connection strings.
- **`auth`:** Tablas de seguridad centralizadas — `usuario`, `usuario_empresa`, `rol`, `modulo`, `opcion_menu`, `accion`, `permiso`, `sesion`, `log_acceso`.

```mermaid
erDiagram
    TENANT ||--o{ USUARIO_EMPRESA : "tiene usuarios"
    USUARIO ||--o{ USUARIO_EMPRESA : "accede a"
    ROL ||--o{ USUARIO_EMPRESA : "asignado como"
    ROL ||--o{ ROL_OPCION_MENU : "tiene opciones"
    OPCION_MENU ||--o{ ROL_OPCION_MENU : "asignada a roles"
    MODULO ||--o{ OPCION_MENU : "contiene"
    OPCION_MENU ||--o{ PERMISO : "tiene acciones"
    ACCION ||--o{ PERMISO : "define"
    USUARIO ||--o{ USUARIO_OPCION_MENU : "opciones individuales"
    USUARIO ||--o{ SESION : "sesiones"
```

> **ER completo con columnas:** [`DISENO_BASE_DATOS.md`](./DISENO_BASE_DATOS.md), sección 3.3.

### 32.3 Modelo de seguridad centralizado

Un usuario puede tener **acceso a múltiples empresas**, cada una con un **rol diferente**:

```
┌──────────────────────────────────────────────────────────────────┐
│                    restaurant_pe_master                          │
│                                                                  │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ auth.usuario: jramirez                                      │ │
│  │                                                              │ │
│  │ ┌─────────────────────────────────┐                         │ │
│  │ │ usuario_empresa                 │                         │ │
│  │ │  → empresa_id: 1 (Lima SAC)    │  rol: ADMIN_ALMACEN     │ │
│  │ │  → empresa_id: 2 (Bogotá SAS)  │  rol: JEFE_COMPRAS      │ │
│  │ │  → empresa_id: 3 (Chile SpA)   │  rol: AUDITOR (solo ver)│ │
│  │ └─────────────────────────────────┘                         │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                                                                  │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │ master.tenant    │  │ master.tenant    │  │ master.tenant    │ │
│  │ id: 1            │  │ id: 2            │  │ id: 3            │ │
│  │ Lima SAC         │  │ Bogotá SAS       │  │ Chile SpA        │ │
│  │ → restaurant_    │  │ → restaurant_    │  │ → restaurant_    │ │
│  │   pe_emp_1       │  │   pe_emp_2       │  │   pe_emp_3       │ │
│  └────────┬─────────┘  └────────┬─────────┘  └────────┬─────────┘ │
│           │                      │                      │          │
└───────────┼──────────────────────┼──────────────────────┼──────────┘
            ▼                      ▼                      ▼
    ┌───────────────┐     ┌───────────────┐     ┌───────────────┐
    │ restaurant_   │     │ restaurant_   │     │ restaurant_   │
    │ pe_emp_1      │     │ pe_emp_2      │     │ pe_emp_3      │
    │               │     │               │     │               │
    │ 10 schemas    │     │ 10 schemas    │     │ 10 schemas    │
    │ de negocio    │     │ de negocio    │     │ de negocio    │
    └───────────────┘     └───────────────┘     └───────────────┘
```

### 32.4 ms-auth-security como proveedor de tenants

**ms-auth-security** es el único servicio con acceso directo a `restaurant_pe_master` y actúa como **proveedor central de información de tenants** para todos los demás microservicios.

```mermaid
sequenceDiagram
    participant MS as ms-compras (startup)
    participant AUTH as ms-auth-security
    participant MASTER as restaurant_pe_master
    participant MQ as RabbitMQ

    rect rgb(240, 248, 255)
        Note over MS,MASTER: Inicialización del microservicio
        MS->>AUTH: GET /internal/tenants/active
        AUTH->>MASTER: SELECT * FROM master.tenant WHERE activo = true
        MASTER-->>AUTH: Lista de tenants con connection strings
        AUTH-->>MS: [{empresaId:1, jdbcUrl:..., user:..., pass:...}, ...]
        MS->>MS: Crear HikariCP pool por cada tenant
        MS->>MS: Registrar pools en TenantRoutingDataSource
        Note over MS: ✅ Listo para recibir requests
    end

    rect rgb(255, 248, 240)
        Note over AUTH,MQ: Cuando se crea una nueva empresa
        AUTH->>MASTER: CREATE DATABASE ... TEMPLATE
        AUTH->>MASTER: INSERT INTO master.tenant
        AUTH->>MQ: Publicar evento: tenant.created
        MQ-->>MS: Evento: tenant.created {empresaId: 4}
        MS->>AUTH: GET /internal/tenants/4
        AUTH-->>MS: {empresaId:4, jdbcUrl:..., user:..., pass:...}
        MS->>MS: Agregar nuevo HikariCP pool (sin reinicio)
        Note over MS: ✅ Nuevo tenant disponible dinámicamente
    end
```

### 32.5 Endpoints internos de ms-auth-security para gestión de tenants

| Método | Endpoint | Descripción |
|:------:|----------|-------------|
| GET | `/internal/tenants/active` | Lista todos los tenants activos con connection strings |
| GET | `/internal/tenants/{empresaId}` | Obtener connection info de un tenant específico |
| POST | `/api/admin/tenants` | Crear nueva empresa (solo SUPERADMIN) |
| PUT | `/api/admin/tenants/{id}` | Actualizar datos del tenant |
| POST | `/api/admin/tenants/{id}/desactivar` | Desactivar empresa (bloquea acceso) |
| POST | `/api/admin/tenants/{id}/activar` | Reactivar empresa |
| GET | `/api/admin/tenants` | Listar todas las empresas registradas |
| GET | `/api/admin/tenants/{id}/stats` | Estadísticas del tenant (tamaño BD, usuarios, etc.) |

### 32.6 Proceso de onboarding de nueva empresa

```mermaid
flowchart TB
    A[Superadmin solicita\ncrear empresa] --> B[POST /api/admin/tenants]
    B --> C{Validar datos\nde la empresa}
    C -->|❌ Inválido| D[Retornar error\n400 Bad Request]
    C -->|✅ Válido| E["CREATE DATABASE\nrestaurant_pe_emp_N\nTEMPLATE restaurant_pe_template"]
    E --> F["INSERT INTO\nmaster.tenant\n(con connection string)"]
    F --> G["Ejecutar Flyway\nen la nueva BD\n(por si hay migraciones\nposteriores al template)"]
    G --> H["Insertar seed data:\n• Datos empresa\n• País, monedas, impuestos\n• Sucursal principal\n• Plan contable base\n• Secuencias numeración\n• Config por defecto"]
    H --> I["Crear usuario admin\nen auth.usuario_empresa\n(con rol ADMIN)"]
    I --> J["Publicar evento\ntenant.created\nvía RabbitMQ"]
    J --> K["Todos los ms\nagregan pool\ndinámicamente"]
    K --> L["✅ Empresa lista\npara operar"]

    style E fill:#e3f2fd,stroke:#1565c0
    style J fill:#fff3e0,stroke:#ef6c00
    style L fill:#e8f5e9,stroke:#2e7d32
```

### 32.7 Ventajas y consideraciones

| Ventaja | Descripción |
|---------|-------------|
| **Aislamiento total** | Cada empresa es una BD independiente; imposible ver datos ajenos |
| **Sin `empresa_id`** | Las tablas de negocio no necesitan columna `empresa_id` (queries más limpios) |
| **Backup independiente** | Se puede hacer backup/restore de una sola empresa sin afectar las demás |
| **Escalabilidad horizontal** | Una empresa con mucho volumen se puede mover a otro servidor PostgreSQL |
| **Borrado seguro** | `DROP DATABASE restaurant_pe_emp_X` elimina todos los datos de una empresa |
| **Compliance (GDPR, etc.)** | Datos de cada empresa totalmente aislados por diseño |
| **Performance** | Los índices de una empresa no se ven afectados por el volumen de otra |
| **Clonación instantánea** | `CREATE DATABASE ... TEMPLATE` clona toda la estructura en segundos |
| **Numeración simplificada** | Las secuencias no necesitan `empresa_id` — ya son locales a la BD |

| Consideración | Mitigación |
|---------------|------------|
| Múltiples conexiones (pools) | HikariCP con pools pequeños por tenant (2-10 conns cada uno) |
| Migraciones en múltiples BDs | `MultiTenantMigrationRunner` automatiza la ejecución en todas |
| Reportes cruzados | Endpoint de consolidación o Data Warehouse a futuro |
| Complejidad operativa | Script automatizado de onboarding + eventos RabbitMQ |
| Monitoreo | Métricas por tenant (tamaño BD, conexiones activas, queries lentos) |

### 32.8 Diagrama de despliegue completo

```mermaid
flowchart TB
    subgraph Docker_Host["Docker Compose — Entorno local"]
        subgraph Infra["Infraestructura"]
            PG["PostgreSQL 16\n:5432"]
            MQ["RabbitMQ\n:5672 / :15672"]
            REDIS["Redis\n:6379"]
        end

        subgraph Spring["Spring Cloud"]
            EU["Eureka\n:8761"]
            CFG["Config Server\n:8888"]
            GW["API Gateway\n:8080"]
        end

        subgraph Auth["Servicio de Autenticación"]
            AUTH_MS["ms-auth-security\n:9001\nConecta a: restaurant_pe_master"]
        end

        subgraph Negocio["Servicios de Negocio (con TenantRoutingDataSource)"]
            CORE["ms-core-maestros :9002"]
            ALM["ms-almacen :9003"]
            COM["ms-compras :9004"]
            FIN["ms-finanzas :9005"]
            CNT["ms-contabilidad :9006"]
            RRHH_S["ms-rrhh :9007"]
            ACT["ms-activos-fijos :9008"]
            PROD["ms-produccion :9009"]
            VEN["ms-ventas :9010"]
        end

        subgraph Soporte["Servicios de Soporte"]
            AUD["ms-auditoria :9011"]
            RPT["ms-reportes :9012"]
            NOTIF["ms-notificaciones :9013"]
        end

        subgraph Databases["Bases de datos en PostgreSQL"]
            DB_MASTER["restaurant_pe_master\n(auth + tenants)"]
            DB_TEMPLATE["restaurant_pe_template\n(modelo)"]
            DB_EMP1["restaurant_pe_emp_1\n(empresa demo)"]
        end

        FE["Frontend Angular :4200"]
    end

    FE --> GW
    GW --> AUTH_MS
    GW --> CORE & ALM & COM & FIN & CNT & RRHH_S & ACT & PROD & VEN
    GW --> AUD & RPT & NOTIF

    AUTH_MS -->|"conexión directa"| DB_MASTER
    AUTH_MS -.->|"provee tenants"| CORE & ALM & COM & FIN & CNT & RRHH_S & ACT & PROD & VEN & AUD

    CORE & ALM & COM & FIN & CNT & RRHH_S & ACT & PROD & VEN & AUD -->|"TenantRouting"| DB_EMP1

    DB_TEMPLATE -.->|"TEMPLATE"| DB_EMP1

    AUTH_MS --> REDIS
    AUTH_MS --> MQ
    CORE & ALM & COM & FIN & CNT & RRHH_S & ACT & PROD & VEN --> MQ

    style DB_MASTER fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px
    style DB_TEMPLATE fill:#fff3e0,stroke:#ef6c00,stroke-width:2px
    style DB_EMP1 fill:#e3f2fd,stroke:#1565c0
    style AUTH_MS fill:#fce4ec,stroke:#c62828,stroke-width:2px
```

### 32.9 Resumen de la decisión arquitectónica

| Decisión | Valor |
|----------|-------|
| **Estrategia multitenancy** | Database-per-Tenant |
| **BD modelo** | `restaurant_pe_template` (nunca se usa en producción) |
| **BD por empresa** | `restaurant_pe_emp_{id}` (clon del template) |
| **BD administrativa** | `restaurant_pe_master` (auth + tenant registry) |
| **Proveedor de tenants** | `ms-auth-security` vía endpoint `/internal/tenants/active` |
| **Ruteo dinámico** | `AbstractRoutingDataSource` + header `X-Empresa-Id` |
| **`empresa_id` en tablas** | **No necesario** (la BD ya es de una sola empresa) |
| **Pool de conexiones** | HikariCP con pool independiente por tenant |
| **Nueva empresa** | `CREATE DATABASE ... TEMPLATE` + seed data + evento RabbitMQ |
| **Migraciones** | Flyway ejecutado contra template + todos los tenants activos |
| **Sincronización** | Evento `tenant.created` vía RabbitMQ para agregar pools dinámicamente |
| **Seguridad centralizada** | Usuarios, roles, permisos en BD master (transversales a empresas) |

---

*Documento de arquitectura técnica del proyecto Restaurant.pe. Cubre microservicios, estrategia Database-per-Tenant, seguridad centralizada, multitenancy, comunicación, DevOps, estándares de desarrollo, diagramas de arquitectura (C4), entidades (resumen), comunicación, interacción, flujos y estados. La definición detallada de tablas, columnas, índices, migraciones y ER completos se encuentra en [`DISENO_BASE_DATOS.md`](./DISENO_BASE_DATOS.md). Basado en el análisis de las HUs y la experiencia del ERP SIGRE.*
