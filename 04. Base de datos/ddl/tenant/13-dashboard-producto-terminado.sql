-- ============================================================
-- SIGRE ERP - Tenant DDL
-- Dashboard logístico Hermes / producto terminado
-- Idempotente — seguro en create-template y en tenants ya clonados.
-- ============================================================

SET client_min_messages TO WARNING;

-- 1) Clase de artículo en core.articulo (si aún no existe)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'core' AND table_name = 'articulo' AND column_name = 'articulo_clase_id'
    ) THEN
        ALTER TABLE core.articulo
            ADD COLUMN articulo_clase_id BIGINT REFERENCES core.articulo_clase(id);
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS IX_ARTICULO_CLASE_ID ON core.articulo (articulo_clase_id);

COMMENT ON COLUMN core.articulo.articulo_clase_id IS
    'FK a core.articulo_clase. El código PT se lee de config ALMACEN.CLASE_PRODUCTO_TERMINADO';

-- 2) Parámetro tenant: código de clase = producto terminado
INSERT INTO config.configuracion (modulo, parametro, tipo_dato, valor_texto, editable)
SELECT 'ALMACEN', 'CLASE_PRODUCTO_TERMINADO', 'TEXT', '01', TRUE
WHERE NOT EXISTS (
    SELECT 1 FROM config.configuracion
    WHERE modulo = 'ALMACEN' AND parametro = 'CLASE_PRODUCTO_TERMINADO'
);
