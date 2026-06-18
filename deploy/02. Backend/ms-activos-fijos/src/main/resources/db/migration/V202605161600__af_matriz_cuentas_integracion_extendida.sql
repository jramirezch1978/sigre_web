-- Cuentas adicionales en matriz (seguro, alta OC, capitalización) y trazas de asiento

ALTER TABLE activos.af_matriz_sub_clase
    ADD COLUMN IF NOT EXISTS cuenta_gasto_seguro_id BIGINT,
    ADD COLUMN IF NOT EXISTS cuenta_pasivo_seguro_id BIGINT,
    ADD COLUMN IF NOT EXISTS cuenta_proveedor_transitoria_id BIGINT,
    ADD COLUMN IF NOT EXISTS cuenta_capitalizacion_id BIGINT;

ALTER TABLE activos.af_maestro
    ADD COLUMN IF NOT EXISTS cntbl_asiento_id BIGINT;

ALTER TABLE activos.af_adaptacion
    ADD COLUMN IF NOT EXISTS cntbl_asiento_id BIGINT;
