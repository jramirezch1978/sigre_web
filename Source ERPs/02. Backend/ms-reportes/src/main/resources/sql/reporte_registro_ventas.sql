-- =============================================================================
-- Registro de Ventas - Formato SUNAT (PostgreSQL / RestPE)
-- Adaptado desde VE721 Oracle (d_rpt_reg_ventas_tbl.srd)
-- Usa ventas.cntas_cobrar_det_imp para impuestos (equivale a SIGRE CC_DOC_DET_IMP)
-- Parámetros: :anio, :mes, :origen ('%' = todos los orígenes/sucursales)
-- =============================================================================
-- Tipos de documento relevantes (core.doc_tipo seed):
--   NCC  = Notas de Crédito x Cobrar   (flag_signo '-', sunat '07')
--   NDC  = Nota Débito x Cobrar        (flag_signo '+', sunat '08')
--   NVC  = excluido del reporte
-- Libro contable: contabilidad.cntbl_libro.codigo = '4' (Registro de Ventas)
-- Crédito fiscal ventas: core.credito_fiscal codigos '08'..'12' (flag_cxp_cxc = 'C')
-- ICBPER: tipo_impuesto 'ICBPE'
-- =============================================================================

WITH
pen AS (
    SELECT core.fn_moneda_default_pen_id() AS moneda_pen_id
),
cf AS (
    SELECT
        MAX(CASE WHEN codigo = '08' THEN id END) AS cf08,
        MAX(CASE WHEN codigo = '09' THEN id END) AS cf09,
        MAX(CASE WHEN codigo = '10' THEN id END) AS cf10,
        MAX(CASE WHEN codigo = '11' THEN id END) AS cf11,
        MAX(CASE WHEN codigo = '12' THEN id END) AS cf12
    FROM core.credito_fiscal
),
imp_icbper AS (
    SELECT id FROM core.tipos_impuesto WHERE tipo_impuesto = 'ICBPE'
),
libro_ventas AS (
    SELECT id FROM contabilidad.cntbl_libro WHERE codigo = '4' LIMIT 1
),
cc_refs AS (
    SELECT DISTINCT ON (cc_nc.id)
        cc_nc.id AS cntas_cobrar_id,
        cc_ref.fecha_emision AS fecha_emision_ref,
        dt_ref.sunat_codigo  AS tipo_ref,
        cc_ref.serie         AS serie_ref,
        LTRIM(cc_ref.numero, '0') AS nro_ref
    FROM ventas.cntas_cobrar cc_nc
    JOIN core.doc_tipo dt_nc ON dt_nc.id = cc_nc.doc_tipo_id
    JOIN ventas.cntas_cobrar cc_ref
      ON cc_ref.id = COALESCE(
             cc_nc.cntas_cobrar_ref_id,
             (SELECT ccd_line.cntas_cobrar_id
                FROM ventas.cntas_cobrar_det ccd
                JOIN ventas.cntas_cobrar_det ccd_line ON ccd_line.id = ccd.cntas_cobrar_det_ref_id
               WHERE ccd.cntas_cobrar_id = cc_nc.id
                 AND ccd.cntas_cobrar_det_ref_id IS NOT NULL
               ORDER BY ccd.nro_item
               LIMIT 1)
         )
    JOIN core.doc_tipo dt_ref ON dt_ref.id = cc_ref.doc_tipo_id
    WHERE dt_nc.codigo IN ('NCC', 'NDC')
    ORDER BY cc_nc.id
)
SELECT
    cc.ano,
    cc.mes,
    cc.nro_asiento,
    cc.fecha_emision AS fecha_documento,
    cc.fecha_vencimiento,
    dt.codigo AS tipo_doc,
    dt.nombre AS desc_tipo_doc,
    cc.serie,
    cc.serie || '-' || LTRIM(cc.numero, '0') AS nro_doc,
    cc.cliente_id AS cod_relacion,
    m.codigo AS cod_moneda,

    -- Importe total documento (base + impuestos) × TC × signo
    ((SELECT COALESCE(SUM(ccd.cantidad * ccd.precio_unitario * (100 - COALESCE(ccd.porc_descuento, 0)) / 100), 0)
        FROM ventas.cntas_cobrar_det ccd
       WHERE ccd.cntas_cobrar_id = cc.id)
     + (SELECT COALESCE(SUM(ci.importe), 0)
          FROM ventas.cntas_cobrar_det ccd
          JOIN ventas.cntas_cobrar_det_imp ci ON ci.cntas_cobrar_det_id = ccd.id
         WHERE ccd.cntas_cobrar_id = cc.id))
    * CASE WHEN cc.moneda_id = pen.moneda_pen_id THEN 1 ELSE cc.tasa_cambio END
    * CASE WHEN dt.flag_signo = '+' THEN 1 ELSE -1 END AS importe_doc,

    CASE
        WHEN cc.flag_estado = '0' THEN '**** ANULADO ****'
        ELSE ec.razon_social
    END AS nom_proveedor,

    CASE
        WHEN cc.flag_estado = '0' THEN 'ANULADO'
        WHEN ec.nro_documento IS NULL THEN ''
        ELSE COALESCE(tdi.codigo, ec.tipo_documento) || ' - ' || ec.nro_documento
    END AS nro_doc_ident,

    CASE
        WHEN cc.moneda_id = pen.moneda_pen_id THEN NULL
        ELSE cc.tasa_cambio
    END::NUMERIC AS tasa_cambio,

    m.codigo AS cod_moneda,
    dt.sunat_codigo AS tipo_doc_sunat,

    -- Ventas gravadas (credito_fiscal '09')
    CASE WHEN cc.flag_estado = '0' THEN 0 ELSE
        (SELECT COALESCE(SUM(ccd.cantidad * ccd.precio_unitario * (100 - COALESCE(ccd.porc_descuento, 0)) / 100), 0)
           FROM ventas.cntas_cobrar_det ccd
          WHERE ccd.cntas_cobrar_id = cc.id
            AND ccd.credito_fiscal_id = cf.cf09)
        * CASE WHEN cc.moneda_id = pen.moneda_pen_id THEN 1 ELSE cc.tasa_cambio END
        * CASE WHEN dt.flag_signo = '+' THEN 1 ELSE -1 END
    END AS vtas_gravadas,

    -- IGV gravadas (CF '09', excluye ICBPER)
    CASE WHEN cc.flag_estado = '0' THEN 0 ELSE
        (SELECT COALESCE(SUM(ci.importe), 0)
            * CASE WHEN cc.moneda_id = pen.moneda_pen_id THEN 1 ELSE cc.tasa_cambio END
           FROM ventas.cntas_cobrar_det ccd
           JOIN ventas.cntas_cobrar_det_imp ci ON ci.cntas_cobrar_det_id = ccd.id
           JOIN core.tipos_impuesto ti ON ti.id = ci.tipos_impuesto_id
          WHERE ccd.cntas_cobrar_id = cc.id
            AND ccd.credito_fiscal_id = cf.cf09
            AND ti.id NOT IN (SELECT id FROM imp_icbper))
        * CASE WHEN dt.flag_signo = '+' THEN 1 ELSE -1 END
    END AS igv_gravadas,

    -- IGV transferencia gratuita (CF '12')
    CASE WHEN cc.flag_estado = '0' THEN 0 ELSE
        (SELECT COALESCE(SUM(ci.importe), 0)
            * CASE WHEN cc.moneda_id = pen.moneda_pen_id THEN 1 ELSE cc.tasa_cambio END
           FROM ventas.cntas_cobrar_det ccd
           JOIN ventas.cntas_cobrar_det_imp ci ON ci.cntas_cobrar_det_id = ccd.id
           JOIN core.tipos_impuesto ti ON ti.id = ci.tipos_impuesto_id
          WHERE ccd.cntas_cobrar_id = cc.id
            AND ccd.credito_fiscal_id = cf.cf12
            AND ti.id NOT IN (SELECT id FROM imp_icbper))
        * CASE WHEN dt.flag_signo = '+' THEN 1 ELSE -1 END
    END AS igv_gratuito,

    -- Ventas inafectas (CF '10')
    CASE WHEN cc.flag_estado = '0' THEN 0 ELSE
        (SELECT COALESCE(SUM(ccd.cantidad * ccd.precio_unitario * (100 - COALESCE(ccd.porc_descuento, 0)) / 100), 0)
           FROM ventas.cntas_cobrar_det ccd
          WHERE ccd.cntas_cobrar_id = cc.id
            AND ccd.credito_fiscal_id = cf.cf10)
        * CASE WHEN cc.moneda_id = pen.moneda_pen_id THEN 1 ELSE cc.tasa_cambio END
        * CASE WHEN dt.flag_signo = '+' THEN 1 ELSE -1 END
    END AS vtas_inafectas,

    -- IGV inafectas (CF '10')
    CASE WHEN cc.flag_estado = '0' THEN 0 ELSE
        (SELECT COALESCE(SUM(ci.importe), 0)
            * CASE WHEN cc.moneda_id = pen.moneda_pen_id THEN 1 ELSE cc.tasa_cambio END
           FROM ventas.cntas_cobrar_det ccd
           JOIN ventas.cntas_cobrar_det_imp ci ON ci.cntas_cobrar_det_id = ccd.id
           JOIN core.tipos_impuesto ti ON ti.id = ci.tipos_impuesto_id
          WHERE ccd.cntas_cobrar_id = cc.id
            AND ccd.credito_fiscal_id = cf.cf10
            AND ti.id NOT IN (SELECT id FROM imp_icbper))
        * CASE WHEN dt.flag_signo = '+' THEN 1 ELSE -1 END
    END AS igv_inafectas,

    -- Ventas exoneradas (CF '11')
    CASE WHEN cc.flag_estado = '0' THEN 0 ELSE
        (SELECT COALESCE(SUM(ccd.cantidad * ccd.precio_unitario * (100 - COALESCE(ccd.porc_descuento, 0)) / 100), 0)
           FROM ventas.cntas_cobrar_det ccd
          WHERE ccd.cntas_cobrar_id = cc.id
            AND ccd.credito_fiscal_id = cf.cf11)
        * CASE WHEN cc.moneda_id = pen.moneda_pen_id THEN 1 ELSE cc.tasa_cambio END
        * CASE WHEN dt.flag_signo = '+' THEN 1 ELSE -1 END
    END AS vtas_exoneradas,

    -- IGV exoneradas (CF '11')
    CASE WHEN cc.flag_estado = '0' THEN 0 ELSE
        (SELECT COALESCE(SUM(ci.importe), 0)
            * CASE WHEN cc.moneda_id = pen.moneda_pen_id THEN 1 ELSE cc.tasa_cambio END
           FROM ventas.cntas_cobrar_det ccd
           JOIN ventas.cntas_cobrar_det_imp ci ON ci.cntas_cobrar_det_id = ccd.id
           JOIN core.tipos_impuesto ti ON ti.id = ci.tipos_impuesto_id
          WHERE ccd.cntas_cobrar_id = cc.id
            AND ccd.credito_fiscal_id = cf.cf11
            AND ti.id NOT IN (SELECT id FROM imp_icbper))
        * CASE WHEN dt.flag_signo = '+' THEN 1 ELSE -1 END
    END AS igv_exoneradas,

    -- Exportaciones (CF '08', sin gratuitas)
    CASE WHEN cc.flag_estado = '0' THEN 0 ELSE
        (SELECT COALESCE(SUM(ccd.cantidad * ccd.precio_unitario * (100 - COALESCE(ccd.porc_descuento, 0)) / 100), 0)
           FROM ventas.cntas_cobrar_det ccd
          WHERE ccd.cntas_cobrar_id = cc.id
            AND ccd.credito_fiscal_id = cf.cf08
            AND COALESCE(ccd.descripcion, '') NOT ILIKE '%GRATUIT%')
        * CASE WHEN cc.moneda_id = pen.moneda_pen_id THEN 1 ELSE cc.tasa_cambio END
        * CASE WHEN dt.flag_signo = '+' THEN 1 ELSE -1 END
    END AS exportaciones,

    -- Ventas no onerosas / gratuitas (CF '12', sin gratuitas en descripción)
    CASE WHEN cc.flag_estado = '0' THEN 0 ELSE
        (SELECT ABS(COALESCE(SUM(ccd.cantidad * ccd.precio_unitario * (100 - COALESCE(ccd.porc_descuento, 0)) / 100), 0))
           FROM ventas.cntas_cobrar_det ccd
          WHERE ccd.cntas_cobrar_id = cc.id
            AND ccd.credito_fiscal_id = cf.cf12
            AND COALESCE(ccd.descripcion, '') NOT ILIKE '%GRATUIT%')
        * CASE WHEN cc.moneda_id = pen.moneda_pen_id THEN 1 ELSE cc.tasa_cambio END
        * CASE WHEN dt.flag_signo = '+' THEN 1 ELSE -1 END
    END AS ventas_gratuitas,

    -- ICBPER
    CASE WHEN cc.flag_estado = '0' THEN 0 ELSE
        (SELECT COALESCE(SUM(ci.importe), 0)
            * CASE WHEN cc.moneda_id = pen.moneda_pen_id THEN 1 ELSE cc.tasa_cambio END
           FROM ventas.cntas_cobrar_det ccd
           JOIN ventas.cntas_cobrar_det_imp ci ON ci.cntas_cobrar_det_id = ccd.id
          WHERE ccd.cntas_cobrar_id = cc.id
            AND ci.tipos_impuesto_id IN (SELECT id FROM imp_icbper))
        * CASE WHEN dt.flag_signo = '+' THEN 1 ELSE -1 END
    END AS icbper,

    dr.fecha_emision_ref,
    dr.tipo_ref,
    dr.serie_ref,
    dr.nro_ref,

    'NCC'::VARCHAR AS ncc

FROM ventas.cntas_cobrar cc
JOIN core.doc_tipo dt ON dt.id = cc.doc_tipo_id
JOIN core.entidad_contribuyente ec ON ec.id = cc.cliente_id
LEFT JOIN core.tipo_doc_identidad tdi ON tdi.id = ec.tipo_doc_identidad_id
JOIN core.moneda m ON m.id = cc.moneda_id
JOIN auth.sucursal s ON s.id = cc.sucursal_id
LEFT JOIN cc_refs dr ON dr.cntas_cobrar_id = cc.id
CROSS JOIN pen
CROSS JOIN cf
WHERE cc.cntbl_libro_id = (SELECT id FROM libro_ventas)
  AND COALESCE(cc.cod_origen, LEFT(s.codigo, 2)) LIKE :origen
  AND dt.codigo NOT IN ('NVC')
  AND cc.ano = :anio
  AND cc.mes = :mes
ORDER BY tipo_doc_sunat ASC, nro_doc ASC;
