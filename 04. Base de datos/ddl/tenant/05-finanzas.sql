-- ============================================================
-- SIGRE ERP - Tenant DB - finanzas schema
-- DROP de esquemas centralizado en 01-core.sql
-- ============================================================
--
-- DIAGRAMA DE RELACIONES (→ = tiene FK hacia):
--
--   banco_cnta → core.moneda, contabilidad.plan_contable_det (FK plan_contable_det_id en 06-contabilidad.sql)
--   grupo_concepto_financiero (sin dependencias)
--   concepto_financiero → grupo_concepto_financiero (opcional), contabilidad.matriz_contable (FK en 06-contabilidad.sql)
--   actividad_flujo_caja (sin dependencias; legacy FIN_ACTIVIDAD_FLUJO)
--   grupo_codigo_flujo_caja → actividad_flujo_caja
--   codigo_flujo_caja → grupo_codigo_flujo_caja
--   cntas_pagar → auth.sucursal, core.entidad_contribuyente, core.doc_tipo, core.moneda, core.forma_pago,
--                 core.detr_bien_serv, contabilidad.cntbl_libro (FK diferida en 06-contabilidad.sql)
--   cntas_pagar_det → cntas_pagar, concepto_financiero, core.articulo, core.credito_fiscal (credito_fiscal_id),
--   cntas_pagar_det_imp → cntas_pagar_det, core.tipos_impuesto (impuestos por ítem),
--                     core.doc_tipo, compras.orden_compra_det, compras.orden_servicio_det, almacen.vale_mov_det,
--                     auth.sucursal (ref), rrhh.trabajador (diferida), contabilidad.centros_costo (diferida)
--   caja_bancos → banco_cnta, finanzas.concepto_financiero (obligatorio)
--   caja_bancos_det → caja_bancos; core.entidad_contribuyente, core.doc_tipo; cntas_pagar, ventas.cntas_cobrar,
--                     solicitud_giro, liquidacion, concepto_financiero, auth.sucursal (ref), codigo_flujo_caja,
--                     banco_cnta (proveedor); core.moneda; contabilidad.centros_costo (FK en 06-contabilidad.sql)
--   conciliacion_bancaria → banco_cnta
--   conciliacion_det → conciliacion_bancaria, caja_bancos
--   solicitud_giro → core.entidad_contribuyente, auth.usuario (modalidad G/F; tipo ADELANTO/DEVOLUCION; devolución con auditoría)
--   liquidacion → solicitud_giro, core.doc_tipo, core.entidad_contribuyente, core.moneda, concepto_financiero (obligatorio), auth.usuario
--   liquidacion_det → liquidacion, core.moneda, concepto_financiero (obligatorio), cntas_pagar, ventas.cntas_cobrar
--   autorizador_giro → auth.usuario (FK a contabilidad.centros_costo se agrega en 06-contabilidad.sql)

--   programacion_pago (sin dependencias)
--   programacion_pago_det → programacion_pago, cntas_pagar
--   fondo_fijo → auth.sucursal
--   rendicion_gasto → fondo_fijo
--   pago → cntas_pagar, banco_cnta, core.forma_pago
--   flujo_caja_proyectado (sin dependencias)
--   detraccion → cntas_pagar
--   retencion → cntas_pagar, core.entidad_contribuyente (proveedor_id), auth.sucursal, caja_bancos
--   flujo_caja → auth.sucursal
--   saldo_banco_mes → banco_cnta
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

CREATE SCHEMA IF NOT EXISTS finanzas;

-- ============================================================
-- SECCIÓN 2: CREATE (tablas, constraints)
-- ============================================================

-- Maestro de bancos — base SIGRE BANCO (movido desde core)
CREATE TABLE finanzas.banco (
    id                  BIGSERIAL       NOT NULL,
    cod_banco           CHAR(3)         NOT NULL UNIQUE,
    nom_banco           VARCHAR(120),
    proveedor           VARCHAR(8),
    cod_banco_rtps      CHAR(2),
    direccion           VARCHAR(200),
    swift               VARCHAR(20),
    cod_banco_sunat     CHAR(2),
    flag_estado         VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_BANCO PRIMARY KEY (id)
);

-- Maestro de cuentas bancarias propias — base SIGRE BANCO_CNTA
CREATE TABLE finanzas.banco_cnta (
    id                  BIGSERIAL       NOT NULL,
    cod_ctabco          VARCHAR(30)     NOT NULL UNIQUE,
    -- FK → contabilidad.plan_contable_det(id); constraint FK_BANCO_CNTA_PLAN_CONTABLE_DET en 06-contabilidad.sql (tras CREATE plan_contable_det)
    plan_contable_det_id BIGINT          NOT NULL,
    banco_id            BIGINT          NOT NULL,
    tipo_ctabco         CHAR(1),
    descripcion         VARCHAR(200),
    correlativo_cheque  INTEGER,
    moneda_id           BIGINT,
    saldo_disponible    NUMERIC(18,4),
    sldo_contable       NUMERIC(18,4),
    sldo_bancario       NUMERIC(18,4),
    sucursal_id         BIGINT          REFERENCES auth.sucursal(id),
    flag_uso_interno    CHAR(1)         DEFAULT '0',
    flag_estado VARCHAR(1)         DEFAULT '1',
    nro_cci             VARCHAR(30),
    flag_flujo_caja     CHAR(1)         DEFAULT '1',
    nro_cuenta          VARCHAR(30),
    flag_facturacion_simpl CHAR(1)      DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_BANCO_CNTA PRIMARY KEY (id),
    CONSTRAINT FK_BANCO_CNTA_BANCO FOREIGN KEY (banco_id) REFERENCES finanzas.banco(id),
    CONSTRAINT FK_BANCO_CNTA_MONEDA FOREIGN KEY (moneda_id) REFERENCES core.moneda(id)
);

-- Grupo de conceptos financieros (legacy COFIN_GRUPO / SIGRE).
CREATE TABLE finanzas.grupo_concepto_financiero (
    id                  BIGSERIAL       NOT NULL,
    codigo              VARCHAR(20)     NOT NULL UNIQUE,
    nombre              VARCHAR(150)    NOT NULL,
    flag_estado         VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_GRUPO_CONCEPTO_FINANCIERO PRIMARY KEY (id)
);

COMMENT ON TABLE finanzas.grupo_concepto_financiero IS
    'Agrupación de conceptos financieros (legacy COFIN_GRUPO).';

CREATE TABLE finanzas.concepto_financiero (
    -- Maestro: catálogo de conceptos financieros
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    matriz_contable_id  BIGINT          NOT NULL,
    grupo_concepto_financiero_id BIGINT  REFERENCES finanzas.grupo_concepto_financiero(id),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

-- Actividad de flujo de caja (legacy FIN_ACTIVIDAD_FLUJO).
CREATE TABLE finanzas.actividad_flujo_caja (
    id                  BIGSERIAL       NOT NULL,
    codigo              CHAR(2)         NOT NULL,
    nombre              VARCHAR(200)    NOT NULL,
    orden               INTEGER         NOT NULL DEFAULT 0,
    flag_tipo_flujo     CHAR(1)         NOT NULL DEFAULT 'E',
    flag_estado         VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_ACTIVIDAD_FLUJO_CAJA PRIMARY KEY (id),
    CONSTRAINT UQ_ACTIVIDAD_FLUJO_CAJA_CODIGO UNIQUE (codigo)
);

COMMENT ON TABLE finanzas.actividad_flujo_caja IS
    'Actividades de flujo de caja: operaciones, inversiones, financiamiento (legacy FIN_ACTIVIDAD_FLUJO).';
COMMENT ON COLUMN finanzas.actividad_flujo_caja.flag_tipo_flujo IS 'Tipo de flujo: E = Flujo Económico, F = Flujo Financiero.';

-- Grupo de codigos de flujo de caja (legacy GRUPO_COD_FLUJO_CAJA).
CREATE TABLE finanzas.grupo_codigo_flujo_caja (
    id                  BIGSERIAL       NOT NULL,
    codigo              VARCHAR(20)     NOT NULL UNIQUE,
    nombre              VARCHAR(150),
    flag_reporte        CHAR(1),
    factor              CHAR(1),
    orden               INTEGER         NOT NULL DEFAULT 0,
    actividad_flujo_caja_id BIGINT      NOT NULL,
    flag_estado VARCHAR(1)         NOT NULL DEFAULT '1',
    fec_registro        DATE            NOT NULL DEFAULT CURRENT_DATE,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_GRUPO_CODIGO_FLUJO_CAJA PRIMARY KEY (id),
    CONSTRAINT FK_GRUPO_COD_FLUJO_ACTIVIDAD FOREIGN KEY (actividad_flujo_caja_id)
        REFERENCES finanzas.actividad_flujo_caja(id)
);

COMMENT ON COLUMN finanzas.grupo_codigo_flujo_caja.flag_reporte IS 'Tipo para reporte: G = Grupo, S = Subgrupo.';
COMMENT ON COLUMN finanzas.grupo_codigo_flujo_caja.factor IS 'Factor del grupo: I = Ingreso (+1), E = Egreso (-1).';

CREATE TABLE finanzas.codigo_flujo_caja (
    -- Maestro: catálogo de códigos de flujo de caja
    id                          BIGSERIAL       NOT NULL,
    codigo                      VARCHAR(20)     NOT NULL UNIQUE,
    grupo_codigo_flujo_caja_id  BIGINT,
    nombre                      VARCHAR(150)    NOT NULL,
    tipo                        VARCHAR(20)     NOT NULL,
    factor                      NUMERIC(12,3),
    factor_flujo_caja           SMALLINT        DEFAULT 0,
    orden                       INTEGER         NOT NULL DEFAULT 0,
    fec_registro                DATE            NOT NULL DEFAULT CURRENT_DATE,
    cod_usr                     VARCHAR(20),
    flag_estado VARCHAR(1)         NOT NULL DEFAULT '1',
    created_by                  BIGINT,
    fec_creacion                TIMESTAMPTZ     DEFAULT NOW(),
    updated_by                  BIGINT,
    fec_modificacion            TIMESTAMPTZ,
    CONSTRAINT PK_CODIGO_FLUJO_CAJA PRIMARY KEY (id),
    CONSTRAINT FK_CODIGO_FLUJO_CAJA_01 FOREIGN KEY (grupo_codigo_flujo_caja_id) REFERENCES finanzas.grupo_codigo_flujo_caja(id)
);
COMMENT ON COLUMN finanzas.codigo_flujo_caja.factor IS 'Factor numérico del concepto: 1 = Ingreso, -1 = Egreso.';

CREATE TABLE finanzas.cntas_pagar (
    id BIGSERIAL PRIMARY KEY,
    sucursal_id BIGINT NOT NULL REFERENCES auth.sucursal(id),
    proveedor_id BIGINT NOT NULL REFERENCES core.entidad_contribuyente(id),
    doc_tipo_id BIGINT NOT NULL REFERENCES core.doc_tipo(id),
    serie VARCHAR(10),
    numero VARCHAR(20),
    fecha_emision DATE NOT NULL,
    fecha_vencimiento DATE,
    fecha_registro DATE NOT NULL DEFAULT CURRENT_DATE,
    moneda_id BIGINT REFERENCES core.moneda(id) NOT NULL,
    tasa_cambio NUMERIC(11, 4) NOT NULL DEFAULT 1,
    total NUMERIC(18, 4) NOT NULL DEFAULT 0,
    saldo NUMERIC(18, 4) NOT NULL DEFAULT 0,
    descripcion VARCHAR(2000),
    forma_pago_id BIGINT REFERENCES core.forma_pago(id),
    ano INTEGER NOT NULL,
    mes INTEGER NOT NULL,
    cntbl_libro_id BIGINT NOT NULL,
    cod_origen VARCHAR(2),
    oper_detr CHAR(2),
    detr_bien_serv_id BIGINT REFERENCES core.detr_bien_serv(id),
    nro_detraccion VARCHAR(12),
    flag_detraccion CHAR(1) NOT NULL DEFAULT '0',
    importe_detraccion NUMERIC(18, 4) NOT NULL DEFAULT 0,
    flag_retencion CHAR(1) NOT NULL DEFAULT '0',
    porc_ret_igv NUMERIC(5, 2) DEFAULT 0,
    cntbl_asiento_id BIGINT,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    UNIQUE (proveedor_id, doc_tipo_id, serie, numero)
);

COMMENT ON COLUMN finanzas.cntas_pagar.tasa_cambio IS
    'Tipo de cambio del documento; origen: core.fn_tasa_cambio_calendario(fecha, id_moneda_origen, id_moneda_destino) al registrar la CxP.';
COMMENT ON COLUMN finanzas.cntas_pagar.ano IS 'Año del periodo contable (SIGRE: ANO).';
COMMENT ON COLUMN finanzas.cntas_pagar.mes IS 'Mes del periodo contable (SIGRE: MES).';
COMMENT ON COLUMN finanzas.cntas_pagar.cntbl_libro_id IS 'Libro contable (SIGRE: NRO_LIBRO → FK contabilidad.cntbl_libro.id).';
COMMENT ON COLUMN finanzas.cntas_pagar.cod_origen IS 'Código origen legacy (2 chars) para correlativo SUNAT.';
COMMENT ON COLUMN finanzas.cntas_pagar.cntbl_asiento_id IS
    'FK al asiento contable de provisión; correlativo SUNAT desde contabilidad.cntbl_asiento.voucher.';

CREATE TABLE finanzas.cntas_pagar_det (
    id BIGSERIAL PRIMARY KEY,
    cntas_pagar_id BIGINT NOT NULL REFERENCES finanzas.cntas_pagar(id),
    item                    INTEGER         NOT NULL,
    concepto_financiero_id  BIGINT          NOT NULL,
    descripcion             VARCHAR(2000)   NOT NULL,
    articulo_id             BIGINT          REFERENCES core.articulo(id),
    cantidad                NUMERIC(12, 4)  NOT NULL DEFAULT 0,
    precio_unitario         NUMERIC(17, 8)  NOT NULL DEFAULT 0,
    monto                   NUMERIC(18, 4)  NOT NULL,
    centros_costo_id        BIGINT          NOT NULL,                                  -- FK diferida → contabilidad.centros_costo(id) en 06-contabilidad.sql
    credito_fiscal_id       BIGINT          NOT NULL REFERENCES core.credito_fiscal(id),
    orden_compra_det_id     BIGINT          REFERENCES compras.orden_compra_det(id),
    orden_servicio_det_id   BIGINT          REFERENCES compras.orden_servicio_det(id),
    vale_mov_det_id         BIGINT          REFERENCES almacen.vale_mov_det(id),
    sucursal_ref_id         BIGINT          REFERENCES auth.sucursal(id),
    doc_tipo_ref_id         BIGINT          REFERENCES core.doc_tipo(id),
    nro_ref                 VARCHAR(12),
    item_ref                INTEGER,
    fec_movilidad           DATE,
    mov_desde               VARCHAR(200),
    mov_hasta               VARCHAR(200),
    trabajador_id           BIGINT,                                                    -- FK diferida → rrhh.trabajador(id) en 07-rrhh.sql
    fecha_mov DATE NOT NULL,
    tipo_mov VARCHAR(20) NOT NULL,
    referencia VARCHAR(120),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT FK_CNTAS_PAGAR_DET_CONCEPTO_FIN FOREIGN KEY (concepto_financiero_id) REFERENCES finanzas.concepto_financiero(id)
);

-- Caja y bancos — base SIGRE CAJA_BANCOS (38 columnas)
CREATE TABLE finanzas.caja_bancos (
    id                    BIGSERIAL       NOT NULL,
    sucursal_id           BIGINT          NOT NULL REFERENCES auth.sucursal(id),
    nro_registro          VARCHAR(12)     NOT NULL UNIQUE,
    flag_estado           VARCHAR(1)      NOT NULL DEFAULT '1',
    fecha_emision         DATE,
    fecha_programada      DATE,
    fecha_ejecucion       DATE,
    flag_pago             CHAR(1),
    moneda_id             BIGINT          REFERENCES core.moneda(id),
    entidad_contribuyente_id BIGINT       REFERENCES core.entidad_contribuyente(id),
    imp_total             NUMERIC(18,4)   DEFAULT 0,
    imp_asignado          NUMERIC(18,4)   DEFAULT 0,
    registro_ref_id       BIGINT          REFERENCES finanzas.caja_bancos(id),
    impreso               SMALLINT,
    banco_cnta_id         BIGINT          REFERENCES finanzas.banco_cnta(id),
    banco_cnta_ref_id     BIGINT          REFERENCES finanzas.banco_cnta(id),
    reg_cheque            INTEGER,
    fecha_cobro_chq       DATE,
    concepto_financiero_id BIGINT        NOT NULL REFERENCES finanzas.concepto_financiero(id),
    ano                   INTEGER         NOT NULL,
    mes                   INTEGER         NOT NULL,
    cntbl_libro_id        BIGINT          NOT NULL,
    cntbl_asiento_id      BIGINT,
    flag_tipo_transaccion CHAR(1),
    observacion           VARCHAR(500),
    flag_adelanto         CHAR(1)         DEFAULT '0',
    doc_tipo_id           BIGINT          REFERENCES core.doc_tipo(id),
    nro_doc               VARCHAR(12),
    flag_conciliacion     CHAR(1),
    tasa_cambio           NUMERIC(11,8)   DEFAULT 0,
    medio_pago_id         BIGINT          REFERENCES core.catalogo_sunat_det(id),
    flag_padron_sunat     CHAR(1),
    facturacion_simpl_id  BIGINT,                                      -- FK diferida a finanzas.facturacion_simplificada(id) (tabla pendiente de creación)
    flag_forma_pago_fs    CHAR(1),
    fact_simpl_pago_id    BIGINT,                                      -- FK diferida a finanzas.facturacion_simplificada_pagos(id) (tabla pendiente de creación)
    created_by            BIGINT,
    fec_creacion          TIMESTAMPTZ     DEFAULT NOW(),
    updated_by            BIGINT,
    fec_modificacion      TIMESTAMPTZ,
    CONSTRAINT PK_CAJA_BANCOS PRIMARY KEY (id)
);

COMMENT ON COLUMN finanzas.caja_bancos.ano IS 'Año del periodo contable (SIGRE: ANO).';
COMMENT ON COLUMN finanzas.caja_bancos.mes IS 'Mes del periodo contable (SIGRE: MES).';
COMMENT ON COLUMN finanzas.caja_bancos.cntbl_libro_id IS 'Libro contable (SIGRE: NRO_LIBRO → FK contabilidad.cntbl_libro.id).';

-- Caja y bancos detalle (legado SIGRE); FK como en cntas_pagar_det — identificadores *_id
CREATE TABLE finanzas.caja_bancos_det (
    id                        BIGSERIAL       NOT NULL,
    caja_bancos_id            BIGINT          NOT NULL,
    item                      SMALLINT        NOT NULL DEFAULT 1,
    entidad_contribuyente_id  BIGINT          NOT NULL,
    doc_tipo_id               BIGINT          NOT NULL,
    nro_doc                   VARCHAR(12)     NOT NULL,
    importe                   NUMERIC(18,4)   NOT NULL DEFAULT 0,
    cntas_pagar_id            BIGINT,
    cntas_cobrar_id           BIGINT,
    solicitud_giro_id         BIGINT,
    liquidacion_id            BIGINT,
    concepto_financiero_id    BIGINT,
    flag_cxp                  CHAR(1),
    sucursal_ref_id           BIGINT,
    impt_ret_igv              NUMERIC(18,4)   DEFAULT 0,
    flag_ret_igv              CHAR(1)         DEFAULT '0',
    flag_referencia           CHAR(1),
    moneda_id                 BIGINT,
    flag_flujo_caja           CHAR(1)         DEFAULT '1',
    factor                    SMALLINT        DEFAULT 0,
    flag_provisionado         CHAR(1),
    centros_costo_id          BIGINT,
    flag_aplic_comp           CHAR(1)         DEFAULT '0',
    codigo_flujo_caja_id      BIGINT,
    banco_cnta_prov_id        BIGINT,
    flag_estado               VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by                BIGINT,
    fec_creacion              TIMESTAMPTZ     DEFAULT NOW(),
    updated_by                BIGINT,
    fec_modificacion          TIMESTAMPTZ,
    CONSTRAINT PK_CAJA_BANCOS_DET PRIMARY KEY (id),
    CONSTRAINT FK_CAJA_BANCOS_DET_01 FOREIGN KEY (caja_bancos_id) REFERENCES finanzas.caja_bancos(id),
    CONSTRAINT FK_CAJA_BANCOS_DET_02 FOREIGN KEY (moneda_id) REFERENCES core.moneda(id),
    CONSTRAINT FK_CAJA_BANCOS_DET_03 FOREIGN KEY (entidad_contribuyente_id) REFERENCES core.entidad_contribuyente(id),
    CONSTRAINT FK_CAJA_BANCOS_DET_04 FOREIGN KEY (doc_tipo_id) REFERENCES core.doc_tipo(id),
    CONSTRAINT FK_CAJA_BANCOS_DET_05 FOREIGN KEY (cntas_pagar_id) REFERENCES finanzas.cntas_pagar(id),
    CONSTRAINT FK_CAJA_BANCOS_DET_06 FOREIGN KEY (cntas_cobrar_id) REFERENCES ventas.cntas_cobrar(id),
    CONSTRAINT FK_CAJA_BANCOS_DET_07 FOREIGN KEY (concepto_financiero_id) REFERENCES finanzas.concepto_financiero(id),
    CONSTRAINT FK_CAJA_BANCOS_DET_08 FOREIGN KEY (sucursal_ref_id) REFERENCES auth.sucursal(id),
    CONSTRAINT FK_CAJA_BANCOS_DET_09 FOREIGN KEY (codigo_flujo_caja_id) REFERENCES finanzas.codigo_flujo_caja(id),
    CONSTRAINT FK_CAJA_BANCOS_DET_10 FOREIGN KEY (banco_cnta_prov_id) REFERENCES finanzas.banco_cnta(id)
);

CREATE TABLE finanzas.conciliacion_bancaria (
    id                BIGSERIAL       NOT NULL,
    banco_cnta_id     BIGINT          NOT NULL,
    periodo_anio      INTEGER         NOT NULL,
    periodo_mes       INTEGER         NOT NULL,
    saldo_banco       NUMERIC(18, 4),
    saldo_libros      NUMERIC(18, 4),
    diferencia        NUMERIC(18, 4),
    flag_estado       VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CONCILIACION_BANCARIA PRIMARY KEY (id),
    CONSTRAINT FK_CONCILIACION_BANCARIA_01 FOREIGN KEY (banco_cnta_id) REFERENCES finanzas.banco_cnta(id)
);

CREATE TABLE finanzas.conciliacion_det (
    id                BIGSERIAL       NOT NULL,
    conciliacion_id   BIGINT          NOT NULL,
    caja_bancos_id    BIGINT,
    conciliado        BOOLEAN         NOT NULL DEFAULT FALSE,
    observacion       TEXT,
    flag_estado       VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CONCILIACION_DET PRIMARY KEY (id),
    CONSTRAINT FK_CONCILIACION_DET_01 FOREIGN KEY (conciliacion_id) REFERENCES finanzas.conciliacion_bancaria(id),
    CONSTRAINT FK_CONCILIACION_DET_02 FOREIGN KEY (caja_bancos_id) REFERENCES finanzas.caja_bancos(id)
);


CREATE TABLE finanzas.solicitud_giro (
    id                               BIGSERIAL       NOT NULL,
    numero                           VARCHAR(12)     NOT NULL UNIQUE,
    sucursal_id                      BIGINT          NOT NULL REFERENCES auth.sucursal(id),
    solicitante_id                   BIGINT,
    fecha                            DATE            NOT NULL,
    monto                            NUMERIC(18, 4)  NOT NULL,
    motivo                           TEXT,
    tipo_solicitud                   CHAR(1)        NOT NULL DEFAULT 'O', -- O => Orden de Giro, F => Fondo Fijo
    centros_costo_id                 BIGINT,                                                     -- FK diferida → contabilidad.centros_costo(id) en 06-contabilidad.sql
    aprobador_id                     BIGINT,
    fec_aprobacion                   TIMESTAMPTZ,
    fec_rechazo                      TIMESTAMPTZ,
    motivo_rechazo                   TEXT,
    motivo_devolucion                TEXT,
    aprobador_devolucion_id          BIGINT,
    fec_aprobacion_devolucion        TIMESTAMPTZ,
    fec_rechazo_devolucion           TIMESTAMPTZ,
    motivo_rechazo_devolucion        TEXT,
    flag_estado_devolucion           VARCHAR(1),
    flag_estado                      VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by                       BIGINT,
    fec_creacion                     TIMESTAMPTZ     DEFAULT NOW(),
    updated_by                       BIGINT,
    fec_modificacion                 TIMESTAMPTZ,
    CONSTRAINT PK_SOLICITUD_GIRO PRIMARY KEY (id),
    CONSTRAINT FK_SOLICITUD_GIRO_SOLICITANTE FOREIGN KEY (solicitante_id) REFERENCES auth.usuario(id),
    CONSTRAINT FK_SOLICITUD_GIRO_APROBADOR FOREIGN KEY (aprobador_id) REFERENCES auth.usuario(id),
    CONSTRAINT FK_SOLICITUD_GIRO_APROB_DEV FOREIGN KEY (aprobador_devolucion_id) REFERENCES auth.usuario(id),
    CONSTRAINT CK_SOLICITUD_GIRO_TIPO CHECK (tipo_solicitud IN ('O', 'F')),
    CONSTRAINT CK_SOLICITUD_GIRO_DEVOL_FLAG CHECK (flag_estado_devolucion IS NULL OR flag_estado_devolucion IN ('A', 'R'))
);

COMMENT ON COLUMN finanzas.solicitud_giro.tipo_solicitud IS
    'O=Orden de giro, F=Fondo fijo.';
COMMENT ON COLUMN finanzas.solicitud_giro.motivo_devolucion IS
    'Motivo por el que se devuelve el giro (sin tarea / no compra, etc.).';
COMMENT ON COLUMN finanzas.solicitud_giro.aprobador_devolucion_id IS
    'Usuario que aprobo o rechazo la solicitud de devolucion.';
COMMENT ON COLUMN finanzas.solicitud_giro.fec_aprobacion_devolucion IS
    'Marca de tiempo de aprobacion de la devolucion.';
COMMENT ON COLUMN finanzas.solicitud_giro.fec_rechazo_devolucion IS
    'Marca de tiempo de rechazo de la devolucion.';
COMMENT ON COLUMN finanzas.solicitud_giro.motivo_rechazo_devolucion IS
    'Motivo cuando se rechaza la devolucion.';
COMMENT ON COLUMN finanzas.solicitud_giro.flag_estado_devolucion IS
    'NULL=sin resolucion devolucion pendiente o no aplica; A=aprobado; R=rechazado.';

-- Cabecera de liquidacion (legacy LIQUIDACION), asociada a una solicitud de giro.
CREATE TABLE finanzas.liquidacion (
    id                      BIGSERIAL       NOT NULL,
    solicitud_giro_id       BIGINT          NOT NULL,
    nro_liquidacion        VARCHAR(12)     NOT NULL UNIQUE,
    doc_tipo_id             BIGINT,
    sucursal_id             BIGINT          REFERENCES auth.sucursal(id),
    proveedor_id            BIGINT,
    fecha_registro          DATE            NOT NULL DEFAULT CURRENT_DATE,
    fecha_liquidacion       DATE,
    tipo_liquidacion        CHAR(1),
    moneda_id               BIGINT,
    concepto_financiero_id  BIGINT NOT NULL,
    importe_neto            NUMERIC(18, 4)  NOT NULL DEFAULT 0,
    saldo                   NUMERIC(18, 4)  NOT NULL DEFAULT 0, -- saldo por devolver o reintegrar
    tasa_cambio             NUMERIC(11, 8)  NOT NULL DEFAULT 0,
    anio                    INTEGER,
    mes                     INTEGER,
    cntbl_libro_id          BIGINT,
    cntbl_asiento_id        BIGINT,
    usuario_id              BIGINT,
    observacion             VARCHAR(200),
    flag_estado VARCHAR(1)         NOT NULL DEFAULT '1',
    created_by              BIGINT,
    fec_creacion            TIMESTAMPTZ     DEFAULT NOW(),
    updated_by              BIGINT,
    fec_modificacion        TIMESTAMPTZ,
    CONSTRAINT PK_LIQUIDACION PRIMARY KEY (id),
    CONSTRAINT FK_LIQUIDACION_01 FOREIGN KEY (solicitud_giro_id) REFERENCES finanzas.solicitud_giro(id),
    CONSTRAINT FK_LIQUIDACION_02 FOREIGN KEY (doc_tipo_id) REFERENCES core.doc_tipo(id),
    CONSTRAINT FK_LIQUIDACION_03 FOREIGN KEY (proveedor_id) REFERENCES core.entidad_contribuyente(id),
    CONSTRAINT FK_LIQUIDACION_04 FOREIGN KEY (moneda_id) REFERENCES core.moneda(id),
    CONSTRAINT FK_LIQUIDACION_05 FOREIGN KEY (concepto_financiero_id) REFERENCES finanzas.concepto_financiero(id),
    CONSTRAINT FK_LIQUIDACION_06 FOREIGN KEY (usuario_id) REFERENCES auth.usuario(id)
);

-- FK diferidas: solicitud_giro y liquidacion se crean después de caja_bancos_det en este script
ALTER TABLE finanzas.caja_bancos_det
    ADD CONSTRAINT FK_CAJA_BANCOS_DET_11 FOREIGN KEY (solicitud_giro_id) REFERENCES finanzas.solicitud_giro(id);
ALTER TABLE finanzas.caja_bancos_det
    ADD CONSTRAINT FK_CAJA_BANCOS_DET_12 FOREIGN KEY (liquidacion_id) REFERENCES finanzas.liquidacion(id);

-- Detalle de liquidacion (legacy LIQUIDACION_DET).
CREATE TABLE finanzas.liquidacion_det (
    id                      BIGSERIAL       NOT NULL,
    liquidacion_id          BIGINT          NOT NULL,
    item                    INTEGER         NOT NULL,
    origen_doc_ref          CHAR(2),
    moneda_id               BIGINT,
    concepto_financiero_id  BIGINT NOT NULL,
    cntas_pagar_id          BIGINT,
    cntas_cobrar_id         BIGINT,
    centros_costo_id        BIGINT,
    factor_signo            SMALLINT,
    importe                 NUMERIC(18, 4)  NOT NULL DEFAULT 0,
    flag_retencion          CHAR(1)         DEFAULT '0',
    importe_retenido        NUMERIC(18, 4)  NOT NULL DEFAULT 0,
    flag_provisionado       CHAR(1)         DEFAULT '0',
    flag_estado VARCHAR(1)         NOT NULL DEFAULT '1',
    created_by              BIGINT,
    fec_creacion            TIMESTAMPTZ     DEFAULT NOW(),
    updated_by              BIGINT,
    fec_modificacion        TIMESTAMPTZ,
    CONSTRAINT PK_LIQUIDACION_DET PRIMARY KEY (id),
    CONSTRAINT UQ_LIQUIDACION_DET_01 UNIQUE (liquidacion_id, item),
    CONSTRAINT FK_LIQUIDACION_DET_01 FOREIGN KEY (liquidacion_id) REFERENCES finanzas.liquidacion(id),
    CONSTRAINT FK_LIQUIDACION_DET_02 FOREIGN KEY (moneda_id) REFERENCES core.moneda(id),
    CONSTRAINT FK_LIQUIDACION_DET_03 FOREIGN KEY (concepto_financiero_id) REFERENCES finanzas.concepto_financiero(id),
    CONSTRAINT FK_LIQUIDACION_DET_04 FOREIGN KEY (cntas_pagar_id) REFERENCES finanzas.cntas_pagar(id),
    CONSTRAINT FK_LIQUIDACION_DET_05 FOREIGN KEY (cntas_cobrar_id) REFERENCES ventas.cntas_cobrar(id)
);

-- Matriz de autorizadores por centro de costo (legacy AUTORIZADOR_GIRO).
CREATE TABLE finanzas.autorizador_giro (
    id                   BIGSERIAL       NOT NULL,
    centros_costo_id     BIGINT          NOT NULL,
    usuario_id           BIGINT          NOT NULL,
    activo               BOOLEAN         NOT NULL DEFAULT TRUE,
    flag_estado          VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by           BIGINT,
    fec_creacion         TIMESTAMPTZ     DEFAULT NOW(),
    updated_by           BIGINT,
    fec_modificacion     TIMESTAMPTZ,
    CONSTRAINT PK_AUTORIZADOR_GIRO PRIMARY KEY (id),
    CONSTRAINT UQ_AUTORIZADOR_GIRO_01 UNIQUE (centros_costo_id, usuario_id),
    CONSTRAINT FK_AUTORIZADOR_GIRO_01 FOREIGN KEY (usuario_id) REFERENCES auth.usuario(id)
);

CREATE TABLE finanzas.programacion_pago (
    id                   BIGSERIAL       NOT NULL,
    fecha_programada     DATE            NOT NULL,
    flag_estado          VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_PROGRAMACION_PAGO PRIMARY KEY (id)
);

CREATE TABLE finanzas.programacion_pago_det (
    id                   BIGSERIAL       NOT NULL,
    programacion_id      BIGINT          NOT NULL,
    cntas_pagar_id       BIGINT,
    monto_programado     NUMERIC(18, 4)  NOT NULL,
    flag_estado          VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_PROGRAMACION_PAGO_DET PRIMARY KEY (id),
    CONSTRAINT FK_PROGRAMACION_PAGO_DET_01 FOREIGN KEY (programacion_id) REFERENCES finanzas.programacion_pago(id),
    CONSTRAINT FK_PROGRAMACION_PAGO_DET_02 FOREIGN KEY (cntas_pagar_id) REFERENCES finanzas.cntas_pagar(id)
);

CREATE TABLE finanzas.fondo_fijo (
    id                   BIGSERIAL       NOT NULL,
    sucursal_id          BIGINT,
    responsable_id       BIGINT,
    monto_autorizado     NUMERIC(18, 4)  NOT NULL,
    monto_disponible     NUMERIC(18, 4)  NOT NULL,
    flag_estado          VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_FONDO_FIJO PRIMARY KEY (id),
    CONSTRAINT FK_FONDO_FIJO_01 FOREIGN KEY (sucursal_id) REFERENCES auth.sucursal(id)
);

CREATE TABLE finanzas.rendicion_gasto (
    id                   BIGSERIAL       NOT NULL,
    fondo_fijo_id        BIGINT          NOT NULL,
    fecha                DATE            NOT NULL,
    monto                NUMERIC(18, 4)  NOT NULL,
    concepto             TEXT,
    comprobante          VARCHAR(60),
    flag_estado          VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_RENDICION_GASTO PRIMARY KEY (id),
    CONSTRAINT FK_RENDICION_GASTO_01 FOREIGN KEY (fondo_fijo_id) REFERENCES finanzas.fondo_fijo(id)
);

CREATE TABLE finanzas.pago (
    id                   BIGSERIAL       NOT NULL,
    cntas_pagar_id       BIGINT,
    banco_cnta_id        BIGINT,
    forma_pago_id        BIGINT,
    fecha                DATE            NOT NULL,
    monto                NUMERIC(18, 4)  NOT NULL,
    referencia           VARCHAR(120),
    flag_estado          VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_PAGO PRIMARY KEY (id),
    CONSTRAINT FK_PAGO_01 FOREIGN KEY (cntas_pagar_id) REFERENCES finanzas.cntas_pagar(id),
    CONSTRAINT FK_PAGO_02 FOREIGN KEY (banco_cnta_id) REFERENCES finanzas.banco_cnta(id),
    CONSTRAINT FK_PAGO_03 FOREIGN KEY (forma_pago_id) REFERENCES core.forma_pago(id)
);

CREATE TABLE finanzas.flujo_caja_proyectado (
    id                   BIGSERIAL       NOT NULL,
    fecha                DATE            NOT NULL,
    tipo                 VARCHAR(20)     NOT NULL,
    concepto             TEXT,
    monto                NUMERIC(18, 4)  NOT NULL,
    realizado            BOOLEAN         NOT NULL DEFAULT FALSE,
    flag_estado          VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_FLUJO_CAJA_PROYECTADO PRIMARY KEY (id)
);

CREATE TABLE finanzas.detraccion (
    id BIGSERIAL PRIMARY KEY,
    cntas_pagar_id BIGINT REFERENCES finanzas.cntas_pagar(id),
    nro_detraccion VARCHAR(12) NOT NULL,
    flag_estado VARCHAR(1) DEFAULT '1',
    fecha_registro DATE,
    nro_deposito VARCHAR(15),
    fecha_deposito DATE,
    cod_usr CHAR(6),
    importe NUMERIC(13,2) NOT NULL DEFAULT 0,
    flag_tabla CHAR(1),
    org_caja_banc CHAR(2),
    nro_reg_caja_banc NUMERIC(10,0),
    tipo_doc_cxc CHAR(4),
    nro_doc_cxc CHAR(10),
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT UQ_DETRACCION_01 UNIQUE (nro_detraccion)
);

CREATE TABLE finanzas.retencion (
    id BIGSERIAL PRIMARY KEY,
    cntas_pagar_id BIGINT REFERENCES finanzas.cntas_pagar(id),
    nro_certificado CHAR(15) NOT NULL,
    fecha_emision DATE,
    sucursal_id BIGINT REFERENCES auth.sucursal(id),
    proveedor_id BIGINT NOT NULL REFERENCES core.entidad_contribuyente(id),
    nro_reg_caja_ban BIGINT NOT NULL REFERENCES finanzas.caja_bancos(id),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    flag_tabla CHAR(1),
    saldo_sol NUMERIC(13,2) NOT NULL DEFAULT 0,
    saldo_dol NUMERIC(13,2) NOT NULL DEFAULT 0,
    importe_doc NUMERIC(13,2) NOT NULL DEFAULT 0,
    fec_pago DATE,
    tasa_cambio NUMERIC(7,4) NOT NULL DEFAULT 1,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT UQ_RETENCION_01 UNIQUE (nro_certificado)
);

COMMENT ON COLUMN finanzas.retencion.nro_reg_caja_ban IS
    'FK obligatoria al registro/movimiento en finanzas.caja_bancos (antes nro correlativo numérico legacy).';

CREATE TABLE finanzas.flujo_caja (
    id BIGSERIAL PRIMARY KEY,
    sucursal_id BIGINT NOT NULL REFERENCES auth.sucursal(id),
    anio INTEGER NOT NULL,
    mes INTEGER NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    ingresos_operativos NUMERIC(18, 4) NOT NULL DEFAULT 0,
    egresos_operativos NUMERIC(18, 4) NOT NULL DEFAULT 0,
    saldo_inicial NUMERIC(18, 4) NOT NULL DEFAULT 0,
    saldo_final NUMERIC(18, 4) NOT NULL DEFAULT 0,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    UNIQUE (sucursal_id, anio, mes, tipo)
);

-- Saldo mensual por cuenta bancaria — base SIGRE SALDO_BANCO_MES
CREATE TABLE finanzas.saldo_banco_mes (
    id                  BIGSERIAL       NOT NULL,
    banco_cnta_id       BIGINT          NOT NULL,
    ano                 INTEGER         NOT NULL,
    mes                 INTEGER         NOT NULL,
    ingresos            NUMERIC(18,4)   NOT NULL DEFAULT 0,
    egresos             NUMERIC(18,4)   NOT NULL DEFAULT 0,
    saldo               NUMERIC(18,4)   NOT NULL DEFAULT 0,
    saldo_conciliado    NUMERIC(18,4)   NOT NULL DEFAULT 0,
    flag_estado         VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_SALDO_BANCO_MES PRIMARY KEY (id),
    CONSTRAINT FK_SALDO_BANCO_MES_BANCO_CNTA FOREIGN KEY (banco_cnta_id) REFERENCES finanzas.banco_cnta(id),
    CONSTRAINT UQ_SALDO_BANCO_MES UNIQUE (banco_cnta_id, ano, mes)
);

-- ============================================================
-- SECCIÓN 3: ÍNDICES
-- ============================================================

CREATE INDEX IX_BANCO_01                     ON finanzas.banco (cod_banco_sunat);
CREATE INDEX IX_BANCO_CNTA_01                ON finanzas.banco_cnta (banco_id);
CREATE INDEX IX_BANCO_CNTA_02                ON finanzas.banco_cnta (moneda_id);
CREATE INDEX IX_BANCO_CNTA_03                ON finanzas.banco_cnta (flag_estado);
CREATE INDEX IX_GRUPO_CONCEPTO_FINANCIERO_01 ON finanzas.grupo_concepto_financiero (codigo);
CREATE INDEX IX_ACTIVIDAD_FLUJO_CAJA_01      ON finanzas.actividad_flujo_caja (orden);
CREATE INDEX IX_GRUPO_COD_FLUJO_CAJA_01      ON finanzas.grupo_codigo_flujo_caja (orden);
CREATE INDEX IX_GRUPO_COD_FLUJO_CAJA_02      ON finanzas.grupo_codigo_flujo_caja (factor);
CREATE INDEX IX_GRUPO_COD_FLUJO_CAJA_03      ON finanzas.grupo_codigo_flujo_caja (actividad_flujo_caja_id);
CREATE INDEX IX_CODIGO_FLUJO_CAJA_01         ON finanzas.codigo_flujo_caja (grupo_codigo_flujo_caja_id);
CREATE INDEX IX_CODIGO_FLUJO_CAJA_02         ON finanzas.codigo_flujo_caja (orden);
CREATE INDEX IX_CNTAS_PAGAR_01               ON finanzas.cntas_pagar (proveedor_id, fecha_vencimiento);
CREATE INDEX IX_CNTAS_PAGAR_02               ON finanzas.cntas_pagar (cntbl_asiento_id);
CREATE INDEX IX_CNTAS_PAGAR_03               ON finanzas.cntas_pagar (ano, mes, cntbl_libro_id);
CREATE INDEX IX_CNTAS_PAGAR_04               ON finanzas.cntas_pagar (fecha_emision);
CREATE INDEX IX_CNTAS_PAGAR_DET_01           ON finanzas.cntas_pagar_det (cntas_pagar_id, fecha_mov);
CREATE INDEX IX_CNTAS_PAGAR_DET_10           ON finanzas.cntas_pagar_det (cntas_pagar_id, credito_fiscal_id);
CREATE INDEX IF NOT EXISTS IX_CNTAS_PAGAR_DET_02           ON finanzas.cntas_pagar_det (concepto_financiero_id);
CREATE INDEX IF NOT EXISTS IX_CNTAS_PAGAR_DET_03           ON finanzas.cntas_pagar_det (articulo_id);
CREATE INDEX IF NOT EXISTS IX_CNTAS_PAGAR_DET_04           ON finanzas.cntas_pagar_det (centros_costo_id);
CREATE INDEX IF NOT EXISTS IX_CNTAS_PAGAR_DET_05           ON finanzas.cntas_pagar_det (orden_compra_det_id);
CREATE INDEX IF NOT EXISTS IX_CNTAS_PAGAR_DET_06           ON finanzas.cntas_pagar_det (orden_servicio_det_id);
CREATE INDEX IF NOT EXISTS IX_CNTAS_PAGAR_DET_07           ON finanzas.cntas_pagar_det (vale_mov_det_id);
CREATE INDEX IF NOT EXISTS IX_CNTAS_PAGAR_DET_08           ON finanzas.cntas_pagar_det (trabajador_id);
CREATE INDEX IF NOT EXISTS IX_CNTAS_PAGAR_DET_09           ON finanzas.cntas_pagar_det (sucursal_ref_id, doc_tipo_ref_id, nro_ref);
CREATE INDEX IX_CAJA_BANCOS_01               ON finanzas.caja_bancos (banco_cnta_id, fecha_emision);
CREATE INDEX IX_CAJA_BANCOS_02               ON finanzas.caja_bancos (sucursal_id, nro_registro);
CREATE INDEX IX_CAJA_BANCOS_03               ON finanzas.caja_bancos (entidad_contribuyente_id);
CREATE INDEX IX_CAJA_BANCOS_04               ON finanzas.caja_bancos (flag_estado);
CREATE INDEX IX_CAJA_BANCOS_05               ON finanzas.caja_bancos (cntbl_asiento_id);
CREATE INDEX IX_CAJA_BANCOS_06               ON finanzas.caja_bancos (medio_pago_id);
CREATE INDEX IX_CAJA_BANCOS_07               ON finanzas.caja_bancos (doc_tipo_id);
CREATE INDEX IX_CAJA_BANCOS_08               ON finanzas.caja_bancos (ano, mes, cntbl_libro_id);
CREATE INDEX IX_CAJA_BANCOS_DET_01           ON finanzas.caja_bancos_det (caja_bancos_id, item);
CREATE INDEX IX_CAJA_BANCOS_DET_02           ON finanzas.caja_bancos_det (entidad_contribuyente_id, doc_tipo_id, nro_doc);
CREATE INDEX IX_CAJA_BANCOS_DET_03           ON finanzas.caja_bancos_det (codigo_flujo_caja_id);
CREATE INDEX IX_CONCILIACION_BANCARIA_01     ON finanzas.conciliacion_bancaria (banco_cnta_id, periodo_anio, periodo_mes);
CREATE INDEX IX_CONCILIACION_DET_01          ON finanzas.conciliacion_det (conciliacion_id);
CREATE INDEX IX_CONCILIACION_DET_02          ON finanzas.conciliacion_det (caja_bancos_id);
CREATE INDEX IX_SOLICITUD_GIRO_01            ON finanzas.solicitud_giro (fecha);
CREATE INDEX IX_SOLICITUD_GIRO_02            ON finanzas.solicitud_giro (sucursal_id);
CREATE INDEX IX_SOLICITUD_GIRO_03            ON finanzas.solicitud_giro (tipo_solicitud);
CREATE INDEX IX_SOLICITUD_GIRO_04            ON finanzas.solicitud_giro (centros_costo_id);
CREATE INDEX IX_SOLICITUD_GIRO_05            ON finanzas.solicitud_giro (aprobador_devolucion_id);
CREATE INDEX IX_SOLICITUD_GIRO_06            ON finanzas.solicitud_giro (flag_estado_devolucion);
CREATE INDEX IX_LIQUIDACION_01               ON finanzas.liquidacion (solicitud_giro_id);
CREATE INDEX IX_LIQUIDACION_02               ON finanzas.liquidacion (fecha_liquidacion);
CREATE INDEX IX_LIQUIDACION_DET_01           ON finanzas.liquidacion_det (liquidacion_id, item);
CREATE INDEX IX_LIQUIDACION_DET_02           ON finanzas.liquidacion_det (cntas_pagar_id);
CREATE INDEX IX_LIQUIDACION_DET_03           ON finanzas.liquidacion_det (cntas_cobrar_id);
CREATE INDEX IX_LIQUIDACION_DET_04           ON finanzas.liquidacion_det (centros_costo_id);
CREATE INDEX IX_AUTORIZADOR_GIRO_01          ON finanzas.autorizador_giro (usuario_id, activo);
CREATE INDEX IX_PROGRAMACION_PAGO_01         ON finanzas.programacion_pago (fecha_programada);
CREATE INDEX IX_PROGRAMACION_PAGO_DET_01     ON finanzas.programacion_pago_det (programacion_id);
CREATE INDEX IX_PROGRAMACION_PAGO_DET_02     ON finanzas.programacion_pago_det (cntas_pagar_id);
CREATE INDEX IX_FONDO_FIJO_01               ON finanzas.fondo_fijo (sucursal_id);
CREATE INDEX IX_RENDICION_GASTO_01           ON finanzas.rendicion_gasto (fondo_fijo_id, fecha);
CREATE INDEX IX_PAGO_01                      ON finanzas.pago (cntas_pagar_id, fecha);
CREATE INDEX IX_PAGO_02                      ON finanzas.pago (banco_cnta_id);
CREATE INDEX IX_FLUJO_CAJA_PROYECTADO_01     ON finanzas.flujo_caja_proyectado (fecha, tipo);
CREATE INDEX IX_DETRACCION_01                ON finanzas.detraccion (cntas_pagar_id, flag_estado);
CREATE INDEX IX_RETENCION_01                 ON finanzas.retencion (cntas_pagar_id, flag_estado);
CREATE INDEX IX_RETENCION_02                 ON finanzas.retencion (proveedor_id);
CREATE INDEX IX_RETENCION_03                 ON finanzas.retencion (nro_reg_caja_ban);
CREATE INDEX IX_SALDO_BANCO_MES_01           ON finanzas.saldo_banco_mes (banco_cnta_id);

-- ============================================================
-- SECCIÓN 4: FK diferidas y columnas idempotentes
-- ============================================================

-- banco_cnta: último número de cheque emitido por cuenta (tesorería / caja bancos)
ALTER TABLE finanzas.banco_cnta ADD COLUMN IF NOT EXISTS correlativo_cheque INTEGER DEFAULT 0;

-- cntas_pagar: columnas legacy SIGRE para registro compras SUNAT (idempotente)
ALTER TABLE finanzas.cntas_pagar ADD COLUMN IF NOT EXISTS fecha_registro DATE DEFAULT CURRENT_DATE;
ALTER TABLE finanzas.cntas_pagar ADD COLUMN IF NOT EXISTS tasa_cambio NUMERIC(11,4) DEFAULT 1;
ALTER TABLE finanzas.cntas_pagar ADD COLUMN IF NOT EXISTS descripcion VARCHAR(2000);
ALTER TABLE finanzas.cntas_pagar ADD COLUMN IF NOT EXISTS forma_pago_id BIGINT;
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
         WHERE table_schema = 'finanzas' AND table_name = 'cntas_pagar' AND column_name = 'periodo_anio'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.columns
         WHERE table_schema = 'finanzas' AND table_name = 'cntas_pagar' AND column_name = 'ano'
    ) THEN
        ALTER TABLE finanzas.cntas_pagar RENAME COLUMN periodo_anio TO ano;
    END IF;
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
         WHERE table_schema = 'finanzas' AND table_name = 'cntas_pagar' AND column_name = 'periodo_mes'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.columns
         WHERE table_schema = 'finanzas' AND table_name = 'cntas_pagar' AND column_name = 'mes'
    ) THEN
        ALTER TABLE finanzas.cntas_pagar RENAME COLUMN periodo_mes TO mes;
    END IF;
END $$;
ALTER TABLE finanzas.cntas_pagar ADD COLUMN IF NOT EXISTS ano INTEGER;
ALTER TABLE finanzas.cntas_pagar ADD COLUMN IF NOT EXISTS mes INTEGER;
ALTER TABLE finanzas.cntas_pagar ADD COLUMN IF NOT EXISTS cntbl_libro_id BIGINT;
UPDATE finanzas.cntas_pagar SET ano = EXTRACT(YEAR FROM fecha_emision)::INTEGER WHERE ano IS NULL;
UPDATE finanzas.cntas_pagar SET mes = EXTRACT(MONTH FROM fecha_emision)::INTEGER WHERE mes IS NULL;
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM finanzas.cntas_pagar WHERE ano IS NULL) THEN
        ALTER TABLE finanzas.cntas_pagar ALTER COLUMN ano SET NOT NULL;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM finanzas.cntas_pagar WHERE mes IS NULL) THEN
        ALTER TABLE finanzas.cntas_pagar ALTER COLUMN mes SET NOT NULL;
    END IF;
END $$;
ALTER TABLE finanzas.cntas_pagar DROP COLUMN IF EXISTS nro_asiento;
ALTER TABLE finanzas.cntas_pagar ADD COLUMN IF NOT EXISTS cod_origen VARCHAR(2);
ALTER TABLE finanzas.cntas_pagar ADD COLUMN IF NOT EXISTS oper_detr CHAR(2);
ALTER TABLE finanzas.cntas_pagar ADD COLUMN IF NOT EXISTS detr_bien_serv_id BIGINT;
ALTER TABLE finanzas.cntas_pagar ADD COLUMN IF NOT EXISTS nro_detraccion VARCHAR(12);
ALTER TABLE finanzas.cntas_pagar ADD COLUMN IF NOT EXISTS flag_detraccion CHAR(1) DEFAULT '0';
ALTER TABLE finanzas.cntas_pagar ADD COLUMN IF NOT EXISTS importe_detraccion NUMERIC(18,4) DEFAULT 0;
ALTER TABLE finanzas.cntas_pagar ADD COLUMN IF NOT EXISTS flag_retencion CHAR(1) DEFAULT '0';
ALTER TABLE finanzas.cntas_pagar ADD COLUMN IF NOT EXISTS porc_ret_igv NUMERIC(5,2) DEFAULT 0;

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cntas_pagar_forma_pago')
    THEN ALTER TABLE finanzas.cntas_pagar ADD CONSTRAINT fk_cntas_pagar_forma_pago FOREIGN KEY (forma_pago_id) REFERENCES core.forma_pago(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cntas_pagar_detr_bien_serv')
    THEN ALTER TABLE finanzas.cntas_pagar ADD CONSTRAINT fk_cntas_pagar_detr_bien_serv FOREIGN KEY (detr_bien_serv_id) REFERENCES core.detr_bien_serv(id); END IF; END $$;

-- concepto_financiero: columna tipo eliminada (BD existentes)
ALTER TABLE finanzas.concepto_financiero DROP COLUMN IF EXISTS tipo;

-- grupo_concepto_financiero + FK en concepto_financiero (BD existentes)
CREATE TABLE IF NOT EXISTS finanzas.grupo_concepto_financiero (
    id                  BIGSERIAL       NOT NULL,
    codigo              VARCHAR(20)     NOT NULL UNIQUE,
    nombre              VARCHAR(150)    NOT NULL,
    flag_estado         VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_GRUPO_CONCEPTO_FINANCIERO PRIMARY KEY (id)
);
ALTER TABLE finanzas.concepto_financiero ADD COLUMN IF NOT EXISTS grupo_concepto_financiero_id BIGINT;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_concepto_financiero_grupo')
    THEN ALTER TABLE finanzas.concepto_financiero
        ADD CONSTRAINT fk_concepto_financiero_grupo
        FOREIGN KEY (grupo_concepto_financiero_id) REFERENCES finanzas.grupo_concepto_financiero(id);
END IF; END $$;
CREATE INDEX IF NOT EXISTS IX_GRUPO_CONCEPTO_FINANCIERO_01 ON finanzas.grupo_concepto_financiero (codigo);
CREATE INDEX IF NOT EXISTS IX_CONCEPTO_FINANCIERO_02 ON finanzas.concepto_financiero (grupo_concepto_financiero_id);

-- actividad_flujo_caja + FK en grupo_codigo_flujo_caja (BD existentes)
CREATE TABLE IF NOT EXISTS finanzas.actividad_flujo_caja (
    id                  BIGSERIAL       NOT NULL,
    codigo              CHAR(2)         NOT NULL,
    nombre              VARCHAR(200)    NOT NULL,
    orden               INTEGER         NOT NULL DEFAULT 0,
    flag_tipo_flujo     CHAR(1)         NOT NULL DEFAULT 'E',
    flag_estado         VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_ACTIVIDAD_FLUJO_CAJA PRIMARY KEY (id),
    CONSTRAINT UQ_ACTIVIDAD_FLUJO_CAJA_CODIGO UNIQUE (codigo)
);
ALTER TABLE finanzas.grupo_codigo_flujo_caja ADD COLUMN IF NOT EXISTS actividad_flujo_caja_id BIGINT;
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
         WHERE table_schema = 'finanzas' AND table_name = 'grupo_codigo_flujo_caja' AND column_name = 'cod_actividad'
    ) THEN
        UPDATE finanzas.grupo_codigo_flujo_caja g
           SET actividad_flujo_caja_id = a.id
          FROM finanzas.actividad_flujo_caja a
         WHERE g.actividad_flujo_caja_id IS NULL
           AND g.cod_actividad IS NOT NULL
           AND TRIM(g.cod_actividad) = a.codigo;
        ALTER TABLE finanzas.grupo_codigo_flujo_caja DROP COLUMN IF EXISTS cod_actividad;
    END IF;
END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_grupo_cod_flujo_actividad')
    THEN ALTER TABLE finanzas.grupo_codigo_flujo_caja
        ADD CONSTRAINT fk_grupo_cod_flujo_actividad
        FOREIGN KEY (actividad_flujo_caja_id) REFERENCES finanzas.actividad_flujo_caja(id);
END IF; END $$;
CREATE INDEX IF NOT EXISTS IX_ACTIVIDAD_FLUJO_CAJA_01 ON finanzas.actividad_flujo_caja (orden);
CREATE INDEX IF NOT EXISTS IX_GRUPO_COD_FLUJO_CAJA_03 ON finanzas.grupo_codigo_flujo_caja (actividad_flujo_caja_id);

-- cntas_pagar_det: columnas añadidas post-despliegue inicial (idempotente)
ALTER TABLE finanzas.cntas_pagar_det ADD COLUMN IF NOT EXISTS concepto_financiero_id BIGINT;
ALTER TABLE finanzas.cntas_pagar_det ADD COLUMN IF NOT EXISTS item INTEGER;
ALTER TABLE finanzas.cntas_pagar_det ADD COLUMN IF NOT EXISTS descripcion VARCHAR(2000);
ALTER TABLE finanzas.cntas_pagar_det ADD COLUMN IF NOT EXISTS articulo_id BIGINT;
ALTER TABLE finanzas.cntas_pagar_det ADD COLUMN IF NOT EXISTS cantidad NUMERIC(12,4) DEFAULT 0;
ALTER TABLE finanzas.cntas_pagar_det ADD COLUMN IF NOT EXISTS precio_unitario NUMERIC(17,8) DEFAULT 0;
ALTER TABLE finanzas.cntas_pagar_det ADD COLUMN IF NOT EXISTS centros_costo_id BIGINT;
ALTER TABLE finanzas.cntas_pagar_det ADD COLUMN IF NOT EXISTS orden_compra_det_id BIGINT;
ALTER TABLE finanzas.cntas_pagar_det ADD COLUMN IF NOT EXISTS orden_servicio_det_id BIGINT;
ALTER TABLE finanzas.cntas_pagar_det ADD COLUMN IF NOT EXISTS vale_mov_det_id BIGINT;
ALTER TABLE finanzas.cntas_pagar_det ADD COLUMN IF NOT EXISTS sucursal_ref_id BIGINT;
ALTER TABLE finanzas.cntas_pagar_det ADD COLUMN IF NOT EXISTS doc_tipo_ref_id BIGINT;
ALTER TABLE finanzas.cntas_pagar_det ADD COLUMN IF NOT EXISTS nro_ref VARCHAR(12);
ALTER TABLE finanzas.cntas_pagar_det ADD COLUMN IF NOT EXISTS item_ref INTEGER;
ALTER TABLE finanzas.cntas_pagar_det ADD COLUMN IF NOT EXISTS fec_movilidad DATE;
ALTER TABLE finanzas.cntas_pagar_det ADD COLUMN IF NOT EXISTS mov_desde VARCHAR(200);
ALTER TABLE finanzas.cntas_pagar_det ADD COLUMN IF NOT EXISTS mov_hasta VARCHAR(200);
ALTER TABLE finanzas.cntas_pagar_det ADD COLUMN IF NOT EXISTS trabajador_id BIGINT;
ALTER TABLE finanzas.cntas_pagar_det ADD COLUMN IF NOT EXISTS credito_fiscal_id BIGINT;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
         WHERE table_schema = 'finanzas' AND table_name = 'cntas_pagar_det' AND column_name = 'tipo_cred_fiscal'
    ) THEN
        UPDATE finanzas.cntas_pagar_det cpd
           SET credito_fiscal_id = cf.id
          FROM core.credito_fiscal cf
         WHERE cpd.credito_fiscal_id IS NULL
           AND cpd.tipo_cred_fiscal IS NOT NULL
           AND cf.codigo = cpd.tipo_cred_fiscal;
        ALTER TABLE finanzas.cntas_pagar_det DROP CONSTRAINT IF EXISTS fk_cpd_credito_fiscal;
        ALTER TABLE finanzas.cntas_pagar_det DROP COLUMN IF EXISTS tipo_cred_fiscal;
    END IF;
END $$;

UPDATE finanzas.cntas_pagar_det cpd
   SET credito_fiscal_id = cf.id
  FROM core.credito_fiscal cf
 WHERE cpd.credito_fiscal_id IS NULL
   AND cf.codigo = '01';

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cpd_credito_fiscal')
    THEN ALTER TABLE finanzas.cntas_pagar_det ADD CONSTRAINT fk_cpd_credito_fiscal FOREIGN KEY (credito_fiscal_id) REFERENCES core.credito_fiscal(id); END IF; END $$;

DROP TABLE IF EXISTS finanzas.cp_doc_det_imp;
DROP TABLE IF EXISTS finanzas.doc_referencias;

DROP INDEX IF EXISTS finanzas.ix_cntas_pagar_03;
-- caja_bancos: periodo contable y libro (idempotente; cntbl_libro_id sin backfill automático)
ALTER TABLE finanzas.caja_bancos ADD COLUMN IF NOT EXISTS ano INTEGER;
ALTER TABLE finanzas.caja_bancos ADD COLUMN IF NOT EXISTS mes INTEGER;
ALTER TABLE finanzas.caja_bancos ADD COLUMN IF NOT EXISTS cntbl_libro_id BIGINT;
UPDATE finanzas.caja_bancos
   SET ano = EXTRACT(YEAR FROM COALESCE(fecha_ejecucion, fecha_emision))::INTEGER
 WHERE ano IS NULL
   AND COALESCE(fecha_ejecucion, fecha_emision) IS NOT NULL;
UPDATE finanzas.caja_bancos
   SET mes = EXTRACT(MONTH FROM COALESCE(fecha_ejecucion, fecha_emision))::INTEGER
 WHERE mes IS NULL
   AND COALESCE(fecha_ejecucion, fecha_emision) IS NOT NULL;
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM finanzas.caja_bancos WHERE ano IS NULL) THEN
        ALTER TABLE finanzas.caja_bancos ALTER COLUMN ano SET NOT NULL;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM finanzas.caja_bancos WHERE mes IS NULL) THEN
        ALTER TABLE finanzas.caja_bancos ALTER COLUMN mes SET NOT NULL;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM finanzas.caja_bancos WHERE cntbl_libro_id IS NULL) THEN
        ALTER TABLE finanzas.caja_bancos ALTER COLUMN cntbl_libro_id SET NOT NULL;
    END IF;
END $$;
CREATE INDEX IF NOT EXISTS IX_CAJA_BANCOS_08 ON finanzas.caja_bancos (ano, mes, cntbl_libro_id);

CREATE INDEX IF NOT EXISTS IX_CNTAS_PAGAR_03 ON finanzas.cntas_pagar (ano, mes, cntbl_libro_id);
CREATE INDEX IF NOT EXISTS IX_CNTAS_PAGAR_04 ON finanzas.cntas_pagar (fecha_emision);
DROP INDEX IF EXISTS finanzas.ix_cntas_pagar_det_10;
CREATE INDEX IF NOT EXISTS IX_CNTAS_PAGAR_DET_10 ON finanzas.cntas_pagar_det (cntas_pagar_id, credito_fiscal_id);
-- FKs idempotentes para columnas nuevas de cntas_pagar_det
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cpd_articulo')
    THEN ALTER TABLE finanzas.cntas_pagar_det ADD CONSTRAINT fk_cpd_articulo FOREIGN KEY (articulo_id) REFERENCES core.articulo(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cpd_orden_compra_det')
    THEN ALTER TABLE finanzas.cntas_pagar_det ADD CONSTRAINT fk_cpd_orden_compra_det FOREIGN KEY (orden_compra_det_id) REFERENCES compras.orden_compra_det(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cpd_orden_servicio_det')
    THEN ALTER TABLE finanzas.cntas_pagar_det ADD CONSTRAINT fk_cpd_orden_servicio_det FOREIGN KEY (orden_servicio_det_id) REFERENCES compras.orden_servicio_det(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cpd_vale_mov_det')
    THEN ALTER TABLE finanzas.cntas_pagar_det ADD CONSTRAINT fk_cpd_vale_mov_det FOREIGN KEY (vale_mov_det_id) REFERENCES almacen.vale_mov_det(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cpd_sucursal_ref')
    THEN ALTER TABLE finanzas.cntas_pagar_det ADD CONSTRAINT fk_cpd_sucursal_ref FOREIGN KEY (sucursal_ref_id) REFERENCES auth.sucursal(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cpd_doc_tipo_ref')
    THEN ALTER TABLE finanzas.cntas_pagar_det ADD CONSTRAINT fk_cpd_doc_tipo_ref FOREIGN KEY (doc_tipo_ref_id) REFERENCES core.doc_tipo(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_orden_compra_banco')
    THEN ALTER TABLE compras.orden_compra ADD CONSTRAINT fk_orden_compra_banco FOREIGN KEY (banco_id) REFERENCES finanzas.banco(id); END IF; END $$;

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_orden_servicio_banco')
    THEN ALTER TABLE compras.orden_servicio ADD CONSTRAINT fk_orden_servicio_banco FOREIGN KEY (banco_id) REFERENCES finanzas.banco(id); END IF; END $$;

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_entidad_banco_cnta_banco')
    THEN ALTER TABLE compras.entidad_banco_cnta ADD CONSTRAINT fk_entidad_banco_cnta_banco FOREIGN KEY (banco_id) REFERENCES finanzas.banco(id); END IF; END $$;

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_osd_concepto_financiero')
    THEN ALTER TABLE compras.orden_servicio_det ADD CONSTRAINT fk_osd_concepto_financiero FOREIGN KEY (concepto_financiero_id) REFERENCES finanzas.concepto_financiero(id); END IF; END $$;

-- FK fk_cpd_trabajador diferida a 07-rrhh.sql (esquema rrhh no existe aquí aún)

-- Obligatoriedad de columnas nuevas en cntas_pagar_det (BD existentes)
DO $$
DECLARE
    cols TEXT[] := ARRAY['item','descripcion','cantidad','precio_unitario','centros_costo_id'];
    c TEXT;
BEGIN
    FOREACH c IN ARRAY cols LOOP
        IF EXISTS (
            SELECT 1 FROM information_schema.columns
            WHERE table_schema = 'finanzas' AND table_name = 'cntas_pagar_det'
              AND column_name = c AND is_nullable = 'YES'
        ) THEN
            IF NOT EXISTS (SELECT 1 FROM finanzas.cntas_pagar_det WHERE
                CASE c
                    WHEN 'item' THEN item IS NULL
                    WHEN 'descripcion' THEN descripcion IS NULL
                    WHEN 'cantidad' THEN cantidad IS NULL
                    WHEN 'precio_unitario' THEN precio_unitario IS NULL
                    WHEN 'centros_costo_id' THEN centros_costo_id IS NULL
                END
            ) THEN
                EXECUTE format('ALTER TABLE finanzas.cntas_pagar_det ALTER COLUMN %I SET NOT NULL', c);
            END IF;
        END IF;
    END LOOP;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'fk_cntas_pagar_det_concepto_fin'
    ) THEN
        ALTER TABLE finanzas.cntas_pagar_det
            ADD CONSTRAINT fk_cntas_pagar_det_concepto_fin
            FOREIGN KEY (concepto_financiero_id)
            REFERENCES finanzas.concepto_financiero (id);
    END IF;
END $$;

ALTER TABLE ventas.cntas_cobrar_det ADD COLUMN IF NOT EXISTS concepto_financiero_id BIGINT;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint c
        JOIN pg_class t ON c.conrelid = t.oid
        JOIN pg_namespace n ON t.relnamespace = n.oid
        WHERE c.contype = 'f'
          AND c.conname = 'fk_cntas_cobrar_det_concepto_fin'
          AND n.nspname = 'ventas'
    ) THEN
        ALTER TABLE ventas.cntas_cobrar_det
            ADD CONSTRAINT fk_cntas_cobrar_det_concepto_fin
            FOREIGN KEY (concepto_financiero_id)
            REFERENCES finanzas.concepto_financiero (id);
    END IF;
END $$;

-- Obligatoriedad histórica: relleno mínimo y NOT NULL sólo si no quedan nulos ni catálogo vacío.
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'finanzas' AND table_name = 'cntas_pagar_det'
          AND column_name = 'concepto_financiero_id' AND is_nullable = 'YES'
    ) THEN
        UPDATE finanzas.cntas_pagar_det d
        SET concepto_financiero_id = (SELECT MIN(id) FROM finanzas.concepto_financiero)
        WHERE d.concepto_financiero_id IS NULL
          AND EXISTS (SELECT 1 FROM finanzas.concepto_financiero);
        IF NOT EXISTS (SELECT 1 FROM finanzas.cntas_pagar_det WHERE concepto_financiero_id IS NULL) THEN
            ALTER TABLE finanzas.cntas_pagar_det
                ALTER COLUMN concepto_financiero_id SET NOT NULL;
        END IF;
    END IF;
END $$;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'ventas' AND table_name = 'cntas_cobrar_det'
          AND column_name = 'concepto_financiero_id' AND is_nullable = 'YES'
    ) THEN
        UPDATE ventas.cntas_cobrar_det d
        SET concepto_financiero_id = (SELECT MIN(id) FROM finanzas.concepto_financiero)
        WHERE d.concepto_financiero_id IS NULL
          AND EXISTS (SELECT 1 FROM finanzas.concepto_financiero);
        IF NOT EXISTS (SELECT 1 FROM ventas.cntas_cobrar_det WHERE concepto_financiero_id IS NULL) THEN
            ALTER TABLE ventas.cntas_cobrar_det
                ALTER COLUMN concepto_financiero_id SET NOT NULL;
        END IF;
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS IX_CNTAS_COBRAR_DET_CONCEPTO ON ventas.cntas_cobrar_det (concepto_financiero_id);

-- caja_bancos / liquidacion / liquidacion_det: concepto financiero obligatorio (BD ya existentes)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'finanzas' AND table_name = 'caja_bancos'
          AND column_name = 'concepto_financiero_id' AND is_nullable = 'YES'
    ) THEN
        UPDATE finanzas.caja_bancos d
        SET concepto_financiero_id = (SELECT MIN(id) FROM finanzas.concepto_financiero)
        WHERE d.concepto_financiero_id IS NULL
          AND EXISTS (SELECT 1 FROM finanzas.concepto_financiero);
        IF NOT EXISTS (SELECT 1 FROM finanzas.caja_bancos WHERE concepto_financiero_id IS NULL) THEN
            ALTER TABLE finanzas.caja_bancos
                ALTER COLUMN concepto_financiero_id SET NOT NULL;
        END IF;
    END IF;
END $$;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'finanzas' AND table_name = 'liquidacion'
          AND column_name = 'concepto_financiero_id' AND is_nullable = 'YES'
    ) THEN
        UPDATE finanzas.liquidacion d
        SET concepto_financiero_id = (SELECT MIN(id) FROM finanzas.concepto_financiero)
        WHERE d.concepto_financiero_id IS NULL
          AND EXISTS (SELECT 1 FROM finanzas.concepto_financiero);
        IF NOT EXISTS (SELECT 1 FROM finanzas.liquidacion WHERE concepto_financiero_id IS NULL) THEN
            ALTER TABLE finanzas.liquidacion
                ALTER COLUMN concepto_financiero_id SET NOT NULL;
        END IF;
    END IF;
END $$;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'finanzas' AND table_name = 'liquidacion_det'
          AND column_name = 'concepto_financiero_id' AND is_nullable = 'YES'
    ) THEN
        UPDATE finanzas.liquidacion_det d
        SET concepto_financiero_id = (SELECT MIN(id) FROM finanzas.concepto_financiero)
        WHERE d.concepto_financiero_id IS NULL
          AND EXISTS (SELECT 1 FROM finanzas.concepto_financiero);
        IF NOT EXISTS (SELECT 1 FROM finanzas.liquidacion_det WHERE concepto_financiero_id IS NULL) THEN
            ALTER TABLE finanzas.liquidacion_det
                ALTER COLUMN concepto_financiero_id SET NOT NULL;
        END IF;
    END IF;
END $$;

-- ============================================================
-- Impuestos por ítem de Cuentas por Pagar (SIGRE: CP_DOC_DET_IMP)
-- Relación N:M entre cntas_pagar_det y core.tipos_impuesto
-- ============================================================
CREATE TABLE IF NOT EXISTS finanzas.cntas_pagar_det_imp (
    id                  BIGSERIAL       PRIMARY KEY,
    cntas_pagar_det_id  BIGINT          NOT NULL REFERENCES finanzas.cntas_pagar_det(id) ON DELETE CASCADE,
    tipos_impuesto_id   BIGINT          NOT NULL REFERENCES core.tipos_impuesto(id),
    importe             NUMERIC(18, 4)  NOT NULL DEFAULT 0,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    UNIQUE (cntas_pagar_det_id, tipos_impuesto_id)
);
CREATE INDEX IF NOT EXISTS IX_CP_DET_IMP_01 ON finanzas.cntas_pagar_det_imp (tipos_impuesto_id);

COMMENT ON TABLE finanzas.cntas_pagar_det_imp IS
    'Impuestos desglosados por cada ítem de cuentas por pagar (equivale a SIGRE CP_DOC_DET_IMP).';

-- ============================================================
-- Impuestos por ítem de Cuentas por Cobrar (SIGRE: CC_DOC_DET_IMP)
-- Relación N:M entre cntas_cobrar_det y core.tipos_impuesto
-- ============================================================
CREATE TABLE IF NOT EXISTS ventas.cntas_cobrar_det_imp (
    id                  BIGSERIAL       PRIMARY KEY,
    cntas_cobrar_det_id BIGINT          NOT NULL REFERENCES ventas.cntas_cobrar_det(id) ON DELETE CASCADE,
    tipos_impuesto_id   BIGINT          NOT NULL REFERENCES core.tipos_impuesto(id),
    importe             NUMERIC(18, 4)  NOT NULL DEFAULT 0,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    UNIQUE (cntas_cobrar_det_id, tipos_impuesto_id)
);
CREATE INDEX IF NOT EXISTS IX_CC_DET_IMP_01 ON ventas.cntas_cobrar_det_imp (tipos_impuesto_id);

COMMENT ON TABLE ventas.cntas_cobrar_det_imp IS
    'Impuestos desglosados por cada ítem de cuentas por cobrar (equivale a SIGRE CC_DOC_DET_IMP).';

-- Migrar impuestos legacy de columnas en det → tablas det_imp (idempotente)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'finanzas' AND table_name = 'cntas_pagar_det' AND column_name = 'tipos_impuesto_id'
    ) THEN
        INSERT INTO finanzas.cntas_pagar_det_imp (cntas_pagar_det_id, tipos_impuesto_id, importe)
        SELECT cpd.id, cpd.tipos_impuesto_id, COALESCE(cpd.impuesto, 0)
        FROM finanzas.cntas_pagar_det cpd
        WHERE cpd.tipos_impuesto_id IS NOT NULL
          AND COALESCE(cpd.impuesto, 0) <> 0
        ON CONFLICT (cntas_pagar_det_id, tipos_impuesto_id) DO NOTHING;

        INSERT INTO finanzas.cntas_pagar_det_imp (cntas_pagar_det_id, tipos_impuesto_id, importe)
        SELECT cpd.id, cpd.tipos_impuesto2_id, COALESCE(cpd.impuesto2, 0)
        FROM finanzas.cntas_pagar_det cpd
        WHERE cpd.tipos_impuesto2_id IS NOT NULL
          AND COALESCE(cpd.impuesto2, 0) <> 0
        ON CONFLICT (cntas_pagar_det_id, tipos_impuesto_id) DO NOTHING;

        ALTER TABLE finanzas.cntas_pagar_det DROP CONSTRAINT IF EXISTS fk_cpd_tipos_impuesto;
        ALTER TABLE finanzas.cntas_pagar_det DROP CONSTRAINT IF EXISTS fk_cpd_tipos_impuesto2;
        ALTER TABLE finanzas.cntas_pagar_det DROP COLUMN IF EXISTS tipos_impuesto_id;
        ALTER TABLE finanzas.cntas_pagar_det DROP COLUMN IF EXISTS impuesto;
        ALTER TABLE finanzas.cntas_pagar_det DROP COLUMN IF EXISTS tipos_impuesto2_id;
        ALTER TABLE finanzas.cntas_pagar_det DROP COLUMN IF EXISTS impuesto2;
    END IF;

    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'ventas' AND table_name = 'cntas_cobrar_det' AND column_name = 'tipos_impuesto_id'
    ) THEN
        INSERT INTO ventas.cntas_cobrar_det_imp (cntas_cobrar_det_id, tipos_impuesto_id, importe)
        SELECT ccd.id, ccd.tipos_impuesto_id, COALESCE(ccd.impuesto, 0)
        FROM ventas.cntas_cobrar_det ccd
        WHERE ccd.tipos_impuesto_id IS NOT NULL
          AND COALESCE(ccd.impuesto, 0) <> 0
        ON CONFLICT (cntas_cobrar_det_id, tipos_impuesto_id) DO NOTHING;

        INSERT INTO ventas.cntas_cobrar_det_imp (cntas_cobrar_det_id, tipos_impuesto_id, importe)
        SELECT ccd.id, ccd.tipos_impuesto2_id, COALESCE(ccd.impuesto2, 0)
        FROM ventas.cntas_cobrar_det ccd
        WHERE ccd.tipos_impuesto2_id IS NOT NULL
          AND COALESCE(ccd.impuesto2, 0) <> 0
        ON CONFLICT (cntas_cobrar_det_id, tipos_impuesto_id) DO NOTHING;

        ALTER TABLE ventas.cntas_cobrar_det DROP CONSTRAINT IF EXISTS fk_ccd_tipos_impuesto;
        ALTER TABLE ventas.cntas_cobrar_det DROP CONSTRAINT IF EXISTS fk_ccd_tipos_impuesto2;
        ALTER TABLE ventas.cntas_cobrar_det DROP COLUMN IF EXISTS tipos_impuesto_id;
        ALTER TABLE ventas.cntas_cobrar_det DROP COLUMN IF EXISTS impuesto;
        ALTER TABLE ventas.cntas_cobrar_det DROP COLUMN IF EXISTS tipos_impuesto2_id;
        ALTER TABLE ventas.cntas_cobrar_det DROP COLUMN IF EXISTS impuesto2;
    END IF;
END $$;

-- ============================================================
-- Índices para optimizar reporte Registro de Compras SUNAT
-- (query_registro_compras_sunat_pg.sql)
-- ============================================================

-- cntas_pagar: búsqueda de referencia por (proveedor, tipo_doc, numero) sin incluir serie
CREATE INDEX IF NOT EXISTS IX_CNTAS_PAGAR_05
    ON finanzas.cntas_pagar (proveedor_id, doc_tipo_id, numero)
    WHERE flag_estado <> '0';

-- cntas_pagar: filtro principal del reporte (periodo + libro + estado activo)
CREATE INDEX IF NOT EXISTS IX_CNTAS_PAGAR_06
    ON finanzas.cntas_pagar (ano, mes, cntbl_libro_id, flag_estado);

-- cntas_pagar_det: cobertura de subconsultas de bases por crédito fiscal con flag_estado
CREATE INDEX IF NOT EXISTS IX_CNTAS_PAGAR_DET_11
    ON finanzas.cntas_pagar_det (cntas_pagar_id, credito_fiscal_id, flag_estado)
    INCLUDE (monto);

-- cntas_pagar_det_imp: búsqueda por det_id (cubre las sumas de impuestos por ítem padre)
CREATE INDEX IF NOT EXISTS IX_CP_DET_IMP_02
    ON finanzas.cntas_pagar_det_imp (cntas_pagar_det_id)
    INCLUDE (tipos_impuesto_id, importe);

-- caja_bancos_det: EXISTS para flag_retencion del reporte
CREATE INDEX IF NOT EXISTS IX_CAJA_BANCOS_DET_04
    ON finanzas.caja_bancos_det (cntas_pagar_id, flag_ret_igv)
    WHERE flag_estado <> '0';

-- cntas_cobrar_det_imp: búsqueda por det_id (simétrico al de CxP)
CREATE INDEX IF NOT EXISTS IX_CC_DET_IMP_02
    ON ventas.cntas_cobrar_det_imp (cntas_cobrar_det_id)
    INCLUDE (tipos_impuesto_id, importe);
