-- HU-AF-001 tipos de operación, TAB-007/008 numeración, traslado documento

CREATE TABLE IF NOT EXISTS activos.af_tipo_operacion (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(10) NOT NULL,
    descripcion VARCHAR(150) NOT NULL,
    naturaleza VARCHAR(20) NOT NULL,
    tipo_calculo VARCHAR(30) NOT NULL,
    cuenta_contable_id BIGINT,
    centro_costo_id BIGINT,
    afecta_contabilidad BOOLEAN NOT NULL DEFAULT TRUE,
    metodo_calculo VARCHAR(30),
    observaciones VARCHAR(500),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by BIGINT,
    fec_creacion TIMESTAMPTZ DEFAULT NOW(),
    updated_by BIGINT,
    fec_modificacion TIMESTAMPTZ,
    CONSTRAINT uq_af_tipo_operacion_codigo UNIQUE (codigo)
);

CREATE TABLE IF NOT EXISTS activos.af_numeracion_config (
    id BIGSERIAL PRIMARY KEY,
    tipo VARCHAR(20) NOT NULL,
    prefijo VARCHAR(20) NOT NULL DEFAULT 'AF',
    secuencia_actual BIGINT NOT NULL DEFAULT 0,
    longitud_numero INTEGER NOT NULL DEFAULT 6,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by BIGINT,
    fec_creacion TIMESTAMPTZ DEFAULT NOW(),
    updated_by BIGINT,
    fec_modificacion TIMESTAMPTZ,
    CONSTRAINT uq_af_numeracion_config_tipo UNIQUE (tipo)
);

INSERT INTO activos.af_numeracion_config (tipo, prefijo, secuencia_actual, longitud_numero)
VALUES ('MAESTRO', 'AF', 0, 6),
       ('TRASLADO', 'TR', 0, 6)
ON CONFLICT (tipo) DO NOTHING;

ALTER TABLE activos.af_operaciones
    ADD COLUMN IF NOT EXISTS af_tipo_operacion_id BIGINT;

ALTER TABLE activos.af_traslado
    ADD COLUMN IF NOT EXISTS numero_documento VARCHAR(30);

CREATE INDEX IF NOT EXISTS ix_af_operaciones_tipo_op ON activos.af_operaciones (af_tipo_operacion_id);
