-- Issue #6: Movimientos del activo — traslados, adaptaciones, valuación y venta/baja.
-- Agrega columnas de estado y campos de workflow para soportar flujos completos.

-- ========== af_maestro: estado operativo del activo ==========
ALTER TABLE activos.af_maestro
    ADD COLUMN IF NOT EXISTS estado_activo VARCHAR(20) NOT NULL DEFAULT 'ACTIVO';

COMMENT ON COLUMN activos.af_maestro.estado_activo IS
    'Estado operativo: ACTIVO, DEPRECIANDOSE, BAJ_V, BAJ_S, BAJ_O, BAJ_D, RETIRADO';

-- ========== af_traslado: workflow solicitud→aprobación→ejecución ==========
ALTER TABLE activos.af_traslado
    ADD COLUMN IF NOT EXISTS estado              VARCHAR(20) NOT NULL DEFAULT 'SOLICITUD',
    ADD COLUMN IF NOT EXISTS fecha_programada    DATE,
    ADD COLUMN IF NOT EXISTS fecha_aprobacion    DATE,
    ADD COLUMN IF NOT EXISTS centro_costo_origen_id  BIGINT,
    ADD COLUMN IF NOT EXISTS centro_costo_destino_id BIGINT,
    ADD COLUMN IF NOT EXISTS responsable_ejecucion_id BIGINT,
    ADD COLUMN IF NOT EXISTS comentario_rechazo  TEXT;

COMMENT ON COLUMN activos.af_traslado.estado IS
    'Workflow: SOLICITUD → APROBADO → EJECUTADO | RECHAZADO | ANULADO';

CREATE INDEX IF NOT EXISTS ix_af_traslado_estado ON activos.af_traslado (estado);

-- ========== af_adaptacion: estado de capitalización ==========
ALTER TABLE activos.af_adaptacion
    ADD COLUMN IF NOT EXISTS estado VARCHAR(20) NOT NULL DEFAULT 'REGISTRADO';

COMMENT ON COLUMN activos.af_adaptacion.estado IS
    'Flujo: REGISTRADO → VALIDADO → CAPITALIZADO | ANULADO';

-- ========== af_valuacion: workflow de revaluación ==========
ALTER TABLE activos.af_valuacion
    ADD COLUMN IF NOT EXISTS estado              VARCHAR(20) NOT NULL DEFAULT 'EN_PROCESO',
    ADD COLUMN IF NOT EXISTS tipo_revaluacion    VARCHAR(20),
    ADD COLUMN IF NOT EXISTS fuente_revaluacion  VARCHAR(50),
    ADD COLUMN IF NOT EXISTS factor_revaluacion  NUMERIC(10, 6),
    ADD COLUMN IF NOT EXISTS documento_soporte   VARCHAR(30),
    ADD COLUMN IF NOT EXISTS nueva_vida_util     INTEGER,
    ADD COLUMN IF NOT EXISTS valor_residual      NUMERIC(18, 4);

COMMENT ON COLUMN activos.af_valuacion.estado IS
    'Workflow: EN_PROCESO → VALIDADO → APROBADO → CONTABILIZADO | ANULADO';

CREATE INDEX IF NOT EXISTS ix_af_valuacion_estado ON activos.af_valuacion (estado);

-- ========== af_venta: baja con tipo y cálculo de resultado ==========
ALTER TABLE activos.af_venta
    ADD COLUMN IF NOT EXISTS estado                    VARCHAR(20) NOT NULL DEFAULT 'EN_PROCESO',
    ADD COLUMN IF NOT EXISTS tipo_baja                 VARCHAR(20),
    ADD COLUMN IF NOT EXISTS tipo_documento_venta      VARCHAR(30),
    ADD COLUMN IF NOT EXISTS numero_documento          VARCHAR(30),
    ADD COLUMN IF NOT EXISTS depreciacion_acumulada    NUMERIC(18, 4),
    ADD COLUMN IF NOT EXISTS valor_neto_contable       NUMERIC(18, 4),
    ADD COLUMN IF NOT EXISTS resultado_baja            NUMERIC(18, 4),
    ADD COLUMN IF NOT EXISTS tipo_siniestro            VARCHAR(50),
    ADD COLUMN IF NOT EXISTS monto_indemnizacion       NUMERIC(18, 4),
    ADD COLUMN IF NOT EXISTS motivo_obsolescencia      VARCHAR(50),
    ADD COLUMN IF NOT EXISTS descripcion_detalle       TEXT;

COMMENT ON COLUMN activos.af_venta.estado IS
    'Workflow: EN_PROCESO → CONTABILIZADO → CERRADO | ANULADO';
COMMENT ON COLUMN activos.af_venta.tipo_baja IS
    'VENTA, SINIESTRO, OBSOLESCENCIA';
COMMENT ON COLUMN activos.af_venta.resultado_baja IS
    'Positivo = ganancia, negativo = pérdida';

CREATE INDEX IF NOT EXISTS ix_af_venta_estado ON activos.af_venta (estado);
