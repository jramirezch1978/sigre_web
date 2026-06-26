-- ============================================================
-- Restaurant.pe ERP - Tenant DB - compras schema
-- DROP de esquemas centralizado en 01-core.sql
-- ============================================================
--
-- DIAGRAMA DE RELACIONES (→ = tiene FK hacia):
--
--   cotizacion → auth.sucursal, core.entidad_contribuyente, core.moneda
--   cotizacion_det → cotizacion, core.articulo
--   orden_compra → auth.sucursal, core.entidad_contribuyente, core.moneda,
--                  core.forma_pago, core.entidad_banco_cnta (cuenta pago proveedor);
--                  nro_orden_compra correlativo vía core.fn_get_document_number('compras.orden_compra', sucursal, ano)
--   tipo_percepcion (catálogo SUNAT: tipos de percepción con tasa)
--   orden_compra_det → orden_compra, core.articulo, almacen.almacen, tipo_percepcion, prog_compras_det (FK tras tabla),
--                      produccion.operaciones_det (FK en 09-produccion.sql), contabilidad.centros_costo (FK diferida)
--   orden_servicio → auth.sucursal, core.entidad_contribuyente, core.moneda, core.doc_tipo,
--                    compras.comprador, produccion.orden_trabajo (FK en 09-produccion.sql)
--   orden_servicio_det → orden_servicio, compras.servicio, contabilidad.centros_costo (FK diferida),
--                        produccion.operaciones_det (FK en 09-produccion.sql)
--   os_ajuste_valor → orden_servicio_det
--   asignacion_os_oc → orden_servicio, orden_compra
--   asignacion_os_oc_det → asignacion_os_oc, orden_servicio_det, orden_compra_det
--   os_conformidad_log → orden_servicio_det
--   conformidad_servicio → orden_servicio
--   conformidad_servicio_det → conformidad_servicio
--   entidad_detraccion → core.entidad_contribuyente, core.detr_bien_serv
--   solicitud_compra → auth.sucursal
--   solicitud_compra_det → solicitud_compra, core.articulo
--   aprobacion (polimórfica, sin FK a tablas padres)
--   contrato_marco → core.entidad_contribuyente
--   comprador (standalone)
--   comprador_categoria → comprador, core.articulo_categ
--   aprobador_configurado (standalone)
--   prog_compras → auth.sucursal
--   prog_compras_det → prog_compras, core.articulo
--   entidad_articulo → core.entidad_contribuyente, core.articulo
--   tipo_entidad_contribuyente (catálogo tipo proveedor/cliente)
--   articulo_precio_pactado → core.articulo, core.entidad_contribuyente, core.moneda
--   articulo_estructura (PK compuesta, sin FK)
--   incoterm (catálogo Incoterms ICC, 14 registros SIGRE)
--   oc_importacion → orden_compra, incoterm
--   compra_fondo (standalone, control de fondos presupuestales)
--   entidad_banco_cnta → core.entidad_contribuyente, core.moneda
--   servicios (standalone)
--
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

CREATE SCHEMA IF NOT EXISTS compras;

-- ============================================================
-- CREATE (tablas, constraints e índices)
-- ============================================================

CREATE TABLE compras.cotizacion (
    id BIGSERIAL PRIMARY KEY,
    sucursal_id BIGINT NOT NULL REFERENCES auth.sucursal(id),
    proveedor_id BIGINT NOT NULL REFERENCES core.entidad_contribuyente(id),
    fecha DATE NOT NULL,
    moneda_id BIGINT REFERENCES core.moneda(id),
    total NUMERIC(18, 4) NOT NULL DEFAULT 0,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

-- Tipos de percepción SUNAT (catálogo maestro: tasa de percepción aplicable a compras)
CREATE TABLE compras.tipo_percepcion (
    id              BIGSERIAL       PRIMARY KEY,
    codigo          VARCHAR(10)     NOT NULL UNIQUE,
    descripcion     VARCHAR(200)    NOT NULL,
    tasa            NUMERIC(7, 4)   NOT NULL,
    flag_estado     VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by      BIGINT,
    fec_creacion    TIMESTAMPTZ     DEFAULT NOW(),
    updated_by      BIGINT,
    fec_modificacion TIMESTAMPTZ
);

CREATE TABLE compras.orden_compra (
    id BIGSERIAL PRIMARY KEY,
    sucursal_id BIGINT NOT NULL REFERENCES auth.sucursal(id),
    nro_orden_compra VARCHAR(12) NOT NULL,
    proveedor_id BIGINT NOT NULL REFERENCES core.entidad_contribuyente(id),
    fecha_emision DATE NOT NULL,
    fecha_entrega DATE,
    moneda_id BIGINT REFERENCES core.moneda(id),
    forma_pago_id BIGINT REFERENCES core.forma_pago(id),
    entidad_banco_cnta_id BIGINT REFERENCES core.entidad_banco_cnta(id),
    lugar_entrega VARCHAR(300),
    observaciones VARCHAR(2000),
    tipo_cambio NUMERIC(10, 4),
    subtotal NUMERIC(18, 4) NOT NULL DEFAULT 0,
    descuento_total NUMERIC(18, 4) NOT NULL DEFAULT 0,
    igv_total NUMERIC(18, 4) NOT NULL DEFAULT 0,
    percepcion_total NUMERIC(18, 4) NOT NULL DEFAULT 0,
    total NUMERIC(18, 4) NOT NULL DEFAULT 0,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    flag_importacion CHAR(1) DEFAULT '0',
    flag_solicita_dua CHAR(1) DEFAULT '0',
    banco_id BIGINT,                       -- FK diferida → finanzas.banco(id) en 05-finanzas.sql
    nro_cuenta VARCHAR(30),
    centro_beneficio VARCHAR(20),
    comprador_id BIGINT,
    aprobador_id BIGINT,
    fecha_aprobacion TIMESTAMPTZ,
    motivo_anulacion TEXT,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT UQ_ORDEN_COMPRA_NRO UNIQUE (nro_orden_compra)
);

COMMENT ON COLUMN compras.orden_compra.nro_orden_compra IS
    'Número de OC legible: codigo sucursal + año (fecha_emision) + 9 dígitos; único en el tenant.';

CREATE TABLE compras.orden_compra_det (
    id BIGSERIAL PRIMARY KEY,
    orden_compra_id BIGINT NOT NULL REFERENCES compras.orden_compra(id),
    articulo_id BIGINT NOT NULL REFERENCES core.articulo(id),
    cant_proyectada NUMERIC(18, 4) NOT NULL,
    fec_proyectada DATE,
    cant_procesada NUMERIC(18, 4) NOT NULL DEFAULT 0,
    cant_facturada NUMERIC(18, 4) NOT NULL DEFAULT 0,
    valor_unitario NUMERIC(18, 6) NOT NULL,
    tipo_impuesto_id BIGINT REFERENCES core.tipos_impuesto(id),
    valor_impuesto NUMERIC(18, 4) DEFAULT 0,
    descuento_porcentaje NUMERIC(7, 4) DEFAULT 0,
    descuento_monto NUMERIC(18, 4) DEFAULT 0,
    tipo_percepcion_id BIGINT REFERENCES compras.tipo_percepcion(id),
    percepcion_monto NUMERIC(18, 4) DEFAULT 0,
    subtotal NUMERIC(18, 4) NOT NULL DEFAULT 0,
    centros_costo_id BIGINT, -- FK diferida: se crea en 06-contabilidad.sql
    almacen_id BIGINT REFERENCES almacen.almacen(id),
    referencia_sol_compra_id BIGINT,
    fecha_entrega DATE,
    operaciones_det_id BIGINT, -- FK: produccion.operaciones_det (enlace a requerimiento de OT)
    prog_compras_det_id BIGINT, -- FK: se crea tras CREATE prog_compras_det
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

-- Maestro de servicios (compras) — base SIGRE SERVICIOS
-- Movimiento proyectado de articulos originado por la OC
CREATE TABLE compras.articulo_mov_proy (
    id BIGSERIAL PRIMARY KEY,
    articulo_id BIGINT NOT NULL REFERENCES core.articulo(id),
    almacen_id BIGINT REFERENCES almacen.almacen(id),
    orden_compra_det_id BIGINT REFERENCES compras.orden_compra_det(id),
    cantidad NUMERIC(18,4) NOT NULL,
    fecha_proyectada DATE,
    tipo_origen VARCHAR(20) DEFAULT 'OC',
    flag_estado VARCHAR(1) DEFAULT '1',
    created_by BIGINT,
    fec_creacion TIMESTAMPTZ DEFAULT NOW(),
    updated_by BIGINT,
    fec_modificacion TIMESTAMPTZ
);

CREATE TABLE compras.servicio (
    id                  BIGSERIAL       NOT NULL,
    servicio            CHAR(6)         NOT NULL UNIQUE,
    flag_estado VARCHAR(1)         DEFAULT '1',
    articulo_sub_categ_id BIGINT REFERENCES core.articulo_sub_categ(id),
    descripcion         VARCHAR(200),
    tarifa_estd         NUMERIC(18,4),
    unidad_medida_id    BIGINT          REFERENCES core.unidad_medida(id),
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_SERVICIO PRIMARY KEY (id)
);

-- Orden de servicio (cabecera)
-- Modelo alineado a SIGRE (ORDEN_SERVICIO) + HU_ORDENES_SERVICIO.md. Los servicios, a diferencia
-- de las ordenes de compra, operan por IMPORTE por linea (no por cantidad x precio unitario).
CREATE TABLE compras.orden_servicio (
    id                      BIGSERIAL       PRIMARY KEY,
    sucursal_id             BIGINT          NOT NULL REFERENCES auth.sucursal(id),
    cod_origen              VARCHAR(10),                                                    -- Código de origen (OS, etc.)
    nro_os                  VARCHAR(30)     NOT NULL,                                                    -- SIGRE: NRO_OS (formato: cod_origen + '-' + LPAD(ult_nro,8,'0'); ampliado de 12 a 30 por overflow al numerar)
    doc_tipo_id             BIGINT          REFERENCES core.doc_tipo(id),
    proveedor_id            BIGINT          NOT NULL REFERENCES core.entidad_contribuyente(id),
    entidad_direccion_id    BIGINT          REFERENCES core.entidad_direccion(id),            -- SIGRE: DIRECCION_ITEM
    nom_vendedor            VARCHAR(300),                                                    -- SIGRE: NOM_VENDEDOR
    fecha_emision           DATE            NOT NULL,                                       -- SIGRE: FEC_REGISTRO
    moneda_id               BIGINT          REFERENCES core.moneda(id),
    tipo_cambio             NUMERIC(10,4),                                                  -- Moderno (no SIGRE)
    forma_pago_id           BIGINT          REFERENCES core.forma_pago(id),                 -- SIGRE: FORMA_PAGO
    descripcion             VARCHAR(2000),                                                  -- SIGRE: DESCRIPCION
    comprador_id            BIGINT,                                                         -- SIGRE: COD_USR (FK diferida a compras.comprador: constraint definido tras CREATE compras.comprador más abajo)
    banco_id                BIGINT,                                                         -- SIGRE: COD_BANCO. FK diferida → finanzas.banco(id) en 05-finanzas.sql
    nro_cuenta              VARCHAR(30),                                                    -- SIGRE: NRO_CUENTA
    flag_cotizacion         CHAR(1)         NOT NULL DEFAULT '0',                           -- SIGRE: FLAG_COTIZACION
    flag_req_serv           CHAR(1)         NOT NULL DEFAULT '0',                           -- SIGRE: FLAG_REQ_SERV (0=Usuario, 1=Compra, 2=Otro proceso)
    flag_solicita_acta      CHAR(1)         NOT NULL DEFAULT '0',                           -- SIGRE: FLAG_SOLICITA_ACTA
    orden_trabajo_id        BIGINT,                                                         -- FK a orden de trabajo (cuando aplica)
    monto_facturado         NUMERIC(18,4)   NOT NULL DEFAULT 0,                             -- SIGRE: MONTO_FACTURADO
    monto_conforme          NUMERIC(18,4)   NOT NULL DEFAULT 0,                             -- SIGRE: MONTO_CONFORME
    total                   NUMERIC(18,4)   NOT NULL DEFAULT 0,                             -- SIGRE: MONTO_TOTAL
    aprobador_id            BIGINT,                                                         -- SIGRE: APROBADOR (usuario que aprobo)
    fecha_aprob             TIMESTAMP,                                                      -- SIGRE: FECHA_APROB
    motivo_anulacion        TEXT,                                                           -- SIGRE: MOTIVO_BAJA
    fecha_baja              TIMESTAMPTZ,                                                    -- SIGRE: FECHA_BAJA
    usr_baja                BIGINT,                                                         -- SIGRE: USR_BAJA
    flag_estado VARCHAR(1)         NOT NULL DEFAULT '1',                           -- SIGRE: FLAG_ESTADO (0=Anulado, 1=Activo, 2=Cerrado, 3=Pendiente VoBo)
    created_by              BIGINT,
    fec_creacion            TIMESTAMPTZ     DEFAULT NOW(),
    updated_by              BIGINT,
    fec_modificacion        TIMESTAMPTZ,
    CONSTRAINT UK_ORDEN_SERVICIO_NUMERO UNIQUE (sucursal_id, nro_os)
);

-- Orden de servicio (detalle)
-- Modelo alineado a SIGRE (ORDEN_SERVICIO_DET) + HU_ORDENES_SERVICIO.md. El detalle lleva IMPORTE
-- directo (no cantidad x precio unitario como OC) y admite dos impuestos (IGV + percepcion/detraccion).
CREATE TABLE compras.orden_servicio_det (
    id                      BIGSERIAL       PRIMARY KEY,
    orden_servicio_id       BIGINT          NOT NULL REFERENCES compras.orden_servicio(id),
    nro_item                INTEGER         NOT NULL,                                       -- SIGRE: NRO_ITEM
    servicio_id             BIGINT          NOT NULL REFERENCES compras.servicio(id),       -- SIGRE: SERVICIO (resuelto por codigo)
    descripcion             VARCHAR(2000)   NOT NULL,                                       -- SIGRE: DESCRIPCION (descripcion libre de la linea)
    fec_proyect             DATE,                                                           -- SIGRE: FEC_PROYECT (fecha proyectada de ejecucion del servicio)
    fec_fin_servicio        DATE,                                                           -- SIGRE: FEC_FIN_SERVICIO
    importe                 NUMERIC(18,4)   NOT NULL DEFAULT 0,                             -- SIGRE: IMPORTE (importe pactado del servicio, base)
    descto_porcentaje       NUMERIC(7,4)    NOT NULL DEFAULT 0,                             -- Moderno: porcentaje de descuento
    decuento                NUMERIC(18,4)   NOT NULL DEFAULT 0,                             -- SIGRE: DECUENTO (monto de descuento calculado)
    tipos_impuesto_id       BIGINT          REFERENCES core.tipos_impuesto(id),              -- SIGRE: TIPO_IMPUESTO (ej: IGV)
    impuesto                NUMERIC(18,4)   NOT NULL DEFAULT 0,                             -- SIGRE: IMPUESTO (monto de impuesto 1)
    tipos_impuesto2_id      BIGINT          REFERENCES core.tipos_impuesto(id),             -- SIGRE: TIPO_IMPUESTO2 (ej: PERCEPCION, DETRACCION)
    impuesto2               NUMERIC(18,4)   NOT NULL DEFAULT 0,                             -- SIGRE: IMPUESTO2
    subtotal                NUMERIC(18,4)   NOT NULL DEFAULT 0,                             -- Calculado: importe - decuento + impuesto + impuesto2
    imp_provisionado        NUMERIC(18,4)   NOT NULL DEFAULT 0,                             -- SIGRE: IMP_PROVISIONADO (lo que ya se facturo via cuentas por pagar)
    centros_costo_id        BIGINT,                                                         -- SIGRE: CENCOS. FK diferida a contabilidad.centros_costo (06-contabilidad.sql)
    concepto_financiero_id  BIGINT,                                                         -- SIGRE: CONFIN. FK diferida a finanzas.concepto_financiero (05-finanzas.sql)
    operaciones_det_id      BIGINT,                                                         -- SIGRE: OPER_SEC. FK diferida a produccion.operaciones_det (09-produccion.sql)
    conformidad_fecha       TIMESTAMPTZ,                                                    -- SIGRE: CONFORMIDAD_FECHA
    conformidad_usr         BIGINT          REFERENCES auth.usuario(id),                     -- SIGRE: CONFORMIDAD_USR
    aprobador_id            BIGINT,                                                         -- SIGRE: APROBADOR (aprobador por linea, para flujos por item)
    fec_aprobacion          TIMESTAMPTZ,                                                    -- SIGRE: FEC_APROBACION
    flag_estado VARCHAR(1)         NOT NULL DEFAULT '1',                           -- 0=Anulado, 1=Activo, 2=Cerrado
    created_by              BIGINT,
    fec_creacion            TIMESTAMPTZ     DEFAULT NOW(),
    updated_by              BIGINT,
    fec_modificacion        TIMESTAMPTZ,
    CONSTRAINT UK_ORDEN_SERVICIO_DET_ITEM UNIQUE (orden_servicio_id, nro_item)
);

-- Numerador correlativo de ordenes de servicio por sucursal y origen
CREATE TABLE compras.num_ord_srv (
    id BIGSERIAL PRIMARY KEY,
    sucursal_id BIGINT NOT NULL,
    cod_origen VARCHAR(10) NOT NULL,
    ult_nro BIGINT DEFAULT 0
);

-- Historial de ajustes de importe por linea de OS
CREATE TABLE compras.os_ajuste_valor (
    id                      BIGSERIAL       PRIMARY KEY,
    orden_servicio_det_id   BIGINT          NOT NULL REFERENCES compras.orden_servicio_det(id),
    importe_anterior        NUMERIC(18,4)   NOT NULL,
    importe_nuevo           NUMERIC(18,4)   NOT NULL,
    motivo                  TEXT,
    created_by              BIGINT          NOT NULL,
    fec_creacion            TIMESTAMPTZ     DEFAULT NOW()
);

-- Vinculo OS <-> OC (cabecera)
CREATE TABLE compras.asignacion_os_oc (
    id                      BIGSERIAL       PRIMARY KEY,
    orden_servicio_id       BIGINT          NOT NULL REFERENCES compras.orden_servicio(id),
    orden_compra_id         BIGINT          NOT NULL REFERENCES compras.orden_compra(id),
    fecha_asignacion        TIMESTAMPTZ     DEFAULT NOW(),
    created_by              BIGINT,
    fec_creacion            TIMESTAMPTZ     DEFAULT NOW(),
    CONSTRAINT UQ_ASIGNACION_OS_OC UNIQUE (orden_servicio_id, orden_compra_id)
);

-- Vinculo OS <-> OC (detalle)
CREATE TABLE compras.asignacion_os_oc_det (
    id                      BIGSERIAL       PRIMARY KEY,
    asignacion_os_oc_id     BIGINT          NOT NULL REFERENCES compras.asignacion_os_oc(id),
    orden_servicio_det_id   BIGINT          NOT NULL REFERENCES compras.orden_servicio_det(id),
    orden_compra_det_id     BIGINT          NOT NULL REFERENCES compras.orden_compra_det(id),
    monto_aplicado          NUMERIC(18,4)   NOT NULL DEFAULT 0,
    created_by              BIGINT,
    fec_creacion            TIMESTAMPTZ     DEFAULT NOW()
);

-- Bitacora de conformidad por linea de OS
CREATE TABLE compras.os_conformidad_log (
    id                      BIGSERIAL       PRIMARY KEY,
    orden_servicio_det_id   BIGINT          NOT NULL REFERENCES compras.orden_servicio_det(id),
    accion                  VARCHAR(20)     NOT NULL,
    usuario_id              BIGINT          NOT NULL,
    fecha                   TIMESTAMPTZ     DEFAULT NOW(),
    observacion             TEXT
);

CREATE TABLE compras.conformidad_servicio (
    id BIGSERIAL PRIMARY KEY,
    orden_servicio_id BIGINT NOT NULL REFERENCES compras.orden_servicio(id),
    fecha DATE NOT NULL,
    observacion TEXT,
    aprobado BOOLEAN NOT NULL DEFAULT FALSE,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE compras.entidad_detraccion (
    id BIGSERIAL PRIMARY KEY,
    entidad_contribuyente_id BIGINT NOT NULL REFERENCES core.entidad_contribuyente(id),
    detr_bien_serv_id BIGINT NOT NULL,                                                     -- FK diferida → core.detr_bien_serv(id)
    porcentaje NUMERIC(7, 4) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE compras.solicitud_compra (
    id                  BIGSERIAL       NOT NULL,
    sucursal_id         BIGINT REFERENCES auth.sucursal(id),
    nrol_sol_compra     VARCHAR(12)     NOT NULL UNIQUE,
    fecha               DATE            NOT NULL,
    solicitante_id      BIGINT,
    prioridad           VARCHAR(20),
    justificacion       TEXT,
    flag_estado         VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_SOLICITUD_COMPRA PRIMARY KEY (id)
);

CREATE TABLE compras.solicitud_compra_det (
    id                  BIGSERIAL       NOT NULL,
    solicitud_id        BIGINT          NOT NULL,
    articulo_id         BIGINT          NOT NULL,
    almacen_id          BIGINT          REFERENCES almacen.almacen(id),
    cantidad            NUMERIC(18,4)   NOT NULL,
    especificaciones    TEXT,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_SOLICITUD_COMPRA_DET PRIMARY KEY (id),
    CONSTRAINT FK_SOLICITUD_COMPRA_DET_01 FOREIGN KEY (solicitud_id) REFERENCES compras.solicitud_compra(id),
    CONSTRAINT FK_SOLICITUD_COMPRA_DET_02 FOREIGN KEY (articulo_id) REFERENCES core.articulo(id)
);

CREATE TABLE compras.cotizacion_det (
    id                  BIGSERIAL       NOT NULL,
    cotizacion_id       BIGINT          NOT NULL,
    articulo_id         BIGINT          NOT NULL,
    cantidad            NUMERIC(18,4)   NOT NULL,
    precio_unitario     NUMERIC(18,4)   NOT NULL,
    descuento           NUMERIC(18,4)   DEFAULT 0,
    plazo_entrega_dias  INTEGER,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_COTIZACION_DET PRIMARY KEY (id),
    CONSTRAINT FK_COTIZACION_DET_01 FOREIGN KEY (cotizacion_id) REFERENCES compras.cotizacion(id),
    CONSTRAINT FK_COTIZACION_DET_02 FOREIGN KEY (articulo_id) REFERENCES core.articulo(id)
);

CREATE TABLE compras.aprobacion (
    id                  BIGSERIAL       NOT NULL,
    doc_tipo_id         BIGINT          NOT NULL REFERENCES core.doc_tipo(id),
    documento_id        BIGINT          NOT NULL,
    nivel               INTEGER         NOT NULL DEFAULT 1,
    aprobador_id        BIGINT,
    accion              VARCHAR(20),
    comentario          TEXT,
    fecha               TIMESTAMPTZ     DEFAULT NOW(),
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_APROBACION PRIMARY KEY (id)
);

CREATE TABLE compras.conformidad_servicio_det (
    id                          BIGSERIAL       NOT NULL,
    conformidad_servicio_id     BIGINT          NOT NULL,
    secuencia                   INTEGER         NOT NULL,
    descripcion                 TEXT,
    cantidad                    NUMERIC(18,4),
    precio_unitario             NUMERIC(18,4),
    subtotal                    NUMERIC(18,4),
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CONFORMIDAD_SERVICIO_DET PRIMARY KEY (id),
    CONSTRAINT FK_CONFORMIDAD_SERVICIO_DET_01 FOREIGN KEY (conformidad_servicio_id) REFERENCES compras.conformidad_servicio(id)
);

CREATE TABLE compras.contrato_marco (
    id                  BIGSERIAL       NOT NULL,
    proveedor_id        BIGINT          NOT NULL,
    nro_contrato_marco  VARCHAR(12)     NOT NULL UNIQUE,
    fecha_inicio        DATE            NOT NULL,
    fecha_fin           DATE,
    condiciones         TEXT,
    flag_estado         VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CONTRATO_MARCO PRIMARY KEY (id),
    CONSTRAINT FK_CONTRATO_MARCO_01 FOREIGN KEY (proveedor_id) REFERENCES core.entidad_contribuyente(id)
);

CREATE TABLE compras.comprador (
    id                  BIGSERIAL       NOT NULL,
    usuario_id          BIGINT          NOT NULL,
    nombre              VARCHAR(150),
    flag_estado VARCHAR(1)         NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_COMPRADOR PRIMARY KEY (id)
);

-- FK diferida: compras.orden_servicio.comprador_id → compras.comprador (definido arriba).
-- La columna se declara sin REFERENCES en el CREATE de orden_servicio para evitar la dependencia
-- de orden de tablas dentro del mismo script.
ALTER TABLE compras.orden_servicio DROP CONSTRAINT IF EXISTS FK_ORDEN_SERVICIO_COMPRADOR;
ALTER TABLE compras.orden_servicio
    ADD CONSTRAINT FK_ORDEN_SERVICIO_COMPRADOR FOREIGN KEY (comprador_id) REFERENCES compras.comprador(id);

CREATE TABLE compras.comprador_categoria (
    id                  BIGSERIAL       NOT NULL,
    comprador_id        BIGINT          NOT NULL,
    articulo_categ_id   BIGINT          NOT NULL,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_COMPRADOR_CATEGORIA PRIMARY KEY (id),
    CONSTRAINT FK_COMPRADOR_CATEGORIA_01 FOREIGN KEY (comprador_id) REFERENCES compras.comprador(id),
    CONSTRAINT FK_COMPRADOR_CATEGORIA_02 FOREIGN KEY (articulo_categ_id) REFERENCES core.articulo_categ(id)
);

CREATE TABLE compras.aprobador_configurado (
    id                  BIGSERIAL       NOT NULL,
    doc_tipo_id         BIGINT          NOT NULL REFERENCES core.doc_tipo(id),
    nivel               INTEGER         NOT NULL,
    aprobador_id        BIGINT          NOT NULL,
    monto_minimo        NUMERIC(18,4),
    monto_maximo        NUMERIC(18,4),
    flag_estado VARCHAR(1)         NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_APROBADOR_CONFIGURADO PRIMARY KEY (id)
);

CREATE TABLE compras.prog_compras (
    id                  BIGSERIAL       NOT NULL,
    sucursal_id         BIGINT REFERENCES auth.sucursal(id),
    nro_prog_compras    VARCHAR(12)     NOT NULL UNIQUE,
    anio                INTEGER         NOT NULL,
    mes                 INTEGER         NOT NULL,
    flag_estado         VARCHAR(1)     NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_PROG_COMPRAS PRIMARY KEY (id)
);

CREATE TABLE compras.prog_compras_det (
    id                  BIGSERIAL       NOT NULL,
    prog_compras_id     BIGINT          NOT NULL,
    articulo_id         BIGINT          NOT NULL,
    cantidad            NUMERIC(18,4)   NOT NULL,
    precio_estimado     NUMERIC(18,4),
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_PROG_COMPRAS_DET PRIMARY KEY (id),
    CONSTRAINT FK_PROG_COMPRAS_DET_01 FOREIGN KEY (prog_compras_id) REFERENCES compras.prog_compras(id),
    CONSTRAINT FK_PROG_COMPRAS_DET_02 FOREIGN KEY (articulo_id) REFERENCES core.articulo(id)
);

ALTER TABLE compras.orden_compra_det
    ADD CONSTRAINT FK_OC_DET_PROG_COMPRAS_DET FOREIGN KEY (prog_compras_det_id) REFERENCES compras.prog_compras_det(id);

-- almacen.vale_mov → compras: columnas en 02-almacen.sql sin REFERENCES; FK tras existir tablas destino.
ALTER TABLE almacen.vale_mov
    ADD CONSTRAINT FK_VALE_MOV_ORDEN_COMPRA FOREIGN KEY (orden_compra_id) REFERENCES compras.orden_compra(id);

ALTER TABLE almacen.vale_mov
    ADD CONSTRAINT FK_VALE_MOV_PROG_COMPRAS FOREIGN KEY (prog_compras_id) REFERENCES compras.prog_compras(id);

CREATE INDEX IX_VALE_MOV_05 ON almacen.vale_mov (orden_compra_id);
CREATE INDEX IX_VALE_MOV_06 ON almacen.vale_mov (prog_compras_id);

CREATE TABLE compras.entidad_articulo (
    id                          BIGSERIAL       NOT NULL,
    entidad_contribuyente_id    BIGINT          NOT NULL,
    articulo_id                 BIGINT          NOT NULL,
    precio_referencia           NUMERIC(18,4),
    flag_estado VARCHAR(1)         NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_ENTIDAD_ARTICULO PRIMARY KEY (id),
    CONSTRAINT FK_ENTIDAD_ARTICULO_01 FOREIGN KEY (entidad_contribuyente_id) REFERENCES core.entidad_contribuyente(id),
    CONSTRAINT FK_ENTIDAD_ARTICULO_02 FOREIGN KEY (articulo_id) REFERENCES core.articulo(id)
);

CREATE TABLE compras.tipo_entidad_contribuyente (
    id                          BIGSERIAL       NOT NULL,
    tipo                        VARCHAR(30)     NOT NULL,
    descripcion                 VARCHAR(200)    NOT NULL,
    flag_estado VARCHAR(1)         NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_TIPO_ENTIDAD_CONTRIBUYENTE PRIMARY KEY (id)
);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_entidad_tipo_entidad_contrib')
    THEN ALTER TABLE core.entidad_contribuyente ADD CONSTRAINT fk_entidad_tipo_entidad_contrib FOREIGN KEY (tipo_entidad_contribuyente_id) REFERENCES compras.tipo_entidad_contribuyente(id); END IF; END $$;

CREATE TABLE compras.articulo_precio_pactado (
    id                  BIGSERIAL       NOT NULL,
    articulo_id         BIGINT          NOT NULL,
    proveedor_id        BIGINT          NOT NULL,
    precio              NUMERIC(18,4)   NOT NULL,
    moneda_id           BIGINT,
    fecha_desde         DATE,
    fecha_hasta         DATE,
    flag_estado VARCHAR(1)         NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_ARTICULO_PRECIO_PACTADO PRIMARY KEY (id),
    CONSTRAINT FK_ARTICULO_PRECIO_PACTADO_01 FOREIGN KEY (articulo_id) REFERENCES core.articulo(id),
    CONSTRAINT FK_ARTICULO_PRECIO_PACTADO_02 FOREIGN KEY (proveedor_id) REFERENCES core.entidad_contribuyente(id),
    CONSTRAINT FK_ARTICULO_PRECIO_PACTADO_03 FOREIGN KEY (moneda_id) REFERENCES core.moneda(id)
);

CREATE TABLE compras.articulo_estructura (
    articulo_padre_id    BIGINT          NOT NULL REFERENCES core.articulo(id),
    articulo_hijo_id     BIGINT          NOT NULL REFERENCES core.articulo(id),
    cantidad             NUMERIC(18,4)   NOT NULL DEFAULT 0,
    created_by           BIGINT,
    fec_creacion         TIMESTAMPTZ     DEFAULT NOW(),
    updated_by           BIGINT,
    fec_modificacion     TIMESTAMPTZ,
    CONSTRAINT PK_ARTICULO_ESTRUCTURA PRIMARY KEY (articulo_padre_id, articulo_hijo_id)
);

-- Incoterms (SIGRE: INCOTERM, 14 registros)
CREATE TABLE compras.incoterm (
    id                  BIGSERIAL       NOT NULL,
    codigo              CHAR(3)         NOT NULL UNIQUE,
    descripcion         VARCHAR(200),
    flag_estado         VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_INCOTERM PRIMARY KEY (id)
);

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
         WHERE table_schema = 'compras' AND table_name = 'incoterm' AND column_name = 'descripcion'
           AND (character_maximum_length IS NULL OR character_maximum_length < 200)
    ) THEN
        ALTER TABLE compras.incoterm ALTER COLUMN descripcion TYPE VARCHAR(200);
    END IF;
END $$;

-- Importación de OC (datos DUA, puertos, agente)
CREATE TABLE compras.oc_importacion (
    id                  BIGSERIAL       NOT NULL,
    orden_compra_id     BIGINT          NOT NULL,
    incoterm_id         BIGINT          REFERENCES compras.incoterm(id),
    puerto_embarque     VARCHAR(100),
    puerto_destino      VARCHAR(100),
    agente_aduanas      VARCHAR(200),
    nro_dua             VARCHAR(30),
    fecha_embarque      DATE,
    fecha_llegada_est   DATE,
    observaciones       TEXT,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_OC_IMPORTACION PRIMARY KEY (id),
    CONSTRAINT FK_OC_IMPORTACION_01 FOREIGN KEY (orden_compra_id) REFERENCES compras.orden_compra(id)
);

-- Control de fondos presupuestales por centro de costo + año
CREATE TABLE compras.compra_fondo (
    id                  BIGSERIAL       NOT NULL,
    centros_costo_id    BIGINT          NOT NULL,           -- FK diferida → contabilidad.centros_costo(id) en 06-contabilidad.sql
    monto_total         NUMERIC(18, 4)  NOT NULL DEFAULT 0,
    monto_usado         NUMERIC(18, 4)  NOT NULL DEFAULT 0,
    anio                INTEGER         NOT NULL,
    flag_estado VARCHAR(1)         DEFAULT '1',
    CONSTRAINT PK_COMPRA_FONDO PRIMARY KEY (id),
    CONSTRAINT UQ_COMPRA_FONDO_01 UNIQUE (centros_costo_id, anio)
);

-- Cuentas bancarias de la entidad (proveedor/cliente) (banco + moneda)
CREATE TABLE compras.entidad_banco_cnta (
    id                  BIGSERIAL       NOT NULL,
    entidad_contribuyente_id BIGINT     NOT NULL,
    moneda_id           BIGINT          NOT NULL,
    banco_id            BIGINT,                             -- FK diferida → finanzas.banco(id) en 05-finanzas.sql
    nro_cuenta          VARCHAR(30),
    cci                 VARCHAR(20),                        -- Código de Cuenta Interbancaria
    flag_tipo_cuenta    CHAR(1),                            -- A=Ahorros, C=Cuenta Corriente
    flag_estado VARCHAR(1)         DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_ENTIDAD_BANCO_CNTA PRIMARY KEY (id),
    CONSTRAINT FK_ENTIDAD_BANCO_CNTA_01 FOREIGN KEY (entidad_contribuyente_id) REFERENCES core.entidad_contribuyente(id),
    CONSTRAINT FK_ENTIDAD_BANCO_CNTA_02 FOREIGN KEY (moneda_id) REFERENCES core.moneda(id),
    CONSTRAINT CK_ENTIDAD_BANCO_CNTA_TIPO CHECK (flag_tipo_cuenta IN ('A', 'C'))
);

-- ============================================================
-- SECCIÓN 2B: TABLAS IDEMPOTENTES (templates clonados sin estas tablas OS)
-- ============================================================

CREATE TABLE IF NOT EXISTS compras.os_ajuste_valor (
    id                      BIGSERIAL       PRIMARY KEY,
    orden_servicio_det_id   BIGINT          NOT NULL REFERENCES compras.orden_servicio_det(id),
    importe_anterior        NUMERIC(18,4)   NOT NULL,
    importe_nuevo           NUMERIC(18,4)   NOT NULL,
    motivo                  TEXT,
    created_by              BIGINT          NOT NULL,
    fec_creacion            TIMESTAMPTZ     DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS compras.asignacion_os_oc (
    id                      BIGSERIAL       PRIMARY KEY,
    orden_servicio_id       BIGINT          NOT NULL REFERENCES compras.orden_servicio(id),
    orden_compra_id         BIGINT          NOT NULL REFERENCES compras.orden_compra(id),
    fecha_asignacion        TIMESTAMPTZ     DEFAULT NOW(),
    created_by              BIGINT,
    fec_creacion            TIMESTAMPTZ     DEFAULT NOW(),
    CONSTRAINT UQ_ASIGNACION_OS_OC UNIQUE (orden_servicio_id, orden_compra_id)
);

CREATE TABLE IF NOT EXISTS compras.asignacion_os_oc_det (
    id                      BIGSERIAL       PRIMARY KEY,
    asignacion_os_oc_id     BIGINT          NOT NULL REFERENCES compras.asignacion_os_oc(id),
    orden_servicio_det_id   BIGINT          NOT NULL REFERENCES compras.orden_servicio_det(id),
    orden_compra_det_id     BIGINT          NOT NULL REFERENCES compras.orden_compra_det(id),
    monto_aplicado          NUMERIC(18,4)   NOT NULL DEFAULT 0,
    created_by              BIGINT,
    fec_creacion            TIMESTAMPTZ     DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS compras.os_conformidad_log (
    id                      BIGSERIAL       PRIMARY KEY,
    orden_servicio_det_id   BIGINT          NOT NULL REFERENCES compras.orden_servicio_det(id),
    accion                  VARCHAR(20)     NOT NULL,
    usuario_id              BIGINT          NOT NULL,
    fecha                   TIMESTAMPTZ     DEFAULT NOW(),
    observacion             TEXT
);

-- ============================================================
-- SECCIÓN 3: ÍNDICES
-- ============================================================

CREATE INDEX IX_ORDEN_COMPRA_01 ON compras.orden_compra (proveedor_id, fecha_emision);
CREATE INDEX IX_ORDEN_COMPRA_DET_01 ON compras.orden_compra_det (orden_compra_id, articulo_id);
CREATE INDEX IX_ORDEN_COMPRA_DET_02 ON compras.orden_compra_det (almacen_id);
CREATE INDEX IX_ORDEN_COMPRA_DET_03 ON compras.orden_compra_det (prog_compras_det_id);
CREATE INDEX IX_ORDEN_COMPRA_DET_04 ON compras.orden_compra_det (operaciones_det_id);
CREATE INDEX IF NOT EXISTS IX_ARTICULO_MOV_PROY_01 ON compras.articulo_mov_proy (articulo_id);
CREATE INDEX IF NOT EXISTS IX_ARTICULO_MOV_PROY_02 ON compras.articulo_mov_proy (almacen_id);
CREATE INDEX IF NOT EXISTS IX_ARTICULO_MOV_PROY_03 ON compras.articulo_mov_proy (orden_compra_det_id);
CREATE INDEX IX_SOLICITUD_COMPRA_01          ON compras.solicitud_compra (sucursal_id, fecha);
CREATE INDEX IX_SOLICITUD_COMPRA_DET_01      ON compras.solicitud_compra_det (solicitud_id, articulo_id);
CREATE INDEX IX_COTIZACION_DET_01            ON compras.cotizacion_det (cotizacion_id, articulo_id);
CREATE INDEX IX_APROBACION_01                ON compras.aprobacion (doc_tipo_id, documento_id);
CREATE INDEX IX_CONFORMIDAD_SERVICIO_DET_01  ON compras.conformidad_servicio_det (conformidad_servicio_id);
CREATE INDEX IX_CONTRATO_MARCO_01            ON compras.contrato_marco (proveedor_id, flag_estado);
CREATE INDEX IX_COMPRADOR_CATEGORIA_01       ON compras.comprador_categoria (comprador_id, articulo_categ_id);
CREATE INDEX IX_APROBADOR_CONFIGURADO_01     ON compras.aprobador_configurado (doc_tipo_id, nivel);
CREATE INDEX IX_PROG_COMPRAS_01              ON compras.prog_compras (sucursal_id, anio, mes);
CREATE INDEX IX_PROG_COMPRAS_DET_01          ON compras.prog_compras_det (prog_compras_id, articulo_id);
CREATE INDEX IX_ENTIDAD_ARTICULO_01          ON compras.entidad_articulo (entidad_contribuyente_id, articulo_id);
CREATE INDEX IX_TIPO_ENTIDAD_CONTRIBUYENTE_01 ON compras.tipo_entidad_contribuyente (tipo);
CREATE INDEX IX_ARTICULO_PRECIO_PACTADO_01   ON compras.articulo_precio_pactado (articulo_id, proveedor_id);
CREATE INDEX IX_ARTICULO_ESTRUCTURA_01       ON compras.articulo_estructura (articulo_padre_id);
CREATE INDEX IX_ARTICULO_ESTRUCTURA_02       ON compras.articulo_estructura (articulo_hijo_id);
CREATE INDEX IX_SERVICIO_01                  ON compras.servicio (flag_estado);
CREATE INDEX IX_SERVICIO_02                  ON compras.servicio (articulo_sub_categ_id);
CREATE INDEX IX_ORDEN_SERVICIO_01            ON compras.orden_servicio (sucursal_id, fecha_emision);
CREATE INDEX IX_ORDEN_SERVICIO_02            ON compras.orden_servicio (proveedor_id);
CREATE INDEX IX_ORDEN_SERVICIO_03            ON compras.orden_servicio (flag_estado);
CREATE INDEX IX_ORDEN_SERVICIO_04            ON compras.orden_servicio (comprador_id);
CREATE INDEX IX_ORDEN_SERVICIO_DET_01        ON compras.orden_servicio_det (orden_servicio_id, servicio_id);
CREATE INDEX IX_ORDEN_SERVICIO_DET_02        ON compras.orden_servicio_det (centros_costo_id);
CREATE INDEX IX_ORDEN_SERVICIO_DET_03        ON compras.orden_servicio_det (operaciones_det_id);
CREATE INDEX IX_OS_AJUSTE_VALOR_01           ON compras.os_ajuste_valor (orden_servicio_det_id);
CREATE INDEX IX_ASIGNACION_OS_OC_01          ON compras.asignacion_os_oc (orden_servicio_id);
CREATE INDEX IX_ASIGNACION_OS_OC_02          ON compras.asignacion_os_oc (orden_compra_id);
CREATE INDEX IX_ASIGNACION_OS_OC_DET_01       ON compras.asignacion_os_oc_det (asignacion_os_oc_id);
CREATE INDEX IX_OS_CONFORMIDAD_LOG_01        ON compras.os_conformidad_log (orden_servicio_det_id);
CREATE UNIQUE INDEX IF NOT EXISTS UQ_NUM_ORD_SRV ON compras.num_ord_srv (sucursal_id, cod_origen);
CREATE INDEX IX_OC_IMPORTACION_01           ON compras.oc_importacion (orden_compra_id);
CREATE INDEX IX_ENTIDAD_BANCO_CNTA_01       ON compras.entidad_banco_cnta (entidad_contribuyente_id, moneda_id);

-- ============================================================
-- SECCION 4: DATOS MINIMOS OPERATIVOS
-- ============================================================

INSERT INTO compras.num_ord_srv (sucursal_id, cod_origen, ult_nro)
VALUES (1, 'OS', 0)
ON CONFLICT (sucursal_id, cod_origen) DO NOTHING;

-- Catálogo Incoterms (ICC 2020). compras.oc_importacion.incoterm_id referencia este maestro;
-- el front opera con el código (codigo CHAR(3), ej. 'FOB'), resuelto a id en el backend.
INSERT INTO compras.incoterm (codigo, descripcion) VALUES
    ('EXW', 'Ex Works / En fábrica'),
    ('FCA', 'Free Carrier / Franco transportista'),
    ('FAS', 'Free Alongside Ship / Franco al costado del buque'),
    ('FOB', 'Free On Board / Franco a bordo'),
    ('CFR', 'Cost and Freight / Costo y flete'),
    ('CIF', 'Cost, Insurance and Freight / Costo, seguro y flete'),
    ('CPT', 'Carriage Paid To / Transporte pagado hasta'),
    ('CIP', 'Carriage and Insurance Paid To / Transporte y seguro pagados hasta'),
    ('DAP', 'Delivered At Place / Entregado en lugar'),
    ('DPU', 'Delivered At Place Unloaded / Entregado en lugar descargado'),
    ('DDP', 'Delivered Duty Paid / Entregado con derechos pagados')
ON CONFLICT (codigo) DO NOTHING;

-- ============================================================
-- SECCION 5: FUNCIONES DE REPORTES
-- ============================================================

-- Reporte "Gestión de compras al detalle" (Ítem 9 / front: GET /api/compras/reportes/gestion-compras).
-- Devuelve una fila por línea de orden de compra. Filtros opcionales (NULL = sin filtro).
CREATE OR REPLACE FUNCTION compras.sp_generar_reporte_compras(
    p_sucursal_id  BIGINT DEFAULT NULL,
    p_fecha_desde  DATE   DEFAULT NULL,
    p_fecha_hasta  DATE   DEFAULT NULL
)
RETURNS TABLE (
    fecha_compra   DATE,
    nro_orden      VARCHAR,
    doc_fiscal     VARCHAR,
    razon_social   VARCHAR,
    producto       VARCHAR,
    categoria      VARCHAR,
    unidad_medida  VARCHAR,
    cantidad       NUMERIC,
    precio_venta   NUMERIC,
    condicion      VARCHAR,
    estado         VARCHAR
)
LANGUAGE sql
STABLE
AS $$
    SELECT  oc.fecha_emision                                   AS fecha_compra,
            oc.nro_orden_compra                                AS nro_orden,
            NULL::varchar                                      AS doc_fiscal,
            ec.razon_social                                    AS razon_social,
            a.nombre                                           AS producto,
            cat.desc_categ                                     AS categoria,
            COALESCE(um.abreviatura, um.nombre)                AS unidad_medida,
            d.cant_proyectada                                  AS cantidad,
            d.valor_unitario                                   AS precio_venta,
            fp.nombre                                          AS condicion,
            CASE oc.flag_estado
                WHEN '1' THEN 'Activo'
                WHEN '0' THEN 'Anulado'
                WHEN '2' THEN 'Cerrado'
                WHEN '3' THEN 'Pendiente'
                ELSE oc.flag_estado
            END                                                AS estado
    FROM        compras.orden_compra      oc
    JOIN        compras.orden_compra_det  d   ON d.orden_compra_id = oc.id AND d.flag_estado = '1'
    JOIN        core.articulo             a   ON a.id = d.articulo_id
    LEFT JOIN   core.articulo_categ       cat ON cat.id = a.articulo_categ_id
    LEFT JOIN   core.unidad_medida        um  ON um.id = a.unidad_medida_id
    LEFT JOIN   core.entidad_contribuyente ec ON ec.id = oc.proveedor_id
    LEFT JOIN   core.forma_pago           fp  ON fp.id = oc.forma_pago_id
    WHERE   oc.flag_estado <> '0'
      AND   (p_sucursal_id IS NULL OR oc.sucursal_id = p_sucursal_id)
      AND   (p_fecha_desde IS NULL OR oc.fecha_emision >= p_fecha_desde)
      AND   (p_fecha_hasta IS NULL OR oc.fecha_emision <= p_fecha_hasta)
    ORDER BY oc.fecha_emision DESC, oc.nro_orden_compra;
$$;
