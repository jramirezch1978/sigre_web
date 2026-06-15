-- ============================================================
-- Órdenes de Servicio – DDL completo
-- Fecha  : 2026-04-21
-- Schema : compras
-- ============================================================

-- 1. orden_servicio (cabecera)
CREATE TABLE IF NOT EXISTS compras.orden_servicio (
    id                    BIGSERIAL       PRIMARY KEY,
    sucursal_id           BIGINT          NOT NULL,
    cod_origen            VARCHAR(10),
    nro_os                VARCHAR(20),
    proveedor_id          BIGINT          NOT NULL,
    nom_vendedor          VARCHAR(60),
    doc_tipo_id           BIGINT,
    fec_registro          DATE            NOT NULL,
    moneda_id             BIGINT,
    tipo_cambio           NUMERIC(10,4),
    forma_pago            VARCHAR(50),
    flag_req_serv         CHAR(1)         DEFAULT '0',
    flag_proveedor_compra CHAR(1)         DEFAULT '0',
    flag_solicita_acta    CHAR(1)         DEFAULT '0',
    sol_origen            VARCHAR(10),
    nro_sol_serv          VARCHAR(20),
    job                   VARCHAR(10),
    orden_trabajo_id      BIGINT,
    direccion_item        INTEGER,
    direccion             VARCHAR(4000),
    uo_dst_pago           VARCHAR(10),
    cod_banco             VARCHAR(20),
    nro_cuenta            VARCHAR(30),
    centro_beneficio      VARCHAR(20),
    monto_total           NUMERIC(18,4)   DEFAULT 0,
    descripcion           VARCHAR(2000),
    estado                VARCHAR(20)     DEFAULT 'GENERADA',
    flag_estado           CHAR(1)         DEFAULT '1',
    comprador_id          BIGINT,
    aprobador_id          BIGINT,
    fecha_aprob           TIMESTAMPTZ,
    motivo_anulacion      TEXT,
    created_by            BIGINT,
    fec_creacion          TIMESTAMPTZ     DEFAULT NOW(),
    updated_by            BIGINT,
    fec_modificacion      TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_orden_servicio_sucursal
    ON compras.orden_servicio (sucursal_id);

CREATE INDEX IF NOT EXISTS idx_orden_servicio_proveedor
    ON compras.orden_servicio (proveedor_id);

CREATE INDEX IF NOT EXISTS idx_orden_servicio_estado
    ON compras.orden_servicio (estado);

CREATE UNIQUE INDEX IF NOT EXISTS uq_orden_servicio_nro
    ON compras.orden_servicio (sucursal_id, cod_origen, nro_os)
    WHERE flag_estado = '1';

-- 2. orden_servicio_det (detalle / líneas)
CREATE TABLE IF NOT EXISTS compras.orden_servicio_det (
    id                    BIGSERIAL       PRIMARY KEY,
    orden_servicio_id     BIGINT          NOT NULL
        REFERENCES compras.orden_servicio (id),
    nro_item              INTEGER         NOT NULL,
    servicio_id           BIGINT          NOT NULL,
    descripcion           VARCHAR(2000),
    fec_proyect           DATE            NOT NULL,
    importe               NUMERIC(18,4)   NOT NULL,
    dscto_porcentaje      NUMERIC(7,4)    DEFAULT 0,
    decuento              NUMERIC(18,4)   DEFAULT 0,
    tipo_impuesto         VARCHAR(20),
    impuesto              NUMERIC(18,4)   DEFAULT 0,
    tipo_impuesto2        VARCHAR(20),
    impuesto2             NUMERIC(18,4)   DEFAULT 0,
    subtotal              NUMERIC(18,4)   DEFAULT 0,
    imp_provisionado      NUMERIC(18,4)   DEFAULT 0,
    cencos                VARCHAR(20),
    cnta_prsp             VARCHAR(20),
    centro_benef          VARCHAR(20),
    confin                VARCHAR(10),
    cod_maquina           VARCHAR(20),
    oper_sec              VARCHAR(20),
    conformidad_fecha     TIMESTAMPTZ,
    conformidad_usr       BIGINT,
    flag_estado           CHAR(1)         DEFAULT '1',
    created_by            BIGINT,
    fec_creacion          TIMESTAMPTZ     DEFAULT NOW(),
    updated_by            BIGINT,
    fec_modificacion      TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_os_det_orden
    ON compras.orden_servicio_det (orden_servicio_id);

CREATE INDEX IF NOT EXISTS idx_os_det_servicio
    ON compras.orden_servicio_det (servicio_id);

-- 3. num_ord_srv (numeración correlativa)
CREATE TABLE IF NOT EXISTS compras.num_ord_srv (
    id                    BIGSERIAL       PRIMARY KEY,
    sucursal_id           BIGINT          NOT NULL,
    cod_origen            VARCHAR(10)     NOT NULL,
    ult_nro               BIGINT          DEFAULT 0
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_num_ord_srv
    ON compras.num_ord_srv (sucursal_id, cod_origen);

-- 4. os_ajuste_valor (historial de ajustes de importe)
CREATE TABLE IF NOT EXISTS compras.os_ajuste_valor (
    id                    BIGSERIAL       PRIMARY KEY,
    orden_servicio_det_id BIGINT          NOT NULL
        REFERENCES compras.orden_servicio_det (id),
    importe_anterior      NUMERIC(18,4)   NOT NULL,
    importe_nuevo         NUMERIC(18,4)   NOT NULL,
    motivo                TEXT,
    created_by            BIGINT          NOT NULL,
    fec_creacion          TIMESTAMPTZ     DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_os_ajuste_det
    ON compras.os_ajuste_valor (orden_servicio_det_id);

-- 5. asignacion_os_oc (vínculo OS ↔ OC, cabecera)
CREATE TABLE IF NOT EXISTS compras.asignacion_os_oc (
    id                    BIGSERIAL       PRIMARY KEY,
    orden_servicio_id     BIGINT          NOT NULL
        REFERENCES compras.orden_servicio (id),
    orden_compra_id       BIGINT          NOT NULL
        REFERENCES compras.orden_compra (id),
    fecha_asignacion      TIMESTAMPTZ     DEFAULT NOW(),
    created_by            BIGINT,
    fec_creacion          TIMESTAMPTZ     DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_asig_os_oc_os
    ON compras.asignacion_os_oc (orden_servicio_id);

CREATE INDEX IF NOT EXISTS idx_asig_os_oc_oc
    ON compras.asignacion_os_oc (orden_compra_id);

CREATE UNIQUE INDEX IF NOT EXISTS uq_asig_os_oc
    ON compras.asignacion_os_oc (orden_servicio_id, orden_compra_id);

-- 6. asignacion_os_oc_det (detalle del vínculo)
CREATE TABLE IF NOT EXISTS compras.asignacion_os_oc_det (
    id                    BIGSERIAL       PRIMARY KEY,
    asignacion_os_oc_id   BIGINT          NOT NULL
        REFERENCES compras.asignacion_os_oc (id),
    orden_servicio_det_id BIGINT          NOT NULL
        REFERENCES compras.orden_servicio_det (id),
    orden_compra_det_id   BIGINT          NOT NULL
        REFERENCES compras.orden_compra_det (id),
    monto_aplicado        NUMERIC(18,4)   NOT NULL DEFAULT 0,
    created_by            BIGINT,
    fec_creacion          TIMESTAMPTZ     DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_asig_os_oc_det_asig
    ON compras.asignacion_os_oc_det (asignacion_os_oc_id);

-- 7. os_conformidad_log (bitácora de conformidad por línea)
CREATE TABLE IF NOT EXISTS compras.os_conformidad_log (
    id                    BIGSERIAL       PRIMARY KEY,
    orden_servicio_det_id BIGINT          NOT NULL
        REFERENCES compras.orden_servicio_det (id),
    accion                VARCHAR(20)     NOT NULL,
    usuario_id            BIGINT          NOT NULL,
    fecha                 TIMESTAMPTZ     DEFAULT NOW(),
    observacion           TEXT
);

CREATE INDEX IF NOT EXISTS idx_os_conf_log_det
    ON compras.os_conformidad_log (orden_servicio_det_id);
