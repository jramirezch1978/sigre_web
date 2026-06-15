-- ============================================================
-- SIGRE ERP - Security DB - master schema
-- Estrategia: DROP + CREATE (reconstrucción completa)
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

CREATE SCHEMA IF NOT EXISTS master;

-- ============================================================
-- SECCIÓN 1: DROP (eliminar tablas en orden correcto por FK)
-- ============================================================
--
-- DIAGRAMA DE RELACIONES (→ = tiene FK hacia):
--
--   empresa (sin dependencias en master)
--
--   NOTA: auth.usuario_empresa → master.empresa (en 03-auth.sql)
--         Se elimina con CASCADE al hacer DROP de master.empresa.
--
-- ORDEN DE DROP:
--   1. empresa (CASCADE elimina FK de auth.usuario_empresa)
-- ============================================================

DROP TABLE IF EXISTS master.distrito CASCADE;
DROP TABLE IF EXISTS master.provincia CASCADE;
DROP TABLE IF EXISTS master.departamento CASCADE;
DROP TABLE IF EXISTS master.pais CASCADE;
DROP TABLE IF EXISTS master.empresa CASCADE;

-- ============================================================
-- SECCIÓN 2: CREATE (crear tablas, constraints e índices)
-- ============================================================

CREATE SEQUENCE IF NOT EXISTS master.seq_empresa_codigo
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    CACHE 1;

CREATE TABLE master.empresa (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    ruc VARCHAR(20) NOT NULL UNIQUE,
    razon_social VARCHAR(200) NOT NULL,
    nombre_comercial VARCHAR(200),
    direccion_fiscal VARCHAR(300),
    ubigeo VARCHAR(12),
    representante_legal VARCHAR(200),
    correo_contacto VARCHAR(150),
    telefono_contacto VARCHAR(30),
    db_host VARCHAR(120) NOT NULL CHECK (TRIM(db_host) <> ''),
    db_port INTEGER NOT NULL DEFAULT 5432,
    db_name VARCHAR(120) NOT NULL CHECK (TRIM(db_name) <> ''),
    db_user VARCHAR(120) NOT NULL CHECK (TRIM(db_user) <> ''),
    db_password_encrypted TEXT NOT NULL CHECK (TRIM(db_password_encrypted) <> ''),
    logo BYTEA,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_estado IN ('0', '1')),
    modificado_en TIMESTAMPTZ
);

CREATE TABLE master.pais (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(4) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE master.departamento (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    pais_id BIGINT NOT NULL REFERENCES master.pais(id),
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE master.provincia (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    departamento_id BIGINT NOT NULL REFERENCES master.departamento(id),
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE master.distrito (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    provincia_id BIGINT NOT NULL REFERENCES master.provincia(id),
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

-- ============================================================
-- SECCIÓN 3: ÍNDICES
-- ============================================================

CREATE INDEX IX_EMPRESA_01 ON master.empresa (flag_estado);
CREATE INDEX IX_EMPRESA_02 ON master.empresa (razon_social);
CREATE INDEX IX_MASTER_PAIS_01 ON master.pais (activo);
CREATE INDEX IX_MASTER_DEP_01 ON master.departamento (pais_id);
CREATE INDEX IX_MASTER_PROV_01 ON master.provincia (departamento_id);
CREATE INDEX IX_MASTER_DIST_01 ON master.distrito (provincia_id);
