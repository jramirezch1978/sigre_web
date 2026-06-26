-- ============================================================
-- Patch  : Compras - activar flujo aprobacion OC
-- Fecha  : 2026-06-09
-- Schemas: core, compras
-- Objetivo: aplicar sobre BD YA desplegada (template/clones).
--           Idempotente.
-- Refs    : Reporte QA 2026-06-08 (INC-05, INC-06)
-- Uso     : psql -f 20260609-compras-aprobacion-oc-config.sql
-- ============================================================

SET client_min_messages TO WARNING;

-- INC-05: Activar parametro de flujo de aprobacion
INSERT INTO config.configuracion (modulo, parametro, tipo_dato, valor_texto, editable, activo)
SELECT 'COMPRAS', 'COMPRA_APROBACION_OC', 'TEXT', '1', TRUE, TRUE
    WHERE NOT EXISTS (
    SELECT 1 FROM config.configuracion WHERE parametro = 'COMPRA_APROBACION_OC'
);

UPDATE config.configuracion
SET valor_texto = '1', modificado_en = NOW()
WHERE parametro = 'COMPRA_APROBACION_OC'
  AND valor_texto <> '1';

-- INC-06: Registrar aprobador por defecto (primer usuario activo como aprobador de OC)
INSERT INTO compras.aprobador_configurado
(doc_tipo_id, nivel, aprobador_id, monto_minimo, monto_maximo, flag_estado)
SELECT dt.id, 1, u.id, 0, 999999999, '1'
FROM auth.usuario u
         CROSS JOIN core.doc_tipo dt
WHERE dt.codigo = 'OC'
  AND u.flag_estado = '1'
  AND u.id = 1
  AND NOT EXISTS (
    SELECT 1 FROM compras.aprobador_configurado ac
    WHERE ac.doc_tipo_id = dt.id AND ac.nivel = 1
);
