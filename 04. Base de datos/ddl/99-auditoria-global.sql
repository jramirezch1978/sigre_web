-- ============================================================
-- SIGRE ERP - Campos globales de auditoría (columnas + FK)
-- ============================================================
-- Asegura que todas las tablas tengan created_by, updated_by,
-- fec_creacion, fec_modificacion con FK a auth.usuario.
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

DO $$
DECLARE
    rec RECORD;
    fk_created_name TEXT;
    fk_updated_name TEXT;
BEGIN
    FOR rec IN
        SELECT schemaname, tablename
        FROM pg_tables
        WHERE schemaname IN (
            'master', 'config', 'auth', 'core', 'almacen', 'compras', 'ventas',
            'finanzas', 'contabilidad', 'rrhh', 'activos', 'produccion', 'auditoria'
        )
          AND tablename <> 'flyway_schema_history'
        ORDER BY schemaname, tablename
    LOOP
        -- Migrar columnas legacy a nombres estándar si existen
        IF EXISTS (
            SELECT 1 FROM information_schema.columns
            WHERE table_schema = rec.schemaname AND table_name = rec.tablename AND column_name = 'create_by'
        ) AND NOT EXISTS (
            SELECT 1 FROM information_schema.columns
            WHERE table_schema = rec.schemaname AND table_name = rec.tablename AND column_name = 'created_by'
        ) THEN
            EXECUTE format('ALTER TABLE %I.%I RENAME COLUMN create_by TO created_by', rec.schemaname, rec.tablename);
        ELSIF EXISTS (
            SELECT 1 FROM information_schema.columns
            WHERE table_schema = rec.schemaname AND table_name = rec.tablename AND column_name = 'create_by'
        ) THEN
            EXECUTE format('ALTER TABLE %I.%I DROP COLUMN IF EXISTS create_by', rec.schemaname, rec.tablename);
        END IF;

        IF EXISTS (
            SELECT 1 FROM information_schema.columns
            WHERE table_schema = rec.schemaname AND table_name = rec.tablename AND column_name = 'modified_by'
        ) AND NOT EXISTS (
            SELECT 1 FROM information_schema.columns
            WHERE table_schema = rec.schemaname AND table_name = rec.tablename AND column_name = 'updated_by'
        ) THEN
            EXECUTE format('ALTER TABLE %I.%I RENAME COLUMN modified_by TO updated_by', rec.schemaname, rec.tablename);
        ELSIF EXISTS (
            SELECT 1 FROM information_schema.columns
            WHERE table_schema = rec.schemaname AND table_name = rec.tablename AND column_name = 'modified_by'
        ) THEN
            EXECUTE format('ALTER TABLE %I.%I DROP COLUMN IF EXISTS modified_by', rec.schemaname, rec.tablename);
        END IF;

        -- Asegurar columnas estándar
        EXECUTE format('ALTER TABLE %I.%I ADD COLUMN IF NOT EXISTS created_by BIGINT', rec.schemaname, rec.tablename);
        EXECUTE format('ALTER TABLE %I.%I ADD COLUMN IF NOT EXISTS fec_creacion TIMESTAMPTZ DEFAULT NOW()', rec.schemaname, rec.tablename);
        EXECUTE format('ALTER TABLE %I.%I ADD COLUMN IF NOT EXISTS updated_by BIGINT', rec.schemaname, rec.tablename);
        EXECUTE format('ALTER TABLE %I.%I ADD COLUMN IF NOT EXISTS fec_modificacion TIMESTAMPTZ', rec.schemaname, rec.tablename);

        -- FK a auth.usuario
        fk_created_name := substr(
            format('fk_%s_%s_cb_%s', rec.schemaname, rec.tablename, md5(rec.schemaname || '.' || rec.tablename || '.created_by')),
            1, 63
        );
        fk_updated_name := substr(
            format('fk_%s_%s_ub_%s', rec.schemaname, rec.tablename, md5(rec.schemaname || '.' || rec.tablename || '.updated_by')),
            1, 63
        );

        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = fk_created_name) THEN
            EXECUTE format(
                'ALTER TABLE %I.%I ADD CONSTRAINT %I FOREIGN KEY (created_by) REFERENCES auth.usuario(id)',
                rec.schemaname, rec.tablename, fk_created_name
            );
        END IF;

        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = fk_updated_name) THEN
            EXECUTE format(
                'ALTER TABLE %I.%I ADD CONSTRAINT %I FOREIGN KEY (updated_by) REFERENCES auth.usuario(id)',
                rec.schemaname, rec.tablename, fk_updated_name
            );
        END IF;
    END LOOP;
END $$;
