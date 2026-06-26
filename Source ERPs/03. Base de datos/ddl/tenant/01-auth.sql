-- ============================================================
-- Restaurant.pe ERP — esquema auth en BD tenant (y template)
-- ============================================================
-- Orden de ejecución: después de tenant/00-auth-usuario.sql y antes de tenant/01-core.sql.
-- Las FK de auth.sucursal a core.moneda y geografía (país, departamento, provincia, distrito)
-- se declaran en 01-core.sql con ALTER TABLE, cuando ya existan esas tablas core.
-- ============================================================

SET client_min_messages TO WARNING;

-- Catálogo de sucursales (tenant). Ubigeo enlazado vía core.pais / departamento / provincia / distrito.
CREATE TABLE auth.sucursal (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(2) NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    direccion VARCHAR(300),
    ciudad VARCHAR(120),
    moneda_defult_id BIGINT,
    pais_id BIGINT,
    departamento_id BIGINT,
    provincia_id BIGINT,
    distrito_id BIGINT,
    ubigeo VARCHAR(12),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    UNIQUE (codigo)
);

-- FK: usuario_sucursal se define en 00-auth-usuario.sql (antes de existir auth.sucursal).
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.tables
        WHERE table_schema = 'auth' AND table_name = 'usuario_sucursal'
    ) AND NOT EXISTS (
        SELECT 1 FROM pg_constraint c
        JOIN pg_class t ON c.conrelid = t.oid
        JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = 'auth' AND t.relname = 'usuario_sucursal' AND c.conname = 'fk_usuario_sucursal_sucursal'
    ) THEN
        ALTER TABLE auth.usuario_sucursal
            ADD CONSTRAINT fk_usuario_sucursal_sucursal FOREIGN KEY (sucursal_id) REFERENCES auth.sucursal (id);
    END IF;
END $$;

-- auth.sucursal.codigo VARCHAR(2) — BD existentes con formato legacy {empresa}-{sufijo}
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
         WHERE table_schema = 'auth' AND table_name = 'sucursal'
           AND column_name = 'codigo'
           AND character_maximum_length > 2
    ) THEN
        UPDATE auth.sucursal s
           SET codigo = CASE
               WHEN s.codigo LIKE '%-%' THEN split_part(s.codigo, '-', 2)
               ELSE LEFT(s.codigo, 2)
           END
         WHERE LENGTH(s.codigo) > 2;
        ALTER TABLE auth.sucursal ALTER COLUMN codigo TYPE VARCHAR(2);
    END IF;
END $$;

COMMENT ON COLUMN auth.sucursal.codigo IS
    'Código de sucursal (2 caracteres, UNIQUE). Prefijo SS del voucher contable.';
