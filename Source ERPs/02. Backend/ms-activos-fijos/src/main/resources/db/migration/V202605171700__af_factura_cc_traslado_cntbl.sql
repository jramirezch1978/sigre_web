-- Factura proveedor, distribución CC por activo, asiento en traslado

ALTER TABLE activos.af_maestro
    ADD COLUMN IF NOT EXISTS factura_proveedor_serie VARCHAR(20),
    ADD COLUMN IF NOT EXISTS factura_proveedor_numero VARCHAR(30),
    ADD COLUMN IF NOT EXISTS factura_proveedor_fecha DATE;

CREATE UNIQUE INDEX IF NOT EXISTS uq_af_maestro_factura_proveedor
    ON activos.af_maestro (proveedor_id, factura_proveedor_serie, factura_proveedor_numero)
    WHERE factura_proveedor_serie IS NOT NULL AND factura_proveedor_numero IS NOT NULL;

ALTER TABLE activos.af_traslado
    ADD COLUMN IF NOT EXISTS cntbl_asiento_id BIGINT;

CREATE TABLE IF NOT EXISTS activos.af_maestro_cc_distrib (
    id              BIGSERIAL PRIMARY KEY,
    af_maestro_id   BIGINT         NOT NULL REFERENCES activos.af_maestro (id),
    centro_costo_id BIGINT         NOT NULL,
    porcentaje      NUMERIC(7, 4)  NOT NULL,
    created_by      BIGINT,
    created_at      TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    updated_by      BIGINT,
    updated_at      TIMESTAMP,
    CONSTRAINT uq_af_maestro_cc UNIQUE (af_maestro_id, centro_costo_id),
    CONSTRAINT chk_af_maestro_cc_pct CHECK (porcentaje > 0 AND porcentaje <= 100)
);

CREATE INDEX IF NOT EXISTS idx_af_maestro_cc_maestro ON activos.af_maestro_cc_distrib (af_maestro_id);
