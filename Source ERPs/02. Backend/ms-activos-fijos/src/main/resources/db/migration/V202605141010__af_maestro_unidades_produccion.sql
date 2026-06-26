-- Unidades de producción para método UNIDADES_PRODUCIDAS (sin valores ficticios en código).
ALTER TABLE activos.af_maestro
    ADD COLUMN IF NOT EXISTS unidades_produccion_totales INTEGER;

ALTER TABLE activos.af_maestro
    ADD COLUMN IF NOT EXISTS unidades_produccion_periodo INTEGER;

COMMENT ON COLUMN activos.af_maestro.unidades_produccion_totales IS
    'Unidades totales proyectadas del activo (depreciación por unidades producidas).';

COMMENT ON COLUMN activos.af_maestro.unidades_produccion_periodo IS
    'Unidades producidas en el último período a depreciar (batch masivo); la API mensual puede sobrescribir con el cuerpo de la solicitud.';
