-- ms-activos-fijos: tablas para matriz contable por subclase, historial, documentos y devengo de primas.
-- Requiere esquema activos. La validación de cuentas usa contabilidad.plan_contable_det en runtime.

CREATE TABLE IF NOT EXISTS activos.af_matriz_sub_clase (
    id                  BIGSERIAL PRIMARY KEY,
    af_sub_clase_id     BIGINT NOT NULL UNIQUE REFERENCES activos.af_sub_clase (id),
    cuenta_activo_id    BIGINT,
    cuenta_dep_acum_id  BIGINT,
    cuenta_gasto_dep_id BIGINT,
    cuenta_baja_id      BIGINT,
    cuenta_res_venta_id BIGINT,
    centro_costo_id     BIGINT,
    flag_estado         VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS ix_af_matriz_sub_clase_01 ON activos.af_matriz_sub_clase (af_sub_clase_id);

CREATE TABLE IF NOT EXISTS activos.af_historial (
    id              BIGSERIAL PRIMARY KEY,
    af_maestro_id   BIGINT NOT NULL REFERENCES activos.af_maestro (id),
    tipo_evento     VARCHAR(50) NOT NULL,
    descripcion     VARCHAR(500) NOT NULL,
    valor_anterior  VARCHAR(200),
    valor_nuevo     VARCHAR(200),
    usuario_id      BIGINT NOT NULL,
    fecha_evento    TIMESTAMPTZ NOT NULL,
    ip_origen       VARCHAR(50),
    modulo          VARCHAR(50),
    flag_estado     VARCHAR(1) NOT NULL DEFAULT '1',
    created_by      BIGINT,
    fec_creacion    TIMESTAMPTZ DEFAULT NOW(),
    updated_by      BIGINT,
    fec_modificacion TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS ix_af_historial_maestro ON activos.af_historial (af_maestro_id, fecha_evento DESC);

CREATE TABLE IF NOT EXISTS activos.af_documento (
    id                 BIGSERIAL PRIMARY KEY,
    af_maestro_id      BIGINT NOT NULL REFERENCES activos.af_maestro (id),
    tipo_documento    VARCHAR(50) NOT NULL,
    nombre_archivo     VARCHAR(255) NOT NULL,
    ruta_archivo       VARCHAR(500) NOT NULL,
    descripcion        VARCHAR(500),
    fecha_carga        DATE NOT NULL,
    tamanio_bytes      BIGINT,
    extension          VARCHAR(10),
    usuario_carga_id   BIGINT NOT NULL,
    flag_estado        VARCHAR(1) NOT NULL DEFAULT '1',
    created_by         BIGINT,
    fec_creacion       TIMESTAMPTZ DEFAULT NOW(),
    updated_by         BIGINT,
    fec_modificacion   TIMESTAMPTZ,
    CONSTRAINT uq_af_documento_ruta UNIQUE (ruta_archivo)
);

CREATE INDEX IF NOT EXISTS ix_af_documento_maestro ON activos.af_documento (af_maestro_id);

CREATE TABLE IF NOT EXISTS activos.af_prima_devengo (
    id                   BIGSERIAL PRIMARY KEY,
    af_poliza_seguro_id  BIGINT NOT NULL REFERENCES activos.af_poliza_seguro (id),
    anio                 INTEGER NOT NULL,
    mes                  INTEGER NOT NULL,
    importe_devengado    NUMERIC(18, 4) NOT NULL,
    meses_vigencia_poliza INTEGER,
    flag_estado          VARCHAR(1) NOT NULL DEFAULT '1',
    created_by           BIGINT,
    fec_creacion         TIMESTAMPTZ DEFAULT NOW(),
    updated_by           BIGINT,
    fec_modificacion     TIMESTAMPTZ,
    UNIQUE (af_poliza_seguro_id, anio, mes)
);

CREATE INDEX IF NOT EXISTS ix_af_prima_devengo_poliza ON activos.af_prima_devengo (af_poliza_seguro_id);
