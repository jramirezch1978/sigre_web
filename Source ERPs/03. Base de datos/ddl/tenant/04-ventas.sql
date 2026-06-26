-- ============================================================
-- Restaurant.pe ERP - Tenant DB - ventas schema
-- DROP de esquemas centralizado en 01-core.sql
-- ============================================================
--
-- DIAGRAMA DE RELACIONES (→ = tiene FK hacia):
--
--   punto_venta → auth.sucursal, almacen.almacen
--   comanda → auth.sucursal, core.entidad_contribuyente, punto_venta (pedido a cocina / preparación)
--   comanda_det → comanda, core.articulo
--   fs_factura_simpl → auth.sucursal, core.entidad_contribuyente, core.doc_tipo, core.moneda, punto_venta
--   fs_factura_simpl_det → fs_factura_simpl, core.articulo, core.unidad_medida
--   fs_factura_simpl_pagos → fs_factura_simpl
--   cntas_cobrar → auth.sucursal, core.entidad_contribuyente, core.doc_tipo, core.moneda,
--                 contabilidad.cntbl_libro (FK diferida en 06-contabilidad.sql)
--   cntas_cobrar_det → cntas_cobrar + concepto_financiero obligatorio; FK concepto_financiero en 05-finanzas.sql
--   entidad_creditos_cxc → core.entidad_contribuyente, core.moneda
--   zona → auth.sucursal
--   mesa → zona
--   pedido_mesa → auth.sucursal, mesa (sesión de atención en salón/restaurante; no es OV comercial)
--   Flujo típico restaurante: pedido_mesa + comanda/comanda_det (cocina) → luego factura/boleta (fs_factura_simpl)
--   orden_venta → OV comercial ERP/SIGRE (B2B, despacho, export); no es pedido de mesa ni comanda
--               nro_orden_venta correlativo vía core.numerador_documento (nombre_tabla ventas.orden_venta, sucursal, ano) + funciones correlativo
--   orden_venta_det → orden_venta, core.articulo, almacen.almacen
--   proforma → auth.sucursal, core.entidad_contribuyente, core.moneda
--   proforma_det → proforma, core.articulo
--   cierre_caja (turno_id sin FK)
--   descuento_promocion (sin FKs)
--   propina → fs_factura_simpl
--   reservacion → auth.sucursal, core.entidad_contribuyente, mesa; opcional fs_factura_simpl
--   reservacion_det → reservacion, core.articulo
--   carta → auth.sucursal
--   carta_det → carta, core.articulo
--   canal_distribucion (sin FKs)
--   vendedor (sin FKs)
--   servicios_cxc (sin FKs) — maestro servicios cuentas por cobrar
--   vta_zona_venta (sin FKs) — zona comercial de venta
--   vta_zona_despacho (sin FKs) — zona de despacho
--   vta_zona_reparto (sin FKs) — zona de reparto
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

CREATE SCHEMA IF NOT EXISTS ventas;

-- ============================================================
-- CREATE (tablas, constraints e índices)
-- ============================================================

CREATE TABLE ventas.punto_venta (
    id BIGSERIAL PRIMARY KEY,
    sucursal_id BIGINT NOT NULL REFERENCES auth.sucursal(id),
    almacen_id BIGINT REFERENCES almacen.almacen(id),
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    serie_boleta VARCHAR(10),
    serie_factura VARCHAR(10),
    tipo_impresora VARCHAR(30),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    UNIQUE (sucursal_id, codigo)
);

CREATE TABLE ventas.comanda (
    id BIGSERIAL PRIMARY KEY,
    sucursal_id BIGINT NOT NULL REFERENCES auth.sucursal(id),
    punto_venta_id BIGINT REFERENCES ventas.punto_venta(id),
    turno_id BIGINT,
    cliente_id BIGINT REFERENCES core.entidad_contribuyente(id),
    mesa VARCHAR(30),
    fecha_hora TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    total NUMERIC(18, 4) NOT NULL DEFAULT 0,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

COMMENT ON TABLE ventas.comanda IS
    'Pedido que atiende cocina/barra (ítems a preparar). En restaurante se asocia a mesa/punto de venta; suele ser base para liquidar en boleta o factura electrónica (fs_factura_simpl).';

CREATE TABLE ventas.comanda_det (
    id BIGSERIAL PRIMARY KEY,
    comanda_id BIGINT NOT NULL REFERENCES ventas.comanda(id),
    articulo_id BIGINT NOT NULL REFERENCES core.articulo(id),
    cantidad NUMERIC(18, 4) NOT NULL,
    precio_unitario NUMERIC(18, 6) NOT NULL,
    subtotal NUMERIC(18, 4) NOT NULL DEFAULT 0,
    observacion VARCHAR(250),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE ventas.fs_factura_simpl (
    id BIGSERIAL PRIMARY KEY,
    sucursal_id BIGINT NOT NULL REFERENCES auth.sucursal(id),
    punto_venta_id BIGINT REFERENCES ventas.punto_venta(id),
    cliente_id BIGINT NOT NULL REFERENCES core.entidad_contribuyente(id),
    doc_tipo_id BIGINT NOT NULL REFERENCES core.doc_tipo(id),
    serie VARCHAR(10) NOT NULL,
    numero VARCHAR(20) NOT NULL,
    fecha_emision DATE NOT NULL,
    moneda_id BIGINT REFERENCES core.moneda(id),
    subtotal NUMERIC(18, 4) NOT NULL DEFAULT 0,
    impuesto NUMERIC(18, 4) NOT NULL DEFAULT 0,
    total NUMERIC(18, 4) NOT NULL DEFAULT 0,
    ano INTEGER NOT NULL,
    mes INTEGER NOT NULL,
    cntbl_libro_id BIGINT NOT NULL,
    cntas_cobrar_id BIGINT,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    UNIQUE (doc_tipo_id, serie, numero)
);

CREATE TABLE ventas.fs_factura_simpl_det (
    id BIGSERIAL PRIMARY KEY,
    fs_factura_simpl_id BIGINT NOT NULL REFERENCES ventas.fs_factura_simpl(id),
    articulo_id BIGINT NOT NULL REFERENCES core.articulo(id),
    unidad_medida_id BIGINT REFERENCES core.unidad_medida(id),
    cantidad NUMERIC(18, 4) NOT NULL,
    precio_unitario NUMERIC(18, 6) NOT NULL,
    subtotal NUMERIC(18, 4) NOT NULL DEFAULT 0,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE ventas.fs_factura_simpl_pagos (
    id BIGSERIAL PRIMARY KEY,
    fs_factura_simpl_id BIGINT NOT NULL REFERENCES ventas.fs_factura_simpl(id),
    forma_pago_id BIGINT,
    monto NUMERIC(18, 4) NOT NULL,
    referencia VARCHAR(120),
    fecha_pago TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE ventas.cntas_cobrar (
    id BIGSERIAL PRIMARY KEY,
    sucursal_id BIGINT NOT NULL REFERENCES auth.sucursal(id),
    cliente_id BIGINT NOT NULL REFERENCES core.entidad_contribuyente(id),
    doc_tipo_id BIGINT NOT NULL REFERENCES core.doc_tipo(id),
    serie VARCHAR(10),
    numero VARCHAR(20),
    fecha_emision DATE NOT NULL,
    fecha_vencimiento DATE,
    moneda_id BIGINT REFERENCES core.moneda(id),
    tasa_cambio NUMERIC(11, 4) NOT NULL DEFAULT 1,
    total NUMERIC(18, 4) NOT NULL DEFAULT 0,
    saldo NUMERIC(18, 4) NOT NULL DEFAULT 0,
    nro_asiento INTEGER,
    ano INTEGER NOT NULL,
    mes INTEGER NOT NULL,
    cntbl_libro_id BIGINT NOT NULL,
    cod_origen VARCHAR(2),
    cntbl_asiento_id BIGINT,
    cntas_cobrar_ref_id BIGINT REFERENCES ventas.cntas_cobrar(id),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    UNIQUE (cliente_id, doc_tipo_id, serie, numero)
);

COMMENT ON COLUMN ventas.cntas_cobrar.tasa_cambio IS 'Tipo de cambio del documento; para convertir a soles en reportes SUNAT.';
COMMENT ON COLUMN ventas.cntas_cobrar.nro_asiento IS 'Correlativo SUNAT del registro de ventas.';
COMMENT ON COLUMN ventas.cntas_cobrar.ano IS 'Año del periodo contable (SIGRE: ANO).';
COMMENT ON COLUMN ventas.cntas_cobrar.mes IS 'Mes del periodo contable (SIGRE: MES).';
COMMENT ON COLUMN ventas.cntas_cobrar.cntbl_libro_id IS 'Libro contable (SIGRE: NRO_LIBRO → FK contabilidad.cntbl_libro.id).';
COMMENT ON COLUMN ventas.cntas_cobrar.cod_origen IS 'Código origen (2 chars) para correlativo SUNAT.';
COMMENT ON COLUMN ventas.cntas_cobrar.cntas_cobrar_ref_id IS 'Referencia al documento original (cabecera) que modifica esta NC/ND.';

CREATE TABLE ventas.cntas_cobrar_det (
    id BIGSERIAL PRIMARY KEY,
    cntas_cobrar_id BIGINT NOT NULL REFERENCES ventas.cntas_cobrar(id),
    nro_item                INTEGER         NOT NULL,
    concepto_financiero_id  BIGINT          NOT NULL,
    descripcion             VARCHAR(2000),
    credito_fiscal_id       BIGINT          NOT NULL REFERENCES core.credito_fiscal(id),
    cantidad                NUMERIC(12, 4)  NOT NULL DEFAULT 0,
    precio_unitario         NUMERIC(17, 8)  NOT NULL DEFAULT 0,
    porc_descuento          NUMERIC(4, 2)   DEFAULT 0,
    importe_descuento       NUMERIC(4, 2)   DEFAULT 0,
    monto                   NUMERIC(18, 4)  NOT NULL,
    cntas_cobrar_det_ref_id BIGINT          REFERENCES ventas.cntas_cobrar_det(id),
    fecha_mov DATE NOT NULL,
    tipo_mov VARCHAR(20) NOT NULL,
    referencia VARCHAR(120),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE ventas.entidad_creditos_cxc (
    id BIGSERIAL PRIMARY KEY,
    entidad_contribuyente_id BIGINT NOT NULL REFERENCES core.entidad_contribuyente(id),
    moneda_id BIGINT REFERENCES core.moneda(id),
    limite_credito NUMERIC(18, 4) NOT NULL DEFAULT 0,
    dias_credito INTEGER NOT NULL DEFAULT 0,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

-- ============================================================
-- SECCIÓN 2B: TABLAS NUEVAS
-- ============================================================

CREATE TABLE ventas.zona (
    id BIGSERIAL NOT NULL,
    sucursal_id BIGINT,
    nombre VARCHAR(120) NOT NULL,
    capacidad INTEGER,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_ZONA PRIMARY KEY (id),
    CONSTRAINT FK_ZONA_01 FOREIGN KEY (sucursal_id) REFERENCES auth.sucursal(id)
);

CREATE TABLE ventas.mesa (
    id BIGSERIAL NOT NULL,
    zona_id BIGINT NOT NULL,
    numero VARCHAR(20) NOT NULL UNIQUE,
    capacidad INTEGER,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_MESA PRIMARY KEY (id),
    CONSTRAINT FK_MESA_01 FOREIGN KEY (zona_id) REFERENCES ventas.zona(id)
);

CREATE TABLE ventas.pedido_mesa (
    id BIGSERIAL NOT NULL,
    sucursal_id BIGINT,
    tipo VARCHAR(20) NOT NULL,
    mesa_id BIGINT,
    mesero_id BIGINT,
    turno_id BIGINT,
    numero VARCHAR(30) NOT NULL UNIQUE,
    comensales INTEGER,
    apertura TIMESTAMPTZ,
    cierre TIMESTAMPTZ,
    observaciones TEXT,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_PEDIDO_MESA PRIMARY KEY (id),
    CONSTRAINT FK_PEDIDO_MESA_01 FOREIGN KEY (sucursal_id) REFERENCES auth.sucursal(id),
    CONSTRAINT FK_PEDIDO_MESA_02 FOREIGN KEY (mesa_id) REFERENCES ventas.mesa(id)
);

COMMENT ON TABLE ventas.pedido_mesa IS
    'Atención por mesa en restaurante (salón): apertura/cierre de la sesión en mesa. '
    'Lo que cocina despacha se registra en comanda/comanda_det; ese circuito es uno de los que se factura (p. ej. fs_factura_simpl). '
    'No confundir con ventas.orden_venta (orden de venta comercial tipo ERP/SIGRE).';

CREATE TABLE ventas.pedido_mesa_det (
    id BIGSERIAL NOT NULL,
    pedido_mesa_id BIGINT NOT NULL,
    articulo_id BIGINT NOT NULL,
    cantidad NUMERIC(18, 4) NOT NULL,
    precio_unitario NUMERIC(18, 6) NOT NULL,
    subtotal NUMERIC(18, 4) NOT NULL,
    observacion VARCHAR(250),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_PEDIDO_MESA_DET PRIMARY KEY (id),
    CONSTRAINT FK_PEDIDO_MESA_DET_01 FOREIGN KEY (pedido_mesa_id) REFERENCES ventas.pedido_mesa(id),
    CONSTRAINT FK_PEDIDO_MESA_DET_02 FOREIGN KEY (articulo_id) REFERENCES core.articulo(id)
);

COMMENT ON TABLE ventas.pedido_mesa_det IS
    'Líneas de consumo/solicitud asociadas al pedido de mesa (ms-ventas); distinto de comanda_det (cocina).';

CREATE TABLE ventas.vendedor (
    id BIGSERIAL NOT NULL,
    usuario_id BIGINT NOT NULL,
    nombre VARCHAR(150),
    comision_porcentaje NUMERIC(8, 4),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_VENDEDOR PRIMARY KEY (id)
);

-- Orden de venta comercial (cabecera SIGRE ORDEN_VENTA / ERP). Distinta de pedido_mesa (restaurante).
CREATE TABLE ventas.orden_venta (
    id BIGSERIAL PRIMARY KEY,
    sucursal_id BIGINT NOT NULL REFERENCES auth.sucursal(id),
    nro_orden_venta VARCHAR(50) NOT NULL,
    cliente_id BIGINT REFERENCES core.entidad_contribuyente(id),
    comprador_final_id BIGINT REFERENCES core.entidad_contribuyente(id),
    vendedor_id BIGINT REFERENCES ventas.vendedor(id),
    fecha_emision DATE NOT NULL,
    fecha_registro TIMESTAMPTZ,
    fecha_embarque DATE,
    fecha_doc DATE,
    moneda_id BIGINT REFERENCES core.moneda(id),
    forma_pago_id BIGINT REFERENCES core.forma_pago(id),
    doc_tipo_id BIGINT REFERENCES core.doc_tipo(id),
    nro_doc VARCHAR(20),
    forma_embarque VARCHAR(4),
    monto_total NUMERIC(18, 4) NOT NULL DEFAULT 0,
    monto_facturado NUMERIC(18, 4) NOT NULL DEFAULT 0,
    monto_flete NUMERIC(18, 4),
    monto_seguro NUMERIC(18, 4),
    observaciones VARCHAR(2000),
    destino TEXT,
    punto_partida TEXT,
    pais_destino VARCHAR(4),
    ubigeo_dst CHAR(6),
    puerto_org VARCHAR(8),
    puerto_dst VARCHAR(8),
    flag_mercado CHAR(1),
    flag_despacho CHAR(1),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by BIGINT,
    fec_creacion TIMESTAMPTZ DEFAULT NOW(),
    updated_by BIGINT,
    fec_modificacion TIMESTAMPTZ,
    CONSTRAINT UQ_ORDEN_VENTA_NRO UNIQUE (nro_orden_venta)
);

COMMENT ON TABLE ventas.orden_venta IS
    'Orden de venta comercial (SIGRE ORDEN_VENTA): cliente, precios, despacho B2B. No es pedido_mesa ni comanda de restaurante.';
COMMENT ON COLUMN ventas.orden_venta.nro_orden_venta IS
    'Número OV legible: 2 sucursal + 4 año + 6 secuencial vía core.fn_get_document_number.';

CREATE TABLE ventas.orden_venta_det (
    id BIGSERIAL PRIMARY KEY,
    orden_venta_id BIGINT NOT NULL REFERENCES ventas.orden_venta(id),
    articulo_id BIGINT NOT NULL REFERENCES core.articulo(id),
    linea_nro INTEGER,
    cant_proyectada NUMERIC(18, 4) NOT NULL,
    fec_proyectada DATE,
    cant_procesada NUMERIC(18, 4) NOT NULL DEFAULT 0,
    cant_facturada NUMERIC(18, 4) NOT NULL DEFAULT 0,
    valor_unitario NUMERIC(18, 6) NOT NULL,
    tipos_impuesto_id BIGINT REFERENCES core.tipos_impuesto(id),
    valor_impuesto NUMERIC(18, 4) DEFAULT 0,
    subtotal NUMERIC(18, 4) NOT NULL DEFAULT 0,
    almacen_id BIGINT REFERENCES almacen.almacen(id),
    centros_costo_id BIGINT,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by BIGINT,
    fec_creacion TIMESTAMPTZ DEFAULT NOW(),
    updated_by BIGINT,
    fec_modificacion TIMESTAMPTZ
);

COMMENT ON TABLE ventas.orden_venta_det IS 'Líneas de orden de venta comercial (B2B / despacho).';

CREATE TABLE ventas.proforma (
    id BIGSERIAL NOT NULL,
    sucursal_id BIGINT,
    cliente_id BIGINT,
    numero VARCHAR(30) NOT NULL UNIQUE,
    fecha DATE NOT NULL,
    fecha_validez DATE,
    moneda_id BIGINT,
    subtotal NUMERIC(18, 4),
    igv NUMERIC(18, 4),
    total NUMERIC(18, 4),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_PROFORMA PRIMARY KEY (id),
    CONSTRAINT FK_PROFORMA_01 FOREIGN KEY (sucursal_id) REFERENCES auth.sucursal(id),
    CONSTRAINT FK_PROFORMA_02 FOREIGN KEY (cliente_id) REFERENCES core.entidad_contribuyente(id),
    CONSTRAINT FK_PROFORMA_03 FOREIGN KEY (moneda_id) REFERENCES core.moneda(id)
);

COMMENT ON COLUMN ventas.proforma.numero IS
    'Número legible 12 caracteres: 2 código sucursal + 4 año + 6 secuencial vía core.fn_get_document_number(''ventas.proforma'', ...).';

CREATE TABLE ventas.proforma_det (
    id BIGSERIAL NOT NULL,
    proforma_id BIGINT NOT NULL,
    articulo_id BIGINT NOT NULL,
    descripcion VARCHAR(250),
    cantidad NUMERIC(18, 4) NOT NULL,
    precio_unitario NUMERIC(18, 4) NOT NULL,
    descuento NUMERIC(18, 4) DEFAULT 0,
    subtotal NUMERIC(18, 4),
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_PROFORMA_DET PRIMARY KEY (id),
    CONSTRAINT FK_PROFORMA_DET_01 FOREIGN KEY (proforma_id) REFERENCES ventas.proforma(id),
    CONSTRAINT FK_PROFORMA_DET_02 FOREIGN KEY (articulo_id) REFERENCES core.articulo(id)
);

CREATE TABLE ventas.cierre_caja (
    id BIGSERIAL NOT NULL,
    turno_id BIGINT,
    ventas_efectivo NUMERIC(18, 4) DEFAULT 0,
    ventas_tarjeta NUMERIC(18, 4) DEFAULT 0,
    ventas_digital NUMERIC(18, 4) DEFAULT 0,
    ventas_total NUMERIC(18, 4) DEFAULT 0,
    propinas_total NUMERIC(18, 4) DEFAULT 0,
    fondo_inicial NUMERIC(18, 4) DEFAULT 0,
    fondo_final NUMERIC(18, 4) DEFAULT 0,
    diferencia NUMERIC(18, 4) DEFAULT 0,
    observaciones TEXT,
    fecha_cierre TIMESTAMPTZ,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CIERRE_CAJA PRIMARY KEY (id)
);

CREATE TABLE ventas.descuento_promocion (
    id BIGSERIAL NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    valor NUMERIC(18, 4),
    fecha_inicio DATE,
    fecha_fin DATE,
    dias_aplicacion VARCHAR(30),
    hora_inicio TIME,
    hora_fin TIME,
    monto_minimo NUMERIC(18, 4),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_DESCUENTO_PROMOCION PRIMARY KEY (id)
);

CREATE TABLE ventas.propina (
    id BIGSERIAL NOT NULL,
    fs_factura_simpl_id BIGINT NOT NULL,
    trabajador_id BIGINT,
    monto NUMERIC(18, 4) NOT NULL,
    fecha DATE NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_PROPINA PRIMARY KEY (id),
    CONSTRAINT FK_PROPINA_01 FOREIGN KEY (fs_factura_simpl_id) REFERENCES ventas.fs_factura_simpl(id)
);

CREATE TABLE ventas.reservacion (
    id BIGSERIAL NOT NULL,
    sucursal_id BIGINT,
    cliente_id BIGINT,
    mesa_id BIGINT,
    fs_factura_simpl_id BIGINT REFERENCES ventas.fs_factura_simpl(id),
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    comensales INTEGER,
    observaciones TEXT,
    estado VARCHAR(20) NOT NULL DEFAULT 'CONFIRMADA',
    motivo_cancelacion TEXT,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_RESERVACION PRIMARY KEY (id),
    CONSTRAINT FK_RESERVACION_01 FOREIGN KEY (sucursal_id) REFERENCES auth.sucursal(id),
    CONSTRAINT FK_RESERVACION_02 FOREIGN KEY (cliente_id) REFERENCES core.entidad_contribuyente(id),
    CONSTRAINT FK_RESERVACION_03 FOREIGN KEY (mesa_id) REFERENCES ventas.mesa(id)
);

CREATE TABLE ventas.reservacion_det (
    id BIGSERIAL NOT NULL,
    reservacion_id BIGINT NOT NULL,
    articulo_id BIGINT,
    cantidad NUMERIC(18, 4),
    observacion TEXT,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_RESERVACION_DET PRIMARY KEY (id),
    CONSTRAINT FK_RESERVACION_DET_01 FOREIGN KEY (reservacion_id) REFERENCES ventas.reservacion(id),
    CONSTRAINT FK_RESERVACION_DET_02 FOREIGN KEY (articulo_id) REFERENCES core.articulo(id)
);

CREATE TABLE ventas.carta (
    id BIGSERIAL NOT NULL,
    sucursal_id BIGINT,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CARTA PRIMARY KEY (id),
    CONSTRAINT FK_CARTA_01 FOREIGN KEY (sucursal_id) REFERENCES auth.sucursal(id)
);

CREATE TABLE ventas.carta_det (
    id BIGSERIAL NOT NULL,
    carta_id BIGINT NOT NULL,
    articulo_id BIGINT NOT NULL,
    precio NUMERIC(18, 4),
    orden INTEGER,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CARTA_DET PRIMARY KEY (id),
    CONSTRAINT FK_CARTA_DET_01 FOREIGN KEY (carta_id) REFERENCES ventas.carta(id),
    CONSTRAINT FK_CARTA_DET_02 FOREIGN KEY (articulo_id) REFERENCES core.articulo(id)
);

CREATE TABLE ventas.canal_distribucion (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CANAL_DISTRIBUCION PRIMARY KEY (id)
);

-- Maestro de servicios CxC (ventas) — base SIGRE SERVICIOS_CXC
CREATE TABLE ventas.servicios_cxc (
    id                  BIGSERIAL       NOT NULL,
    cod_servicio        CHAR(3)         NOT NULL UNIQUE,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    desc_servicio       VARCHAR(200),
    tarifa              NUMERIC(15,4),
    cod_moneda          CHAR(3),
    flag_afecto_igv     CHAR(1)         DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_SERVICIOS_CXC PRIMARY KEY (id)
);

-- Maestro de zonas de venta — base SIGRE VTA_ZONA_VENTA
CREATE TABLE ventas.vta_zona_venta (
    id                  BIGSERIAL       NOT NULL,
    zona_venta          VARCHAR(8)      NOT NULL UNIQUE,
    desc_zona_venta     VARCHAR(200)    NOT NULL,
    ubigeo              CHAR(6),
    flag_estado VARCHAR(1)         NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_VTA_ZONA_VENTA PRIMARY KEY (id)
);

-- Maestro de zonas de despacho — base SIGRE VTA_ZONA_DESPACHO
CREATE TABLE ventas.vta_zona_despacho (
    id                  BIGSERIAL       NOT NULL,
    zona_despacho       VARCHAR(8)      NOT NULL UNIQUE,
    desc_zona_despacho  VARCHAR(200)    NOT NULL,
    ubigeo              CHAR(6),
    flag_estado VARCHAR(1)         NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_VTA_ZONA_DESPACHO PRIMARY KEY (id)
);

-- Maestro de zonas de reparto — base SIGRE VTA_ZONA_REPARTO
CREATE TABLE ventas.vta_zona_reparto (
    id                  BIGSERIAL       NOT NULL,
    zona_reparto        VARCHAR(8)      NOT NULL UNIQUE,
    desc_zona_reparto   VARCHAR(200)    NOT NULL,
    ubigeo              CHAR(6),
    flag_estado VARCHAR(1)         NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_VTA_ZONA_REPARTO PRIMARY KEY (id)
);

-- ============================================================
-- SECCIÓN 3: ÍNDICES
-- ============================================================

CREATE INDEX IX_COMANDA_01 ON ventas.comanda (sucursal_id, fecha_hora);
CREATE INDEX IX_COMANDA_DET_01 ON ventas.comanda_det (comanda_id, articulo_id);
CREATE INDEX IX_FS_FACTURA_SIMPL_01 ON ventas.fs_factura_simpl (cliente_id, fecha_emision);
CREATE INDEX IX_FS_FACTURA_SIMPL_02 ON ventas.fs_factura_simpl (cntas_cobrar_id);
ALTER TABLE ventas.fs_factura_simpl ADD CONSTRAINT FK_FS_FACTURA_SIMPL_CNTAS_COBRAR FOREIGN KEY (cntas_cobrar_id) REFERENCES ventas.cntas_cobrar(id);
CREATE INDEX IX_CNTAS_COBRAR_01 ON ventas.cntas_cobrar (cliente_id, fecha_vencimiento);
CREATE INDEX IX_CNTAS_COBRAR_02 ON ventas.cntas_cobrar (cntbl_asiento_id);
CREATE INDEX IX_CNTAS_COBRAR_03 ON ventas.cntas_cobrar (ano, mes, cntbl_libro_id);

CREATE INDEX IX_ZONA_01 ON ventas.zona (sucursal_id);
CREATE INDEX IX_MESA_01 ON ventas.mesa (zona_id);
CREATE INDEX IX_PEDIDO_MESA_01 ON ventas.pedido_mesa (sucursal_id);
CREATE INDEX IX_PEDIDO_MESA_02 ON ventas.pedido_mesa (mesa_id);
CREATE INDEX IX_PEDIDO_MESA_DET_01 ON ventas.pedido_mesa_det (pedido_mesa_id);
CREATE INDEX IX_ORDEN_VENTA_01 ON ventas.orden_venta (sucursal_id, fecha_emision);
CREATE INDEX IX_ORDEN_VENTA_02 ON ventas.orden_venta (cliente_id);
CREATE INDEX IX_ORDEN_VENTA_DET_01 ON ventas.orden_venta_det (orden_venta_id, articulo_id);
CREATE INDEX IX_ORDEN_VENTA_DET_02 ON ventas.orden_venta_det (almacen_id);
CREATE INDEX IX_VENDEDOR_01 ON ventas.vendedor (usuario_id);
CREATE INDEX IX_PROFORMA_01 ON ventas.proforma (sucursal_id, cliente_id, fecha);
CREATE INDEX IX_PROFORMA_DET_01 ON ventas.proforma_det (proforma_id, articulo_id);
CREATE INDEX IX_CIERRE_CAJA_01 ON ventas.cierre_caja (turno_id);
CREATE INDEX IX_DESCUENTO_PROMOCION_01 ON ventas.descuento_promocion (flag_estado, fecha_inicio, fecha_fin);
CREATE INDEX IX_PROPINA_01 ON ventas.propina (fs_factura_simpl_id);
CREATE INDEX IX_PROPINA_02 ON ventas.propina (trabajador_id, fecha);
CREATE INDEX IX_RESERVACION_01 ON ventas.reservacion (sucursal_id, fecha);
CREATE INDEX IX_RESERVACION_02 ON ventas.reservacion (mesa_id, fecha);
CREATE INDEX IX_RESERVACION_FS_FACTURA ON ventas.reservacion (fs_factura_simpl_id);
CREATE INDEX IX_RESERVACION_DET_01 ON ventas.reservacion_det (reservacion_id);
CREATE INDEX IX_CARTA_01 ON ventas.carta (sucursal_id);
CREATE INDEX IX_CARTA_DET_01 ON ventas.carta_det (carta_id, articulo_id);
CREATE INDEX IX_CANAL_DISTRIBUCION_01 ON ventas.canal_distribucion (codigo);
CREATE INDEX IX_SERVICIOS_CXC_01 ON ventas.servicios_cxc (flag_estado);
CREATE INDEX IX_VTA_ZONA_VENTA_01 ON ventas.vta_zona_venta (flag_estado);
CREATE INDEX IX_VTA_ZONA_DESPACHO_01 ON ventas.vta_zona_despacho (flag_estado);
CREATE INDEX IX_VTA_ZONA_REPARTO_01 ON ventas.vta_zona_reparto (flag_estado);

-- FK almacen.vale_mov → ventas.orden_venta (columna definida en 02-almacen.sql sin REFERENCES).
ALTER TABLE almacen.vale_mov
    ADD CONSTRAINT FK_VALE_MOV_ORDEN_VENTA FOREIGN KEY (orden_venta_id) REFERENCES ventas.orden_venta (id);

-- FK almacen.vale_mov_det → ventas.orden_venta_det (columna definida en 02-almacen.sql sin REFERENCES).
-- Idempotente: DROP IF EXISTS + ADD permite re-ejecutar el script sin fallar.
ALTER TABLE almacen.vale_mov_det DROP CONSTRAINT IF EXISTS FK_VALE_MOV_DET_OV_DET;
ALTER TABLE almacen.vale_mov_det
    ADD CONSTRAINT FK_VALE_MOV_DET_OV_DET FOREIGN KEY (orden_venta_det_id) REFERENCES ventas.orden_venta_det (id);

CREATE INDEX IX_VALE_MOV_10 ON almacen.vale_mov (orden_venta_id);
CREATE INDEX IF NOT EXISTS IX_VALE_MOV_DET_06 ON almacen.vale_mov_det (orden_venta_det_id);

-- cntas_cobrar: periodo contable (idempotente; backfill cntbl_libro_id en 06-contabilidad.sql y seed)
ALTER TABLE ventas.cntas_cobrar ADD COLUMN IF NOT EXISTS ano INTEGER;
ALTER TABLE ventas.cntas_cobrar ADD COLUMN IF NOT EXISTS mes INTEGER;
ALTER TABLE ventas.cntas_cobrar ADD COLUMN IF NOT EXISTS cntbl_libro_id BIGINT;
UPDATE ventas.cntas_cobrar SET ano = EXTRACT(YEAR FROM fecha_emision)::INTEGER WHERE ano IS NULL;
UPDATE ventas.cntas_cobrar SET mes = EXTRACT(MONTH FROM fecha_emision)::INTEGER WHERE mes IS NULL;
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM ventas.cntas_cobrar WHERE ano IS NULL) THEN
        ALTER TABLE ventas.cntas_cobrar ALTER COLUMN ano SET NOT NULL;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM ventas.cntas_cobrar WHERE mes IS NULL) THEN
        ALTER TABLE ventas.cntas_cobrar ALTER COLUMN mes SET NOT NULL;
    END IF;
END $$;
CREATE INDEX IF NOT EXISTS IX_CNTAS_COBRAR_03 ON ventas.cntas_cobrar (ano, mes, cntbl_libro_id);

-- fs_factura_simpl: periodo contable y libro (idempotente; cntbl_libro_id sin backfill automático)
ALTER TABLE ventas.fs_factura_simpl ADD COLUMN IF NOT EXISTS ano INTEGER;
ALTER TABLE ventas.fs_factura_simpl ADD COLUMN IF NOT EXISTS mes INTEGER;
ALTER TABLE ventas.fs_factura_simpl ADD COLUMN IF NOT EXISTS cntbl_libro_id BIGINT;
UPDATE ventas.fs_factura_simpl SET ano = EXTRACT(YEAR FROM fecha_emision)::INTEGER WHERE ano IS NULL;
UPDATE ventas.fs_factura_simpl SET mes = EXTRACT(MONTH FROM fecha_emision)::INTEGER WHERE mes IS NULL;
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM ventas.fs_factura_simpl WHERE ano IS NULL) THEN
        ALTER TABLE ventas.fs_factura_simpl ALTER COLUMN ano SET NOT NULL;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM ventas.fs_factura_simpl WHERE mes IS NULL) THEN
        ALTER TABLE ventas.fs_factura_simpl ALTER COLUMN mes SET NOT NULL;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM ventas.fs_factura_simpl WHERE cntbl_libro_id IS NULL) THEN
        ALTER TABLE ventas.fs_factura_simpl ALTER COLUMN cntbl_libro_id SET NOT NULL;
    END IF;
END $$;

-- cntas_cobrar: columnas nuevas para Registro de Ventas SUNAT (BD existentes)
ALTER TABLE ventas.cntas_cobrar ADD COLUMN IF NOT EXISTS tasa_cambio NUMERIC(11, 4) NOT NULL DEFAULT 1;
ALTER TABLE ventas.cntas_cobrar ADD COLUMN IF NOT EXISTS nro_asiento INTEGER;
ALTER TABLE ventas.cntas_cobrar ADD COLUMN IF NOT EXISTS cod_origen VARCHAR(2);
ALTER TABLE ventas.cntas_cobrar ADD COLUMN IF NOT EXISTS cntas_cobrar_ref_id BIGINT REFERENCES ventas.cntas_cobrar(id);

-- cntas_cobrar_det: columnas nuevas para Registro de Ventas SUNAT (BD existentes)
ALTER TABLE ventas.cntas_cobrar_det ADD COLUMN IF NOT EXISTS nro_item INTEGER;
ALTER TABLE ventas.cntas_cobrar_det ADD COLUMN IF NOT EXISTS descripcion VARCHAR(2000);
ALTER TABLE ventas.cntas_cobrar_det ADD COLUMN IF NOT EXISTS credito_fiscal_id BIGINT REFERENCES core.credito_fiscal(id);
ALTER TABLE ventas.cntas_cobrar_det ADD COLUMN IF NOT EXISTS cantidad NUMERIC(12, 4) NOT NULL DEFAULT 0;
ALTER TABLE ventas.cntas_cobrar_det ADD COLUMN IF NOT EXISTS precio_unitario NUMERIC(17, 8) NOT NULL DEFAULT 0;
ALTER TABLE ventas.cntas_cobrar_det ADD COLUMN IF NOT EXISTS porc_descuento NUMERIC(4, 2) DEFAULT 0;
ALTER TABLE ventas.cntas_cobrar_det ADD COLUMN IF NOT EXISTS importe_descuento NUMERIC(4, 2) DEFAULT 0;
ALTER TABLE ventas.cntas_cobrar_det ADD COLUMN IF NOT EXISTS cntas_cobrar_det_ref_id BIGINT REFERENCES ventas.cntas_cobrar_det(id);

CREATE INDEX IF NOT EXISTS IX_CNTAS_COBRAR_DET_01 ON ventas.cntas_cobrar_det (cntas_cobrar_id, credito_fiscal_id, flag_estado);
CREATE INDEX IF NOT EXISTS IX_CNTAS_COBRAR_DET_02 ON ventas.cntas_cobrar_det (cntas_cobrar_det_ref_id) WHERE cntas_cobrar_det_ref_id IS NOT NULL;
