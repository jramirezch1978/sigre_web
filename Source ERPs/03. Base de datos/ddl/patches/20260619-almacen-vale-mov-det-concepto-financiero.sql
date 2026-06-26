-- ============================================================
-- Patch  : Almacen - integracion contable por concepto (Ruta B)
-- Fecha  : 2026-06-19
-- Schemas: almacen
-- Objetivo: aplicar sobre BD YA desplegada (template/clones).
--           Agrega vale_mov_det.concepto_financiero_id usada por el
--           endpoint contable nuevo (POST /api/almacen/movimientos/contable).
--           Idempotente. Columna nullable: no afecta el flujo legacy.
-- Refs    : Handoff "Integracion contable de movimientos de almacen (Ruta B)"
-- Uso     : psql -f 20260619-almacen-vale-mov-det-concepto-financiero.sql
-- ============================================================

SET client_min_messages TO WARNING;

ALTER TABLE almacen.vale_mov_det
    ADD COLUMN IF NOT EXISTS concepto_financiero_id BIGINT;

COMMENT ON COLUMN almacen.vale_mov_det.concepto_financiero_id IS
    'FK lógica a finanzas.concepto_financiero(id). Integración contable por concepto (Ruta B): cada línea contabilizable envía su concepto financiero a contabilidad (matriz_contable_id ← concepto.matriz_contable_id). Nullable: el flujo legacy (tipo_mov + grp_cntbl + cod_sub_cat) no la usa.';
