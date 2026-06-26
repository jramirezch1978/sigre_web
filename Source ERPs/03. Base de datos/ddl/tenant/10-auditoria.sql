-- ============================================================
-- Restaurant.pe ERP - Tenant DB - auditoria schema
-- DROP de esquemas centralizado en 01-core.sql
-- ============================================================
--
-- DIAGRAMA DE RELACIONES (→ = tiene FK hacia):
--
--   log_auditoria (sin dependencias)
--   log_cambio_campo → log_auditoria
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

CREATE SCHEMA IF NOT EXISTS auditoria;

-- ============================================================
-- CREATE (tablas, constraints e índices)
-- ============================================================

CREATE TABLE auditoria.log_auditoria (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT,
    modulo VARCHAR(60) NOT NULL,
    tabla VARCHAR(120) NOT NULL,
    registro_id VARCHAR(80),
    accion VARCHAR(20) NOT NULL,
    resumen VARCHAR(300),
    ip VARCHAR(64),
    user_agent TEXT,
    created_by BIGINT,
    fec_creacion TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_by BIGINT,
    fec_modificacion TIMESTAMPTZ
);

CREATE TABLE auditoria.log_cambio_campo (
    id BIGSERIAL PRIMARY KEY,
    log_auditoria_id BIGINT NOT NULL REFERENCES auditoria.log_auditoria(id),
    campo VARCHAR(120) NOT NULL,
    valor_anterior TEXT,
    valor_nuevo TEXT
);

-- ============================================================
-- SECCIÓN 3: ÍNDICES
-- ============================================================

CREATE INDEX IX_LOG_AUDITORIA_01 ON auditoria.log_auditoria (modulo, fec_creacion DESC);
CREATE INDEX IX_LOG_CAMBIO_CAMPO_01 ON auditoria.log_cambio_campo (log_auditoria_id);
