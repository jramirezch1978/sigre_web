-- ============================================================
-- Restaurant.pe ERP — Inicialización de esquemas
-- Se ejecuta automáticamente al crear el contenedor PostgreSQL
-- ============================================================

CREATE SCHEMA IF NOT EXISTS auth;
CREATE SCHEMA IF NOT EXISTS core;
CREATE SCHEMA IF NOT EXISTS almacen;
CREATE SCHEMA IF NOT EXISTS compras;
CREATE SCHEMA IF NOT EXISTS finanzas;
CREATE SCHEMA IF NOT EXISTS contabilidad;
CREATE SCHEMA IF NOT EXISTS rrhh;
CREATE SCHEMA IF NOT EXISTS activos;
CREATE SCHEMA IF NOT EXISTS produccion;
CREATE SCHEMA IF NOT EXISTS ventas;
CREATE SCHEMA IF NOT EXISTS auditoria;

-- Permisos para el usuario de la aplicación
GRANT ALL PRIVILEGES ON SCHEMA auth TO rpe_admin;
GRANT ALL PRIVILEGES ON SCHEMA core TO rpe_admin;
GRANT ALL PRIVILEGES ON SCHEMA almacen TO rpe_admin;
GRANT ALL PRIVILEGES ON SCHEMA compras TO rpe_admin;
GRANT ALL PRIVILEGES ON SCHEMA finanzas TO rpe_admin;
GRANT ALL PRIVILEGES ON SCHEMA contabilidad TO rpe_admin;
GRANT ALL PRIVILEGES ON SCHEMA rrhh TO rpe_admin;
GRANT ALL PRIVILEGES ON SCHEMA activos TO rpe_admin;
GRANT ALL PRIVILEGES ON SCHEMA produccion TO rpe_admin;
GRANT ALL PRIVILEGES ON SCHEMA ventas TO rpe_admin;
GRANT ALL PRIVILEGES ON SCHEMA auditoria TO rpe_admin;
