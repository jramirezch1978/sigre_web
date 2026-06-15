-- ============================================================
-- SIGRE ERP - Defaults de auditoría (post auditoria-global)
-- ============================================================
-- Se ejecuta DESPUÉS de 99-auditoria-global.sql (que agrega las columnas).
-- Configura defaults y backfill usando el usuario admin.
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

-- 1) Función para obtener el id del usuario admin (auditoría por defecto)
CREATE OR REPLACE FUNCTION auth.fn_work_user_id()
RETURNS BIGINT
LANGUAGE SQL
STABLE
AS $$
    SELECT id
    FROM auth.usuario
    WHERE username = 'admin'
    LIMIT 1
$$;

-- 2) Defaults y backfill de auditoría usando admin
DO $$
DECLARE
    rec RECORD;
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
        EXECUTE format(
            'ALTER TABLE %I.%I ALTER COLUMN created_by SET DEFAULT auth.fn_work_user_id()',
            rec.schemaname, rec.tablename
        );
        EXECUTE format(
            'ALTER TABLE %I.%I ALTER COLUMN updated_by SET DEFAULT auth.fn_work_user_id()',
            rec.schemaname, rec.tablename
        );
        EXECUTE format(
            'UPDATE %I.%I SET created_by = COALESCE(created_by, auth.fn_work_user_id()), updated_by = COALESCE(updated_by, auth.fn_work_user_id())',
            rec.schemaname, rec.tablename
        );
    END LOOP;
END $$;

-- 3) Los usuarios se auto-referencian en auditoría
UPDATE auth.usuario
SET created_by = (SELECT id FROM auth.usuario WHERE username = 'admin' LIMIT 1),
    updated_by = (SELECT id FROM auth.usuario WHERE username = 'admin' LIMIT 1),
    fec_modificacion = COALESCE(fec_modificacion, NOW())
WHERE created_by IS NULL OR updated_by IS NULL;
