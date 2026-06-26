-- ============================================================
-- Restaurant.pe ERP - Security DB - config schema
-- Estrategia: DROP + CREATE (reconstrucción completa)
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

CREATE SCHEMA IF NOT EXISTS config;

-- ============================================================
-- SECCIÓN 1: DROP (eliminar tablas en orden correcto por FK)
-- ============================================================
--
-- DIAGRAMA DE RELACIONES (→ = tiene FK hacia):
--
--   configuracion (sin dependencias)
--   configuracion_usuario (sin dependencias)
--   config_traduccion (sin dependencias)
--
-- ORDEN DE DROP (sin dependencias entre ellas, orden libre):
--   1. config_traduccion
--   2. configuracion_usuario
--   3. configuracion
-- ============================================================

DROP TABLE IF EXISTS config.config_traduccion CASCADE;
DROP TABLE IF EXISTS config.configuracion_usuario CASCADE;
DROP TABLE IF EXISTS config.configuracion CASCADE;

-- ============================================================
-- SECCIÓN 2: CREATE (crear tablas, constraints e índices)
-- ============================================================

CREATE TABLE config.configuracion (
    id BIGSERIAL PRIMARY KEY,
    modulo VARCHAR(60) NOT NULL,
    parametro VARCHAR(120) NOT NULL,
    tipo_dato VARCHAR(20) NOT NULL,
    valor_texto TEXT,
    valor_entero INTEGER,
    valor_decimal NUMERIC(18, 6),
    valor_fecha DATE,
    valor_bool BOOLEAN,
    editable BOOLEAN NOT NULL DEFAULT TRUE,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    modificado_en TIMESTAMPTZ,
    UNIQUE (modulo, parametro)
);

CREATE TABLE config.config_traduccion (
    id BIGSERIAL PRIMARY KEY,
    idioma VARCHAR(10) NOT NULL,
    clave VARCHAR(180) NOT NULL,
    texto TEXT NOT NULL,
    modulo VARCHAR(60),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    modificado_en TIMESTAMPTZ,
    UNIQUE (idioma, clave)
);

-- Parámetros de configuración por usuario (preferencias / overrides de ámbito USUARIO)
CREATE TABLE config.configuracion_usuario (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT NOT NULL,
    modulo VARCHAR(60),
    parametro VARCHAR(120) NOT NULL,
    tipo_dato VARCHAR(20) NOT NULL,
    valor_texto TEXT,
    valor_entero INTEGER,
    valor_decimal NUMERIC(18, 6),
    valor_fecha DATE,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by BIGINT,
    fec_creacion TIMESTAMPTZ DEFAULT NOW(),
    updated_by BIGINT,
    fec_modificacion TIMESTAMPTZ
);

-- ============================================================
-- SECCIÓN 3: ÍNDICES
-- ============================================================

CREATE INDEX IX_CONFIGURACION_01 ON config.configuracion (modulo, activo);
CREATE INDEX IX_CONFIGURACION_USUARIO_01 ON config.configuracion_usuario (usuario_id, modulo, parametro);
CREATE INDEX IX_CONFIG_TRADUCCION_01 ON config.config_traduccion (idioma, modulo);
