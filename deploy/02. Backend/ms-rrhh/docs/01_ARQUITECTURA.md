# Arquitectura de ms-rrhh

## Visión General

Microservicio encargado de la gestión integral de Recursos Humanos del ERP Restaurant.pe.
Cubre 10 macroprocesos: Maestros de Personal, Asistencia y Jornadas, Nómina, Beneficios Sociales,
Gestión de Personal, Financiero, Reclutamiento, Reportes, Configuración y Localización LATAM.

**Puerto:** `9010` | **Esquema BD:** `rrhh` | **Stack:** Java 21 + Spring Boot 3.x + PostgreSQL

## Stack Tecnológico

| Componente | Tecnología |
|---|---|
| Lenguaje | Java 21 |
| Framework | Spring Boot 3.x |
| ORM | Spring Data JPA / Hibernate |
| Mapeo DTO | MapStruct (`componentModel = "spring"`) |
| Seguridad | Spring Security + JWT (filtro tenant-aware en módulo common) |
| Documentación API | SpringDoc OpenAPI (Swagger UI) |
| Base de datos | PostgreSQL 16+, esquema `rrhh` por tenant |
| Migraciones | Flyway (deshabilitado; BD gestionada externamente vía DDL) |
| Mensajería | RabbitMQ / AMQP (productor para eventos de planilla y beneficios) |
| Cliente HTTP | OpenFeign (ms-core-maestros, ms-auth) |
| Métricas | Micrometer `@Timed` + Prometheus + Actuator |
| Testing | JUnit 5 + Testcontainers (PostgreSQL) |
| Cobertura | JaCoCo (mínimo 80% instrucciones) |

## Estructura del Proyecto

```
ms-rrhh/
├── Dockerfile
├── pom.xml
├── src/main/java/pe/restaurant/rrhh/
│   ├── RrhhApplication.java
│   ├── config/
│   │   ├── RrhhSecurityConfig.java
│   │   └── RrhhJwtAuthenticationFilter.java
│   ├── constants/       (18 archivos)
│   │   ├── AreaConstants.java              ✅
│   │   ├── CargoConstants.java             ✅
│   │   ├── TurnoConstants.java             ✅
│   │   ├── AdminAfpConstants.java          ✅
│   │   ├── ConceptoPlanillaConstants.java  ✅
│   │   ├── TipoNovedadRrhhConstants.java   ✅
│   │   ├── PermisoLicenciaConstants.java   ✅
│   │   ├── SancionAmonestacionConstants.java ✅
│   │   ├── TipoSancionConstants.java       ✅
│   │   ├── TipoSuspensionLaboralConstants.java ✅
│   │   ├── PrestamoConstants.java          ✅
│   │   ├── NovedadRrhhConstants.java       ✅
│   │   ├── CtsConstants.java               ✅
│   │   ├── GratificacionConstants.java     ✅
│   │   ├── ~~BoletaPagoConstants.java~~     ❌ (eliminado)
│   │   ├── CntaCrrteConstants.java         ✅
│   │   ├── CapacitacionConstants.java      ✅
│   │   ├── PeriodoGratificacionConstants.java ✅
│   │   └── ... (resto inline en service)
│   ├── controller/     (38 controllers, **276 endpoints**)
│   │   ├── AreaController.java              ✅
│   │   ├── CargoController.java             ✅
│   │   ├── TurnoController.java             ✅
│   │   ├── AdminAfpController.java          ✅
│   │   ├── ConceptoPlanillaController.java  ✅
│   │   ├── TipoNovedadRrhhController.java   ✅
│   │   ├── GanDescFijoController.java       ✅
│   │   ├── GanDescVariableController.java   ✅
│   │   ├── TrabajadorController.java        ✅ (+ sub-recursos contrato/horario)
│   │   ├── AsistenciaController.java        ✅
│   │   ├── CalculoController.java           ✅
│   │   ├── CapacitacionController.java      ✅ (+ participantes)
│   │   ├── PermisoLicenciaController.java   ✅ (+ aprobar/rechazar)
│   │   ├── SancionAmonestacionController.java ✅
│   │   ├── TipoSancionController.java       ✅
│   │   ├── TipoSuspensionLaboralController.java ✅
│   │   ├── PrestamoController.java          ✅
│   │   ├── NovedadRrhhController.java       ✅ (+ detalles)
│   │   ├── LiquidacionController.java       ✅
│   │   ├── QuintaCategoriaController.java   ✅
│   │   ├── CtsController.java               ✅
│   │   ├── GratificacionController.java     ✅
│   │   ├── CntaCrrteController.java         ✅ (+ movimientos)
│   │   ├── VacacionController.java          ✅
│   │   ├── EvaluacionDesempenoController.java ✅
│   │   ├── ControlSubsidioController.java   ✅
│   │   ├── SexoController.java              ✅
│   │   ├── EstadoCivilController.java       ✅
│   │   ├── RegimenLaboralController.java     ✅
│   │   ├── TipoContratoController.java       ✅
│   │   ├── TipoSubsidioController.java      ✅
│   │   ├── TipoPlanillaController.java      ✅
│   │   ├── TipoConceptoCalculoController.java ✅
│   │   ├── TipoMovAsistenciaController.java  ✅
│   │   ├── TipoMovimientoCntaCrrteController.java ✅
│   │   ├── PeriodoGratificacionController.java ✅
│   │   ├── PeriodoCtsController.java        ✅
│   │   └── ProgramVacacionController.java    ✅
│   ├── dto/
│   │   ├── request/ (CreateRequest, UpdateRequest por entidad)
│   │   └── response/ (Response, DTO por entidad)
│   ├── entity/
│   │   ├── Area.java, Cargo.java, Turno.java, ...
│   │   └── (41+ entidades JPA)
│   ├── mapper/ (MapStruct interfaces)
│   ├── repository/ (JPA repositories + JpaSpecificationExecutor)
│   ├── service/
│   │   ├── impl/ (implementaciones con @Timed + @Transactional)
│   │   └── (interfaces)
│   ├── client/ (OpenFeign: CoreMaestrosClient, AuthClient)
│   ├── specification/ (JPA Specifications para filtros dinámicos)
│   ├── validation/ (Validators con lógica de negocio)
│   ├── exception/ (Manejadores globales + BusinessException)
│   ├── event/ (RabbitMQ publishers: CalculoCompletadoEvent, etc.)
│   ├── enums/ (TipoConceptoCalculo, EstadoCalculo, etc.)
│   ├── batch/ (lógica de procesos batch: gratificación, CTS, planilla)
│   └── testdata/ (Factories + Seeders para pruebas)
└── src/test/java/pe/restaurant/rrhh/
    └── (tests unitarios + integración)
```

## Capas Arquitectónicas

### 1. Configuración y Seguridad

- `RrhhSecurityConfig`: Cadena de filtros Spring Security. CORS habilitado, CSRF deshabilitado, sesiones STATELESS.
- Whitelist público: `/actuator/**`, `/swagger-ui/**`, `/v3/api-docs/**`.
- Multi-tenancy: resolucion de tenant desde el token JWT.

### 2. Controladores REST

Todos devuelven `ApiResponse<T>` (wrapper estándar del módulo common).
Las entidades con sub-recursos (Trabajador → Contrato, Horario) exponen endpoints anidados.

### 3. Servicios

Patrón interface + implementación con `@Timed` (Micrometer) en todos los métodos públicos.
Nivel clase `@Transactional(readOnly = true)`, métodos de escritura con `@Transactional`.
Los procesos batch (planilla, gratificación, CTS) se ejecutan en transacciones propias.

### 4. Repositorios

JPA con soporte `JpaSpecificationExecutor` para filtros dinámicos en todas las entidades CRUD.
Las tablas batch (calculo, gratificación, cts) usan repositorios con consultas JPQL personalizadas.

### 5. Mappers (MapStruct)

`componentModel = "spring"` para convertir Request ↔ Entity ↔ Response.
Mappers independientes por cada entidad.

## Diagrama de Arquitectura

```
                      ┌───────────────────────────────────────────┐
                      │            ms-rrhh (:9010)                  │
                      │                                            │
   ┌──────────┐       │  ┌──────────┐  ┌──────────┐  ┌─────────┐ │
   │ Cliente  │──────▶│  │Controller│─▶│ Service  │─▶│ JPA     │ │
   │ HTTP/REST│       │  │  (REST)  │  │ (lógica) │  │ Repo    │ │
   └──────────┘       │  └──────────┘  └────┬─────┘  └─────────┘ │
                      │                     │                     │
                      │              ┌──────────────────────┐     │
                      │              │ OpenFeign clients    │     │
                      │              │ (core, auth)         │     │
                      │              └──────────────────────┘     │
                      │                                            │
                      │  ┌──────────────────────────────────────┐ │
                      │  │     Módulo Common (common)            │ │
                      │  │  ApiResponse<T> · BusinessException  │ │
                      │  │  BaseEntity · AuditOnlyMappedEntity  │ │
                      │  │  PageData · PageMeta · JwtFilter     │ │
                      │  └──────────────────────────────────────┘ │
                      │                                            │
                      │  ┌──────────────────────────────────────┐ │
                      │  │  RabbitMQ publisher (eventos)        │ │
                      │  │  Micrometer @Timed · Actuator        │ │
                      │  │  SpringDoc OpenAPI (Swagger)         │ │
                      │  └──────────────────────────────────────┘ │
                      │                                            │
                      └────────────────────────────────────────────┘
                                    │
                                    ▼
                      ┌──────────────────────────────┐
                      │  PostgreSQL multi-tenant      │
                      │  Esquema: rrhh (por tenant)   │
                      │  + auth (core, finanzas)      │
                      └──────────────────────────────┘
```

## Decisiones Arquitectónicas Clave

1. **Multi-tenancy por schema**: Cada tenant tiene su propio esquema `rrhh`. Resolución vía filtro JWT.
2. **Sin Flyway activo**: Migraciones gestionadas externamente (DDL único en `03. Base de datos/ddl/tenant/07-rrhh.sql`).
3. **Sin auto-DDL**: `spring.jpa.hibernate.ddl-auto=none`.
4. **BaseEntity vs AuditOnlyMappedEntity**: Entidades CRUD con `flagEstado` extienden `BaseEntity`; entidades batch (calculo, gratificación, cts) extienden `AuditOnlyMappedEntity`.
5. **Sub-recursos**: Contrato y Horario son sub-recursos de Trabajador (`/trabajadores/{id}/contratos`, `/trabajadores/{id}/horarios`).
6. **Catálogos independientes**: Sexo, estado_civil, régimen laboral, tipo_contrato, etc. son tablas maestras pequeñas con su propio CRUD.
7. **Procesos batch**: Planilla, gratificación, CTS y liquidación se ejecutan como procesos transaccionales pesados con control de idempotencia.
8. **RabbitMQ productor**: Eventos tras completar cálculo de planilla, gratificación y CTS para notificar a contabilidad y finanzas.
9. **OpenFeign activo**: Clientes hacia `ms-core-maestros` (entidad_contribuyente, tipo_doc_identidad) y `ms-auth` (validación usuarios).
10. **Cobertura JaCoCo 80%**: Excluye config, entity, dto, repository, feign, testdata.
11. **Discrepancia created_by**: DDL usa `BIGINT` (FK a `auth.usuario`), entities Java usan `String` (consistente con ms-produccion).

## Swagger

- API Docs: `/api/rrhh/v3/api-docs`
- Swagger UI: `/api/rrhh/swagger-ui.html`

## Patrón de Procesos Batch

Todos los procesos batch (planilla, gratificación, CTS, liquidación) siguen este patrón:

```
1. Validar pre-requisitos (período, trabajadores activos, no duplicados)
2. Limpiar cálculo previo (si existe en estado borrador)
3. Por cada trabajador activo:
   a. Calcular conceptos según reglas de negocio
   b. Generar líneas de detalle
   c. Acumular totales
4. Persistir cabecera + detalle en una sola transacción
5. Publicar evento RabbitMQ (notificar a contabilidad/finanzas)
6. Retornar resumen del proceso
```

Idempotencia: si ya existe un cálculo para el mismo período/tipo:
- En estado BORRADOR: se elimina y recalcula
- En estado CERRADO: se rechaza la operación
