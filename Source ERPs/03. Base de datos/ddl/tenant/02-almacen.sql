-- ============================================================
-- Restaurant.pe ERP - Tenant DB - almacen schema
-- DROP de esquemas centralizado en 01-core.sql
-- ============================================================
--
-- DIAGRAMA DE RELACIONES (→ = tiene FK hacia):
--
--   almacen → auth.sucursal
--   almacen_tacito → auth.sucursal, almacen (almacén por defecto según clase de artículo + sucursal; consumido por ms-compras en datos-articulo / HU_ORDENES_COMPRA §12.2)
--   almacen_user → almacen
--   motivo_traslado (sin dependencias)
--   vale_mov → auth.sucursal, almacen, articulo_mov_tipo, core.doc_tipo (tipo doc int/ext);
--             nro_vale correlativo vía core.fn_get_document_number('almacen.vale_mov', sucursal, ano);
--             opcional: orden_compra_id, prog_compras_id (sin FK en CREATE; FK+índices en 03-compras),
--             orden_venta_id (FK+índice en 04-ventas tras ventas.orden_venta),
--             orden_traslado_id (FK en 02 tras orden_traslado), orden_trabajo_id (FK+índice en 09-produccion),
--             tipo_referencia_origen CHAR(1) I|C|V|T|G|P (AL002)
--   vale_mov_det → vale_mov, core.articulo, core.unidad_medida, ubicacion_almacen (posición);
--             FKs opcionales a línea de documento origen (trazabilidad cabecera↔línea):
--               oc_det_id              → compras.orden_compra_det (FK diferida en 03-compras.sql — cross-schema, hoy validación en app),
--               orden_traslado_det_id  → almacen.orden_traslado_det (FK en este mismo archivo tras CREATE orden_traslado_det),
--               orden_venta_det_id     → ventas.orden_venta_det (FK en 04-ventas.sql tras ventas.orden_venta_det),
--               operaciones_det_id     → produccion.operaciones_det (FK en 09-produccion.sql tras produccion.operaciones_det)
--   guia → auth.sucursal, core.entidad_contribuyente (destinatario),
--           core.entidad_contribuyente (transportista), motivo_traslado, vale_mov
--   guia_det → guia, vale_mov, core.articulo, core.unidad_medida
--   ubicacion_almacen → almacen
--   almacen_tipo_mov → almacen, articulo_mov_tipo
--   articulo_almacen → almacen, core.articulo
--   articulo_almacen_lote → almacen, core.articulo, lote_pallet (saldo inventario por lote)
--   articulo_almacen_posicion → ubicacion_almacen (posición), core.articulo (saldo por posición)
--   articulo_bonificacion → core.articulo
--   articulo_saldo_mensual → almacen, core.articulo, vale_mov_det
--   orden_traslado → almacen (origen), almacen (destino)
--   orden_traslado_det → orden_traslado, core.articulo
--   inventario_conteo → almacen, core.articulo, vale_mov, ubicacion_almacen
--   sol_salida → almacen
--   sol_salida_det → sol_salida, core.articulo
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

CREATE SCHEMA IF NOT EXISTS almacen;

-- ============================================================
-- CREATE (tablas, constraints e índices)
-- ============================================================

CREATE TABLE almacen.almacen_tipo (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(120) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE almacen.almacen (
    id BIGSERIAL PRIMARY KEY,
    sucursal_id BIGINT NOT NULL REFERENCES auth.sucursal(id),
    almacen_tipo_id BIGINT REFERENCES almacen.almacen_tipo(id),
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    UNIQUE (sucursal_id, codigo)
);

-- Almacén tácito: almacén por defecto según la clase del artículo y la sucursal.
-- Consumido (solo lectura) por ms-compras en GET /ordenes-compra/datos-articulo
-- (HU_ORDENES_COMPRA §12.2): SELECT almacen_id WHERE cod_clase = :codClase AND sucursal_id = :sucursalId.
CREATE TABLE almacen.almacen_tacito (
    id BIGSERIAL PRIMARY KEY,
    cod_clase VARCHAR(20) NOT NULL,
    sucursal_id BIGINT NOT NULL REFERENCES auth.sucursal(id),
    almacen_id BIGINT NOT NULL REFERENCES almacen.almacen(id),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE INDEX ix_almacen_tacito_clase_sucursal
    ON almacen.almacen_tacito (cod_clase, sucursal_id);

CREATE TABLE almacen.almacen_user (
    id BIGSERIAL PRIMARY KEY,
    almacen_id BIGINT NOT NULL REFERENCES almacen.almacen(id),
    usuario_id BIGINT NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE almacen.motivo_traslado (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(120) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE almacen.lote_pallet (
    id                      BIGSERIAL NOT NULL,
    almacen_id              BIGINT NOT NULL,
    articulo_id             BIGINT NOT NULL,
    nro_lote                VARCHAR(40) NOT NULL,
    fecha_produccion        DATE,
    fecha_vencimiento       DATE,
    observacion             VARCHAR(1000),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_LOTE_PALLET PRIMARY KEY (id),
    CONSTRAINT FK_LOTE_PALLET_01 FOREIGN KEY (almacen_id) REFERENCES almacen.almacen(id),
    CONSTRAINT FK_LOTE_PALLET_02 FOREIGN KEY (articulo_id) REFERENCES core.articulo(id),
    CONSTRAINT UQ_LOTE_PALLET_01 UNIQUE (almacen_id, articulo_id, nro_lote)
);

-- Posición física / ubicación de picking dentro del almacén (pasillo, estante, nivel). Debe crearse antes de vale_mov_det (FK).
CREATE TABLE almacen.ubicacion_almacen (
    id                      BIGSERIAL NOT NULL,
    almacen_id              BIGINT NOT NULL,
    codigo                  VARCHAR(20) NOT NULL,
    nombre                  VARCHAR(120) NOT NULL,
    pasillo                 VARCHAR(30),
    estante                 VARCHAR(30),
    nivel                   VARCHAR(30),
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_UBICACION_ALMACEN PRIMARY KEY (id),
    CONSTRAINT FK_UBICACION_ALMACEN_01 FOREIGN KEY (almacen_id) REFERENCES almacen.almacen(id),
    CONSTRAINT UQ_UBICACION_ALMACEN_01 UNIQUE (almacen_id, codigo)
);

-- Catálogo SIGRE de tipos de movimiento. PK surrogate para FKs desde vale_mov y APIs (JSON: articuloMovTipoId).
CREATE TABLE almacen.articulo_mov_tipo (
    id                      BIGSERIAL NOT NULL,
    tipo_mov                VARCHAR(10) NOT NULL,
    desc_tipo_mov           VARCHAR(200) NOT NULL,
    flag_contabiliza        VARCHAR(1) NOT NULL DEFAULT '0',
    flag_ajuste_valorizacion VARCHAR(1) NOT NULL DEFAULT '0',
    flag_mov_entre_alm      VARCHAR(1) NOT NULL DEFAULT '0',
    flag_solicita_prov      VARCHAR(1) NOT NULL DEFAULT '0',
    flag_solicita_doc_int   VARCHAR(1) NOT NULL DEFAULT '0',
    flag_solicita_doc_ext   VARCHAR(1) NOT NULL DEFAULT '0',
    flag_solicita_ref       VARCHAR(1) NOT NULL DEFAULT '0',
    factor_sldo_total       NUMERIC(10,2) NOT NULL DEFAULT 0,
    factor_sldo_x_llegar    NUMERIC(10,2) NOT NULL DEFAULT 0,
    factor_sldo_sol         NUMERIC(10,2) NOT NULL DEFAULT 0,
    factor_sldo_dev         NUMERIC(10,2) NOT NULL DEFAULT 0,
    factor_sldo_pres        NUMERIC(10,2) NOT NULL DEFAULT 0,
    factor_sldo_consig      NUMERIC(10,2) NOT NULL DEFAULT 0,
    factor_ctrl_templa      NUMERIC(10,2) NOT NULL DEFAULT 0,
    flag_clase_mov          VARCHAR(1),
    flag_solicita_lote      VARCHAR(1) NOT NULL DEFAULT '0',
    flag_estado             VARCHAR(1) NOT NULL DEFAULT '1',
    flag_solicita_precio    VARCHAR(1) NOT NULL DEFAULT '0',
    tipo_mov_dev            VARCHAR(10),
    flag_amp                VARCHAR(1) NOT NULL DEFAULT '0',
    factor_sldo_reservado   NUMERIC(10,2),
    flag_solicita_cenbef    VARCHAR(1) NOT NULL DEFAULT '0',
    flag_cntrl_cta_cte      VARCHAR(1),
    flag_cambia_precio      VARCHAR(1) NOT NULL DEFAULT '0',
    cod_sunat               VARCHAR(10),
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_ARTICULO_MOV_TIPO PRIMARY KEY (id),
    CONSTRAINT UQ_ARTICULO_MOV_TIPO_01 UNIQUE (tipo_mov)
);

-- vale_mov: FK a compras/produccion NO van en CREATE (orden de scripts: 02 → 03 → 09).
--   orden_compra_id, prog_compras_id → FK en 03-compras.sql tras crear tablas compras.
--   orden_venta_id → FK en 04-ventas.sql tras ventas.orden_venta.
--   orden_trabajo_id → FK en 09-produccion.sql tras produccion.orden_trabajo.
--   orden_traslado_id → FK en este script tras CREATE almacen.orden_traslado.
CREATE TABLE almacen.vale_mov (
    id BIGSERIAL PRIMARY KEY,
    sucursal_id BIGINT NOT NULL REFERENCES auth.sucursal(id),
    almacen_id BIGINT NOT NULL REFERENCES almacen.almacen(id),
    articulo_mov_tipo_id BIGINT NOT NULL REFERENCES almacen.articulo_mov_tipo(id),
    fecha_mov DATE NOT NULL,
    nro_vale VARCHAR(12) NOT NULL,
    fec_produccion DATE,
    proveedor_id BIGINT REFERENCES core.entidad_contribuyente(id),
    nom_receptor VARCHAR(120),
    tipo_doc_int_id BIGINT REFERENCES core.doc_tipo(id),
    nro_doc_int VARCHAR(20),
    tipo_doc_ext_id BIGINT REFERENCES core.doc_tipo(id),
    nro_doc_ext VARCHAR(20),
    orden_compra_id BIGINT,
    prog_compras_id BIGINT,
    orden_traslado_id BIGINT,
    orden_trabajo_id BIGINT,
    orden_venta_id BIGINT,
    -- Clase de documento de referencia (misma semántica que articulo_mov_tipo.flag_clase_mov en AL002 / w_al002).
    tipo_referencia_origen CHAR(1),
    observaciones VARCHAR(3000),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by BIGINT,
    fec_creacion TIMESTAMPTZ DEFAULT NOW(),
    updated_by BIGINT,
    fec_modificacion TIMESTAMPTZ,
    CONSTRAINT UQ_VALE_MOV_NRO UNIQUE (nro_vale),
    CONSTRAINT CK_VALE_MOV_TIPO_REF_ORIGEN CHECK (
        tipo_referencia_origen IS NULL
        OR tipo_referencia_origen IN ('I', 'C', 'V', 'T', 'G', 'P')
    )
);

COMMENT ON COLUMN almacen.vale_mov.nro_vale IS
    'Número de vale legible: codigo sucursal + año (fecha_mov) + 9 dígitos; único en el tenant.';
COMMENT ON COLUMN almacen.vale_mov.orden_compra_id IS
    'FK a compras.orden_compra: vale originado por recepción / ingreso contra OC (constraint en 03-compras.sql).';
COMMENT ON COLUMN almacen.vale_mov.prog_compras_id IS
    'FK a compras.prog_compras: programa de compras asociado (constraint en 03-compras.sql).';
COMMENT ON COLUMN almacen.vale_mov.orden_traslado_id IS
    'FK a almacen.orden_traslado (definida en este script inmediatamente después de CREATE orden_traslado).';
COMMENT ON COLUMN almacen.vale_mov.orden_trabajo_id IS
    'FK a produccion.orden_trabajo: consumo/entrega por OT (constraint en 09-produccion.sql).';
COMMENT ON COLUMN almacen.vale_mov.orden_venta_id IS
    'FK a ventas.orden_venta: salida / despacho vinculado a OV comercial (constraint en 04-ventas.sql).';
COMMENT ON COLUMN almacen.vale_mov.tipo_referencia_origen IS
    'Clase de referencia (AL002 d_abc_articulo_mov_tipo_ff, mismo dominio que articulo_mov_tipo.flag_clase_mov). I=Ingresos por compra; C=Consumos internos; V=Ventas a clientes; T=Orden de traslado; G=Guía recepción MP; P=Ingreso por producción. NULL si no aplica.';

CREATE TABLE almacen.vale_mov_det (
    id BIGSERIAL PRIMARY KEY,
    vale_mov_id BIGINT NOT NULL REFERENCES almacen.vale_mov(id),
    articulo_id BIGINT NOT NULL REFERENCES core.articulo(id),
    cant_procesada NUMERIC(18, 4) NOT NULL,
    costo_unitario NUMERIC(18, 6),
    matriz_contable_id BIGINT, -- FK diferida a contabilidad.matriz_contable(id)
    concepto_financiero_id BIGINT, -- FK lógica a finanzas.concepto_financiero(id): integración contable por concepto (Ruta B). Nullable para no afectar el flujo legacy por matriz/subcategoría.
    lote_pallet_id BIGINT REFERENCES almacen.lote_pallet(id),
    moneda_id BIGINT REFERENCES core.moneda(id),
    peso_neto_tm NUMERIC(12, 3) DEFAULT 0,
    precio_unit_ant NUMERIC(21, 12),
    centros_costo_id BIGINT, -- FK diferida: se crea en 06-contabilidad.sql
    ubicacion_almacen_id BIGINT REFERENCES almacen.ubicacion_almacen(id),
    oc_det_id BIGINT, -- FK a compras.orden_compra_det (cross-schema, validar en app o FK diferida en 03-compras.sql)
    orden_traslado_det_id BIGINT, -- FK a almacen.orden_traslado_det (constraint diferido en este mismo archivo)
    orden_venta_det_id BIGINT, -- FK a ventas.orden_venta_det (constraint diferido en 04-ventas.sql)
    operaciones_det_id BIGINT, -- FK a produccion.operaciones_det (constraint diferido en 09-produccion.sql)
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

COMMENT ON COLUMN almacen.vale_mov_det.concepto_financiero_id IS
    'FK lógica a finanzas.concepto_financiero(id). Integración contable por concepto (Ruta B): cada línea contabilizable envía su concepto financiero a contabilidad (matriz_contable_id ← concepto.matriz_contable_id). Nullable: el flujo legacy (tipo_mov + grp_cntbl + cod_sub_cat) no la usa.';
COMMENT ON COLUMN almacen.vale_mov_det.oc_det_id IS
    'FK a compras.orden_compra_det: línea de OC que origina la recepción. Aplica cuando vale_mov.tipo_referencia_origen = ''I''.';
COMMENT ON COLUMN almacen.vale_mov_det.orden_traslado_det_id IS
    'FK a almacen.orden_traslado_det: línea de OT que este detalle despacha (en origen) o recibe (en destino). Aplica cuando tipo_referencia_origen = ''T''.';
COMMENT ON COLUMN almacen.vale_mov_det.orden_venta_det_id IS
    'FK a ventas.orden_venta_det: línea de OV despachada por este detalle. Aplica cuando tipo_referencia_origen = ''V''.';
COMMENT ON COLUMN almacen.vale_mov_det.operaciones_det_id IS
    'FK a produccion.operaciones_det: línea de operación de OT vinculada (consumo o producción). Aplica cuando tipo_referencia_origen = ''P''.';

CREATE TABLE almacen.guia (
    id BIGSERIAL PRIMARY KEY,
    sucursal_id BIGINT NOT NULL REFERENCES auth.sucursal(id),
    serie VARCHAR(10) NOT NULL,
    numero VARCHAR(20) NOT NULL,
    fecha_emision DATE NOT NULL,
    fecha_traslado DATE,
    motivo_traslado_id BIGINT REFERENCES almacen.motivo_traslado(id),
    destinatario_id BIGINT NOT NULL REFERENCES core.entidad_contribuyente(id),
    direccion_partida VARCHAR(300),
    direccion_llegada VARCHAR(300),
    transportista_id BIGINT REFERENCES core.entidad_contribuyente(id),
    vale_mov_id BIGINT REFERENCES almacen.vale_mov(id),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    UNIQUE (sucursal_id, serie, numero)
);

CREATE TABLE almacen.guia_det (
    id BIGSERIAL PRIMARY KEY,
    guia_id BIGINT NOT NULL REFERENCES almacen.guia(id),
    vale_mov_id BIGINT REFERENCES almacen.vale_mov(id),
    articulo_id BIGINT NOT NULL REFERENCES core.articulo(id),
    unidad_medida_id BIGINT NOT NULL REFERENCES core.unidad_medida(id),
    cantidad NUMERIC(18, 4) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

-- ============================================================
-- SECCIÓN 2B: TABLAS ADICIONALES DE ALMACÉN
-- (ubicacion_almacen definida arriba, antes de vale_mov_det)
-- ============================================================

CREATE TABLE almacen.almacen_tipo_mov (
    id                      BIGSERIAL NOT NULL,
    almacen_id              BIGINT NOT NULL,
    articulo_mov_tipo_id    BIGINT NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_ALMACEN_TIPO_MOV PRIMARY KEY (id),
    CONSTRAINT FK_ALMACEN_TIPO_MOV_01 FOREIGN KEY (almacen_id) REFERENCES almacen.almacen(id),
    CONSTRAINT FK_ALMACEN_TIPO_MOV_02 FOREIGN KEY (articulo_mov_tipo_id) REFERENCES almacen.articulo_mov_tipo(id),
    CONSTRAINT UQ_ALMACEN_TIPO_MOV_01 UNIQUE (almacen_id, articulo_mov_tipo_id)
);

CREATE TABLE almacen.articulo_almacen (
    id                      BIGSERIAL NOT NULL,
    almacen_id              BIGINT NOT NULL,
    articulo_id             BIGINT NOT NULL,
    cantidad_disponible     NUMERIC(18, 4) NOT NULL DEFAULT 0,
    cantidad_reservada      NUMERIC(18, 4) NOT NULL DEFAULT 0,
    costo_promedio          NUMERIC(18, 6) NOT NULL DEFAULT 0,
    ultima_actualizacion    TIMESTAMPTZ DEFAULT NOW(),
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_ARTICULO_ALMACEN PRIMARY KEY (id),
    CONSTRAINT FK_ARTICULO_ALMACEN_01 FOREIGN KEY (almacen_id) REFERENCES almacen.almacen(id),
    CONSTRAINT FK_ARTICULO_ALMACEN_02 FOREIGN KEY (articulo_id) REFERENCES core.articulo(id),
    CONSTRAINT UQ_ARTICULO_ALMACEN_01 UNIQUE (almacen_id, articulo_id)
);

-- Saldo de inventario por artículo, almacén y lote/templa. Equivale a templa_saldo de Oracle SIGRE.
-- La suma de saldos por lote para un (almacen, articulo) debe cuadrar con articulo_almacen.cantidad_disponible.
CREATE TABLE almacen.articulo_almacen_lote (
    id                      BIGSERIAL NOT NULL,
    almacen_id              BIGINT NOT NULL,
    articulo_id             BIGINT NOT NULL,
    lote_pallet_id          BIGINT NOT NULL,
    cantidad_total          NUMERIC(18, 4) NOT NULL DEFAULT 0,
    saldo                   NUMERIC(18, 4) NOT NULL DEFAULT 0,
    costo_promedio          NUMERIC(18, 6) NOT NULL DEFAULT 0,
    ultima_actualizacion    TIMESTAMPTZ DEFAULT NOW(),
    created_by              BIGINT,
    fec_creacion            TIMESTAMPTZ     DEFAULT NOW(),
    updated_by              BIGINT,
    fec_modificacion        TIMESTAMPTZ,
    CONSTRAINT PK_ARTICULO_ALMACEN_LOTE PRIMARY KEY (id),
    CONSTRAINT FK_ART_ALM_LOTE_01 FOREIGN KEY (almacen_id) REFERENCES almacen.almacen(id),
    CONSTRAINT FK_ART_ALM_LOTE_02 FOREIGN KEY (articulo_id) REFERENCES core.articulo(id),
    CONSTRAINT FK_ART_ALM_LOTE_03 FOREIGN KEY (lote_pallet_id) REFERENCES almacen.lote_pallet(id),
    CONSTRAINT UQ_ARTICULO_ALMACEN_LOTE_01 UNIQUE (almacen_id, articulo_id, lote_pallet_id)
);

-- Saldo de inventario por artículo y posición (ubicación). Debe cuadrar en suma con articulo_almacen por almacén+artículo (regla de negocio).
CREATE TABLE almacen.articulo_almacen_posicion (
    id                      BIGSERIAL NOT NULL,
    ubicacion_almacen_id    BIGINT NOT NULL,
    articulo_id             BIGINT NOT NULL,
    cantidad_disponible     NUMERIC(18, 4) NOT NULL DEFAULT 0,
    cantidad_reservada      NUMERIC(18, 4) NOT NULL DEFAULT 0,
    costo_promedio          NUMERIC(18, 6) NOT NULL DEFAULT 0,
    ultima_actualizacion    TIMESTAMPTZ DEFAULT NOW(),
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_ARTICULO_ALMACEN_POSICION PRIMARY KEY (id),
    CONSTRAINT FK_ART_ALM_POS_01 FOREIGN KEY (ubicacion_almacen_id) REFERENCES almacen.ubicacion_almacen(id),
    CONSTRAINT FK_ART_ALM_POS_02 FOREIGN KEY (articulo_id) REFERENCES core.articulo(id),
    CONSTRAINT UQ_ARTICULO_ALMACEN_POSICION_01 UNIQUE (articulo_id, ubicacion_almacen_id)
);

CREATE TABLE almacen.articulo_bonificacion (
    id                      BIGSERIAL NOT NULL,
    articulo_id             BIGINT NOT NULL,
    cantidad_minima         NUMERIC(18, 4) NOT NULL,
    cantidad_bonificacion   NUMERIC(18, 4) NOT NULL,
    fecha_inicio            DATE,
    fecha_fin               DATE,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_ARTICULO_BONIFICACION PRIMARY KEY (id),
    CONSTRAINT FK_ARTICULO_BONIFICACION_01 FOREIGN KEY (articulo_id) REFERENCES core.articulo(id)
);

CREATE TABLE almacen.articulo_saldo_mensual (
    id                      BIGSERIAL NOT NULL,
    almacen_id              BIGINT NOT NULL,
    articulo_id             BIGINT NOT NULL,
    vale_mov_det_id         BIGINT,
    fecha                   DATE NOT NULL,
    tipo                    VARCHAR(20) NOT NULL,
    cantidad                NUMERIC(18, 4) NOT NULL,
    costo_unitario          NUMERIC(18, 6) NOT NULL,
    costo_total             NUMERIC(18, 4) NOT NULL,
    saldo_cantidad          NUMERIC(18, 4) NOT NULL,
    saldo_costo_unitario    NUMERIC(18, 6),
    saldo_costo_total       NUMERIC(18, 4),
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_ARTICULO_SALDO_MENSUAL PRIMARY KEY (id),
    CONSTRAINT FK_ARTICULO_SALDO_MENSUAL_01 FOREIGN KEY (almacen_id) REFERENCES almacen.almacen(id),
    CONSTRAINT FK_ARTICULO_SALDO_MENSUAL_02 FOREIGN KEY (articulo_id) REFERENCES core.articulo(id),
    CONSTRAINT FK_ARTICULO_SALDO_MENSUAL_03 FOREIGN KEY (vale_mov_det_id) REFERENCES almacen.vale_mov_det(id)
);

CREATE TABLE almacen.orden_traslado (
    id                      BIGSERIAL NOT NULL,
    almacen_origen_id       BIGINT NOT NULL,
    almacen_destino_id      BIGINT NOT NULL,
    nro_orden_traslado      VARCHAR(12) NOT NULL UNIQUE,
    fecha                   DATE NOT NULL,
    flag_estado             VARCHAR(1) NOT NULL DEFAULT '1',
    observacion             TEXT,
    usuario_id              BIGINT,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_ORDEN_TRASLADO PRIMARY KEY (id),
    CONSTRAINT FK_ORDEN_TRASLADO_01 FOREIGN KEY (almacen_origen_id) REFERENCES almacen.almacen(id),
    CONSTRAINT FK_ORDEN_TRASLADO_02 FOREIGN KEY (almacen_destino_id) REFERENCES almacen.almacen(id)
);

CREATE TABLE almacen.orden_traslado_det (
    id                      BIGSERIAL NOT NULL,
    orden_traslado_id       BIGINT NOT NULL,
    articulo_id             BIGINT NOT NULL,
    cantidad                NUMERIC(18, 4) NOT NULL,
    cantidad_despachada     NUMERIC(18, 4) DEFAULT 0,
    cantidad_recibida       NUMERIC(18, 4) DEFAULT 0,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_ORDEN_TRASLADO_DET PRIMARY KEY (id),
    CONSTRAINT FK_ORDEN_TRASLADO_DET_01 FOREIGN KEY (orden_traslado_id) REFERENCES almacen.orden_traslado(id),
    CONSTRAINT FK_ORDEN_TRASLADO_DET_02 FOREIGN KEY (articulo_id) REFERENCES core.articulo(id)
);

-- Columna vale_mov_orig_id: referencia al vale original en devoluciones.
ALTER TABLE almacen.vale_mov ADD COLUMN IF NOT EXISTS vale_mov_orig_id BIGINT;
ALTER TABLE almacen.vale_mov DROP CONSTRAINT IF EXISTS FK_VALE_MOV_ORIG;
ALTER TABLE almacen.vale_mov
    ADD CONSTRAINT FK_VALE_MOV_ORIG FOREIGN KEY (vale_mov_orig_id) REFERENCES almacen.vale_mov(id);

-- FK diferida: tabla destino orden_traslado creada arriba en este mismo archivo.
ALTER TABLE almacen.vale_mov
    ADD CONSTRAINT FK_VALE_MOV_ORDEN_TRASLADO FOREIGN KEY (orden_traslado_id) REFERENCES almacen.orden_traslado(id);

-- FK diferida: vale_mov_det.orden_traslado_det_id → almacen.orden_traslado_det (misma sección).
-- Idempotente: DROP IF EXISTS + ADD permite re-ejecutar el script sin fallar.
ALTER TABLE almacen.vale_mov_det DROP CONSTRAINT IF EXISTS FK_VALE_MOV_DET_OT_DET;
ALTER TABLE almacen.vale_mov_det
    ADD CONSTRAINT FK_VALE_MOV_DET_OT_DET FOREIGN KEY (orden_traslado_det_id) REFERENCES almacen.orden_traslado_det(id);

CREATE TABLE almacen.inventario_conteo (
    id                      BIGSERIAL NOT NULL,
    almacen_id              BIGINT NOT NULL,
    articulo_id             BIGINT NOT NULL,
    fecha_conteo            DATE NOT NULL,
    nro_conteo              INTEGER NOT NULL DEFAULT 1,
    saldo_sistema           NUMERIC(18, 4),
    cantidad_conteo_1       NUMERIC(18, 4),
    auditor_conteo_1        VARCHAR(120),
    nro_ficha_conteo_1      VARCHAR(30),
    cantidad_conteo_2       NUMERIC(18, 4),
    auditor_conteo_2        VARCHAR(120),
    nro_ficha_conteo_2      VARCHAR(30),
    costo_unitario          NUMERIC(18, 6),
    diferencia              NUMERIC(18, 4),
    vale_mov_ajuste_id      BIGINT,
    lote_pallet_id          BIGINT REFERENCES almacen.lote_pallet(id),
    ubicacion_id            BIGINT,
    usuario_id              BIGINT,
    flag_estado             VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_INVENTARIO_CONTEO PRIMARY KEY (id),
    CONSTRAINT FK_INVENTARIO_CONTEO_01 FOREIGN KEY (almacen_id) REFERENCES almacen.almacen(id),
    CONSTRAINT FK_INVENTARIO_CONTEO_02 FOREIGN KEY (articulo_id) REFERENCES core.articulo(id),
    CONSTRAINT FK_INVENTARIO_CONTEO_03 FOREIGN KEY (vale_mov_ajuste_id) REFERENCES almacen.vale_mov(id),
    CONSTRAINT FK_INVENTARIO_CONTEO_04 FOREIGN KEY (ubicacion_id) REFERENCES almacen.ubicacion_almacen(id)
);

CREATE TABLE almacen.sol_salida (
    id                      BIGSERIAL NOT NULL,
    almacen_id              BIGINT NOT NULL,
    nro_sol_salida          VARCHAR(12) NOT NULL UNIQUE,
    fecha                   DATE NOT NULL,
    solicitante_id          BIGINT,
    flag_estado             VARCHAR(1) NOT NULL DEFAULT '1',
    observacion             TEXT,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_SOL_SALIDA PRIMARY KEY (id),
    CONSTRAINT FK_SOL_SALIDA_01 FOREIGN KEY (almacen_id) REFERENCES almacen.almacen(id)
);

CREATE TABLE almacen.sol_salida_det (
    id                      BIGSERIAL NOT NULL,
    sol_salida_id           BIGINT NOT NULL,
    articulo_id             BIGINT NOT NULL,
    cantidad                NUMERIC(18, 4) NOT NULL,
    cantidad_despachada     NUMERIC(18, 4) DEFAULT 0,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_SOL_SALIDA_DET PRIMARY KEY (id),
    CONSTRAINT FK_SOL_SALIDA_DET_01 FOREIGN KEY (sol_salida_id) REFERENCES almacen.sol_salida(id),
    CONSTRAINT FK_SOL_SALIDA_DET_02 FOREIGN KEY (articulo_id) REFERENCES core.articulo(id)
);

-- ============================================================
-- SECCIÓN 3: ÍNDICES
-- ============================================================

CREATE INDEX IX_ALMACEN_TIPO_01 ON almacen.almacen_tipo (flag_estado);
CREATE INDEX IX_ALMACEN_01 ON almacen.almacen (almacen_tipo_id);
CREATE INDEX IX_VALE_MOV_01 ON almacen.vale_mov (almacen_id, fecha_mov);
CREATE INDEX IX_VALE_MOV_02 ON almacen.vale_mov (articulo_mov_tipo_id);
CREATE INDEX IX_VALE_MOV_03 ON almacen.vale_mov (tipo_doc_int_id);
CREATE INDEX IX_VALE_MOV_04 ON almacen.vale_mov (tipo_doc_ext_id);
-- IX_VALE_MOV_05, 06 (compras): creados en 03-compras.sql junto a las FK.
CREATE INDEX IX_VALE_MOV_07 ON almacen.vale_mov (orden_traslado_id);
-- IX_VALE_MOV_08 (orden_trabajo): creado en 09-produccion.sql junto a la FK.
CREATE INDEX IX_VALE_MOV_09 ON almacen.vale_mov (tipo_referencia_origen);
-- IX_VALE_MOV_10 (orden_venta): creado en 04-ventas.sql junto a la FK.
CREATE INDEX IX_VALE_MOV_DET_01 ON almacen.vale_mov_det (vale_mov_id, articulo_id);
CREATE INDEX IX_VALE_MOV_DET_02 ON almacen.vale_mov_det (matriz_contable_id);
CREATE INDEX IX_VALE_MOV_DET_03 ON almacen.vale_mov_det (ubicacion_almacen_id);
CREATE INDEX IX_VALE_MOV_DET_04 ON almacen.vale_mov_det (centros_costo_id);
CREATE INDEX IF NOT EXISTS IX_VALE_MOV_DET_05 ON almacen.vale_mov_det (orden_traslado_det_id);
-- IX_VALE_MOV_DET_06 (orden_venta_det_id): creado en 04-ventas.sql junto a la FK.
-- IX_VALE_MOV_DET_07 (operaciones_det_id): creado en 09-produccion.sql junto a la FK.
CREATE INDEX IX_GUIA_01 ON almacen.guia (destinatario_id, fecha_emision);

CREATE INDEX IX_UBICACION_ALMACEN_01 ON almacen.ubicacion_almacen (almacen_id);
CREATE INDEX IX_ALMACEN_TIPO_MOV_01 ON almacen.almacen_tipo_mov (almacen_id, articulo_mov_tipo_id);
CREATE INDEX IX_ARTICULO_ALMACEN_01 ON almacen.articulo_almacen (almacen_id, articulo_id);
CREATE INDEX IX_ARTICULO_ALMACEN_LOTE_01 ON almacen.articulo_almacen_lote (almacen_id, articulo_id);
CREATE INDEX IX_ARTICULO_ALMACEN_LOTE_02 ON almacen.articulo_almacen_lote (lote_pallet_id);
CREATE INDEX IX_ARTICULO_ALMACEN_POS_01 ON almacen.articulo_almacen_posicion (ubicacion_almacen_id, articulo_id);
CREATE INDEX IX_ARTICULO_ALMACEN_POS_02 ON almacen.articulo_almacen_posicion (articulo_id);
CREATE INDEX IX_ARTICULO_BONIFICACION_01 ON almacen.articulo_bonificacion (articulo_id);
CREATE INDEX IX_ARTICULO_SALDO_MENSUAL_01 ON almacen.articulo_saldo_mensual (almacen_id, articulo_id, fecha);
CREATE INDEX IX_ORDEN_TRASLADO_01 ON almacen.orden_traslado (almacen_origen_id, fecha);
CREATE INDEX IX_ORDEN_TRASLADO_02 ON almacen.orden_traslado (almacen_destino_id, fecha);
CREATE INDEX IX_ORDEN_TRASLADO_DET_01 ON almacen.orden_traslado_det (orden_traslado_id, articulo_id);
CREATE INDEX IX_INVENTARIO_CONTEO_01 ON almacen.inventario_conteo (almacen_id, articulo_id, fecha_conteo);
CREATE INDEX IX_SOL_SALIDA_01 ON almacen.sol_salida (almacen_id, fecha);
CREATE INDEX IX_SOL_SALIDA_DET_01 ON almacen.sol_salida_det (sol_salida_id, articulo_id);
