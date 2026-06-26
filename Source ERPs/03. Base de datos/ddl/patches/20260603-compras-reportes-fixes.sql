-- ============================================================
-- Patch  : Compras - reportes + fixes
-- Fecha  : 2026-06-03
-- Schemas: compras, core, almacen
-- Objetivo: aplicar sobre BD YA desplegada (template/clones) sin rebuild.
--           Todo es idempotente (IF NOT EXISTS / CREATE OR REPLACE / ALTER TYPE).
-- Refs    : docs front pendientes-backend-compras.md (reportes 1.x, bugs 3 y 4).
-- Uso     : psql -f 20260603-compras-reportes-fixes.sql  (sobre cada tenant)
-- ============================================================

SET client_min_messages TO WARNING;

-- ------------------------------------------------------------
-- 1) Bug datos-articulo (HTTP 500): tabla almacen.almacen_tacito faltante.
--    Almacén por defecto según clase de artículo + sucursal.
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS almacen.almacen_tacito (
    id BIGSERIAL PRIMARY KEY,
    cod_clase VARCHAR(20) NOT NULL,
    sucursal_id BIGINT NOT NULL REFERENCES auth.sucursal(id),
    almacen_id BIGINT NOT NULL REFERENCES almacen.almacen(id),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS ix_almacen_tacito_clase_sucursal
    ON almacen.almacen_tacito (cod_clase, sucursal_id);

-- ------------------------------------------------------------
-- 2) Bug DATA_INTEGRITY en compras.orden_servicio (varchar(12)).
--    nro_os generado ("OS-00000001") y nro_cuenta (CCI) rebalsan 12.
-- ------------------------------------------------------------
ALTER TABLE compras.orden_servicio ALTER COLUMN nro_os    TYPE varchar(30);
ALTER TABLE compras.orden_servicio ALTER COLUMN nro_cuenta TYPE varchar(30);

-- ------------------------------------------------------------
-- 3) Columnas de ficha de proveedor usadas por compras/reportes.
-- ------------------------------------------------------------
ALTER TABLE core.entidad_contribuyente
    ADD COLUMN IF NOT EXISTS nombre_comercial VARCHAR(300),
    ADD COLUMN IF NOT EXISTS direccion        VARCHAR(300);

-- ------------------------------------------------------------
-- 4) Reporte "Gestión de compras al detalle"
--    (GET /api/compras/reportes/gestion-compras).
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION compras.sp_generar_reporte_compras(
    p_sucursal_id  BIGINT DEFAULT NULL,
    p_fecha_desde  DATE   DEFAULT NULL,
    p_fecha_hasta  DATE   DEFAULT NULL
)
RETURNS TABLE (
    fecha_compra   DATE,
    nro_orden      VARCHAR,
    doc_fiscal     VARCHAR,
    razon_social   VARCHAR,
    producto       VARCHAR,
    categoria      VARCHAR,
    unidad_medida  VARCHAR,
    cantidad       NUMERIC,
    precio_venta   NUMERIC,
    condicion      VARCHAR,
    estado         VARCHAR
)
LANGUAGE sql
STABLE
AS $$
    SELECT  oc.fecha_emision                                   AS fecha_compra,
            oc.nro_orden_compra                                AS nro_orden,
            NULL::varchar                                      AS doc_fiscal,
            ec.razon_social                                    AS razon_social,
            a.nombre                                           AS producto,
            cat.desc_categ                                     AS categoria,
            COALESCE(um.abreviatura, um.nombre)                AS unidad_medida,
            d.cant_proyectada                                  AS cantidad,
            d.valor_unitario                                   AS precio_venta,
            fp.nombre                                          AS condicion,
            CASE oc.flag_estado
                WHEN '1' THEN 'Activo'
                WHEN '0' THEN 'Anulado'
                WHEN '2' THEN 'Cerrado'
                WHEN '3' THEN 'Pendiente'
                ELSE oc.flag_estado
            END                                                AS estado
    FROM        compras.orden_compra      oc
    JOIN        compras.orden_compra_det  d   ON d.orden_compra_id = oc.id AND d.flag_estado = '1'
    JOIN        core.articulo             a   ON a.id = d.articulo_id
    LEFT JOIN   core.articulo_categ       cat ON cat.id = a.articulo_categ_id
    LEFT JOIN   core.unidad_medida        um  ON um.id = a.unidad_medida_id
    LEFT JOIN   core.entidad_contribuyente ec ON ec.id = oc.proveedor_id
    LEFT JOIN   core.forma_pago           fp  ON fp.id = oc.forma_pago_id
    WHERE   oc.flag_estado <> '0'
      AND   (p_sucursal_id IS NULL OR oc.sucursal_id = p_sucursal_id)
      AND   (p_fecha_desde IS NULL OR oc.fecha_emision >= p_fecha_desde)
      AND   (p_fecha_hasta IS NULL OR oc.fecha_emision <= p_fecha_hasta)
    ORDER BY oc.fecha_emision DESC, oc.nro_orden_compra;
$$;
