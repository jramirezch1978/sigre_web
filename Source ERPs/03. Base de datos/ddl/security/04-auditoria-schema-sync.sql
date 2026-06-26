-- ============================================================
-- Restaurant.pe ERP - Security DB - auditoria.schema_sync_cron_log
-- Auditoría de cada ejecución del job de sincronización de esquema
-- (template → tenants), consumido por ms-worker. Ejecutar solo
-- contra la BD de security (restaurant_pe_security).
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

CREATE SCHEMA IF NOT EXISTS auditoria;

CREATE TABLE IF NOT EXISTS auditoria.schema_sync_cron_log (
    id                  BIGSERIAL       NOT NULL,
    execution_id        VARCHAR(36),
    status              VARCHAR(20)     NOT NULL,   --INICIO, PROCESANDO, TERMINADO, FALLIDO
    fase                VARCHAR(20),                --GENERAL, FASE_1, FASE_2, FASE_3
    dry_run             BOOLEAN         NOT NULL DEFAULT FALSE,
    tenant_db_name      VARCHAR(100),
    message_final       TEXT,
    is_failed           BOOLEAN         NOT NULL DEFAULT FALSE,
    is_changed          BOOLEAN         NOT NULL DEFAULT FALSE,
    nombre_empresa      VARCHAR(100),
    statements_execute  text,
    schema_object       VARCHAR(100),
    objects_summary     TEXT,
    object_type         VARCHAR(20),    --TABLA, CAMPO, INDICE, SECUENCIA, FK, etc.
    duration_ms         BIGINT          NOT NULL,
    error_detail        TEXT,
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_schema_sync_cron_log PRIMARY KEY (id)
);

ALTER TABLE auditoria.schema_sync_cron_log
    ADD COLUMN IF NOT EXISTS fase VARCHAR(20);

CREATE INDEX IF NOT EXISTS IX_SCHEMA_SYNC_CRON_LOG_01 ON auditoria.schema_sync_cron_log (created_at DESC);
CREATE INDEX IF NOT EXISTS IX_SCHEMA_SYNC_CRON_LOG_02 ON auditoria.schema_sync_cron_log (status);

DO $$
BEGIN
    RAISE NOTICE '[DDL] auditoria.schema_sync_cron_log listo.';
END $$;
