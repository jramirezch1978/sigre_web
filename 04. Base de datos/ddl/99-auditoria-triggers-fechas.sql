-- ============================================================
-- SIGRE ERP - Fechas de auditoría desde la base de datos
-- ============================================================
-- fec_creacion:
--   - DEFAULT NOW() en tablas que tengan la columna
--   - Trigger BEFORE INSERT si el valor llega NULL
-- fec_modificacion:
--   - Trigger BEFORE UPDATE solo en tablas con bloque de auditoría
--     (created_by + fec_creacion + fec_modificacion)
-- Ejecutar DESPUÉS de 99-auditoria-global.sql
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

CREATE SCHEMA IF NOT EXISTS config;

CREATE OR REPLACE FUNCTION config.fn_audit_fec_creacion()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.fec_creacion IS NULL THEN
        NEW.fec_creacion := NOW();
    END IF;
    RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION config.fn_audit_fec_modificacion()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.fec_modificacion := NOW();
    RETURN NEW;
END;
$$;

COMMENT ON FUNCTION config.fn_audit_fec_creacion() IS
    'BEFORE INSERT: asigna fec_creacion = NOW() cuando el INSERT no la envía.';

COMMENT ON FUNCTION config.fn_audit_fec_modificacion() IS
    'BEFORE UPDATE: asigna fec_modificacion = NOW() en tablas con columnas de auditoría.';

DO $$
DECLARE
    rec RECORD;
    trg_fc_name TEXT;
    trg_fm_name TEXT;
    v_has_created_by BOOLEAN;
    v_has_fec_creacion BOOLEAN;
    v_has_fec_modificacion BOOLEAN;
BEGIN
    FOR rec IN
        SELECT n.nspname AS schemaname, c.relname AS tablename
        FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relkind = 'r'
          AND n.nspname IN (
              'master', 'config', 'auth', 'core', 'almacen', 'compras', 'ventas',
              'finanzas', 'contabilidad', 'rrhh', 'activos', 'produccion', 'auditoria'
          )
          AND c.relname <> 'flyway_schema_history'
        ORDER BY n.nspname, c.relname
    LOOP
        SELECT EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = rec.schemaname
              AND table_name = rec.tablename
              AND column_name = 'created_by'
        ) INTO v_has_created_by;

        SELECT EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = rec.schemaname
              AND table_name = rec.tablename
              AND column_name = 'fec_creacion'
        ) INTO v_has_fec_creacion;

        SELECT EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = rec.schemaname
              AND table_name = rec.tablename
              AND column_name = 'fec_modificacion'
        ) INTO v_has_fec_modificacion;

        IF v_has_fec_creacion THEN
            EXECUTE format(
                'ALTER TABLE %I.%I ALTER COLUMN fec_creacion SET DEFAULT NOW()',
                rec.schemaname, rec.tablename
            );

            trg_fc_name := format('trg_fc_%s', substr(md5(rec.schemaname || '.' || rec.tablename), 1, 16));

            EXECUTE format('DROP TRIGGER IF EXISTS %I ON %I.%I', trg_fc_name, rec.schemaname, rec.tablename);
            EXECUTE format(
                'CREATE TRIGGER %I BEFORE INSERT ON %I.%I '
                'FOR EACH ROW EXECUTE FUNCTION config.fn_audit_fec_creacion()',
                trg_fc_name, rec.schemaname, rec.tablename
            );
        END IF;

        IF v_has_created_by AND v_has_fec_creacion AND v_has_fec_modificacion THEN
            trg_fm_name := format(
                'trg_fm_%s',
                substr(md5(rec.schemaname || '.' || rec.tablename || '.mod'), 1, 16)
            );

            EXECUTE format('DROP TRIGGER IF EXISTS %I ON %I.%I', trg_fm_name, rec.schemaname, rec.tablename);
            EXECUTE format(
                'CREATE TRIGGER %I BEFORE UPDATE ON %I.%I '
                'FOR EACH ROW EXECUTE FUNCTION config.fn_audit_fec_modificacion()',
                trg_fm_name, rec.schemaname, rec.tablename
            );
        END IF;
    END LOOP;

    RAISE NOTICE '[DDL] fec_creacion (DEFAULT/trigger INSERT) y fec_modificacion (trigger UPDATE) aplicados.';
END $$;
