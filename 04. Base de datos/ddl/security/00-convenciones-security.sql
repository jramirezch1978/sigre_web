-- ============================================================
-- SIGRE ERP - Security DB - Convenciones base (idempotente)
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

-- Limpiar esquemas de tenant que no deben existir en la BD de security
DROP SCHEMA IF EXISTS core CASCADE;
DROP SCHEMA IF EXISTS almacen CASCADE;
DROP SCHEMA IF EXISTS compras CASCADE;
DROP SCHEMA IF EXISTS ventas CASCADE;
DROP SCHEMA IF EXISTS finanzas CASCADE;
DROP SCHEMA IF EXISTS contabilidad CASCADE;
DROP SCHEMA IF EXISTS rrhh CASCADE;
DROP SCHEMA IF EXISTS activos CASCADE;
DROP SCHEMA IF EXISTS produccion CASCADE;
DROP SCHEMA IF EXISTS auditoria CASCADE;

CREATE SCHEMA IF NOT EXISTS master;
CREATE SCHEMA IF NOT EXISTS config;
CREATE SCHEMA IF NOT EXISTS auth;

DO $$
BEGIN
    RAISE NOTICE '[DDL] Convenciones Security cargadas correctamente.';
END $$;

