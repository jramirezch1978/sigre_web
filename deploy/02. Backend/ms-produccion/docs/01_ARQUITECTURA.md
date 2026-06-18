# Arquitectura de ms-produccion

## Visión General

Microservicio encargado de la gestión de producción del ERP Restaurant.pe.
Puerto: `9009` | Esquema BD: `produccion` | Java 21 + Spring Boot 3.x

## Stack Tecnológico

| Componente | Tecnología |
|---|---|
| Lenguaje | Java 21 |
| Framework | Spring Boot 3.x |
| ORM | Spring Data JPA / Hibernate |
| Mapeo DTO | MapStruct |
| Seguridad | Spring Security + JWT (filtro tenant-aware) |
| Documentación API | SpringDoc OpenAPI (Swagger UI) |
| Base de datos | PostgreSQL |
| Migraciones | Flyway (deshabilitado, BD gestionada externamente) |
| Mensajería | RabbitMQ / AMQP (productor en cerrar/anular/costeo) |
| Cliente HTTP | OpenFeign (5 clients en uso activo) |
| Métricas | Micrometer @Timed + Prometheus + Actuator |
| Testing | JUnit 5 + Testcontainers (PostgreSQL) |
| Cobertura | JaCoCo (mínimo 80% instrucciones) |
| Empaquetado | Docker multi-stage (JRE Alpine, imagen compacta) |

## Estructura del Proyecto

```
ms-produccion/
├── Dockerfile
├── pom.xml
├── src/main/java/pe/restaurant/produccion/
│   ├── ProduccionApplication.java
│   ├── config/
│   │   ├── ProduccionJwtAuthenticationFilter.java
│   │   └── ProduccionSecurityConfig.java
│   ├── controller/
│   │   ├── ControlCalidadController.java
│   │   ├── CosteoProduccionController.java
│   │   ├── DocTecnicaController.java
│   │   ├── LaborController.java
│   │   ├── OperacionController.java
│   │   ├── OrdenTrabajoController.java
│   │   ├── OtAdministracionController.java
│   │   ├── OtTipoController.java
│   │   ├── ParteProduccionController.java
│   │   ├── ProgramacionProduccionController.java
│   │   └── RecetaController.java
│   ├── dto/
│   │   ├── request/ (16 clases)
│   │   ├── response/ (16 clases)
│   │   ├── PageData.java / PageMeta.java
│   │   ├── (legacy: LaborArticuloRequest, etc.)
│   ├── entity/
│   │   ├── ArticuloDocTecnica.java / ArticuloDocTecnicaCaractDet.java
│   │   ├── ControlCalidad.java / CosteoProduccion.java
│   │   ├── FichaTecnica.java
│   │   ├── Labor.java / LaborInsumo.java / LaborProduccion.java
│   │   ├── Operacion.java / OperacionesDet.java
│   │   ├── OrdenTrabajo.java
│   │   ├── OtAdminUder.java / OtAdministracion.java / OtTipo.java
│   │   ├── ParteProduccion.java / ParteProduccionInsumo.java / ParteProduccionProducido.java
│   │   ├── ProgramacionProduccion.java
│   │   ├── Receta.java / RecetaLabor.java / RecetaLaborConsumible.java
│   ├── mapper/ (14 interfaces MapStruct)
│   ├── repository/ (14 interfaces JPA)
│   ├── service/
│   │   ├── impl/ (8 implementaciones)
│   │   ├── (8 interfaces)
│   │   └── TokensSessionVerifier.java
│   ├── client/ (5 OpenFeign clients: CoreArticulo, CoreSucursal, AlmacenValeMov, CoreUnidadMedida, AuthUsuario)
├── src/main/resources/
│   ├── application.yml
│   └── db/migration/.gitkeep
└── src/test/java/pe/restaurant/produccion/
    ├── controller/ (3 test classes)
    ├── mapper/ (6 test classes)
    └── service/impl/ (3 test classes)
```

## Capas Arquitectónicas

### 1. Configuración y Seguridad

- `ProduccionSecurityConfig`: Cadena de filtros Spring Security. CORS habilitado, CSRF deshabilitado, sesiones STATELESS.
- `ProduccionJwtAuthenticationFilter`: Hereda de `JwtTenantAuthFilter` (common). Solo aplica a rutas `/api/produccion/**`.
- Whitelist público: `/actuator/**`, `/swagger-ui/**`, `/v3/api-docs/**`.
- Multi-tenancy: datasource separado (`app.security-datasource`) apunta a `restaurant_pe_security` para validar JWT y sesiones.

### 2. Controladores REST

Todos devuelven `ApiResponse<T>` (wrapper estandar del módulo common).

| Controlador | Base Path | Endpoints |
|---|---|---|
| `OtTipoController` | `/api/produccion/ot-tipos` | CRUD + activar/desactivar (7 endpoints) |
| `OtAdministracionController` | `/api/produccion/ot-administraciones` | CRUD + activar/desactivar + sub-recurso `/usuarios` (10 endpoints) |
| `LaborController` | `/api/produccion/labores` | CRUD + activar/desactivar + sub-recursos `/insumos` y `/producidos` (13 endpoints) |
| `RecetaController` | `/api/produccion/recetas` | CRUD + activar/desactivar + nueva-versión (8 endpoints) |
| `DocTecnicaController` | `/api/produccion/documentos-tecnicos` | CRUD + activar/desactivar + sub-recurso `/caracteristicas` (8 endpoints) |
| `OrdenTrabajoController` | `/api/produccion/ordenes-trabajo` | CRUD + activar/desactivar + cerrar/anular (9 endpoints) |
| `OperacionController` | `/api/produccion/operaciones` | CRUD + activar/desactivar + sub-recurso `/detalles` (9 endpoints) |
| `ProgramacionProduccionController` | `/api/produccion/programacion-produccion` | CRUD + activar/desactivar (7 endpoints) |
| `ParteProduccionController` | `/api/produccion/partes-produccion` | CRUD + activar/desactivar + sub-recursos `/insumos`, `/producidos` (9 endpoints) |
| `ControlCalidadController` | `/api/produccion/controles-calidad` | CRUD + filtros (5 endpoints, sin activar/desactivar) |
| `CosteoProduccionController` | `/api/produccion/costeos` | Batch: procesar + listar + por-periodo (4 endpoints) |

### 3. Servicios

Patrón interface + implementación con `@Timed` (Micrometer) en todos los métodos. Nivel clase `@Transactional(readOnly = true)`, métodos de escritura con `@Transactional`.

- **OtTipoService**: CRUD tipo de OT.
- **OtAdministracionService**: CRUD áreas administrativas + asignación/desasignación de usuarios.
- **LaborService**: CRUD labores + asignación/desasignación de insumos y producidos.
- **RecetaService**: CRUD recetas + labores + consumibles + ficha técnica + versionamiento.
- **ArticuloDocTecnicaService**: CRUD documentos técnicos + características.
- **OrdenTrabajoService**: CRUD con generación de código OT-YYYY-NNNN + cerrar/anular + validación FK cross-schema vía Feign.
- **OperacionService**: CRUD operaciones + sync de detalle con reemplazo total.
- **ProgramacionProduccionService**: CRUD programaciones con validación de fechas.
- **ParteProduccionService**: CRUD partes con dos sub-recursos (insumos + producidos).
- **ControlCalidadService**: CRUD control de calidad (sin flagEstado) + filtros avanzados.
- **CosteoProduccionService**: Proceso batch de costeo: `procesar()`, `findByPeriodo()` — CRUD removido.
- **TokensSessionVerifier**: Consulta `auth.tokens_session` vía JDBC directo (residual, reemplazado parcialmente por Feign).

### 4. Repositorios

6 interfaces JPA con soporte `JpaSpecificationExecutor` para filtros dinámicos (en OtTipo, OtAdministracion, Labor).

### 5. Mappers (MapStruct)

6 interfaces con `componentModel = "spring"` para convertir Request ↔ Entity ↔ Response.

## Diagrama de Arquitectura

```
                     ┌─────────────────────────────────────┐
                     │         ms-produccion (:9009)         │
                     │                                       │
  ┌──────────┐       │  ┌──────────┐  ┌──────────┐          │
  │ Cliente  │──────▶│  │Controller│─▶│ Service  │─▶ JPA    │
  │ HTTP/REST│       │  │  (REST)  │  │ (lógica) │   Repo   │
  └──────────┘       │  └──────────┘  └────┬─────┘          │
                     │                     │                 │
                      │              ┌──────────────────┐      │
                      │              │ OpenFeign clients │      │
                      │              │ (auth/core/almacen)│     │
                      │              └──────────────────┘      │
                     │                                       │
                     │  ┌─────────────────────────────────┐  │
                     │  │     Modulo Common (common)       │  │
                     │  │  AuditOnlyMappedEntity           │  │
                     │  │  JwtTenantAuthFilter            │  │
                     │  │  ApiResponse<T>                  │  │
                     │  │  BusinessException               │  │
                     │  │  TokensSessionChecker            │  │
                     │  └─────────────────────────────────┘  │
                     │                                       │
                     │  ┌─────────────────────────────────┐  │
                     │  │     Seguridad (JDBC separado)    │  │
                     │  │  restaurant_pe_security (SSL)    │  │
                     │  │  → validación usuario/sesión     │  │
                     │  └─────────────────────────────────┘  │
                     │                                       │
                      │  RabbitMQ │ OpenFeign │ Micrometer    │
                      │  (prep)   │ (activo)  │ @Timed        │
                     └─────────────────────────────────────┘
                                  │
                                  ▼
                     ┌─────────────────────┐
                     │  PostgreSQL          │
                     │  Esquema: produccion │
                     │  + Esquema tenant    │
                     └─────────────────────┘
```

## Decisiones Arquitectónicas Clave

1. **Multi-tenancy por schema**: Cada tenant tiene su propio esquema `produccion` en la misma BD. La autenticación JWT resuelve el tenant.

2. **Sin Flyway activo**: Las migraciones de BD se gestionan externamente. `spring.flyway.enabled=false`.

3. **Sin auto-DDL**: `spring.jpa.hibernate.ddl-auto=none`. Los schemas se crean manualmente o con scripts externos.

4. **Datasource de seguridad separado**: La validación de usuarios/sesiones JWT usa un pool conectado a `restaurant_pe_security` con SSL, independiente del datasource de negocio.

5. **OpenFeign activo**: clients para sucursal, artículo, UM, vales, etc. Validaciones críticas de OT también usan SQL nativo (almacén/compras al anular).
6. **RabbitMQ productor**: `ProduccionEventPublisher` publica en `rpe.events` tras commit (configurable con `app.messaging.enabled`).

7. **Discrepancia created_by/updated_by**: En el DDL son `BIGINT` (FK a `auth.usuario`), pero en `AuditOnlyMappedEntity` del módulo common se modelan como `String`. Habrá que resolver esto al implementar nuevas entidades.

8. **Cobertura JaCoCo 80%**: Excluye config, entity, dto, repository, client, feign, TokensSessionVerifier y la clase main. El mínimo exigido es 80% de cobertura de instrucciones sobre el código restante (controllers, services, mappers).

## Swagger

- API Docs: `/api/produccion/v3/api-docs`
- Swagger UI: `/api/produccion/swagger-ui.html`

Ambos endpoints son públicos (sin autenticación).
