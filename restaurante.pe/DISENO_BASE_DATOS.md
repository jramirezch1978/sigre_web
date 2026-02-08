# Diseño de Base de Datos — Restaurant.pe

> Documento complementario a `ARQUITECTURA_RESTAURANT_PE.md`. Contiene la definición detallada de tablas, columnas, índices, migraciones, funciones SQL y diagramas ER por microservicio.

---

## Tabla de contenido

1. [Estrategia Database-per-Tenant](#1-estrategia-database-per-tenant)
2. [Bases de datos y esquemas](#2-bases-de-datos-y-esquemas)
3. [Definición SQL — BD Master](#3-definición-sql--bd-master)
4. [Tablas de seguridad detalladas](#4-tablas-de-seguridad-detalladas)
5. [Convenciones de la base de datos](#5-convenciones-de-la-base-de-datos)
6. [Estrategia de índices](#6-estrategia-de-índices)
7. [Migraciones Flyway (Multi-Tenant)](#7-migraciones-flyway-multi-tenant)
8. [Numeración atómica](#8-numeración-atómica)
9. [Alta de nueva empresa](#9-alta-de-nueva-empresa)
10. [Reportes cruzados entre empresas](#10-reportes-cruzados-entre-empresas)
11. [Diagramas ER detallados por microservicio](#11-diagramas-er-detallados-por-microservicio)
12. [Modelo de datos completo — Conteo de tablas](#12-modelo-de-datos-completo--conteo-de-tablas)

---

## 1. Estrategia Database-per-Tenant

El sistema utiliza el patrón **Database-per-Tenant** de PostgreSQL, aprovechando la función nativa `CREATE DATABASE ... TEMPLATE`. Cada empresa (tenant) tiene su **propia base de datos**, lo que garantiza aislamiento total de datos.

### Diagrama de bases de datos

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

### Reglas clave

- Las tablas de negocio (secciones 11.2 a 11.10) residen en la **BD por Empresa** (`restaurant_pe_emp_{id}`). Como cada BD es de una sola empresa, estas tablas **NO tienen columna `empresa_id`**.
- Las tablas de seguridad (sección 11.1) residen en la **BD Master** (`restaurant_pe_master`), donde sí existe la referencia a empresa a través de `usuario_empresa.empresa_id`.
- Los microservicios de negocio obtienen las connection strings de sus tenants llamando a `ms-auth-security` (`GET /internal/tenants/active`).
- Cada microservicio crea un **pool HikariCP por cada tenant** y los registra en `TenantRoutingDataSource`.
- Cuando se crea una nueva empresa, `ms-auth-security` publica un evento `tenant.created` vía RabbitMQ, y los demás microservicios agregan el pool dinámicamente (sin reinicio).

---

## 2. Bases de datos y esquemas

| Base de datos | Propósito | Esquemas | Quién conecta |
|---------------|-----------|----------|---------------|
| `restaurant_pe_master` | BD administrativa central | `auth`, `master` | Solo **ms-auth-security** |
| `restaurant_pe_template` | Modelo/plantilla (nunca se usa en producción) | `core`, `almacen`, `compras`, `ventas`, `finanzas`, `contabilidad`, `rrhh`, `activos`, `produccion`, `auditoria` | Solo Flyway (migraciones) |
| `restaurant_pe_emp_{id}` | BD de cada empresa (clon del template) | Mismos 10 esquemas del template | **Todos los ms de negocio** (excepto auth) |

### Esquemas por BD

**BD Master** (`restaurant_pe_master`):

| Esquema | Microservicio | Tablas principales |
|---------|---------------|-------------------|
| `auth` | ms-auth-security | usuario, usuario_empresa, rol, permiso, opcion_menu, sesion, log_acceso |
| `master` | ms-auth-security | tenant (registro de empresas con connection strings) |

**BD por Empresa** (`restaurant_pe_emp_{id}`) — cada empresa tiene estos 10 esquemas:

| Esquema | Microservicio | Tablas principales |
|---------|---------------|-------------------|
| `core` | ms-core-maestros | empresa, sucursal, pais, moneda, articulo, categoria, relacion_comercial, config_*, secuencia_documento |
| `almacen` | ms-almacen | almacen, movimiento_almacen, kardex, stock, inventario_fisico, reserva_stock |
| `compras` | ms-compras | solicitud_compra, cotizacion, orden_compra, orden_servicio, recepcion, secuencia_documento |
| `ventas` | ms-ventas | documento_venta, mesa, zona, orden_venta, comanda, cierre_caja, secuencia_documento |
| `finanzas` | ms-finanzas | cuenta_bancaria, documento_pagar, documento_cobrar, pago, cobro, conciliacion |
| `contabilidad` | ms-contabilidad | cuenta_contable, centro_costo, asiento, pre_asiento, matriz_contable, cierre_contable |
| `rrhh` | ms-rrhh | trabajador, contrato, planilla, asistencia, vacacion, liquidacion |
| `activos` | ms-activos-fijos | activo_fijo, clase_activo, depreciacion, mejora, revaluacion, traslado, mantenimiento |
| `produccion` | ms-produccion | receta, orden_produccion, costeo, control_calidad, programacion |
| `auditoria` | ms-auditoria | log_auditoria |

---

## 3. Definición SQL — BD Master

### 3.1 Esquema `master` — Registro de tenants

```sql
CREATE TABLE master.tenant (
    id              BIGSERIAL PRIMARY KEY,
    codigo          VARCHAR(20) NOT NULL UNIQUE,
    nombre          VARCHAR(200) NOT NULL,
    db_name         VARCHAR(100) NOT NULL UNIQUE,
    db_host         VARCHAR(200) NOT NULL DEFAULT 'localhost',
    db_port         INT NOT NULL DEFAULT 5432,
    db_username     VARCHAR(100) NOT NULL DEFAULT 'rpe_admin',
    db_password     VARCHAR(200) NOT NULL,  -- encriptado con AES
    activo          BOOLEAN NOT NULL DEFAULT true,
    fecha_creacion  TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    creado_por      VARCHAR(100),
    CONSTRAINT uk_tenant_db UNIQUE (db_host, db_port, db_name)
);
```

### 3.2 Esquema `auth` — Seguridad centralizada

El esquema `auth` reside en la BD master porque **usuarios, roles y permisos son transversales a todas las empresas**. Un usuario puede tener acceso a más de una empresa.

```sql
-- Relación usuario ↔ empresa
CREATE TABLE auth.usuario_empresa (
    id              BIGSERIAL PRIMARY KEY,
    usuario_id      BIGINT NOT NULL REFERENCES auth.usuario(id),
    empresa_id      BIGINT NOT NULL REFERENCES master.tenant(id),
    rol_id          BIGINT NOT NULL REFERENCES auth.rol(id),
    sucursal_default_id BIGINT,
    activo          BOOLEAN NOT NULL DEFAULT true,
    UNIQUE(usuario_id, empresa_id)
);
```

### 3.3 ER de la BD Master

```mermaid
erDiagram
    %% Esquema master
    TENANT {
        bigint id PK
        varchar codigo UK
        varchar nombre
        varchar db_name UK
        varchar db_host
        int db_port
        varchar db_username
        varchar db_password "AES encrypted"
        boolean activo
        timestamp fecha_creacion
    }

    %% Esquema auth
    USUARIO {
        bigint id PK
        varchar username UK
        varchar password_hash
        varchar email
        varchar nombre
        boolean activo
    }

    USUARIO_EMPRESA {
        bigint id PK
        bigint usuario_id FK
        bigint empresa_id FK "→ tenant.id"
        bigint rol_id FK
        bigint sucursal_default_id
        boolean activo
    }

    ROL {
        bigint id PK
        varchar codigo
        varchar nombre
        varchar descripcion
        boolean activo
    }

    MODULO {
        bigint id PK
        varchar codigo
        varchar nombre
        varchar icono
        int orden
    }

    OPCION_MENU {
        bigint id PK
        bigint modulo_id FK
        bigint padre_id FK "self-ref"
        varchar codigo
        varchar nombre
        varchar ruta_frontend
        varchar icono
        int orden
        boolean activo
    }

    ACCION {
        bigint id PK
        varchar codigo
        varchar nombre
    }

    PERMISO {
        bigint id PK
        bigint opcion_menu_id FK
        bigint accion_id FK
    }

    ROL_OPCION_MENU {
        bigint rol_id FK
        bigint opcion_menu_id FK
    }

    ROL_PERMISO {
        bigint rol_id FK
        bigint permiso_id FK
    }

    USUARIO_OPCION_MENU {
        bigint usuario_id FK
        bigint opcion_menu_id FK
    }

    SESION {
        bigint id PK
        bigint usuario_id FK
        varchar token
        varchar ip
        timestamp fecha_inicio
        timestamp fecha_fin
        boolean activa
    }

    USUARIO ||--o{ USUARIO_EMPRESA : "tiene acceso a"
    TENANT ||--o{ USUARIO_EMPRESA : "tiene usuarios"
    ROL ||--o{ USUARIO_EMPRESA : "asignado como"
    ROL ||--o{ ROL_OPCION_MENU : "tiene opciones"
    OPCION_MENU ||--o{ ROL_OPCION_MENU : "asignada a roles"
    MODULO ||--o{ OPCION_MENU : "contiene"
    OPCION_MENU ||--o{ PERMISO : "tiene acciones"
    ACCION ||--o{ PERMISO : "define"
    ROL ||--o{ ROL_PERMISO : "tiene permisos"
    PERMISO ||--o{ ROL_PERMISO : "asignado a"
    USUARIO ||--o{ USUARIO_OPCION_MENU : "opciones individuales"
    USUARIO ||--o{ SESION : "sesiones"
```

---

## 4. Tablas de seguridad detalladas

> **Importante:** Todas las tablas de seguridad residen en `restaurant_pe_master.auth`, ya que son transversales a todas las empresas.

| Tabla | Columnas |
|-------|----------|
| `usuario` | id, username, password_hash, email, nombre, requiere_cambio_password, habilitado_2fa, secret_2fa, ultimo_acceso, intentos_fallidos, bloqueado, activo, created_at, updated_at |
| `usuario_empresa` | id, usuario_id, **empresa_id** (FK a master.tenant), **rol_id** (FK), sucursal_default_id, activo |
| `rol` | id, codigo, nombre, descripcion, es_admin, activo |
| `modulo` | id, codigo, nombre, icono, orden, activo |
| `opcion_menu` | id, modulo_id, padre_id, codigo, nombre, ruta_frontend, icono, orden, tipo (MENU/SUBMENU/ACCION), activo |
| `accion` | id, codigo, nombre (VER, CREAR, EDITAR, ELIMINAR, APROBAR, IMPRIMIR, EXPORTAR) |
| `permiso` | id, opcion_menu_id, accion_id |
| `rol_opcion_menu` | rol_id, opcion_menu_id (N:M) |
| `rol_opcion_accion` | rol_id, opcion_menu_id, accion_id |
| `rol_permiso` | rol_id, permiso_id |
| `usuario_opcion_menu` | usuario_id, empresa_id, opcion_menu_id (individual/extraordinario por empresa) |
| `usuario_permiso` | usuario_id, empresa_id, permiso_id |
| `usuario_sucursal` | usuario_id, empresa_id, sucursal_id (sucursales asignadas) |
| `sesion` | id, usuario_id, empresa_id, token, ip, fecha_inicio, fecha_fin, activa |
| `log_acceso` | id, usuario_id, empresa_id, accion, ip, fecha, detalle |

**Tabla de tenants** (esquema `master` en BD Master):

| Tabla | Columnas |
|-------|----------|
| `tenant` | id, codigo, nombre, db_name, db_host, db_port, db_username, db_password (AES), activo, fecha_creacion |

---

## 5. Convenciones de la base de datos

| Aspecto | Convención |
|---------|------------|
| **Tablas y columnas** | `snake_case`: `orden_compra`, `fecha_emision` |
| **Claves primarias** | `id BIGSERIAL PRIMARY KEY` (autoincremental) |
| **Claves foráneas** | `{tabla}_id`: `proveedor_id`, `almacen_id` |
| **Multiempresa** | **No se usa `empresa_id`** en tablas de negocio (cada BD es de una empresa) |
| **Multisucursal** | `sucursal_id` donde aplique (tablas operativas) |
| **Auditoría por registro** | `creado_por`, `creado_en`, `modificado_por`, `modificado_en` |
| **Soft delete** | `activo BOOLEAN DEFAULT true` (nunca DELETE físico) |
| **Índices** | Obligatorios en: FKs, campos de búsqueda frecuente, `sucursal_id` |
| **Timestamps** | `TIMESTAMP WITH TIME ZONE` para todos los campos de fecha-hora |
| **Migraciones** | Flyway: `V{version}__{descripcion}.sql` |
| **Enums** | Almacenados como `VARCHAR`, no como tipo ENUM de PostgreSQL (portabilidad) |

---

## 6. Estrategia de índices

> **Nota:** Como cada BD es de una sola empresa, **no se necesita `empresa_id`** en los índices de tablas de negocio.

```sql
-- Índices para búsquedas frecuentes (sin empresa_id)
CREATE INDEX idx_articulo_codigo ON articulo (codigo);
CREATE INDEX idx_articulo_categoria ON articulo (categoria_id);
CREATE INDEX idx_relacion_comercial_doc ON relacion_comercial (numero_documento);

-- Índice para multisucursal
CREATE INDEX idx_movimiento_sucursal ON movimiento_almacen (sucursal_id, fecha);
CREATE INDEX idx_documento_venta_sucursal ON documento_venta (sucursal_id, fecha_emision);

-- Índice para reportes por período
CREATE INDEX idx_movimiento_fecha ON movimiento_almacen (fecha);
CREATE INDEX idx_asiento_periodo ON asiento (periodo_anio, periodo_mes);

-- Índice parcial para registros activos (soft delete)
CREATE INDEX idx_articulo_activo ON articulo (id) WHERE activo = true;
CREATE INDEX idx_relacion_comercial_activo ON relacion_comercial (id) WHERE activo = true;
```

---

## 7. Migraciones Flyway (Multi-Tenant)

Las migraciones se escriben **una sola vez** pero se ejecutan contra **todas las bases de datos de tenant**:

```java
@Component
public class MultiTenantMigrationRunner implements CommandLineRunner {

    @Autowired
    private TenantFeignClient tenantClient;

    @Override
    public void run(String... args) {
        // 1. Migrar la plantilla primero (modelo)
        migrate("restaurant_pe_template");

        // 2. Migrar TODAS las bases de datos de empresas activas
        for (TenantConnectionInfo tenant : tenantClient.getActiveTenants()) {
            migrate(tenant.getJdbcUrl(), tenant.getUsername(), tenant.getPassword());
        }
    }

    private void migrate(String jdbcUrl, String user, String pass) {
        Flyway flyway = Flyway.configure()
            .dataSource(jdbcUrl, user, pass)
            .locations("classpath:db/migration")
            .load();
        flyway.migrate();
    }
}
```

Cada microservicio tiene su carpeta de migraciones:

```
ms-compras/
└── src/main/resources/
    └── db/migration/
        ├── V1__create_schema_compras.sql
        ├── V2__create_table_orden_compra.sql
        ├── V3__create_table_orden_servicio.sql
        ├── V4__create_table_aprobacion.sql
        ├── V5__create_table_recepcion.sql
        └── V6__add_index_orden_compra.sql
```

Cuando se despliega una nueva versión, el runner aplica las migraciones pendientes a **template + todas las empresas** automáticamente. Si una BD ya tiene esas versiones, Flyway las salta.

---

## 8. Numeración atómica

Como cada empresa tiene su propia BD, la tabla de secuencias **ya no necesita `empresa_id`**:

```sql
-- En cada BD de empresa (esquemas ventas, compras, etc.)
CREATE TABLE {schema}.secuencia_documento (
    id              BIGSERIAL PRIMARY KEY,
    sucursal_id     BIGINT NOT NULL,
    tipo_documento  VARCHAR(50) NOT NULL,
    serie           VARCHAR(10) NOT NULL,
    anio            INT NOT NULL,
    ultimo_numero   BIGINT NOT NULL DEFAULT 0,
    UNIQUE(sucursal_id, tipo_documento, serie, anio)
);

-- Función atómica para obtener el siguiente número (sin gaps)
CREATE OR REPLACE FUNCTION {schema}.siguiente_numero(
    p_sucursal_id BIGINT,
    p_tipo_doc    VARCHAR,
    p_serie       VARCHAR,
    p_anio        INT
) RETURNS BIGINT AS $$
DECLARE
    v_numero BIGINT;
BEGIN
    UPDATE {schema}.secuencia_documento
    SET ultimo_numero = ultimo_numero + 1
    WHERE sucursal_id = p_sucursal_id
      AND tipo_documento = p_tipo_doc
      AND serie = p_serie
      AND anio = p_anio
    RETURNING ultimo_numero INTO v_numero;

    IF v_numero IS NULL THEN
        INSERT INTO {schema}.secuencia_documento
            (sucursal_id, tipo_documento, serie, anio, ultimo_numero)
        VALUES (p_sucursal_id, p_tipo_doc, p_serie, p_anio, 1)
        RETURNING ultimo_numero INTO v_numero;
    END IF;

    RETURN v_numero;
END;
$$ LANGUAGE plpgsql;
```

> La función usa `UPDATE ... RETURNING` dentro de la misma transacción del documento. Si la transacción falla, el número se revierte automáticamente — **sin gaps**.

---

## 9. Alta de nueva empresa

```sql
-- 1. Clonar la plantilla (PostgreSQL nativo)
CREATE DATABASE restaurant_pe_emp_4 TEMPLATE restaurant_pe_template;

-- 2. Registrar en la BD master
INSERT INTO master.tenant (codigo, nombre, db_name, db_host, db_port, db_username, db_password, activo)
VALUES ('EMP4', 'Nueva Cadena SRL', 'restaurant_pe_emp_4', 'localhost', 5432, 'rpe_admin', 'encrypted_pass', true);

-- 3. Insertar datos iniciales (seed) en la nueva BD
-- Ejecutado por un endpoint administrativo de ms-auth-security:
--   • Datos de la empresa (razón social, RUC, logo)
--   • País, monedas, impuestos del país
--   • Sucursal principal
--   • Configuraciones default
--   • Plan contable base del país
--   • Secuencias de numeración iniciales
```

---

## 10. Reportes cruzados entre empresas

Para reportes corporativos que consoliden datos de múltiples empresas:

```java
// Endpoint especial que itera sobre las BDs de cada empresa
@GetMapping("/api/reportes/consolidado/ventas")
public ConsolidadoVentas ventasConsolidadas(
        @RequestParam List<Long> empresaIds) {
    List<ResumenVentas> resultados = new ArrayList<>();

    for (Long empresaId : empresaIds) {
        TenantContext.setEmpresaId(empresaId);
        ResumenVentas resumen = ventaService.resumenDelMes();
        resumen.setEmpresaId(empresaId);
        resultados.add(resumen);
    }

    return ConsolidadoVentas.consolidar(resultados);
}
```

A futuro, un **Data Warehouse** que consolide datos de todas las empresas para reportes analíticos avanzados.

---

## 11. Diagramas ER detallados por microservicio

> **NOTA IMPORTANTE (Database-per-Tenant):** Las entidades de las secciones 11.2 a 11.10 representan tablas que residen en la **BD por Empresa** (`restaurant_pe_emp_{id}`). Como cada BD es de una sola empresa, estas tablas **NO tienen columna `empresa_id`**. La sección 11.1 muestra las tablas de la **BD Master** (`restaurant_pe_master`), donde sí existe la referencia a empresa a través de `usuario_empresa.empresa_id`.

### 11.1 ms-auth-security — Esquemas `auth` + `master` (en BD Master)

```mermaid
erDiagram
    TENANT {
        bigint id PK
        varchar codigo UK
        varchar nombre
        varchar db_name UK
        varchar db_host
        int db_port
        varchar db_username
        varchar db_password "AES encrypted"
        boolean activo
        timestamp fecha_creacion
    }
    USUARIO {
        bigint id PK
        varchar username UK
        varchar email UK
        varchar password_hash
        varchar nombre_completo
        boolean requiere_cambio_password
        boolean habilitado_2fa
        varchar secret_2fa
        timestamp ultimo_acceso
        int intentos_fallidos
        boolean bloqueado
        boolean activo
        timestamp created_at
        timestamp updated_at
    }
    USUARIO_EMPRESA {
        bigint id PK
        bigint usuario_id FK
        bigint empresa_id FK "→ tenant.id"
        bigint rol_id FK
        bigint sucursal_default_id
        boolean activo
    }
    ROL {
        bigint id PK
        varchar codigo UK
        varchar nombre
        varchar descripcion
        boolean es_admin
        boolean activo
    }
    MODULO {
        bigint id PK
        varchar codigo UK
        varchar nombre
        varchar icono
        int orden
        boolean activo
    }
    OPCION_MENU {
        bigint id PK
        bigint modulo_id FK
        bigint padre_id FK
        varchar codigo UK
        varchar nombre
        varchar ruta_frontend
        varchar icono
        int orden
        varchar tipo "MENU|SUBMENU|ACCION"
        boolean activo
    }
    ACCION {
        bigint id PK
        varchar codigo UK
        varchar nombre "VER|CREAR|EDITAR|ELIMINAR|APROBAR|IMPRIMIR|EXPORTAR"
    }
    ROL_OPCION_MENU {
        bigint rol_id FK
        bigint opcion_menu_id FK
    }
    ROL_OPCION_ACCION {
        bigint rol_id FK
        bigint opcion_menu_id FK
        bigint accion_id FK
    }
    USUARIO_OPCION_MENU {
        bigint usuario_id FK
        bigint opcion_menu_id FK
        varchar tipo "ADICIONAL|RESTRINGIDA"
    }
    SESION {
        bigint id PK
        bigint usuario_id FK
        varchar token_jti UK
        varchar ip_address
        varchar user_agent
        varchar dispositivo
        timestamp inicio
        timestamp expiracion
        timestamp fin
        boolean activa
    }
    LOG_ACCESO {
        bigint id PK
        bigint usuario_id FK
        varchar accion "LOGIN|LOGOUT|LOGIN_FALLIDO|BLOQUEO"
        varchar ip_address
        varchar user_agent
        timestamp fecha
    }
    USUARIO ||--o{ USUARIO_EMPRESA : "accede a"
    TENANT ||--o{ USUARIO_EMPRESA : "tiene usuarios"
    USUARIO_EMPRESA }o--|| ROL : "tiene un rol por empresa"
    USUARIO ||--o{ SESION : "tiene"
    USUARIO ||--o{ LOG_ACCESO : "registra"
    USUARIO }o--o{ OPCION_MENU : "individual por empresa"
    ROL }o--o{ OPCION_MENU : "asigna"
    ROL }o--o{ ACCION : "permite"
    OPCION_MENU }o--|| MODULO : "pertenece"
    OPCION_MENU }o--o| OPCION_MENU : "hijo de"
```

### 11.2 ms-core-maestros — Esquema `core` (en BD por Empresa)

```mermaid
erDiagram
    EMPRESA {
        bigint id PK
        varchar ruc UK
        varchar razon_social
        varchar nombre_comercial
        varchar direccion_fiscal
        bigint pais_id FK
        varchar logo_url
        boolean activo
    }
    PAIS {
        bigint id PK
        varchar codigo UK
        varchar nombre
        varchar moneda_id FK
        varchar formato_fecha
        varchar zona_horaria
        boolean activo
    }
    SUCURSAL {
        bigint id PK
        bigint pais_id FK
        varchar codigo UK
        varchar nombre
        varchar direccion
        varchar telefono
        varchar ubigeo
        boolean activo
    }
    MONEDA {
        bigint id PK
        varchar codigo UK
        varchar nombre
        varchar simbolo
        int decimales
        boolean activo
    }
    TIPO_CAMBIO {
        bigint id PK
        bigint moneda_origen_id FK
        bigint moneda_destino_id FK
        date fecha
        decimal tc_compra
        decimal tc_venta
    }
    RELACION_COMERCIAL {
        bigint id PK
        varchar tipo_documento
        varchar numero_documento UK
        varchar razon_social
        varchar nombre_comercial
        varchar direccion
        varchar telefono
        varchar email
        boolean es_proveedor
        boolean es_cliente
        boolean es_empleado
        bigint condicion_pago_id FK
        boolean activo
    }
    CONTACTO {
        bigint id PK
        bigint relacion_comercial_id FK
        varchar nombre
        varchar cargo
        varchar telefono
        varchar email
        boolean principal
    }
    CUENTA_BANCARIA_RC {
        bigint id PK
        bigint relacion_comercial_id FK
        varchar banco
        varchar numero_cuenta
        varchar cci
        varchar tipo_cuenta
        bigint moneda_id FK
    }
    ARTICULO {
        bigint id PK
        varchar codigo UK
        varchar nombre
        varchar descripcion
        bigint categoria_id FK
        bigint unidad_medida_id FK
        bigint impuesto_id FK
        varchar tipo "PRODUCTO|SERVICIO|INSUMO|ACTIVO"
        decimal precio_venta
        decimal costo_promedio
        decimal stock_minimo
        decimal stock_maximo
        varchar codigo_barras
        varchar imagen_url
        boolean es_inventariable
        boolean activo
    }
    CATEGORIA {
        bigint id PK
        varchar codigo
        varchar nombre
        bigint padre_id FK
        int nivel
        boolean activo
    }
    UNIDAD_MEDIDA {
        bigint id PK
        varchar codigo UK
        varchar nombre
        varchar abreviatura
    }
    CONVERSION_UNIDAD {
        bigint id PK
        bigint unidad_origen_id FK
        bigint unidad_destino_id FK
        decimal factor_conversion
    }
    IMPUESTO {
        bigint id PK
        bigint pais_id FK
        varchar codigo
        varchar nombre
        decimal porcentaje
        varchar tipo "IGV|ISC|PERCEPCION"
        boolean activo
    }
    SECUENCIA_DOCUMENTO {
        bigint id PK
        bigint sucursal_id FK
        varchar tipo_documento
        varchar serie
        int anio
        bigint ultimo_numero
        varchar formato
    }
    CONDICION_PAGO {
        bigint id PK
        varchar codigo
        varchar nombre
        int dias
        boolean activo
    }
    FORMA_PAGO {
        bigint id PK
        varchar codigo
        varchar nombre
        varchar tipo "EFECTIVO|TARJETA|TRANSFERENCIA|DIGITAL"
        boolean activo
    }
    CONFIG_CLAVE {
        bigint id PK
        varchar clave UK
        varchar descripcion
        varchar tipo_dato
        varchar valor_default
        varchar modulo
    }
    CONFIG_EMPRESA {
        bigint id PK
        bigint config_clave_id FK
        varchar valor
    }
    CONFIG_PAIS {
        bigint id PK
        bigint config_clave_id FK
        bigint pais_id FK
        varchar valor
    }
    CONFIG_SUCURSAL {
        bigint id PK
        bigint config_clave_id FK
        bigint sucursal_id FK
        varchar valor
    }
    CONFIG_USUARIO {
        bigint id PK
        bigint config_clave_id FK
        bigint usuario_id FK
        varchar valor
    }
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

### 11.3 ms-almacen — Esquema `almacen` (en BD por Empresa)

```mermaid
erDiagram
    ALMACEN {
        bigint id PK
        bigint sucursal_id FK
        varchar codigo UK
        varchar nombre
        varchar direccion
        varchar tipo "PRINCIPAL|TRANSITO|DEVOLUCION|PRODUCCION"
        boolean activo
    }
    UBICACION_ALMACEN {
        bigint id PK
        bigint almacen_id FK
        varchar codigo
        varchar nombre
        varchar pasillo
        varchar estante
        varchar nivel
    }
    TIPO_MOVIMIENTO {
        bigint id PK
        varchar codigo UK
        varchar nombre
        varchar naturaleza "INGRESO|SALIDA"
        varchar tipo_sunat
        boolean afecta_costo
        boolean genera_pre_asiento
        boolean activo
    }
    MOVIMIENTO_ALMACEN {
        bigint id PK
        bigint almacen_id FK
        bigint tipo_movimiento_id FK
        varchar numero UK
        date fecha
        varchar referencia_tipo
        bigint referencia_id
        varchar observacion
        varchar estado "BORRADOR|CONFIRMADO|ANULADO"
        bigint usuario_id FK
        timestamp created_at
    }
    MOVIMIENTO_DETALLE {
        bigint id PK
        bigint movimiento_id FK
        bigint articulo_id FK
        decimal cantidad
        decimal costo_unitario
        decimal costo_total
        bigint ubicacion_id FK
        varchar lote
        date fecha_vencimiento
    }
    STOCK {
        bigint id PK
        bigint almacen_id FK
        bigint articulo_id FK
        decimal cantidad_disponible
        decimal cantidad_reservada
        decimal costo_promedio
        timestamp ultima_actualizacion
    }
    KARDEX {
        bigint id PK
        bigint almacen_id FK
        bigint articulo_id FK
        bigint movimiento_detalle_id FK
        date fecha
        varchar tipo "INGRESO|SALIDA"
        decimal cantidad
        decimal costo_unitario
        decimal costo_total
        decimal saldo_cantidad
        decimal saldo_costo_unitario
        decimal saldo_costo_total
    }
    INVENTARIO_FISICO {
        bigint id PK
        bigint almacen_id FK
        date fecha
        varchar estado "EN_PROCESO|COMPARADO|AJUSTADO|CERRADO"
        bigint usuario_id FK
    }
    INVENTARIO_FISICO_DETALLE {
        bigint id PK
        bigint inventario_fisico_id FK
        bigint articulo_id FK
        decimal cantidad_sistema
        decimal cantidad_fisica
        decimal diferencia
        varchar observacion
    }
    RESERVA_STOCK {
        bigint id PK
        bigint almacen_id FK
        bigint articulo_id FK
        decimal cantidad
        varchar origen_tipo
        bigint origen_id
        timestamp fecha_reserva
        timestamp fecha_expiracion
        varchar estado "ACTIVA|CONSUMIDA|EXPIRADA"
    }
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

### 11.4 ms-compras — Esquema `compras` (en BD por Empresa)

```mermaid
erDiagram
    SOLICITUD_COMPRA {
        bigint id PK
        bigint sucursal_id FK
        varchar numero UK
        date fecha
        bigint solicitante_id FK
        varchar prioridad "BAJA|MEDIA|ALTA|URGENTE"
        varchar estado "BORRADOR|ENVIADA|APROBADA|RECHAZADA|EN_OC"
        varchar justificacion
    }
    SOLICITUD_COMPRA_DETALLE {
        bigint id PK
        bigint solicitud_id FK
        bigint articulo_id FK
        decimal cantidad
        varchar especificaciones
    }
    COTIZACION {
        bigint id PK
        bigint solicitud_id FK
        bigint proveedor_id FK
        varchar numero UK
        date fecha
        date fecha_validez
        decimal subtotal
        decimal igv
        decimal total
        bigint moneda_id FK
        varchar estado "PENDIENTE|RECIBIDA|SELECCIONADA|DESCARTADA"
    }
    COTIZACION_DETALLE {
        bigint id PK
        bigint cotizacion_id FK
        bigint articulo_id FK
        decimal cantidad
        decimal precio_unitario
        decimal descuento
        int plazo_entrega_dias
    }
    ORDEN_COMPRA {
        bigint id PK
        bigint sucursal_id FK
        bigint proveedor_id FK
        varchar numero UK
        date fecha
        date fecha_entrega
        bigint moneda_id FK
        bigint condicion_pago_id FK
        decimal subtotal
        decimal igv
        decimal total
        decimal tc
        varchar estado "BORRADOR|PENDIENTE_APROBACION|APROBADA|RECHAZADA|PARCIAL|COMPLETADA|ANULADA"
        varchar observaciones
        bigint cotizacion_id FK
    }
    ORDEN_COMPRA_DETALLE {
        bigint id PK
        bigint orden_compra_id FK
        bigint articulo_id FK
        varchar descripcion
        decimal cantidad
        decimal precio_unitario
        decimal descuento_porcentaje
        decimal subtotal
        decimal cantidad_recibida
        decimal cantidad_pendiente
    }
    ORDEN_SERVICIO {
        bigint id PK
        bigint proveedor_id FK
        varchar numero UK
        date fecha
        varchar descripcion_servicio
        decimal total
        bigint moneda_id FK
        varchar estado "BORRADOR|APROBADA|EN_EJECUCION|COMPLETADA|ANULADA"
    }
    APROBACION {
        bigint id PK
        varchar tipo_documento
        bigint documento_id
        int nivel
        bigint aprobador_id FK
        varchar accion "APROBADO|RECHAZADO"
        varchar comentario
        timestamp fecha
    }
    RECEPCION {
        bigint id PK
        bigint orden_compra_id FK
        bigint almacen_id FK
        varchar numero UK
        date fecha
        varchar guia_remision
        varchar estado "BORRADOR|CONFIRMADA|ANULADA"
        varchar observaciones
    }
    RECEPCION_DETALLE {
        bigint id PK
        bigint recepcion_id FK
        bigint oc_detalle_id FK
        bigint articulo_id FK
        decimal cantidad_recibida
        decimal cantidad_rechazada
        varchar motivo_rechazo
    }
    CONTRATO_MARCO {
        bigint id PK
        bigint proveedor_id FK
        varchar numero UK
        date fecha_inicio
        date fecha_fin
        varchar condiciones
        varchar estado "VIGENTE|VENCIDO|CANCELADO"
    }
    EVALUACION_PROVEEDOR {
        bigint id PK
        bigint proveedor_id FK
        bigint periodo_id FK
        int calidad_puntaje
        int entrega_puntaje
        int precio_puntaje
        int servicio_puntaje
        decimal puntaje_total
        varchar clasificacion "A|B|C|D"
    }
    SOLICITUD_COMPRA ||--o{ SOLICITUD_COMPRA_DETALLE : contiene
    SOLICITUD_COMPRA ||--o{ COTIZACION : genera
    COTIZACION ||--o{ COTIZACION_DETALLE : contiene
    COTIZACION }o--o| ORDEN_COMPRA : "se convierte en"
    ORDEN_COMPRA ||--o{ ORDEN_COMPRA_DETALLE : contiene
    ORDEN_COMPRA ||--o{ RECEPCION : genera
    ORDEN_COMPRA ||--o{ APROBACION : requiere
    RECEPCION ||--o{ RECEPCION_DETALLE : contiene
```

### 11.5 ms-ventas — Esquema `ventas` (en BD por Empresa)

```mermaid
erDiagram
    ZONA {
        bigint id PK
        bigint sucursal_id FK
        varchar nombre
        int capacidad
        boolean activo
    }
    MESA {
        bigint id PK
        bigint zona_id FK
        varchar numero UK
        int capacidad
        varchar estado "LIBRE|OCUPADA|RESERVADA|MANTENIMIENTO"
        boolean activo
    }
    TURNO {
        bigint id PK
        bigint sucursal_id FK
        bigint cajero_id FK
        decimal fondo_inicial
        timestamp apertura
        timestamp cierre
        varchar estado "ABIERTO|CERRADO"
    }
    ORDEN_VENTA {
        bigint id PK
        bigint sucursal_id FK
        bigint mesa_id FK
        bigint mesero_id FK
        bigint turno_id FK
        varchar numero UK
        int comensales
        timestamp apertura
        timestamp cierre
        varchar estado "ABIERTA|CERRADA|ANULADA"
        varchar observaciones
    }
    COMANDA {
        bigint id PK
        bigint orden_id FK
        bigint articulo_id FK
        decimal cantidad
        decimal precio_unitario
        decimal descuento
        decimal subtotal
        varchar estado "PENDIENTE|EN_PREPARACION|SERVIDA|ANULADA"
        varchar observaciones
        timestamp hora_pedido
        timestamp hora_entrega
    }
    DOCUMENTO_VENTA {
        bigint id PK
        bigint sucursal_id FK
        bigint orden_id FK
        bigint cliente_id FK
        bigint turno_id FK
        varchar tipo "BOLETA|FACTURA|NOTA_VENTA"
        varchar serie
        varchar numero UK
        date fecha
        bigint moneda_id FK
        decimal tc
        decimal subtotal
        decimal igv
        decimal isc
        decimal descuento_total
        decimal propina
        decimal recargo_consumo
        decimal total
        varchar estado "EMITIDA|ANULADA|BAJA"
        bigint forma_pago_id FK
    }
    DOCUMENTO_VENTA_DETALLE {
        bigint id PK
        bigint documento_id FK
        bigint articulo_id FK
        varchar descripcion
        decimal cantidad
        decimal precio_unitario
        decimal descuento
        decimal igv
        decimal subtotal
        decimal total
    }
    NOTA_CREDITO_VENTA {
        bigint id PK
        bigint documento_original_id FK
        varchar serie
        varchar numero UK
        date fecha
        varchar motivo
        decimal total
        varchar estado "EMITIDA|ANULADA"
    }
    NOTA_DEBITO_VENTA {
        bigint id PK
        bigint documento_original_id FK
        varchar serie
        varchar numero UK
        date fecha
        varchar motivo
        decimal total
        varchar estado "EMITIDA|ANULADA"
    }
    PAGO_VENTA {
        bigint id PK
        bigint documento_id FK
        bigint forma_pago_id FK
        decimal monto
        varchar referencia
        varchar estado "COMPLETADO|ANULADO"
    }
    DESCUENTO_PROMOCION {
        bigint id PK
        varchar nombre
        varchar tipo "PORCENTAJE|MONTO_FIJO|2X1|COMBO"
        decimal valor
        date fecha_inicio
        date fecha_fin
        varchar dias_aplicacion
        time hora_inicio
        time hora_fin
        decimal monto_minimo
        boolean activo
    }
    FACTURACION_ELECTRONICA {
        bigint id PK
        bigint documento_venta_id FK
        varchar xml_enviado
        varchar xml_cdr
        varchar hash_cpe
        varchar ticket_ose
        varchar estado_sunat "PENDIENTE|ACEPTADO|RECHAZADO|OBSERVADO"
        timestamp fecha_envio
        timestamp fecha_respuesta
        varchar mensaje_respuesta
    }
    CIERRE_CAJA {
        bigint id PK
        bigint turno_id FK
        decimal ventas_efectivo
        decimal ventas_tarjeta
        decimal ventas_digital
        decimal ventas_total
        decimal propinas_total
        decimal fondo_inicial
        decimal fondo_final
        decimal diferencia
        varchar observaciones
        timestamp fecha_cierre
    }
    PROPINA {
        bigint id PK
        bigint documento_venta_id FK
        bigint trabajador_id FK
        decimal monto
        date fecha
    }
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

### 11.6 ms-finanzas — Esquema `finanzas` (en BD por Empresa)

```mermaid
erDiagram
    CUENTA_BANCARIA {
        bigint id PK
        varchar banco
        varchar numero_cuenta UK
        varchar cci
        varchar tipo "AHORRO|CORRIENTE"
        bigint moneda_id FK
        decimal saldo_contable
        boolean activo
    }
    DOCUMENTO_PAGAR {
        bigint id PK
        bigint proveedor_id FK
        varchar tipo "FACTURA|RECIBO|NC|ND"
        varchar serie_numero UK
        date fecha_emision
        date fecha_vencimiento
        bigint moneda_id FK
        decimal tc
        decimal subtotal
        decimal igv
        decimal retencion
        decimal detraccion
        decimal total
        decimal saldo
        varchar estado "PENDIENTE|PARCIAL|PAGADO|ANULADO"
        bigint oc_id FK
    }
    DOCUMENTO_COBRAR {
        bigint id PK
        bigint cliente_id FK
        varchar tipo "FACTURA|BOLETA|LETRA|NC|ND"
        varchar serie_numero UK
        date fecha_emision
        date fecha_vencimiento
        bigint moneda_id FK
        decimal total
        decimal saldo
        varchar estado "PENDIENTE|PARCIAL|COBRADO|ANULADO|PROTESTADA"
    }
    PAGO {
        bigint id PK
        bigint documento_pagar_id FK
        bigint cuenta_bancaria_id FK
        bigint forma_pago_id FK
        date fecha
        decimal monto
        varchar referencia
        varchar numero_operacion
        varchar estado "APLICADO|ANULADO"
    }
    COBRO {
        bigint id PK
        bigint documento_cobrar_id FK
        bigint cuenta_bancaria_id FK
        bigint forma_pago_id FK
        date fecha
        decimal monto
        varchar referencia
        varchar estado "APLICADO|ANULADO"
    }
    MOVIMIENTO_BANCARIO {
        bigint id PK
        bigint cuenta_bancaria_id FK
        date fecha
        varchar tipo "DEPOSITO|RETIRO|TRANSFERENCIA|COMISION|ITF"
        varchar referencia
        decimal monto
        decimal saldo_despues
        boolean conciliado
    }
    CONCILIACION_BANCARIA {
        bigint id PK
        bigint cuenta_bancaria_id FK
        int periodo_anio
        int periodo_mes
        decimal saldo_banco
        decimal saldo_libros
        decimal diferencia
        varchar estado "EN_PROCESO|CONCILIADO|CERRADO"
    }
    CONCILIACION_DETALLE {
        bigint id PK
        bigint conciliacion_id FK
        bigint movimiento_bancario_id FK
        boolean conciliado
        varchar observacion
    }
    ADELANTO {
        bigint id PK
        bigint solicitante_id FK
        bigint proveedor_id FK
        varchar numero UK
        date fecha
        decimal monto
        varchar motivo
        varchar estado "SOLICITADO|APROBADO|DESEMBOLSADO|LIQUIDADO|RECHAZADO"
    }
    PROGRAMACION_PAGO {
        bigint id PK
        date fecha_programada
        varchar estado "PROGRAMADO|EJECUTADO|CANCELADO"
    }
    PROGRAMACION_PAGO_DETALLE {
        bigint id PK
        bigint programacion_id FK
        bigint documento_pagar_id FK
        decimal monto_programado
    }
    FONDO_FIJO {
        bigint id PK
        bigint sucursal_id FK
        bigint responsable_id FK
        decimal monto_autorizado
        decimal monto_disponible
        varchar estado "ACTIVO|RENDICION|REPOSICION"
    }
    RENDICION_GASTO {
        bigint id PK
        bigint fondo_fijo_id FK
        date fecha
        decimal monto
        varchar concepto
        varchar comprobante
        varchar estado "PENDIENTE|APROBADO|RECHAZADO"
    }
    CUENTA_BANCARIA ||--o{ MOVIMIENTO_BANCARIO : tiene
    CUENTA_BANCARIA ||--o{ CONCILIACION_BANCARIA : genera
    CONCILIACION_BANCARIA ||--o{ CONCILIACION_DETALLE : contiene
    DOCUMENTO_PAGAR ||--o{ PAGO : recibe
    DOCUMENTO_COBRAR ||--o{ COBRO : recibe
    PROGRAMACION_PAGO ||--o{ PROGRAMACION_PAGO_DETALLE : contiene
    FONDO_FIJO ||--o{ RENDICION_GASTO : registra
```

### 11.7 ms-contabilidad — Esquema `contabilidad` (en BD por Empresa)

```mermaid
erDiagram
    CUENTA_CONTABLE {
        bigint id PK
        varchar codigo UK
        varchar nombre
        int nivel
        bigint padre_id FK
        varchar naturaleza "DEUDORA|ACREEDORA"
        varchar tipo "TITULO|MOVIMIENTO"
        boolean requiere_cc
        boolean requiere_documento
        boolean activo
    }
    CENTRO_COSTO {
        bigint id PK
        varchar codigo UK
        varchar nombre
        int nivel
        bigint padre_id FK
        varchar tipo "ADMINISTRATIVO|OPERATIVO|VENTAS|PRODUCCION"
        boolean activo
    }
    LIBRO_CONTABLE {
        bigint id PK
        varchar codigo UK
        varchar nombre
        varchar tipo "DIARIO|MAYOR|CAJA|COMPRAS|VENTAS|BANCOS"
    }
    ASIENTO {
        bigint id PK
        bigint libro_id FK
        varchar numero UK
        date fecha
        varchar glosa
        varchar tipo "MANUAL|AUTOMATICO|APERTURA|CIERRE|AJUSTE"
        varchar modulo_origen
        bigint documento_origen_id
        varchar estado "BORRADOR|CONFIRMADO|ANULADO"
        bigint moneda_id FK
        decimal tc
    }
    ASIENTO_DETALLE {
        bigint id PK
        bigint asiento_id FK
        bigint cuenta_contable_id FK
        bigint centro_costo_id FK
        varchar glosa_detalle
        decimal debe
        decimal haber
        decimal debe_me
        decimal haber_me
        varchar referencia
    }
    PRE_ASIENTO {
        bigint id PK
        varchar modulo_origen
        varchar tipo_operacion
        bigint documento_id
        varchar referencia
        date fecha
        jsonb data_contable
        varchar estado "PENDIENTE|PROCESADO|ERROR|IGNORADO"
        varchar error_mensaje
        bigint asiento_generado_id FK
        timestamp fecha_recepcion
        timestamp fecha_procesamiento
    }
    MATRIZ_CONTABLE {
        bigint id PK
        varchar modulo
        varchar tipo_operacion
        bigint cuenta_debe_id FK
        bigint cuenta_haber_id FK
        bigint centro_costo_id FK
        varchar descripcion
        boolean activo
    }
    CIERRE_CONTABLE {
        bigint id PK
        int anio
        int mes
        varchar tipo "MENSUAL|ANUAL"
        varchar estado "ABIERTO|CERRADO|REABIERTO"
        bigint usuario_id FK
        timestamp fecha_cierre
    }
    CUENTA_CONTABLE }o--o| CUENTA_CONTABLE : "padre"
    CENTRO_COSTO }o--o| CENTRO_COSTO : "padre"
    ASIENTO }o--|| LIBRO_CONTABLE : "registrado en"
    ASIENTO ||--o{ ASIENTO_DETALLE : contiene
    ASIENTO_DETALLE }o--|| CUENTA_CONTABLE : "debita/acredita"
    ASIENTO_DETALLE }o--o| CENTRO_COSTO : asigna
    PRE_ASIENTO }o--o| ASIENTO : "genera"
    MATRIZ_CONTABLE }o--|| CUENTA_CONTABLE : "cuenta debe"
```

### 11.8 ms-rrhh — Esquema `rrhh` (en BD por Empresa)

```mermaid
erDiagram
    TRABAJADOR {
        bigint id PK
        bigint relacion_comercial_id FK
        varchar codigo_trabajador UK
        varchar nombres
        varchar apellido_paterno
        varchar apellido_materno
        varchar tipo_documento
        varchar numero_documento UK
        date fecha_nacimiento
        varchar sexo
        varchar estado_civil
        varchar direccion
        varchar telefono
        varchar email
        varchar cuenta_bancaria_sueldo
        varchar cuenta_cts
        bigint afp_id FK
        varchar cuspp
        varchar regimen_laboral
        bigint area_id FK
        bigint cargo_id FK
        bigint sucursal_id FK
        date fecha_ingreso
        date fecha_cese
        varchar motivo_cese
        varchar estado "ACTIVO|VACACIONES|LICENCIA|CESADO"
        boolean activo
    }
    CONTRATO {
        bigint id PK
        bigint trabajador_id FK
        varchar tipo "INDEFINIDO|PLAZO_FIJO|PARCIAL|FORMATIVO"
        date fecha_inicio
        date fecha_fin
        decimal remuneracion
        boolean asignacion_familiar
        varchar estado "VIGENTE|VENCIDO|RENOVADO|RESUELTO"
    }
    AREA {
        bigint id PK
        varchar nombre
        bigint padre_id FK
        bigint responsable_id FK
    }
    CARGO {
        bigint id PK
        varchar nombre
        varchar nivel
        decimal sueldo_minimo
        decimal sueldo_maximo
    }
    AFP {
        bigint id PK
        varchar nombre
        decimal comision_porcentaje
        decimal prima_seguro
        decimal aporte_obligatorio
    }
    HORARIO {
        bigint id PK
        varchar nombre
        time hora_entrada
        time hora_salida
        int minutos_tolerancia
        boolean aplica_lunes
        boolean aplica_martes
        boolean aplica_miercoles
        boolean aplica_jueves
        boolean aplica_viernes
        boolean aplica_sabado
        boolean aplica_domingo
    }
    ASISTENCIA {
        bigint id PK
        bigint trabajador_id FK
        date fecha
        time hora_entrada
        time hora_salida
        varchar tipo_marca "BIOMETRICO|MANUAL|APP|GPS"
        decimal horas_trabajadas
        decimal horas_extra
        varchar estado "ASISTIO|FALTA|TARDANZA|PERMISO|VACACIONES|LICENCIA"
    }
    PERMISO_LICENCIA {
        bigint id PK
        bigint trabajador_id FK
        varchar tipo "PERMISO|LICENCIA_MEDICA|LICENCIA_PATERNIDAD|LICENCIA_SIN_GOCE"
        date fecha_inicio
        date fecha_fin
        int dias
        varchar estado "SOLICITADO|APROBADO|RECHAZADO"
        varchar sustento
    }
    CONCEPTO_PLANILLA {
        bigint id PK
        varchar codigo UK
        varchar nombre
        varchar tipo "INGRESO|DESCUENTO|APORTE_EMPLEADOR"
        varchar formula
        decimal valor_fijo
        boolean afecto_quinta
        boolean afecto_essalud
        boolean aplica_todos
    }
    PLANILLA {
        bigint id PK
        int anio
        int mes
        varchar tipo "MENSUAL|QUINCENAL|SEMANAL|GRATIFICACION|CTS|LIQUIDACION"
        varchar estado "BORRADOR|CALCULADA|APROBADA|PAGADA|CERRADA"
        decimal total_ingresos
        decimal total_descuentos
        decimal total_neto
        decimal total_aportes
    }
    PLANILLA_DETALLE {
        bigint id PK
        bigint planilla_id FK
        bigint trabajador_id FK
        bigint concepto_id FK
        decimal monto
        decimal dias_trabajados
        decimal horas_extra
    }
    VACACION {
        bigint id PK
        bigint trabajador_id FK
        int periodo_anio
        int dias_derecho
        int dias_gozados
        int dias_pendientes
        date fecha_inicio
        date fecha_fin
        varchar estado "PROGRAMADA|EN_GOCE|COMPLETADA"
    }
    LIQUIDACION {
        bigint id PK
        bigint trabajador_id FK
        date fecha_cese
        decimal cts_pendiente
        decimal vacaciones_truncas
        decimal gratificacion_trunca
        decimal indemnizacion
        decimal total_beneficios
        decimal total_descuentos
        decimal neto_pagar
        varchar estado "CALCULADA|APROBADA|PAGADA"
    }
    PRESTAMO {
        bigint id PK
        bigint trabajador_id FK
        decimal monto_total
        int cuotas
        decimal cuota_mensual
        decimal saldo
        varchar estado "ACTIVO|PAGADO"
    }
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

### 11.9 ms-activos-fijos — Esquema `activos` (en BD por Empresa)

```mermaid
erDiagram
    CLASE_ACTIVO {
        bigint id PK
        varchar codigo UK
        varchar nombre
        decimal vida_util_anios
        decimal tasa_depreciacion
        varchar metodo_depreciacion "LINEAL|DECRECIENTE|UNIDADES"
        bigint cuenta_activo_id FK
        bigint cuenta_depreciacion_id FK
        bigint cuenta_gasto_id FK
    }
    UBICACION_FISICA {
        bigint id PK
        bigint sucursal_id FK
        varchar codigo
        varchar nombre
        bigint padre_id FK
        int nivel
    }
    ACTIVO_FIJO {
        bigint id PK
        varchar codigo_activo UK
        varchar descripcion
        bigint clase_id FK
        bigint ubicacion_id FK
        bigint responsable_id FK
        date fecha_adquisicion
        date fecha_inicio_depreciacion
        bigint proveedor_id FK
        varchar factura_referencia
        bigint moneda_id FK
        decimal costo_adquisicion
        decimal valor_residual
        decimal depreciacion_acumulada
        decimal valor_neto
        varchar codigo_qr
        varchar estado "ACTIVO|BAJA|TRANSFERIDO|EN_MANTENIMIENTO"
        boolean activo
    }
    COMPONENTE_ACTIVO {
        bigint id PK
        bigint activo_fijo_id FK
        varchar descripcion
        decimal costo
        date fecha_instalacion
    }
    DEPRECIACION {
        bigint id PK
        bigint activo_fijo_id FK
        int anio
        int mes
        decimal monto_depreciacion
        decimal depreciacion_acumulada
        decimal valor_neto
        boolean procesado
    }
    MEJORA_ACTIVO {
        bigint id PK
        bigint activo_fijo_id FK
        date fecha
        varchar descripcion
        decimal costo
        decimal nueva_vida_util
    }
    REVALUACION {
        bigint id PK
        bigint activo_fijo_id FK
        date fecha
        decimal valor_anterior
        decimal valor_nuevo
        varchar sustento
        bigint perito_id FK
    }
    ASEGURADORA {
        bigint id PK
        varchar nombre
        varchar ruc
        varchar contacto
        boolean activo
    }
    POLIZA_SEGURO {
        bigint id PK
        bigint aseguradora_id FK
        varchar numero_poliza UK
        date fecha_inicio
        date fecha_fin
        decimal prima
        decimal cobertura
        varchar estado "VIGENTE|VENCIDA|CANCELADA"
    }
    POLIZA_ACTIVO {
        bigint id PK
        bigint poliza_id FK
        bigint activo_fijo_id FK
        decimal valor_asegurado
    }
    TRASLADO_ACTIVO {
        bigint id PK
        bigint activo_fijo_id FK
        bigint ubicacion_origen_id FK
        bigint ubicacion_destino_id FK
        bigint solicitante_id FK
        bigint aprobador_id FK
        date fecha_solicitud
        date fecha_ejecucion
        varchar motivo
        varchar estado "SOLICITADO|APROBADO|EJECUTADO|RECHAZADO"
    }
    MANTENIMIENTO_ACTIVO {
        bigint id PK
        bigint activo_fijo_id FK
        varchar tipo "PREVENTIVO|CORRECTIVO"
        date fecha_programada
        date fecha_ejecucion
        decimal costo
        varchar proveedor_servicio
        varchar estado "PROGRAMADO|EN_EJECUCION|COMPLETADO"
    }
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

### 11.10 ms-produccion — Esquema `produccion` (en BD por Empresa)

```mermaid
erDiagram
    RECETA {
        bigint id PK
        bigint articulo_producido_id FK
        varchar codigo UK
        varchar nombre
        int version
        decimal rendimiento_esperado
        decimal porcentaje_merma
        varchar tipo "PLATO|BEBIDA|POSTRE|PREPARACION_BASE"
        varchar estado "ACTIVA|INACTIVA|EN_REVISION"
        decimal costo_mano_obra
        decimal costo_indirecto
        decimal costo_total_estimado
    }
    RECETA_DETALLE {
        bigint id PK
        bigint receta_id FK
        bigint articulo_insumo_id FK
        decimal cantidad_bruta
        decimal cantidad_neta
        decimal porcentaje_merma
        bigint unidad_medida_id FK
        boolean es_opcional
        bigint alternativa_id FK
    }
    RECETA_SUBRECETA {
        bigint id PK
        bigint receta_padre_id FK
        bigint receta_hija_id FK
        decimal cantidad
    }
    ORDEN_PRODUCCION {
        bigint id PK
        bigint sucursal_id FK
        bigint receta_id FK
        varchar numero UK
        date fecha
        decimal cantidad_planificada
        decimal cantidad_producida
        decimal cantidad_merma
        varchar estado "PLANIFICADA|EN_PROCESO|COMPLETADA|CANCELADA"
        bigint responsable_id FK
        timestamp inicio_real
        timestamp fin_real
    }
    ORDEN_PRODUCCION_INSUMO {
        bigint id PK
        bigint orden_id FK
        bigint articulo_id FK
        decimal cantidad_requerida
        decimal cantidad_consumida
        decimal costo_unitario
        decimal costo_total
    }
    COSTEO_PRODUCCION {
        bigint id PK
        bigint orden_id FK
        decimal costo_materia_prima
        decimal costo_mano_obra
        decimal costo_indirecto
        decimal costo_total
        decimal costo_unitario
        decimal rendimiento_real
        decimal porcentaje_merma_real
    }
    CONTROL_CALIDAD {
        bigint id PK
        bigint orden_id FK
        bigint inspector_id FK
        date fecha
        varchar resultado "APROBADO|RECHAZADO|OBSERVADO"
        varchar observaciones
    }
    PROGRAMACION_PRODUCCION {
        bigint id PK
        bigint sucursal_id FK
        date fecha
        bigint receta_id FK
        decimal cantidad
        varchar turno "MANANA|TARDE|NOCHE"
        varchar estado "PROGRAMADO|EJECUTADO|CANCELADO"
    }
    RECETA ||--o{ RECETA_DETALLE : contiene
    RECETA ||--o{ RECETA_SUBRECETA : "incluye sub-recetas"
    RECETA ||--o{ ORDEN_PRODUCCION : ejecuta
    ORDEN_PRODUCCION ||--o{ ORDEN_PRODUCCION_INSUMO : consume
    ORDEN_PRODUCCION ||--o| COSTEO_PRODUCCION : genera
    ORDEN_PRODUCCION ||--o{ CONTROL_CALIDAD : verifica
    RECETA ||--o{ PROGRAMACION_PRODUCCION : programa
```

---

## 12. Modelo de datos completo — Conteo de tablas

| Esquema | Tablas | Descripción |
|---------|:------:|-------------|
| `auth` | 11 | Usuarios, roles, permisos, menú, sesiones |
| `core` | 25+ | Empresa, sucursal, país, moneda, artículos, categorías, impuestos, configuración |
| `almacen` | 7 | Movimientos, kardex, stock, inventario físico |
| `compras` | 7 | OC, OS, aprobaciones, recepción |
| `finanzas` | 12 | CxP, CxC, tesorería, conciliación, adelantos |
| `contabilidad` | 7 | Asientos, pre-asientos, matrices, cierres |
| `rrhh` | 11 | Trabajadores, planilla, asistencia, liquidaciones |
| `activos` | 7 | Activos, depreciación, seguros, traslados |
| `produccion` | 5 | Recetas, órdenes, costeo |
| `auditoria` | 2 | Log de auditoría, log de acceso |
| **Total** | **94+** | |

---

*Documento de diseño de base de datos para el proyecto Restaurant.pe. Complementa a `ARQUITECTURA_RESTAURANT_PE.md` con la definición detallada de tablas, índices, funciones SQL, migraciones y diagramas ER por microservicio. Estrategia: Database-per-Tenant con PostgreSQL.*
