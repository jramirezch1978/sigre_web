-- =============================================================================
-- Registro de Compras - Formato SUNAT (PostgreSQL / RestPE)
-- Adaptado desde FI749 Oracle (d_rpt_reg_compras_sunat_tbl.srd)
-- Usa finanzas.cntas_pagar_det_imp para impuestos (equivale a SIGRE CP_DOC_DET_IMP)
-- Parámetros: :anio, :mes, :origen ('%' = todos los orígenes/sucursales)
-- =============================================================================
-- Tipos de documento relevantes (core.doc_tipo seed):
--   NCP  = Nota de Crédito Proveedor   (flag_signo '-', sunat '07') → factor -1
--   CNC  = Nota de Crédito No Domicili (flag_signo '-', sunat '97') → factor -1
--   NDP  = Nota de Débito por Pagar    (flag_signo '+', sunat '08') → factor +1
--   CDB  = Nota de Débito No Domicilia (flag_signo '+', sunat '98') → factor +1
--   RE   = Recibo de Honorarios        (sunat '02') → EXCLUIDO (se declara en PLAME)
--   LC   = Liquidación de Compra       (sunat '04')
--   FAC  = Factura por Cobrar          (sunat '01') — solo CxC, no aparece aquí
-- =============================================================================

WITH
pen AS (
    SELECT core.fn_moneda_default_pen_id() AS moneda_pen_id
),
imp AS (
    SELECT
        MAX(CASE WHEN tipo_impuesto = 'ISC'   THEN id END) AS id_isc,
        MAX(CASE WHEN tipo_impuesto = 'IPERC' THEN id END) AS id_perc
    FROM core.tipos_impuesto
),
libro_compras AS (
    SELECT id FROM contabilidad.cntbl_libro WHERE codigo = '3' LIMIT 1
),
cp_base AS (
    SELECT
        cp.*,
        dt.codigo        AS tipo_doc,
        dt.nombre        AS desc_tipo_doc,
        dt.sunat_codigo  AS cod_sunat,
        ec.id            AS proveedor,
        ec.razon_social  AS nom_proveedor,
        tdi.codigo       AS tipo_doc_ident,
        ec.nro_documento AS ruc_dni,
        ec.tipo_persona,
        m.codigo         AS moneda_codigo,
        COALESCE(cp.tasa_cambio, ca.tasa_cambio, core.fn_tasa_cambio_calendario(cp.fecha_emision, cp.moneda_id, pen.moneda_pen_id), 1::NUMERIC) AS tasa_cambio_efectiva,
        COALESCE(cp.cod_origen, LEFT(s.codigo, 2)) AS origen,
        ca.voucher,
        dbs.bien_serv,
        dbs.tasa_pdbe,
        dbs.codigo_sunat,
        cp.nro_detraccion AS nro_detraccion_cp,
        CASE
            WHEN dt.codigo IN ('NCP', 'CNC') THEN -1
            ELSE 1
        END AS flag_signo,
        CASE
            WHEN ec.tipo_persona ILIKE 'NATURAL%' THEN '01'
            WHEN ec.tipo_persona ILIKE 'JURIDIC%' THEN '02'
            ELSE '03'
        END AS personeria
    FROM finanzas.cntas_pagar cp
    JOIN core.doc_tipo dt ON dt.id = cp.doc_tipo_id
    JOIN core.entidad_contribuyente ec ON ec.id = cp.proveedor_id
    LEFT JOIN core.tipo_doc_identidad tdi ON tdi.id = ec.tipo_doc_identidad_id
    JOIN core.moneda m ON m.id = cp.moneda_id
    JOIN auth.sucursal s ON s.id = cp.sucursal_id
    LEFT JOIN contabilidad.cntbl_asiento ca ON ca.id = cp.cntbl_asiento_id
    LEFT JOIN core.detr_bien_serv dbs ON dbs.id = cp.detr_bien_serv_id
    CROSS JOIN pen
    WHERE cp.flag_estado <> '0'
      AND COALESCE(cp.ano, EXTRACT(YEAR FROM COALESCE(ca.fecha, cp.fecha_emision))::INTEGER) = :anio
      AND COALESCE(cp.mes, EXTRACT(MONTH FROM COALESCE(ca.fecha, cp.fecha_emision))::INTEGER) = :mes
      AND COALESCE(cp.cntbl_libro_id, ca.libro_id) = (SELECT id FROM libro_compras)
      AND dt.codigo NOT IN ('RE')   -- RE = Recibo de Honorarios → se declara en PLAME, no en Registro de Compras
      AND s.codigo LIKE :origen
),
cp_refs AS (
    SELECT DISTINCT ON (cpd.cntas_pagar_id)
        cpd.cntas_pagar_id,
        cp_ref.fecha_emision AS fec_emision_ref,
        dt_ref.sunat_codigo  AS tipo_doc_ref,
        dt_ref.codigo        AS tipo_ref,
        cp_ref.numero        AS nro_ref,
        CASE
            WHEN cp_ref.serie IS NOT NULL THEN LPAD(cp_ref.serie, 4, '0')
            WHEN POSITION('-' IN COALESCE(cp_ref.serie || '-' || cp_ref.numero, '')) > 0 THEN
                LPAD(SPLIT_PART(COALESCE(cp_ref.serie || '-' || cp_ref.numero, ''), '-', 1), 4, '0')
            ELSE NULL
        END AS serie_doc_ref,
        CASE
            WHEN cp_ref.numero IS NOT NULL THEN LTRIM(cp_ref.numero, '0')
            WHEN POSITION('-' IN COALESCE(cp_ref.serie || '-' || cp_ref.numero, '')) > 0 THEN
                TRIM(SPLIT_PART(COALESCE(cp_ref.serie || '-' || cp_ref.numero, ''), '-', 2))
            ELSE NULL
        END AS nro_doc_ref
    FROM finanzas.cntas_pagar_det cpd
    JOIN finanzas.cntas_pagar cp_doc ON cp_doc.id = cpd.cntas_pagar_id
    JOIN core.doc_tipo dt_nc ON dt_nc.id = cp_doc.doc_tipo_id
    JOIN finanzas.cntas_pagar cp_ref
      ON cp_ref.proveedor_id = cp_doc.proveedor_id
     AND cp_ref.doc_tipo_id  = cpd.doc_tipo_ref_id
     AND cp_ref.numero       = cpd.nro_ref
     AND cp_ref.flag_estado <> '0'
    JOIN core.doc_tipo dt_ref ON dt_ref.id = cp_ref.doc_tipo_id
    WHERE cpd.flag_estado <> '0'
      AND cpd.doc_tipo_ref_id IS NOT NULL
      AND cpd.nro_ref IS NOT NULL
      AND dt_nc.codigo IN ('NCP', 'CNC')  -- Solo notas de crédito referencian un documento original
    ORDER BY cpd.cntas_pagar_id, cpd.item
)
SELECT
    DATE_TRUNC('day', cp.fecha_emision)::DATE AS fec_emision,
    cp.tipo_doc,
    cp.desc_tipo_doc,
    CASE
        WHEN cp.serie IS NULL OR cp.tipo_doc = 'LC' THEN
            COALESCE(cp.serie || '-' || LTRIM(cp.numero, '0'), cp.numero)
        ELSE
            cp.serie || '-' || LTRIM(cp.numero, '0')
    END AS full_nro_doc,
    COALESCE(cp.serie || '-' || cp.numero, cp.numero) AS nro_doc,
    cp.proveedor,
    cp.nom_proveedor AS razon_social,
    cp.tipo_doc_ident || '-' || cp.ruc_dni AS documento_identidad,
    cp.tipo_doc_ident,
    cp.ruc_dni,

    -- 14. Base Imponible Crédito Fiscal 01
    COALESCE((SELECT SUM((CASE WHEN cp.moneda_id = pen.moneda_pen_id THEN cpd.monto ELSE cpd.monto * cp.tasa_cambio_efectiva END) * cp.flag_signo)
        FROM finanzas.cntas_pagar_det cpd CROSS JOIN pen
        WHERE cpd.cntas_pagar_id = cp.id AND cpd.flag_estado <> '0'
          AND cpd.credito_fiscal_id = (SELECT id FROM core.credito_fiscal WHERE codigo = '01' LIMIT 1)), 0) AS ln_base01,

    -- 15. IGV Crédito Fiscal 01 (lee de cntas_pagar_det_imp)
    COALESCE((SELECT SUM((CASE WHEN cp.moneda_id = pen.moneda_pen_id THEN cpi.importe ELSE cpi.importe * cp.tasa_cambio_efectiva END)
            * CASE WHEN ti.signo = '-' THEN -1 ELSE 1 END * cp.flag_signo)
        FROM finanzas.cntas_pagar_det cpd
        JOIN finanzas.cntas_pagar_det_imp cpi ON cpi.cntas_pagar_det_id = cpd.id
        JOIN core.tipos_impuesto ti ON ti.id = cpi.tipos_impuesto_id
        CROSS JOIN pen
        WHERE cpd.cntas_pagar_id = cp.id AND cpd.flag_estado <> '0'
          AND cpd.credito_fiscal_id = (SELECT id FROM core.credito_fiscal WHERE codigo = '01' LIMIT 1)
          AND ti.flag_igv = '1'
          AND ti.id NOT IN (SELECT id_isc FROM imp UNION SELECT id_perc FROM imp)), 0) AS ln_igv01,

    -- 16. Base Imponible Crédito Fiscal 02
    COALESCE((SELECT SUM((CASE WHEN cp.moneda_id = pen.moneda_pen_id THEN cpd.monto ELSE cpd.monto * cp.tasa_cambio_efectiva END) * cp.flag_signo)
        FROM finanzas.cntas_pagar_det cpd CROSS JOIN pen
        WHERE cpd.cntas_pagar_id = cp.id AND cpd.flag_estado <> '0'
          AND cpd.credito_fiscal_id = (SELECT id FROM core.credito_fiscal WHERE codigo = '02' LIMIT 1)), 0) AS ln_base02,

    -- 17. IGV Crédito Fiscal 02
    COALESCE((SELECT SUM((CASE WHEN cp.moneda_id = pen.moneda_pen_id THEN cpi.importe ELSE cpi.importe * cp.tasa_cambio_efectiva END)
            * CASE WHEN ti.signo = '-' THEN -1 ELSE 1 END * cp.flag_signo)
        FROM finanzas.cntas_pagar_det cpd
        JOIN finanzas.cntas_pagar_det_imp cpi ON cpi.cntas_pagar_det_id = cpd.id
        JOIN core.tipos_impuesto ti ON ti.id = cpi.tipos_impuesto_id
        CROSS JOIN pen
        WHERE cpd.cntas_pagar_id = cp.id AND cpd.flag_estado <> '0'
          AND cpd.credito_fiscal_id = (SELECT id FROM core.credito_fiscal WHERE codigo = '02' LIMIT 1)
          AND ti.flag_igv = '1'
          AND ti.id NOT IN (SELECT id_isc FROM imp UNION SELECT id_perc FROM imp)), 0) AS ln_igv02,

    -- 18. Base Imponible Crédito Fiscal 03
    COALESCE((SELECT SUM((CASE WHEN cp.moneda_id = pen.moneda_pen_id THEN cpd.monto ELSE cpd.monto * cp.tasa_cambio_efectiva END) * cp.flag_signo)
        FROM finanzas.cntas_pagar_det cpd CROSS JOIN pen
        WHERE cpd.cntas_pagar_id = cp.id AND cpd.flag_estado <> '0'
          AND cpd.credito_fiscal_id = (SELECT id FROM core.credito_fiscal WHERE codigo = '03' LIMIT 1)), 0) AS ln_base03,

    -- IGV Crédito Fiscal 03
    COALESCE((SELECT SUM((CASE WHEN cp.moneda_id = pen.moneda_pen_id THEN cpi.importe ELSE cpi.importe * cp.tasa_cambio_efectiva END)
            * CASE WHEN ti.signo = '-' THEN -1 ELSE 1 END * cp.flag_signo)
        FROM finanzas.cntas_pagar_det cpd
        JOIN finanzas.cntas_pagar_det_imp cpi ON cpi.cntas_pagar_det_id = cpd.id
        JOIN core.tipos_impuesto ti ON ti.id = cpi.tipos_impuesto_id
        CROSS JOIN pen
        WHERE cpd.cntas_pagar_id = cp.id AND cpd.flag_estado <> '0'
          AND cpd.credito_fiscal_id = (SELECT id FROM core.credito_fiscal WHERE codigo = '03' LIMIT 1)
          AND ti.flag_igv = '1'
          AND ti.id NOT IN (SELECT id_isc FROM imp UNION SELECT id_perc FROM imp)), 0) AS ln_igv03,

    -- 19. Compras no gravadas (base CF 04 + IGV CF 04)
    COALESCE((SELECT SUM((CASE WHEN cp.moneda_id = pen.moneda_pen_id THEN cpd.monto ELSE cpd.monto * cp.tasa_cambio_efectiva END) * cp.flag_signo)
        FROM finanzas.cntas_pagar_det cpd CROSS JOIN pen
        WHERE cpd.cntas_pagar_id = cp.id AND cpd.flag_estado <> '0'
          AND cpd.credito_fiscal_id = (SELECT id FROM core.credito_fiscal WHERE codigo = '04' LIMIT 1)), 0)
    + COALESCE((SELECT SUM((CASE WHEN cp.moneda_id = pen.moneda_pen_id THEN cpi.importe ELSE cpi.importe * cp.tasa_cambio_efectiva END)
            * CASE WHEN ti.signo = '-' THEN -1 ELSE 1 END * cp.flag_signo)
        FROM finanzas.cntas_pagar_det cpd
        JOIN finanzas.cntas_pagar_det_imp cpi ON cpi.cntas_pagar_det_id = cpd.id
        JOIN core.tipos_impuesto ti ON ti.id = cpi.tipos_impuesto_id
        CROSS JOIN pen
        WHERE cpd.cntas_pagar_id = cp.id AND cpd.flag_estado <> '0'
          AND cpd.credito_fiscal_id = (SELECT id FROM core.credito_fiscal WHERE codigo = '04' LIMIT 1)
          AND ti.flag_igv = '1'
          AND ti.id NOT IN (SELECT id_isc FROM imp UNION SELECT id_perc FROM imp)), 0) AS ln_base04,

    -- 20. ISC (Impuesto Selectivo al Consumo)
    COALESCE((SELECT SUM((CASE WHEN cp.moneda_id = pen.moneda_pen_id THEN cpi.importe ELSE cpi.importe * cp.tasa_cambio_efectiva END)
            * CASE WHEN ti.signo = '-' THEN -1 ELSE 1 END * cp.flag_signo)
        FROM finanzas.cntas_pagar_det cpd
        JOIN finanzas.cntas_pagar_det_imp cpi ON cpi.cntas_pagar_det_id = cpd.id
        JOIN core.tipos_impuesto ti ON ti.id = cpi.tipos_impuesto_id
        CROSS JOIN pen
        WHERE cpd.cntas_pagar_id = cp.id AND cpd.flag_estado <> '0'
          AND ti.id = (SELECT id_isc FROM imp)), 0) AS ln_isc,

    -- Percepción
    COALESCE((SELECT SUM((CASE WHEN cp.moneda_id = pen.moneda_pen_id THEN cpi.importe ELSE cpi.importe * cp.tasa_cambio_efectiva END)
            * CASE WHEN ti.signo = '-' THEN -1 ELSE 1 END * cp.flag_signo)
        FROM finanzas.cntas_pagar_det cpd
        JOIN finanzas.cntas_pagar_det_imp cpi ON cpi.cntas_pagar_det_id = cpd.id
        JOIN core.tipos_impuesto ti ON ti.id = cpi.tipos_impuesto_id
        CROSS JOIN pen
        WHERE cpd.cntas_pagar_id = cp.id AND cpd.flag_estado <> '0'
          AND ti.id = (SELECT id_perc FROM imp)), 0) AS ln_percepcion,

    -- 21. Otros cargos o impuestos (no IGV, no ISC, no percepción)
    COALESCE((SELECT SUM((CASE WHEN cp.moneda_id = pen.moneda_pen_id THEN cpi.importe ELSE cpi.importe * cp.tasa_cambio_efectiva END)
            * CASE WHEN ti.signo = '-' THEN -1 ELSE 1 END * cp.flag_signo)
        FROM finanzas.cntas_pagar_det cpd
        JOIN finanzas.cntas_pagar_det_imp cpi ON cpi.cntas_pagar_det_id = cpd.id
        JOIN core.tipos_impuesto ti ON ti.id = cpi.tipos_impuesto_id
        CROSS JOIN pen
        WHERE cpd.cntas_pagar_id = cp.id AND cpd.flag_estado <> '0'
          AND ti.flag_igv = '0'
          AND ti.id NOT IN (SELECT id_isc FROM imp UNION SELECT id_perc FROM imp)), 0) AS ln_otros,

    -- 22. Importe Total del documento (base + todos los impuestos)
    COALESCE((SELECT SUM((CASE WHEN cp.moneda_id = pen.moneda_pen_id THEN cpd.monto ELSE cpd.monto * cp.tasa_cambio_efectiva END) * cp.flag_signo)
        FROM finanzas.cntas_pagar_det cpd CROSS JOIN pen
        WHERE cpd.cntas_pagar_id = cp.id AND cpd.flag_estado <> '0'), 0)
    + COALESCE((SELECT SUM((CASE WHEN cp.moneda_id = pen.moneda_pen_id THEN cpi.importe ELSE cpi.importe * cp.tasa_cambio_efectiva END)
            * CASE WHEN ti.signo = '-' THEN -1 ELSE 1 END * cp.flag_signo)
        FROM finanzas.cntas_pagar_det cpd
        JOIN finanzas.cntas_pagar_det_imp cpi ON cpi.cntas_pagar_det_id = cpd.id
        JOIN core.tipos_impuesto ti ON ti.id = cpi.tipos_impuesto_id
        CROSS JOIN pen
        WHERE cpd.cntas_pagar_id = cp.id AND cpd.flag_estado <> '0'), 0) AS ln_total,

    cp.origen || RIGHT('000000' || COALESCE(NULLIF(SUBSTRING(cp.voucher FROM 11 FOR 6), ''), '0'), 6) AS correlativo,
    cp.fecha_vencimiento AS vencimiento,
    cp.cod_sunat AS doc_tipo_sunat,

    CASE
        WHEN cp.cod_sunat IN ('46', '50', '51', '52', '53', '54') THEN
            CASE
                WHEN cp.serie IS NOT NULL THEN SUBSTRING(cp.serie FROM 2)
                ELSE SUBSTRING(cp.numero FROM 2 FOR POSITION('-' IN cp.numero) - 1)
            END
        WHEN cp.serie IS NULL OR cp.tipo_doc = 'LC' THEN cp.serie
        ELSE cp.serie
    END AS serie_cp,

    CASE
        WHEN cp.cod_sunat IN ('50', '52') THEN COALESCE(cp.serie, cp.numero)
        ELSE NULL
    END AS cod_dua,

    CASE
        WHEN cp.cod_sunat IN ('50', '52') THEN TO_CHAR(cp.fecha_emision, 'YYYY')
        ELSE NULL
    END AS ano_dua,

    CASE
        WHEN cp.cod_sunat IN ('46', '50', '51', '52', '53', '54') THEN
            CASE
                WHEN cp.numero IS NOT NULL AND cp.serie IS NOT NULL THEN LTRIM(cp.numero, '0')
                WHEN POSITION('-' IN cp.numero) > 0 THEN TRIM(SPLIT_PART(cp.numero, '-', 2))
                ELSE TRIM(cp.numero)
            END
        WHEN cp.numero IS NULL OR cp.tipo_doc = 'LC' THEN
            CASE
                WHEN POSITION('-' IN cp.numero) > 0 THEN TRIM(SPLIT_PART(cp.numero, '-', 2))
                ELSE TRIM(cp.numero)
            END
        ELSE LTRIM(cp.numero, '0')
    END AS numero_cp,

    cp.flag_signo,
    CASE WHEN cp.moneda_id = pen.moneda_pen_id THEN '01' ELSE '02' END AS moneda,
    cp.personeria,
    cp.tasa_cambio_efectiva AS tasa_cambio,
    ref.fec_emision_ref,
    ref.tipo_doc_ref,
    ref.serie_doc_ref,
    ref.nro_doc_ref,
    COALESCE(ref.serie_doc_ref || '-' || ref.nro_doc_ref, ref.nro_ref) AS nro_ref,
    det.fecha_deposito,
    det.nro_deposito,
    COALESCE(det.nro_detraccion, cp.nro_detraccion_cp) AS cp_nro_detraccion,
    CASE
        WHEN cp.flag_retencion = '1' THEN '1'
        WHEN EXISTS (
            SELECT 1 FROM finanzas.caja_bancos_det cbd
            WHERE cbd.cntas_pagar_id = cp.id AND cbd.flag_ret_igv = '1' AND cbd.flag_estado <> '0'
        ) THEN '1'
        ELSE '0'
    END AS flag_retencion,
    cp.oper_detr,
    cp.bien_serv,
    cp.tasa_pdbe AS detr_bien_serv_tasa_pdbe,
    cp.codigo_sunat AS detr_bien_serv_codigo_sunat,

    -- Base imponible del documento de referencia (NC/ND)
    COALESCE((
        SELECT SUM(cpd2.monto)
        FROM finanzas.cntas_pagar cp2
        JOIN finanzas.cntas_pagar_det cpd2 ON cpd2.cntas_pagar_id = cp2.id
        WHERE cp2.proveedor_id = cp.proveedor_id
          AND cp2.doc_tipo_id = (SELECT id FROM core.doc_tipo WHERE codigo = ref.tipo_ref LIMIT 1)
          AND cp2.numero = ref.nro_ref
          AND cp2.flag_estado <> '0'
    ), 0) AS base_imponible_ref,

    -- IGV del documento de referencia
    COALESCE((
        SELECT SUM(cpi2.importe)
        FROM finanzas.cntas_pagar cp2
        JOIN finanzas.cntas_pagar_det cpd2 ON cpd2.cntas_pagar_id = cp2.id
        JOIN finanzas.cntas_pagar_det_imp cpi2 ON cpi2.cntas_pagar_det_id = cpd2.id
        JOIN core.tipos_impuesto ti ON ti.id = cpi2.tipos_impuesto_id
        WHERE cp2.proveedor_id = cp.proveedor_id
          AND cp2.doc_tipo_id = (SELECT id FROM core.doc_tipo WHERE codigo = ref.tipo_ref LIMIT 1)
          AND cp2.numero = ref.nro_ref
          AND cp2.flag_estado <> '0'
          AND ti.flag_igv = '1'
    ), 0) AS igv_ref

FROM cp_base cp
CROSS JOIN pen
LEFT JOIN cp_refs ref ON ref.cntas_pagar_id = cp.id
LEFT JOIN finanzas.detraccion det ON det.cntas_pagar_id = cp.id AND det.flag_estado <> '0'
ORDER BY cp.nom_proveedor, cp.tipo_doc, cp.numero;
