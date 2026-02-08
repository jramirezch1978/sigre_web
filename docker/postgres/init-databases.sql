-- ============================================================
-- Restaurant.pe ERP — Inicialización Database-per-Tenant
-- Se ejecuta automáticamente al crear el contenedor PostgreSQL
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

-- Tabla de registro de tenants (empresas)
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
    creado_por      VARCHAR(100),
    CONSTRAINT uk_tenant_db UNIQUE (db_host, db_port, db_name)
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
