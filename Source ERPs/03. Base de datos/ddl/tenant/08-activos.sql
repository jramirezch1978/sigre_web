-- ============================================================
-- Restaurant.pe ERP - Tenant DB - activos schema
-- DROP de esquemas centralizado en 01-core.sql
-- ============================================================
--
-- DIAGRAMA DE RELACIONES (→ = tiene FK hacia):
--
--   af_clase (sin dependencias)
--   af_sub_clase → af_clase
--   af_ubicacion → auth.sucursal
--   af_maestro → af_sub_clase, af_ubicacion, core.entidad_contribuyente
--   af_software → af_maestro
--   af_tipo_operacion → contabilidad.matriz_contable
--   af_matriz_sub_clase → af_sub_clase
--   af_calculo_cntbl → af_maestro, af_tipo_operacion
--   af_adaptacion → af_maestro
--   af_adaptacion_det → af_adaptacion, core.unidad_medida
--   af_adaptacion_dep → af_adaptacion
--   af_accesorios → af_maestro
--   af_revaluacion → af_maestro
--   af_aseguradora (sin dependencias)
--   af_poliza_seguro → af_aseguradora
--   af_poliza_activo → af_poliza_seguro, af_maestro
--   af_prima_devengo → af_poliza_seguro
--   af_traslado → af_maestro, af_ubicacion (origen/destino)
--   af_venta → af_maestro
--   af_valuacion → af_maestro
--   af_operaciones → af_maestro
--   af_documento → af_maestro
--   af_historial → af_maestro
--   af_numeracion_config (sin dependencias)
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

CREATE SCHEMA IF NOT EXISTS activos;

-- ============================================================
-- CREATE (tablas, constraints e índices)
-- ============================================================

CREATE TABLE activos.af_clase (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(120) NOT NULL,
    metodo_depreciacion VARCHAR(30),
    vida_util_meses INTEGER,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE activos.af_sub_clase (
    id BIGSERIAL PRIMARY KEY,
    af_clase_id BIGINT NOT NULL REFERENCES activos.af_clase(id),
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    vida_util_meses INTEGER,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    UNIQUE (af_clase_id, codigo)
);

CREATE TABLE activos.af_ubicacion (
    id BIGSERIAL PRIMARY KEY,
    sucursal_id BIGINT NOT NULL REFERENCES auth.sucursal(id),
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    UNIQUE (sucursal_id, codigo)
);

CREATE TABLE activos.af_tipo_operacion (
    id                      BIGSERIAL       NOT NULL,
    codigo                  VARCHAR(10)     NOT NULL,
    descripcion             VARCHAR(150)    NOT NULL,
    naturaleza              VARCHAR(20)     NOT NULL,
    tipo_calculo            VARCHAR(30)     NOT NULL,
    tasa                    NUMERIC(8, 4),
    metodo_calculo          VARCHAR(30),
    cuenta_contable_id      BIGINT,
    centro_costo_id         BIGINT,
    afecta_contabilidad     BOOLEAN         NOT NULL DEFAULT TRUE,
    modulo_contable         VARCHAR(30),
    tipo_operacion_contable VARCHAR(60),
    observaciones           VARCHAR(500),
    flag_estado             VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by              BIGINT,
    fec_creacion            TIMESTAMPTZ     DEFAULT NOW(),
    updated_by              BIGINT,
    fec_modificacion        TIMESTAMPTZ,
    CONSTRAINT PK_AF_TIPO_OPERACION PRIMARY KEY (id),
    CONSTRAINT UQ_AF_TIPO_OPERACION_CODIGO UNIQUE (codigo)
);

CREATE TABLE activos.af_matriz_sub_clase (
    id                              BIGSERIAL   NOT NULL,
    af_sub_clase_id                 BIGINT      NOT NULL,
    cuenta_activo_id                BIGINT,
    cuenta_dep_acum_id              BIGINT,
    cuenta_gasto_dep_id             BIGINT,
    cuenta_baja_id                  BIGINT,
    cuenta_res_venta_id             BIGINT,
    centro_costo_id                 BIGINT,
    cuenta_gasto_seguro_id          BIGINT,
    cuenta_pasivo_seguro_id         BIGINT,
    cuenta_proveedor_transitoria_id BIGINT,
    cuenta_capitalizacion_id        BIGINT,
    flag_estado                     VARCHAR(1)  NOT NULL DEFAULT '1',
    created_by                      BIGINT,
    fec_creacion                    TIMESTAMPTZ DEFAULT NOW(),
    updated_by                      BIGINT,
    fec_modificacion                TIMESTAMPTZ,
    CONSTRAINT PK_AF_MATRIZ_SUB_CLASE PRIMARY KEY (id),
    CONSTRAINT FK_AF_MATRIZ_SUB_CLASE_01 FOREIGN KEY (af_sub_clase_id) REFERENCES activos.af_sub_clase(id),
    CONSTRAINT UQ_AF_MATRIZ_SUB_CLASE_SC UNIQUE (af_sub_clase_id)
);

CREATE TABLE activos.af_maestro (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(30) NOT NULL UNIQUE,
    nombre VARCHAR(220) NOT NULL,
    af_sub_clase_id BIGINT NOT NULL REFERENCES activos.af_sub_clase(id),
    af_ubicacion_id BIGINT REFERENCES activos.af_ubicacion(id),
    fecha_adquisicion DATE NOT NULL,
    valor_adquisicion NUMERIC(18, 4) NOT NULL,
    valor_residual NUMERIC(18, 4) NOT NULL DEFAULT 0,
    proveedor_id BIGINT REFERENCES core.entidad_contribuyente(id),
    factura_proveedor_serie VARCHAR(20),
    factura_proveedor_numero VARCHAR(30),
    factura_proveedor_fecha DATE,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE activos.af_software (
    id BIGSERIAL PRIMARY KEY,
    af_maestro_id BIGINT NOT NULL REFERENCES activos.af_maestro(id),
    licencia VARCHAR(120),
    proveedor_software VARCHAR(180),
    fecha_vigencia_ini DATE,
    fecha_vigencia_fin DATE,
    soporte VARCHAR(180),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE activos.af_calculo_cntbl (
    id BIGSERIAL PRIMARY KEY,
    af_maestro_id BIGINT NOT NULL REFERENCES activos.af_maestro(id),
    af_tipo_operacion_id BIGINT REFERENCES activos.af_tipo_operacion(id),
    anio INTEGER NOT NULL,
    mes INTEGER NOT NULL,
    depreciacion_periodo NUMERIC(18, 4) NOT NULL,
    depreciacion_acumulada NUMERIC(18, 4) NOT NULL DEFAULT 0,
    valor_neto NUMERIC(18, 4) NOT NULL,
    cntbl_asiento_id BIGINT,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    UNIQUE (af_maestro_id, anio, mes)
);

CREATE TABLE activos.af_adaptacion (
    id BIGSERIAL PRIMARY KEY,
    af_maestro_id BIGINT NOT NULL REFERENCES activos.af_maestro(id),
    fecha DATE NOT NULL,
    descripcion VARCHAR(300) NOT NULL,
    monto_total NUMERIC(18, 4) NOT NULL DEFAULT 0,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE activos.af_adaptacion_det (
    id BIGSERIAL PRIMARY KEY,
    af_adaptacion_id BIGINT NOT NULL REFERENCES activos.af_adaptacion(id),
    descripcion VARCHAR(300) NOT NULL,
    monto NUMERIC(18, 4) NOT NULL,
    unidad_medida_id BIGINT REFERENCES core.unidad_medida(id),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE activos.af_adaptacion_dep (
    id BIGSERIAL PRIMARY KEY,
    af_adaptacion_id BIGINT NOT NULL REFERENCES activos.af_adaptacion(id),
    anio INTEGER NOT NULL,
    mes INTEGER NOT NULL,
    depreciacion_periodo NUMERIC(18, 4) NOT NULL,
    depreciacion_acumulada NUMERIC(18, 4) NOT NULL DEFAULT 0,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    UNIQUE (af_adaptacion_id, anio, mes)
);

CREATE TABLE activos.af_accesorios (
    id BIGSERIAL NOT NULL,
    af_maestro_id BIGINT NOT NULL,
    descripcion VARCHAR(200) NOT NULL,
    costo NUMERIC(18, 4),
    fecha_instalacion DATE,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_AF_ACCESORIOS PRIMARY KEY (id),
    CONSTRAINT FK_AF_ACCESORIOS_01 FOREIGN KEY (af_maestro_id) REFERENCES activos.af_maestro(id)
);

CREATE TABLE activos.af_revaluacion (
    id BIGSERIAL NOT NULL,
    af_maestro_id BIGINT NOT NULL,
    fecha DATE NOT NULL,
    valor_anterior NUMERIC(18, 4),
    valor_nuevo NUMERIC(18, 4),
    sustento TEXT,
    perito_id BIGINT,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_AF_REVALUACION PRIMARY KEY (id),
    CONSTRAINT FK_AF_REVALUACION_01 FOREIGN KEY (af_maestro_id) REFERENCES activos.af_maestro(id)
);

CREATE TABLE activos.af_aseguradora (
    id BIGSERIAL NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    ruc VARCHAR(20),
    contacto VARCHAR(150),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_AF_ASEGURADORA PRIMARY KEY (id)
);

CREATE TABLE activos.af_poliza_seguro (
    id BIGSERIAL NOT NULL,
    af_aseguradora_id BIGINT NOT NULL,
    numero_poliza VARCHAR(30) NOT NULL UNIQUE,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    prima NUMERIC(18, 4),
    cobertura NUMERIC(18, 4),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_AF_POLIZA_SEGURO PRIMARY KEY (id),
    CONSTRAINT FK_AF_POLIZA_SEGURO_01 FOREIGN KEY (af_aseguradora_id) REFERENCES activos.af_aseguradora(id)
);

CREATE TABLE activos.af_poliza_activo (
    id BIGSERIAL NOT NULL,
    af_poliza_seguro_id BIGINT NOT NULL,
    af_maestro_id BIGINT NOT NULL,
    valor_asegurado NUMERIC(18, 4),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_AF_POLIZA_ACTIVO PRIMARY KEY (id),
    CONSTRAINT FK_AF_POLIZA_ACTIVO_01 FOREIGN KEY (af_poliza_seguro_id) REFERENCES activos.af_poliza_seguro(id),
    CONSTRAINT FK_AF_POLIZA_ACTIVO_02 FOREIGN KEY (af_maestro_id) REFERENCES activos.af_maestro(id)
);

CREATE TABLE activos.af_prima_devengo (
    id                      BIGSERIAL       NOT NULL,
    af_poliza_seguro_id     BIGINT          NOT NULL,
    anio                    INTEGER         NOT NULL,
    mes                     INTEGER         NOT NULL,
    importe_devengado       NUMERIC(18, 4)  NOT NULL,
    meses_vigencia_poliza   INTEGER,
    cntbl_asiento_id        BIGINT,
    flag_estado             VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by              BIGINT,
    fec_creacion            TIMESTAMPTZ     DEFAULT NOW(),
    updated_by              BIGINT,
    fec_modificacion        TIMESTAMPTZ,
    CONSTRAINT PK_AF_PRIMA_DEVENGO PRIMARY KEY (id),
    CONSTRAINT FK_AF_PRIMA_DEVENGO_01 FOREIGN KEY (af_poliza_seguro_id) REFERENCES activos.af_poliza_seguro(id),
    CONSTRAINT UQ_AF_PRIMA_DEVENGO_POLIZA_PERIODO UNIQUE (af_poliza_seguro_id, anio, mes)
);

CREATE TABLE activos.af_traslado (
    id BIGSERIAL NOT NULL,
    af_maestro_id BIGINT NOT NULL,
    ubicacion_origen_id BIGINT,
    ubicacion_destino_id BIGINT,
    solicitante_id BIGINT,
    aprobador_id BIGINT,
    fecha_solicitud DATE NOT NULL,
    fecha_ejecucion DATE,
    motivo TEXT,
    cntbl_asiento_id BIGINT,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_AF_TRASLADO PRIMARY KEY (id),
    CONSTRAINT FK_AF_TRASLADO_01 FOREIGN KEY (af_maestro_id) REFERENCES activos.af_maestro(id),
    CONSTRAINT FK_AF_TRASLADO_02 FOREIGN KEY (ubicacion_origen_id) REFERENCES activos.af_ubicacion(id),
    CONSTRAINT FK_AF_TRASLADO_03 FOREIGN KEY (ubicacion_destino_id) REFERENCES activos.af_ubicacion(id)
);

CREATE TABLE activos.af_venta (
    id BIGSERIAL NOT NULL,
    af_maestro_id BIGINT NOT NULL,
    cntas_cobrar_id BIGINT NOT NULL,
    doc_tipo_id BIGINT,
    serie_doc VARCHAR(4),
    nro_doc VARCHAR(10),
    fecha_baja DATE NOT NULL,
    motivo VARCHAR(3000) NOT NULL,
    valor_venta NUMERIC(18, 4),
    depreciacion_acumulada NUMERIC(18, 4),
    valor_neto_contable NUMERIC(18, 4),
    comprador VARCHAR(200),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_AF_VENTA PRIMARY KEY (id),
    CONSTRAINT FK_AF_VENTA_01 FOREIGN KEY (af_maestro_id) REFERENCES activos.af_maestro(id),
    CONSTRAINT FK_AF_VENTA_02 FOREIGN KEY (cntas_cobrar_id) REFERENCES ventas.cntas_cobrar(id),
    CONSTRAINT FK_AF_VENTA_03 FOREIGN KEY (doc_tipo_id) REFERENCES core.doc_tipo(id)
);

CREATE TABLE activos.af_valuacion (
    id                      BIGSERIAL       NOT NULL,
    af_maestro_id           BIGINT          NOT NULL,
    fecha_valuacion         DATE            NOT NULL,
    valor_anterior          NUMERIC(18, 4)  NOT NULL,
    valor_nuevo             NUMERIC(18, 4)  NOT NULL,
    metodo_valuacion        VARCHAR(50)     NOT NULL,
    tipo_revaluacion        VARCHAR(20),
    fuente_revaluacion      VARCHAR(50),
    factor_revaluacion      NUMERIC(10, 6),
    nueva_vida_util         INTEGER,
    valor_residual          NUMERIC(18, 4),
    documento_soporte       VARCHAR(30),
    responsable_id          BIGINT          NOT NULL,
    aprobador_id            BIGINT,
    fecha_aprobacion        DATE,
    estado                  VARCHAR(20)     NOT NULL DEFAULT 'EN_PROCESO',
    observaciones           VARCHAR(500),
    cntbl_asiento_id        BIGINT,
    flag_estado             VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by              BIGINT,
    fec_creacion            TIMESTAMPTZ     DEFAULT NOW(),
    updated_by              BIGINT,
    fec_modificacion        TIMESTAMPTZ,
    CONSTRAINT PK_AF_VALUACION PRIMARY KEY (id),
    CONSTRAINT FK_AF_VALUACION_01 FOREIGN KEY (af_maestro_id) REFERENCES activos.af_maestro(id)
);

CREATE TABLE activos.af_documento (
    id                  BIGSERIAL       NOT NULL,
    af_maestro_id       BIGINT          NOT NULL,
    tipo_documento      VARCHAR(50)     NOT NULL,
    nombre_archivo      VARCHAR(255)    NOT NULL,
    ruta_archivo        VARCHAR(500)    NOT NULL,
    descripcion         VARCHAR(500),
    fecha_carga         DATE            NOT NULL,
    tamanio_bytes       BIGINT,
    extension           VARCHAR(10),
    usuario_carga_id    BIGINT          NOT NULL,
    flag_estado         VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_AF_DOCUMENTO PRIMARY KEY (id),
    CONSTRAINT FK_AF_DOCUMENTO_01 FOREIGN KEY (af_maestro_id) REFERENCES activos.af_maestro(id)
);

CREATE TABLE activos.af_historial (
    id                  BIGSERIAL       NOT NULL,
    af_maestro_id       BIGINT          NOT NULL,
    tipo_evento         VARCHAR(50)     NOT NULL,
    descripcion         VARCHAR(500)    NOT NULL,
    valor_anterior      VARCHAR(200),
    valor_nuevo         VARCHAR(200),
    usuario_id          BIGINT          NOT NULL,
    fecha_evento        TIMESTAMPTZ     NOT NULL,
    ip_origen           VARCHAR(50),
    modulo              VARCHAR(50),
    flag_estado         VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_AF_HISTORIAL PRIMARY KEY (id),
    CONSTRAINT FK_AF_HISTORIAL_01 FOREIGN KEY (af_maestro_id) REFERENCES activos.af_maestro(id)
);

CREATE TABLE activos.af_numeracion_config (
    id                  BIGSERIAL       NOT NULL,
    tipo                VARCHAR(20)     NOT NULL,
    prefijo             VARCHAR(20)     NOT NULL DEFAULT 'AF',
    secuencia_actual    BIGINT          NOT NULL DEFAULT 0,
    longitud_numero     INTEGER         NOT NULL DEFAULT 6,
    flag_estado         VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_AF_NUMERACION_CONFIG PRIMARY KEY (id),
    CONSTRAINT UQ_AF_NUMERACION_CONFIG_TIPO UNIQUE (tipo)
);

CREATE TABLE activos.af_operaciones (
    id BIGSERIAL NOT NULL,
    af_maestro_id BIGINT NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    fecha_programada DATE,
    fecha_ejecucion DATE,
    costo NUMERIC(18, 4),
    proveedor_servicio VARCHAR(200),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_AF_OPERACIONES PRIMARY KEY (id),
    CONSTRAINT FK_AF_OPERACIONES_01 FOREIGN KEY (af_maestro_id) REFERENCES activos.af_maestro(id)
);

CREATE TABLE activos.af_maestro_cc_distrib (
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

-- ============================================================
-- SECCIÓN 3: ÍNDICES
-- ============================================================

CREATE UNIQUE INDEX uq_af_maestro_factura_proveedor
    ON activos.af_maestro (proveedor_id, factura_proveedor_serie, factura_proveedor_numero)
    WHERE factura_proveedor_serie IS NOT NULL AND factura_proveedor_numero IS NOT NULL;

CREATE INDEX idx_af_maestro_cc_maestro ON activos.af_maestro_cc_distrib (af_maestro_id);

CREATE INDEX IX_AF_MAESTRO_01 ON activos.af_maestro (af_sub_clase_id);
CREATE INDEX IX_AF_CALCULO_CNTBL_01 ON activos.af_calculo_cntbl (anio, mes);
CREATE INDEX IX_AF_ADAPTACION_01 ON activos.af_adaptacion (af_maestro_id, fecha);
CREATE INDEX IX_AF_ACCESORIOS_01 ON activos.af_accesorios (af_maestro_id);
CREATE INDEX IX_AF_REVALUACION_01 ON activos.af_revaluacion (af_maestro_id, fecha);
CREATE INDEX IX_AF_POLIZA_SEGURO_01 ON activos.af_poliza_seguro (af_aseguradora_id);
CREATE INDEX IX_AF_POLIZA_ACTIVO_01 ON activos.af_poliza_activo (af_poliza_seguro_id);
CREATE INDEX IX_AF_POLIZA_ACTIVO_02 ON activos.af_poliza_activo (af_maestro_id);
CREATE INDEX IX_AF_TRASLADO_01 ON activos.af_traslado (af_maestro_id);
CREATE INDEX IX_AF_TRASLADO_02 ON activos.af_traslado (fecha_solicitud);
CREATE INDEX IX_AF_VENTA_01 ON activos.af_venta (af_maestro_id);
CREATE INDEX IX_AF_TIPO_OPERACION_01 ON activos.af_tipo_operacion (modulo_contable, tipo_operacion_contable);
CREATE INDEX IX_AF_PRIMA_DEVENGO_01 ON activos.af_prima_devengo (af_poliza_seguro_id);
CREATE INDEX IX_AF_PRIMA_DEVENGO_02 ON activos.af_prima_devengo (anio, mes);
CREATE INDEX IX_AF_VALUACION_01 ON activos.af_valuacion (af_maestro_id);
CREATE INDEX IX_AF_VALUACION_02 ON activos.af_valuacion (fecha_valuacion);
CREATE INDEX IX_AF_DOCUMENTO_01 ON activos.af_documento (af_maestro_id);
CREATE INDEX IX_AF_HISTORIAL_01 ON activos.af_historial (af_maestro_id);
CREATE INDEX IX_AF_HISTORIAL_02 ON activos.af_historial (fecha_evento);
CREATE INDEX IX_AF_OPERACIONES_01 ON activos.af_operaciones (af_maestro_id);
CREATE INDEX IX_AF_OPERACIONES_02 ON activos.af_operaciones (fecha_programada);

-- FKs diferidas: contabilidad → activos (06-contabilidad se carga antes de 08-activos)
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_cntbl_asiento_det_af_maestro')
    THEN ALTER TABLE contabilidad.cntbl_asiento_det ADD CONSTRAINT fk_cntbl_asiento_det_af_maestro FOREIGN KEY (af_maestro_id) REFERENCES activos.af_maestro(id); END IF; END $$;

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_cntbl_preasiento_det_af_maestro')
    THEN ALTER TABLE contabilidad.cntbl_preasiento_det ADD CONSTRAINT fk_cntbl_preasiento_det_af_maestro FOREIGN KEY (af_maestro_id) REFERENCES activos.af_maestro(id); END IF; END $$;
