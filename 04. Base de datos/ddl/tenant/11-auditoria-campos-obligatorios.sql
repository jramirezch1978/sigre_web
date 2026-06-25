-- ============================================================
-- Normalizacion de auditoria para todas las tablas tenant
-- created_by / fec_creacion obligatorios
-- updated_by / fec_modificacion opcionales
-- fec_creacion / fec_modificacion: defaults y triggers en
-- ddl/99-auditoria-triggers-fechas.sql (post 99-auditoria-global.sql)
-- ============================================================

SET client_min_messages TO WARNING;

DO $$
DECLARE
    r RECORD;
    fk_created_name TEXT;
    fk_updated_name TEXT;
    chk_flag_estado_name TEXT;
    v_es_transaccional BOOLEAN;
    v_tablas_transaccionales TEXT[] := ARRAY[
        'compras.orden_compra',
        'compras.orden_compra_det',
        'compras.orden_servicio',
        'compras.orden_servicio_det',
        'compras.conformidad_servicio',
        'compras.conformidad_servicio_det',
        'compras.solicitud_compra',
        'compras.solicitud_compra_det',
        'compras.cotizacion',
        'compras.cotizacion_det',
        'compras.aprobacion',
        'compras.contrato_marco',
        'compras.prog_compras',
        'compras.prog_compras_det',
        'compras.oc_importacion',
        'compras.compra_fondo',
        'finanzas.cntas_pagar',
        'finanzas.cntas_pagar_det',
        'finanzas.caja_bancos',
        'finanzas.caja_bancos_det',
        'finanzas.solicitud_giro',
        'finanzas.liquidacion',
        'finanzas.liquidacion_det',
        'finanzas.programacion_pago',
        'finanzas.programacion_pago_det',
        'finanzas.fondo_fijo',
        'finanzas.rendicion_gasto',
        'finanzas.pago',
        'finanzas.conciliacion_bancaria',
        'finanzas.conciliacion_det',
        'finanzas.detraccion',
        'finanzas.retencion',
        'finanzas.flujo_caja',
        'finanzas.flujo_caja_proyectado',
        'ventas.cntas_cobrar',
        'ventas.cntas_cobrar_det',
        'ventas.orden_venta',
        'ventas.orden_venta_det',
        'ventas.comanda',
        'ventas.comanda_det',
        'ventas.fs_factura_simpl',
        'ventas.fs_factura_simpl_det',
        'ventas.pedido_mesa',
        'ventas.pedido_mesa_det',
        'ventas.proforma',
        'ventas.proforma_det',
        'ventas.cierre_caja',
        'ventas.reservacion',
        'ventas.reservacion_det',
        'ventas.servicios_cxc',
        'almacen.vale_mov',
        'almacen.vale_mov_det',
        'almacen.orden_traslado',
        'almacen.orden_traslado_det',
        'almacen.guia',
        'almacen.guia_det',
        'almacen.inventario_conteo',
        'almacen.sol_salida',
        'almacen.sol_salida_det',
        'contabilidad.cntbl_asiento',
        'contabilidad.cntbl_asiento_det',
        'contabilidad.cntbl_preasiento',
        'contabilidad.cntbl_preasiento_det',
        'contabilidad.cntbl_cierre',
        'produccion.orden_trabajo',
        'produccion.programacion_produccion',
        'rrhh.liquidacion_benef',
        -- RRHH: flag_estado = máquina de estados (no solo activo/anulado 0/1)
        'rrhh.permiso_licencia',
        'rrhh.vacacion',
        'rrhh.cnta_crrte_det'
    ];
BEGIN
    FOR r IN
        SELECT n.nspname AS schema_name, c.relname AS table_name
        FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relkind = 'r'
          AND n.nspname IN (
              'auth', 'core', 'almacen', 'compras', 'ventas', 'finanzas',
              'contabilidad', 'rrhh', 'activos', 'produccion', 'auditoria'
          )
        ORDER BY n.nspname, c.relname
    LOOP
        EXECUTE format('ALTER TABLE %I.%I ADD COLUMN IF NOT EXISTS created_by BIGINT', r.schema_name, r.table_name);
        EXECUTE format('ALTER TABLE %I.%I ADD COLUMN IF NOT EXISTS fec_creacion TIMESTAMPTZ', r.schema_name, r.table_name);
        EXECUTE format('ALTER TABLE %I.%I ADD COLUMN IF NOT EXISTS updated_by BIGINT', r.schema_name, r.table_name);
        EXECUTE format('ALTER TABLE %I.%I ADD COLUMN IF NOT EXISTS fec_modificacion TIMESTAMPTZ', r.schema_name, r.table_name);

        EXECUTE format(
            'UPDATE %I.%I
                SET created_by = COALESCE(created_by, 1),
                    fec_creacion = COALESCE(fec_creacion, NOW()),
                    updated_by = COALESCE(updated_by, 1)
              WHERE created_by IS NULL OR fec_creacion IS NULL OR updated_by IS NULL',
            r.schema_name, r.table_name
        );

        EXECUTE format('ALTER TABLE %I.%I ALTER COLUMN created_by SET DEFAULT 1', r.schema_name, r.table_name);
        EXECUTE format('ALTER TABLE %I.%I ALTER COLUMN fec_creacion SET DEFAULT NOW()', r.schema_name, r.table_name);
        EXECUTE format('ALTER TABLE %I.%I ALTER COLUMN updated_by SET DEFAULT 1', r.schema_name, r.table_name);

        EXECUTE format('ALTER TABLE %I.%I ALTER COLUMN created_by SET NOT NULL', r.schema_name, r.table_name);
        EXECUTE format('ALTER TABLE %I.%I ALTER COLUMN fec_creacion SET NOT NULL', r.schema_name, r.table_name);

        IF EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = r.schema_name
              AND table_name = r.table_name
              AND column_name = 'flag_estado'
        ) THEN
            v_es_transaccional := (r.schema_name || '.' || r.table_name) = ANY(v_tablas_transaccionales);

            IF v_es_transaccional THEN
                EXECUTE format(
                    'ALTER TABLE %I.%I
                        ALTER COLUMN flag_estado TYPE VARCHAR(1)
                        USING CASE WHEN trim(flag_estado::text) IN (''0'',''1'',''2'',''3'',''4'',''5'',''6'',''7'',''8'',''9'') THEN trim(flag_estado::text) ELSE ''0'' END',
                    r.schema_name, r.table_name
                );
                EXECUTE format(
                    'UPDATE %I.%I
                        SET flag_estado = ''0''
                      WHERE flag_estado IS NULL OR flag_estado !~ ''^[0-9]$''',
                    r.schema_name, r.table_name
                );
            ELSE
                EXECUTE format(
                    'ALTER TABLE %I.%I
                        ALTER COLUMN flag_estado TYPE VARCHAR(1)
                        USING CASE WHEN trim(flag_estado::text) = ''1'' THEN ''1'' ELSE ''0'' END',
                    r.schema_name, r.table_name
                );
                EXECUTE format(
                    'UPDATE %I.%I
                        SET flag_estado = CASE WHEN flag_estado = ''1'' THEN ''1'' ELSE ''0'' END
                      WHERE flag_estado IS NULL OR flag_estado NOT IN (''0'', ''1'')',
                    r.schema_name, r.table_name
                );
            END IF;

            EXECUTE format('ALTER TABLE %I.%I ALTER COLUMN flag_estado SET DEFAULT ''1''', r.schema_name, r.table_name);
            EXECUTE format('ALTER TABLE %I.%I ALTER COLUMN flag_estado SET NOT NULL', r.schema_name, r.table_name);

            chk_flag_estado_name := format('chk_fe_%s', substr(md5(r.schema_name || '.' || r.table_name), 1, 20));

            EXECUTE format(
                'ALTER TABLE %I.%I DROP CONSTRAINT IF EXISTS %I',
                r.schema_name, r.table_name, chk_flag_estado_name
            );

            IF v_es_transaccional THEN
                EXECUTE format(
                    'ALTER TABLE %I.%I ADD CONSTRAINT %I CHECK (flag_estado ~ ''^[0-9]$'')',
                    r.schema_name, r.table_name, chk_flag_estado_name
                );
            ELSE
                EXECUTE format(
                    'ALTER TABLE %I.%I ADD CONSTRAINT %I CHECK (flag_estado IN (''0'', ''1''))',
                    r.schema_name, r.table_name, chk_flag_estado_name
                );
            END IF;
        END IF;

        IF EXISTS (
            SELECT 1
            FROM information_schema.tables
            WHERE table_schema = 'auth'
              AND table_name = 'usuario'
        ) THEN
            fk_created_name := format('fk_cb_%s', substr(md5(r.schema_name || '.' || r.table_name), 1, 16));
            fk_updated_name := format('fk_ub_%s', substr(md5(r.schema_name || '.' || r.table_name), 1, 16));

            IF NOT EXISTS (
                SELECT 1
                FROM pg_constraint con
                JOIN pg_class tbl ON tbl.oid = con.conrelid
                JOIN pg_namespace ns ON ns.oid = tbl.relnamespace
                WHERE ns.nspname = r.schema_name
                  AND tbl.relname = r.table_name
                  AND con.conname = fk_created_name
            ) THEN
                EXECUTE format(
                    'ALTER TABLE %I.%I ADD CONSTRAINT %I FOREIGN KEY (created_by) REFERENCES auth.usuario(id) NOT VALID',
                    r.schema_name, r.table_name, fk_created_name
                );
            END IF;

            IF NOT EXISTS (
                SELECT 1
                FROM pg_constraint con
                JOIN pg_class tbl ON tbl.oid = con.conrelid
                JOIN pg_namespace ns ON ns.oid = tbl.relnamespace
                WHERE ns.nspname = r.schema_name
                  AND tbl.relname = r.table_name
                  AND con.conname = fk_updated_name
            ) THEN
                EXECUTE format(
                    'ALTER TABLE %I.%I ADD CONSTRAINT %I FOREIGN KEY (updated_by) REFERENCES auth.usuario(id) NOT VALID',
                    r.schema_name, r.table_name, fk_updated_name
                );
            END IF;
        END IF;
    END LOOP;

    RAISE NOTICE '[DDL tenant] Auditoria + flag_estado estandarizados en todos los esquemas tenant.';
END $$;

-- Default dinámico para moneda por defecto de sucursal (PEN)
CREATE OR REPLACE FUNCTION core.fn_moneda_default_pen_id()
RETURNS BIGINT
LANGUAGE SQL
STABLE
AS $$
    SELECT id
      FROM core.moneda
     WHERE codigo IN ('SOL', 'PEN')
     ORDER BY CASE codigo WHEN 'SOL' THEN 0 WHEN 'PEN' THEN 1 ELSE 2 END, id
     LIMIT 1
$$;

-- Ajuste puntual: sucursal debe tener moneda_defult_id (FK a core.moneda, default PEN)
DO $$
DECLARE
    v_sol_id BIGINT;
BEGIN
    INSERT INTO core.moneda (codigo, sigla_moneda, nombre, simbolo, decimales, flag_estado)
    VALUES ('SOL', 'S/.', 'Soles', 'S/', 2, '1')
    ON CONFLICT (codigo) DO UPDATE SET
        sigla_moneda = EXCLUDED.sigla_moneda,
        nombre = EXCLUDED.nombre,
        simbolo = EXCLUDED.simbolo,
        decimales = EXCLUDED.decimales,
        flag_estado = EXCLUDED.flag_estado;

    SELECT id INTO v_sol_id
    FROM core.moneda
    WHERE codigo IN ('SOL', 'PEN')
    ORDER BY CASE codigo WHEN 'SOL' THEN 0 WHEN 'PEN' THEN 1 ELSE 2 END, id
    LIMIT 1;

    IF v_sol_id IS NULL THEN
        RAISE EXCEPTION 'No se pudo resolver moneda SOL/PEN en core.moneda';
    END IF;

    EXECUTE 'ALTER TABLE auth.sucursal ADD COLUMN IF NOT EXISTS moneda_defult_id BIGINT';
    EXECUTE format('UPDATE auth.sucursal SET moneda_defult_id = %s WHERE moneda_defult_id IS NULL', v_sol_id);
    EXECUTE 'ALTER TABLE auth.sucursal ALTER COLUMN moneda_defult_id SET DEFAULT core.fn_moneda_default_pen_id()';
    EXECUTE 'ALTER TABLE auth.sucursal ALTER COLUMN moneda_defult_id SET NOT NULL';

    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint con
        JOIN pg_class tbl ON tbl.oid = con.conrelid
        JOIN pg_namespace ns ON ns.oid = tbl.relnamespace
        WHERE ns.nspname = 'auth'
          AND tbl.relname = 'sucursal'
          AND con.conname = 'fk_sucursal_05'
    ) THEN
        EXECUTE 'ALTER TABLE auth.sucursal ADD CONSTRAINT FK_SUCURSAL_05 FOREIGN KEY (moneda_defult_id) REFERENCES core.moneda(id)';
    END IF;

    EXECUTE 'CREATE INDEX IF NOT EXISTS ix_sucursal_05 ON auth.sucursal (moneda_defult_id)';
    RAISE NOTICE '[DDL tenant] auth.sucursal ahora referencia moneda_defult_id (PEN por defecto).';
END $$;

-- ============================================================
-- Migracion: columnas de negocio añadidas al DDL despues del
-- despliegue inicial. Usar ADD COLUMN IF NOT EXISTS para que
-- sea idempotente en bases ya actualizadas.
-- ============================================================

-- almacen.almacen: columnas añadidas en v2
DO $$
BEGIN
    -- ano_apertura: año de apertura del almacen
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'almacen' AND table_name = 'almacen' AND column_name = 'ano_apertura'
    ) THEN
        EXECUTE 'ALTER TABLE almacen.almacen ADD COLUMN ano_apertura INTEGER';
        RAISE NOTICE '[DDL tenant] almacen.almacen: columna ano_apertura agregada.';
    END IF;
END $$;

-- Ajuste puntual: ejercicio_periodo es por tenant (sin empresa_id)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'core'
          AND table_name = 'ejercicio_periodo'
          AND column_name = 'empresa_id'
    ) THEN
        EXECUTE 'DROP INDEX IF EXISTS core.ix_ejercicio_periodo_01';
        EXECUTE 'ALTER TABLE core.ejercicio_periodo DROP COLUMN empresa_id';
        EXECUTE 'CREATE UNIQUE INDEX IF NOT EXISTS ix_ejercicio_periodo_01 ON core.ejercicio_periodo (anio)';
        RAISE NOTICE '[DDL tenant] core.ejercicio_periodo normalizada: empresa_id removido y unicidad por anio.';
    END IF;
END $$;
