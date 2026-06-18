-- Trazabilidad ERP: asientos contables y origen compra (actividad 7)

ALTER TABLE activos.af_maestro
    ADD COLUMN IF NOT EXISTS orden_compra_id BIGINT,
    ADD COLUMN IF NOT EXISTS orden_compra_linea_id BIGINT;

CREATE UNIQUE INDEX IF NOT EXISTS uq_af_maestro_oc_linea
    ON activos.af_maestro (orden_compra_id, orden_compra_linea_id)
    WHERE orden_compra_id IS NOT NULL AND orden_compra_linea_id IS NOT NULL;

ALTER TABLE activos.af_calculo_cntbl
    ADD COLUMN IF NOT EXISTS cntbl_asiento_id BIGINT;

ALTER TABLE activos.af_prima_devengo
    ADD COLUMN IF NOT EXISTS cntbl_asiento_id BIGINT;

ALTER TABLE activos.af_venta
    ADD COLUMN IF NOT EXISTS cntbl_asiento_id BIGINT;

ALTER TABLE activos.af_valuacion
    ADD COLUMN IF NOT EXISTS cntbl_asiento_id BIGINT;
