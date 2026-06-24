-- ============================================================
-- SIGRE ERP - Tenant DB - core schema
-- Estrategia: DROP SCHEMA CASCADE + CREATE (reconstrucción completa)
-- ============================================================
--
-- ============================================================
-- REGLA GLOBAL: flag_estado es OBLIGATORIO en TODAS las tablas del proyecto.
-- PROHIBIDO eliminar flag_estado VARCHAR(1) NOT NULL DEFAULT '1' de cualquier tabla.
-- Las entidades JPA heredan de BaseEntity que mapea este campo.
-- ============================================================
--
-- Este script es el PRIMERO en ejecutarse. Elimina TODOS los esquemas
-- de la base de datos tenant y los recrea desde cero.
-- Al hacer DROP SCHEMA ... CASCADE se eliminan automáticamente
-- todas las tablas, índices, constraints y secuencias del esquema.
--
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

-- ============================================================
-- CONVENCIÓN: nomenclatura de variables locales en PL/pgSQL
-- ============================================================
-- Prefijo  l<tt>_  donde:
--   l   = variable Local
--   tt  = acrónimo del tipo de dato:
--     int = INTEGER / BIGINT / SMALLINT
--     var = VARCHAR / TEXT
--     dec = DECIMAL / NUMERIC
--     bol = BOOLEAN
--     dat = DATE
--     tms = TIMESTAMP / TIMESTAMPTZ
--     rec = RECORD / ROW
--
-- Parámetros de entrada mantienen prefijo p_ (p_nombre_tabla, p_sucursalId, etc.)
--
-- Ejemplos:
--   lint_seq      BIGINT          (secuencial)
--   lvar_codigo   VARCHAR(20)     (código textual)
--   ldec_monto    NUMERIC(18,2)   (importe monetario)
--   lbol_activo   BOOLEAN         (bandera lógica)
--   ldat_inicio   DATE
--   ltms_ahora    TIMESTAMPTZ
-- ============================================================

-- ============================================================
-- SECCIÓN 1: DROP de TODOS los esquemas (reconstrucción total)
-- ============================================================
--
-- DEPENDENCIAS ENTRE ESQUEMAS (→ = tiene FK hacia):
--
--   auditoria   (sin dependencias inter-schema)
--   produccion  → core, almacen
--   activos     → core
--   rrhh        → core
--   contabilidad → core
--   finanzas    → core, compras
--   ventas      → core, almacen
--   compras     → core
--   almacen     → core
--   core        (raíz, no depende de nadie)
--
-- ORDEN DE DROP (esquemas dependientes primero, raíz al final):
--   1. auditoria    — sin dependencias externas
--   2. produccion   — depende de core, almacen
--   3. activos      — depende de core
--   4. rrhh         — depende de core
--   5. contabilidad — depende de core
--   6. finanzas     — depende de core, compras
--   7. ventas       — depende de core, almacen
--   8. compras      — depende de core (referenciado por finanzas)
--   9. almacen      — depende de core (referenciado por ventas, produccion)
--  10. core         — raíz (referenciado por todos)
--
-- CASCADE elimina todo: tablas, índices, FKs, secuencias, etc.
-- ============================================================

DROP SCHEMA IF EXISTS auditoria CASCADE;
DROP SCHEMA IF EXISTS produccion CASCADE;
DROP SCHEMA IF EXISTS activos CASCADE;
DROP SCHEMA IF EXISTS rrhh CASCADE;
DROP SCHEMA IF EXISTS contabilidad CASCADE;
DROP SCHEMA IF EXISTS finanzas CASCADE;
DROP SCHEMA IF EXISTS ventas CASCADE;
DROP SCHEMA IF EXISTS compras CASCADE;
DROP SCHEMA IF EXISTS almacen CASCADE;
DROP SCHEMA IF EXISTS core CASCADE;

-- ============================================================
-- SECCIÓN 2: CREATE esquema core (tablas, constraints e índices)
-- ============================================================
-- Los demás esquemas se crean en sus propios scripts (02 a 10).
-- ============================================================

CREATE SCHEMA core;

CREATE TABLE core.num_tablas (
    nombre_tabla VARCHAR(120) NOT NULL,
    cod_origen VARCHAR(20) NOT NULL DEFAULT 'XX',
    ultimo_numero BIGINT NOT NULL DEFAULT 0,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_NUM_TABLAS PRIMARY KEY (nombre_tabla, cod_origen),
    CONSTRAINT CK_NUM_TABLAS_ULTIMO_NUMERO CHECK (ultimo_numero >= 0)
);

-- Ficha fiscal/comercial de la empresa: solo en master.empresa (BD security). Esta BD tenant es ya de una empresa; no se duplica core.empresa aquí.
-- auth.sucursal: definición CREATE en tenant/01-auth.sql; FK e índices de sucursal más abajo en este script.

CREATE TABLE core.moneda (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(10) NOT NULL UNIQUE,
    sigla_moneda VARCHAR(10),
    nombre VARCHAR(80) NOT NULL,
    simbolo VARCHAR(10),
    decimales INTEGER NOT NULL DEFAULT 2,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE OR REPLACE FUNCTION core.fn_moneda_default_pen_id()
RETURNS BIGINT
LANGUAGE SQL
STABLE
AS $$
    SELECT id
      FROM core.moneda
     WHERE codigo IN ('SOL', 'PEN')
     ORDER BY CASE codigo WHEN 'SOL' THEN 0 WHEN 'PEN' THEN 1 ELSE 2 END, id
     LIMIT 1
$$;

CREATE TABLE core.tipo_cambio (
    id BIGSERIAL PRIMARY KEY,
    moneda_id BIGINT NOT NULL REFERENCES core.moneda(id),
    fecha DATE NOT NULL,
    compra NUMERIC(18, 6) NOT NULL,
    venta NUMERIC(18, 6) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

-- Catálogo crédito fiscal SUNAT (registro compras 01–04) — base SIGRE CREDITO_FISCAL
CREATE TABLE core.credito_fiscal (
    id                  BIGSERIAL       NOT NULL,
    codigo              CHAR(2)         NOT NULL,
    descripcion         VARCHAR(50),
    cod_sunat           CHAR(2),
    flag_tipo_adquisicion CHAR(1)       NOT NULL DEFAULT '3',
    flag_cxp_cxc        CHAR(1)         NOT NULL DEFAULT 'P',
    tipo_afectacion_igv CHAR(2),
    flag_estado         VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CREDITO_FISCAL PRIMARY KEY (id),
    CONSTRAINT UQ_CREDITO_FISCAL_CODIGO UNIQUE (codigo),
    CONSTRAINT CK_CREDITO_FISCAL_ADQ CHECK (flag_tipo_adquisicion IN ('1', '2', '3')),
    CONSTRAINT CK_CREDITO_FISCAL_CXC CHECK (flag_cxp_cxc IN ('P', 'C'))
);

-- Migración idempotente: PK codigo → PK id (despliegues previos)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
         WHERE table_schema = 'core' AND table_name = 'credito_fiscal' AND column_name = 'codigo'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.columns
         WHERE table_schema = 'core' AND table_name = 'credito_fiscal' AND column_name = 'id'
    ) THEN
        ALTER TABLE core.credito_fiscal ADD COLUMN id BIGSERIAL;
        ALTER TABLE core.credito_fiscal DROP CONSTRAINT IF EXISTS pk_credito_fiscal;
        ALTER TABLE core.credito_fiscal ADD CONSTRAINT pk_credito_fiscal PRIMARY KEY (id);
        CREATE UNIQUE INDEX IF NOT EXISTS uq_credito_fiscal_codigo ON core.credito_fiscal (codigo);
    END IF;
END $$;

COMMENT ON TABLE core.credito_fiscal IS
    'Tipos de crédito fiscal para líneas de CxP (columnas 01–04 registro compras SUNAT).';

-- Catálogo mínimo requerido por FK de finanzas.cntas_pagar_det (seed completo en 01-carga-inicial-maestros.sql)
INSERT INTO core.credito_fiscal (codigo, descripcion, cod_sunat, flag_tipo_adquisicion, flag_cxp_cxc, tipo_afectacion_igv, flag_estado)
VALUES
    ('01', 'Adq. grav. dest. a oper. gravadas', '01', '3', 'P', '10', '1'),
    ('02', 'Adq. grav. dest. a oper. grav. y/o export.', '02', '3', 'P', '10', '1'),
    ('03', 'Adq. grav. dest. a oper. no gravadas', '03', '3', 'P', '10', '1'),
    ('04', 'Adq. no gravadas', '04', '3', 'P', '30', '1')
ON CONFLICT (codigo) DO NOTHING;

DROP FUNCTION IF EXISTS core.fn_tasa_cambio_calendario(DATE);
DROP FUNCTION IF EXISTS core.fn_tasa_cambio_calendario(DATE, BIGINT, BIGINT);
DROP TABLE IF EXISTS core.calendario;

-- TC por fecha y par de monedas — adaptado de SIGRE USF_FL_CONV_MON usando core.tipo_cambio.
-- USD→PEN: compra. PEN→USD: venta.
CREATE OR REPLACE FUNCTION core.fn_tasa_cambio_calendario(
    fecha DATE,
    id_moneda_origen BIGINT,
    id_moneda_destino BIGINT
)
RETURNS NUMERIC(18, 6)
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    ln_tasa         NUMERIC(18, 6);
    ls_cod_origen   VARCHAR(10);
    ls_cod_destino  VARCHAR(10);
    ld_fecha        DATE;
BEGIN
    ld_fecha := COALESCE(fecha, CURRENT_DATE);

    IF id_moneda_origen IS NULL OR id_moneda_destino IS NULL THEN
        RETURN 1;
    END IF;

    IF id_moneda_origen = id_moneda_destino THEN
        RETURN 1;
    END IF;

    SELECT m.codigo INTO ls_cod_origen
      FROM core.moneda m
     WHERE m.id = id_moneda_origen;

    SELECT m.codigo INTO ls_cod_destino
      FROM core.moneda m
     WHERE m.id = id_moneda_destino;

    IF ls_cod_origen IS NULL OR ls_cod_destino IS NULL THEN
        RETURN 1;
    END IF;

    IF ls_cod_origen IN ('SOL', 'PEN') AND ls_cod_destino IN ('SOL', 'PEN') THEN
        RETURN 1;
    END IF;

    -- USD → soles: compra (SIGRE cmp_dol_prom cuando flag_tc_vta = '0')
    IF ls_cod_origen = 'USD' AND ls_cod_destino IN ('SOL', 'PEN') THEN
        SELECT tc.compra
          INTO ln_tasa
          FROM core.tipo_cambio tc
          JOIN core.moneda m ON m.id = tc.moneda_id AND m.codigo = 'USD'
         WHERE tc.fecha = ld_fecha
           AND tc.flag_estado <> '0'
         LIMIT 1;
        RETURN COALESCE(NULLIF(ln_tasa, 0), 1);
    END IF;

    -- Soles → USD: venta (SIGRE vta_dol_prom)
    IF ls_cod_origen IN ('SOL', 'PEN') AND ls_cod_destino = 'USD' THEN
        SELECT tc.venta
          INTO ln_tasa
          FROM core.tipo_cambio tc
          JOIN core.moneda m ON m.id = tc.moneda_id AND m.codigo = 'USD'
         WHERE tc.fecha = ld_fecha
           AND tc.flag_estado <> '0'
         LIMIT 1;
        RETURN COALESCE(NULLIF(ln_tasa, 0), 1);
    END IF;

    -- EUR → soles: venta EUR (SIGRE vta_eur_bnc)
    IF ls_cod_origen = 'EUR' AND ls_cod_destino IN ('SOL', 'PEN') THEN
        SELECT tc.venta
          INTO ln_tasa
          FROM core.tipo_cambio tc
          JOIN core.moneda m ON m.id = tc.moneda_id AND m.codigo = 'EUR'
         WHERE tc.fecha = ld_fecha
           AND tc.flag_estado <> '0'
         LIMIT 1;
        RETURN COALESCE(NULLIF(ln_tasa, 0), 1);
    END IF;

    -- Soles → EUR: compra EUR
    IF ls_cod_origen IN ('SOL', 'PEN') AND ls_cod_destino = 'EUR' THEN
        SELECT tc.compra
          INTO ln_tasa
          FROM core.tipo_cambio tc
          JOIN core.moneda m ON m.id = tc.moneda_id AND m.codigo = 'EUR'
         WHERE tc.fecha = ld_fecha
           AND tc.flag_estado <> '0'
         LIMIT 1;
        RETURN COALESCE(NULLIF(ln_tasa, 0), 1);
    END IF;

    RETURN 1;
END;
$$;

COMMENT ON FUNCTION core.fn_tasa_cambio_calendario(DATE, BIGINT, BIGINT) IS
    'TC según fecha, id_moneda_origen e id_moneda_destino. SIGRE USF_FL_CONV_MON sobre core.tipo_cambio (compra/venta).';

CREATE TABLE core.unidad_medida (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(80) NOT NULL,
    abreviatura VARCHAR(20),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE core.articulo_categ (
    id BIGSERIAL PRIMARY KEY,
    cat_art VARCHAR(10) NOT NULL,
    desc_categ VARCHAR(200) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);
CREATE UNIQUE INDEX IX_ARTICULO_CATEG_01 ON core.articulo_categ (cat_art);

CREATE TABLE core.articulo_clase (
    id BIGSERIAL PRIMARY KEY,
    cod_clase VARCHAR(10) NOT NULL,
    desc_clase VARCHAR(120) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);
CREATE UNIQUE INDEX IX_ARTICULO_CLASE_01 ON core.articulo_clase (cod_clase);

CREATE TABLE core.articulo_sub_categ (
    id BIGSERIAL PRIMARY KEY,
    cod_sub_cat VARCHAR(10) NOT NULL,
    desc_subcateg VARCHAR(200) NOT NULL,
    articulo_categ_id BIGINT NOT NULL REFERENCES core.articulo_categ(id),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);
CREATE UNIQUE INDEX IX_ARTICULO_SUB_CATEG_01 ON core.articulo_sub_categ (cod_sub_cat);

CREATE TABLE core.marca (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE core.color (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(120) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE core.articulo (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(30) NOT NULL UNIQUE,
    nombre VARCHAR(220) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    unidad_medida_id BIGINT NOT NULL REFERENCES core.unidad_medida(id),
    articulo_categ_id BIGINT REFERENCES core.articulo_categ(id),
    articulo_sub_categ_id BIGINT REFERENCES core.articulo_sub_categ(id),
    marca_id BIGINT REFERENCES core.marca(id),
    color_id BIGINT REFERENCES core.color(id),
    precio_venta NUMERIC(18, 4),
    codigo_barras VARCHAR(80),
    imagen_blob BYTEA,
    imagen_url TEXT,
    es_ventable BOOLEAN NOT NULL DEFAULT TRUE,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE core.entidad_contribuyente (
    id BIGSERIAL PRIMARY KEY,
    tipo_persona VARCHAR(15) NOT NULL,
    tipo_documento VARCHAR(20),
    nro_documento VARCHAR(30),
    razon_social VARCHAR(200),
    nombre_comercial VARCHAR(300),
    direccion VARCHAR(300),
    nombres VARCHAR(120),
    apellidos VARCHAR(120),
    telefono VARCHAR(40),
    email VARCHAR(150),
    es_proveedor BOOLEAN NOT NULL DEFAULT FALSE,
    es_cliente BOOLEAN NOT NULL DEFAULT FALSE,
    es_empleado BOOLEAN NOT NULL DEFAULT FALSE,
    tipo_entidad_contribuyente_id BIGINT,                   -- FK diferida → compras.tipo_entidad_contribuyente(id) en 03-compras.sql
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE core.contacto (
    id BIGSERIAL PRIMARY KEY,
    entidad_contribuyente_id BIGINT NOT NULL REFERENCES core.entidad_contribuyente(id),
    nombre VARCHAR(150) NOT NULL,
    cargo VARCHAR(120),
    telefono VARCHAR(40),
    email VARCHAR(150),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

-- banco y banco_cnta movidos al esquema finanzas (05-finanzas.sql)

CREATE TABLE core.entidad_banco_cnta (
    id BIGSERIAL PRIMARY KEY,
    entidad_contribuyente_id BIGINT NOT NULL REFERENCES core.entidad_contribuyente(id),
    cod_banco CHAR(3),
    moneda_id BIGINT REFERENCES core.moneda(id),
    nro_cuenta VARCHAR(60) NOT NULL,
    cci VARCHAR(60),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE core.entidad_tienda (
    id BIGSERIAL PRIMARY KEY,
    entidad_contribuyente_id BIGINT NOT NULL REFERENCES core.entidad_contribuyente(id),
    codigo VARCHAR(30) NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    direccion VARCHAR(300),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE core.entidad_transporte (
    id BIGSERIAL PRIMARY KEY,
    entidad_contribuyente_id BIGINT NOT NULL REFERENCES core.entidad_contribuyente(id),
    placa VARCHAR(20),
    licencia VARCHAR(30),
    mtc VARCHAR(30),
    chofer VARCHAR(150),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE core.doc_tipo (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(120) NOT NULL,
    sunat_codigo VARCHAR(20),
    flag_signo VARCHAR(1) NOT NULL DEFAULT '+',
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);
COMMENT ON COLUMN core.doc_tipo.flag_signo IS 'Signo del documento: + suma, - resta (NC invierte signo en CxP/CxC).';

-- Numeración de documentos por ORIGEN (punto de venta, terminal, etc.).
-- origen_id = 0 = comodín (fila por defecto cuando el caller no especifica origen).
CREATE TABLE core.doc_tipo_num (
    id BIGSERIAL PRIMARY KEY,
    sucursal_id BIGINT NOT NULL REFERENCES auth.sucursal(id),
    doc_tipo_id BIGINT NOT NULL REFERENCES core.doc_tipo(id),
    origen_id   BIGINT NOT NULL DEFAULT 0,
    anio        INTEGER NOT NULL,
    ultimo_numero BIGINT NOT NULL DEFAULT 0,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    UNIQUE (sucursal_id, doc_tipo_id, origen_id, anio)
);
COMMENT ON TABLE core.doc_tipo_num IS
    'Numeración por tipo de documento y origen lógico (PV, terminal). origen_id 0 = comodín.';

-- Numeración de documentos SUNAT por SERIE (factura, boleta, retención, guía, liquidación de compra).
-- La serie SUNAT mantiene correlativo continuo independientemente del año.
CREATE TABLE core.doc_tipo_num_serie (
    id BIGSERIAL PRIMARY KEY,
    sucursal_id BIGINT NOT NULL REFERENCES auth.sucursal(id),
    doc_tipo_id BIGINT NOT NULL REFERENCES core.doc_tipo(id),
    serie       VARCHAR(10) NOT NULL,
    ultimo_numero BIGINT NOT NULL DEFAULT 0,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    UNIQUE (sucursal_id, doc_tipo_id, serie)
);
COMMENT ON TABLE core.doc_tipo_num_serie IS
    'Numeración SUNAT por serie: PK (sucursal, doc_tipo, serie). Ver core.fn_get_number_sunat_documents.';

CREATE TABLE core.doc_tipo_usuario (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT NOT NULL,
    doc_tipo_id BIGINT NOT NULL REFERENCES core.doc_tipo(id),
    sucursal_id BIGINT REFERENCES auth.sucursal(id),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE core.grupo_tipo_doc (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(30) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE core.grupo_tipo_doc_det (
    id BIGSERIAL PRIMARY KEY,
    grupo_tipo_doc_id BIGINT NOT NULL REFERENCES core.grupo_tipo_doc(id),
    doc_tipo_id BIGINT NOT NULL REFERENCES core.doc_tipo(id),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    UNIQUE (grupo_tipo_doc_id, doc_tipo_id)
);

CREATE TABLE core.secuencia_documento (
    id BIGSERIAL PRIMARY KEY,
    sucursal_id BIGINT NOT NULL REFERENCES auth.sucursal(id),
    tipo_documento VARCHAR(50) NOT NULL,
    serie VARCHAR(10) NOT NULL,
    anio INTEGER NOT NULL,
    ultimo_numero BIGINT NOT NULL DEFAULT 0,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    UNIQUE (sucursal_id, tipo_documento, serie, anio)
);

CREATE TABLE core.num_proveedor (
    id BIGSERIAL PRIMARY KEY,
    sucursal_id BIGINT NOT NULL REFERENCES auth.sucursal(id),
    serie VARCHAR(10) NOT NULL,
    anio INTEGER NOT NULL,
    ultimo_numero BIGINT NOT NULL DEFAULT 0,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    UNIQUE (sucursal_id, serie, anio)
);

CREATE TABLE core.catalogo_sunat (
    id BIGSERIAL PRIMARY KEY,
    codigo_catalogo VARCHAR(30) NOT NULL UNIQUE,
    nombre_catalogo VARCHAR(180) NOT NULL,
    descripcion_catalogo TEXT,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE core.catalogo_sunat_det (
    id BIGSERIAL PRIMARY KEY,
    catalogo_sunat_id BIGINT NOT NULL REFERENCES core.catalogo_sunat(id),
    codigo_item VARCHAR(30) NOT NULL,
    nombre_item VARCHAR(500) NOT NULL,
    descripcion_item TEXT,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    UNIQUE (catalogo_sunat_id, codigo_item)
);

CREATE TABLE core.sunat_cubso (
    id BIGSERIAL PRIMARY KEY,
    cod_cubso VARCHAR(20) NOT NULL UNIQUE,
    descripcion VARCHAR(500) NOT NULL,
    cod_clase VARCHAR(20),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

-- UIT — Unidad Impositiva Tributaria (SIGRE: CANTABRIA.UIT)
-- Histórico por año y fecha de inicio de vigencia; usado en RRHH (5ta categoría, deducción 7 UIT) y contabilidad.
CREATE TABLE core.uit (
    id              BIGSERIAL       NOT NULL,
    ano             INTEGER         NOT NULL,
    importe         NUMERIC(13, 2)  NOT NULL DEFAULT 0,
    fec_ini_vigen   DATE            NOT NULL,
    flag_estado     VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by      BIGINT,
    fec_creacion    TIMESTAMPTZ     DEFAULT NOW(),
    updated_by      BIGINT,
    fec_modificacion TIMESTAMPTZ,
    CONSTRAINT PK_UIT PRIMARY KEY (id),
    CONSTRAINT UQ_UIT_ANO_VIGEN UNIQUE (ano, fec_ini_vigen)
);

COMMENT ON TABLE core.uit IS 'Unidad Impositiva Tributaria (UIT) por año y vigencia';
COMMENT ON COLUMN core.uit.ano IS 'Año fiscal de la UIT';
COMMENT ON COLUMN core.uit.importe IS 'Valor de la UIT en soles';
COMMENT ON COLUMN core.uit.fec_ini_vigen IS 'Fecha desde la que rige el importe';

-- ============================================================
-- core.configuracion: TODOS los parámetros del sistema a nivel de tenant vienen de esta tabla.
-- Esquema: core. Los parámetros se CREAN, ACTUALIZAN o ELIMINAN; NO tienen flag_estado.
-- NO usar core.parametro_sistema (legacy, pendiente de eliminación).
-- ============================================================
CREATE TABLE core.configuracion (
    id BIGSERIAL PRIMARY KEY,
    module VARCHAR(60),
    parameter VARCHAR(120) NOT NULL,
    data_type VARCHAR(20) NOT NULL,
    value_text TEXT,
    value_int INTEGER,
    value_dec NUMERIC(18, 6),
    value_date DATE,
    value_bool BOOLEAN,
    editable BOOLEAN NOT NULL DEFAULT TRUE,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

-- ============================================================
-- Funciones de acceso a core.configuracion: fn_config_<sufijo>(parametro, default).
-- Si el parámetro no existe lo INSERTA con el valor por defecto y lo retorna.
-- Sufijos: _txt (texto), _int (entero), _dec (decimal), _date (fecha), _bool (boolean).
-- Nomenclatura: core.fn_get_parameter_<sufijo>(parametro, default).
-- ============================================================

CREATE OR REPLACE FUNCTION core.fn_get_parameter_txt(
    p_parameter VARCHAR(120),
    p_default TEXT DEFAULT NULL
) RETURNS TEXT
LANGUAGE plpgsql VOLATILE AS $$
DECLARE
    lvar_valor TEXT;
BEGIN
    SELECT c.value_text INTO lvar_valor
    FROM core.configuracion c WHERE c.parameter = p_parameter;

    IF NOT FOUND THEN
        INSERT INTO core.configuracion (parameter, data_type, value_text, fec_creacion)
        VALUES (p_parameter, 'TEXT', p_default, NOW());
        RETURN p_default;
    END IF;

    RETURN COALESCE(lvar_valor, p_default);
END;
$$;

CREATE OR REPLACE FUNCTION core.fn_get_parameter_int(
    p_parameter VARCHAR(120),
    p_default INTEGER DEFAULT 0
) RETURNS INTEGER
LANGUAGE plpgsql VOLATILE AS $$
DECLARE
    lint_valor INTEGER;
BEGIN
    SELECT c.value_int INTO lint_valor
    FROM core.configuracion c WHERE c.parameter = p_parameter;

    IF NOT FOUND THEN
        INSERT INTO core.configuracion (parameter, data_type, value_int, fec_creacion)
        VALUES (p_parameter, 'INTEGER', p_default, NOW());
        RETURN p_default;
    END IF;

    RETURN COALESCE(lint_valor, p_default);
END;
$$;

CREATE OR REPLACE FUNCTION core.fn_get_parameter_dec(
    p_parameter VARCHAR(120),
    p_default NUMERIC DEFAULT 0
) RETURNS NUMERIC(18, 6)
LANGUAGE plpgsql VOLATILE AS $$
DECLARE
    ldec_valor NUMERIC(18, 6);
BEGIN
    SELECT c.value_dec INTO ldec_valor
    FROM core.configuracion c WHERE c.parameter = p_parameter;

    IF NOT FOUND THEN
        INSERT INTO core.configuracion (parameter, data_type, value_dec, fec_creacion)
        VALUES (p_parameter, 'DECIMAL', p_default, NOW());
        RETURN p_default;
    END IF;

    RETURN COALESCE(ldec_valor, p_default);
END;
$$;

CREATE OR REPLACE FUNCTION core.fn_get_parameter_date(
    p_parameter VARCHAR(120),
    p_default DATE DEFAULT NULL
) RETURNS DATE
LANGUAGE plpgsql VOLATILE AS $$
DECLARE
    ldat_valor DATE;
BEGIN
    SELECT c.value_date INTO ldat_valor
    FROM core.configuracion c WHERE c.parameter = p_parameter;

    IF NOT FOUND THEN
        INSERT INTO core.configuracion (parameter, data_type, value_date, fec_creacion)
        VALUES (p_parameter, 'DATE', p_default, NOW());
        RETURN p_default;
    END IF;

    RETURN COALESCE(ldat_valor, p_default);
END;
$$;

CREATE OR REPLACE FUNCTION core.fn_get_parameter_bool(
    p_parameter VARCHAR(120),
    p_default BOOLEAN DEFAULT FALSE
) RETURNS BOOLEAN
LANGUAGE plpgsql VOLATILE AS $$
DECLARE
    lbol_valor BOOLEAN;
BEGIN
    SELECT c.value_bool INTO lbol_valor
    FROM core.configuracion c WHERE c.parameter = p_parameter;

    IF NOT FOUND THEN
        INSERT INTO core.configuracion (parameter, data_type, value_bool, fec_creacion)
        VALUES (p_parameter, 'BOOLEAN', p_default, NOW());
        RETURN p_default;
    END IF;

    RETURN COALESCE(lbol_valor, p_default);
END;
$$;

COMMENT ON FUNCTION core.fn_get_parameter_txt(VARCHAR, TEXT) IS 'Parámetro TEXT de core.configuracion; si no existe lo crea con el default.';
COMMENT ON FUNCTION core.fn_get_parameter_int(VARCHAR, INTEGER) IS 'Parámetro INTEGER de core.configuracion; si no existe lo crea con el default.';
COMMENT ON FUNCTION core.fn_get_parameter_dec(VARCHAR, NUMERIC) IS 'Parámetro DECIMAL de core.configuracion; si no existe lo crea con el default.';
COMMENT ON FUNCTION core.fn_get_parameter_date(VARCHAR, DATE) IS 'Parámetro DATE de core.configuracion; si no existe lo crea con el default.';
COMMENT ON FUNCTION core.fn_get_parameter_bool(VARCHAR, BOOLEAN) IS 'Parámetro BOOLEAN nativo de core.configuracion; si no existe lo crea con el default.';

CREATE TABLE core.configuracion_usuario (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT NOT NULL,
    modulo VARCHAR(60),
    parametro VARCHAR(120) NOT NULL,
    tipo_dato VARCHAR(20) NOT NULL,
    valor_texto TEXT,
    valor_entero INTEGER,
    valor_decimal NUMERIC(18, 6),
    valor_fecha DATE,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE core.calendario_feriado (
    id BIGSERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    descripcion VARCHAR(220) NOT NULL,
    sucursal_id BIGINT REFERENCES auth.sucursal(id),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

-- Maestro de direcciones de entidades — base SIGRE DIRECCIONES
-- PK compuesta: (entidad_contribuyente_id, item)
CREATE TABLE core.entidad_direccion (
    id                      BIGSERIAL       NOT NULL,
    entidad_contribuyente_id BIGINT         NOT NULL REFERENCES core.entidad_contribuyente(id),
    item                    SMALLINT        NOT NULL DEFAULT 1,
    descripcion             VARCHAR(60),
    dir_pais                VARCHAR(40),
    dir_dep_estado          VARCHAR(40),
    dir_provincia           VARCHAR(40),
    dir_ciudad              VARCHAR(40),
    dir_distrito            VARCHAR(40),
    dir_urbanizacion        VARCHAR(40),
    dir_direccion           VARCHAR(300)    NOT NULL,
    dir_direccion2          VARCHAR(300),
    dir_mnz                 CHAR(4),
    dir_lote                CHAR(4),
    dir_numero              VARCHAR(10),
    dir_interior            VARCHAR(40),
    dir_cod_postal          VARCHAR(10),
    dir_referencia          VARCHAR(250),
    ubigeo                  VARCHAR(12),
    cod_pais                VARCHAR(4),
    cod_dpto                VARCHAR(3),
    cod_prov                VARCHAR(3),
    cod_distr               VARCHAR(4),
    dir_siglas_pais         CHAR(2),
    cod_pais_sunat          VARCHAR(4),
    cep                     VARCHAR(40),
    flag_uso                CHAR(1)         NOT NULL DEFAULT '1',
    flag_dir_comercial      CHAR(1)         NOT NULL DEFAULT '0',
    es_principal            BOOLEAN         NOT NULL DEFAULT FALSE,
    latitud                 NUMERIC(20,16)  NOT NULL DEFAULT 0,
    longitud                NUMERIC(20,16)  NOT NULL DEFAULT 0,
    zona_venta              VARCHAR(8),
    zona_despacho           VARCHAR(8),
    nombre_tienda           VARCHAR(120),
    cod_tienda              VARCHAR(10),
    flag_estado VARCHAR(1)         NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_ENTIDAD_DIRECCION PRIMARY KEY (id),
    CONSTRAINT UQ_ENTIDAD_DIRECCION_01 UNIQUE (entidad_contribuyente_id, item)
);

CREATE TABLE core.pais (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    moneda_id BIGINT,
    formato_fecha VARCHAR(20),
    zona_horaria VARCHAR(60),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_PAIS PRIMARY KEY (id),
    CONSTRAINT FK_PAIS_01 FOREIGN KEY (moneda_id) REFERENCES core.moneda(id)
);

CREATE TABLE core.conversion_unidad (
    id BIGSERIAL NOT NULL,
    unidad_origen_id BIGINT NOT NULL,
    unidad_destino_id BIGINT NOT NULL,
    factor_conversion NUMERIC(18,6) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CONVERSION_UNIDAD PRIMARY KEY (id),
    CONSTRAINT FK_CONVERSION_UNIDAD_01 FOREIGN KEY (unidad_origen_id) REFERENCES core.unidad_medida(id),
    CONSTRAINT FK_CONVERSION_UNIDAD_02 FOREIGN KEY (unidad_destino_id) REFERENCES core.unidad_medida(id)
);

CREATE TABLE core.tipos_impuesto (
    id BIGSERIAL NOT NULL,
    tipo_impuesto VARCHAR(10) NOT NULL,
    plan_contable_det_id BIGINT,
    desc_impuesto VARCHAR(200) NOT NULL,
    tasa_impuesto NUMERIC(8,4) NOT NULL DEFAULT 0,
    signo VARCHAR(1) NOT NULL DEFAULT '+',
    flag_dh_cxp VARCHAR(1) NOT NULL DEFAULT 'D',
    flag_igv VARCHAR(1) NOT NULL DEFAULT '0',
    tipo_calculo INTEGER NOT NULL DEFAULT 1,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_TIPOS_IMPUESTO PRIMARY KEY (id),
    CONSTRAINT CK_TIPOS_IMPUESTO_TIPO_CALCULO CHECK (tipo_calculo IN (1, 2, 3))
);
CREATE UNIQUE INDEX IX_TIPOS_IMPUESTO_01 ON core.tipos_impuesto (tipo_impuesto);

COMMENT ON TABLE core.tipos_impuesto IS
    'Catálogo de tipos de impuesto tributarios. '
    'Columna tipo_calculo (INTEGER NOT NULL, default 1) define el modo de cálculo del importe. '
    'Tipos de cálculo permitidos: '
    'Código 1 — Tipo PORCENTAJE — Fórmula: importe = base × tasa / 100 — Ejemplo: IGV 18%, ISC 13%. '
    'Código 2 — Tipo MONTO_FIJO — Fórmula: importe = cantidad × tasa — Ejemplo: ICBPER (bolsa plástica S/0.10 × und). '
    'Código 3 — Tipo BASE_AFFECTING — Fórmula: modifica la base imponible antes de calcular IGV — Ejemplo: ILA 5% (Chile).';

COMMENT ON COLUMN core.tipos_impuesto.tipo_calculo IS
    'Modo de cálculo del importe (NOT NULL, default 1). Valores: '
    '1 PORCENTAJE — importe = base × tasa / 100 — ej. IGV 18%, ISC 13%. '
    '2 MONTO_FIJO — importe = cantidad × tasa — ej. ICBPER (bolsa plástica S/0.10 × und). '
    '3 BASE_AFFECTING — modifica la base antes de IGV — ej. ILA 5% (Chile).';

CREATE TABLE core.condicion_pago (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    dias INTEGER NOT NULL DEFAULT 0,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CONDICION_PAGO PRIMARY KEY (id)
);

CREATE TABLE core.forma_pago (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_FORMA_PAGO PRIMARY KEY (id)
);

CREATE TABLE core.motivo_nota (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_MOTIVO_NOTA PRIMARY KEY (id)
);

CREATE TABLE core.departamento (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    pais_id BIGINT,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_DEPARTAMENTO PRIMARY KEY (id),
    CONSTRAINT FK_DEPARTAMENTO_01 FOREIGN KEY (pais_id) REFERENCES core.pais(id)
);

CREATE TABLE core.provincia (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    departamento_id BIGINT,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_PROVINCIA PRIMARY KEY (id),
    CONSTRAINT FK_PROVINCIA_01 FOREIGN KEY (departamento_id) REFERENCES core.departamento(id)
);

CREATE TABLE core.distrito (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    provincia_id BIGINT,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_DISTRITO PRIMARY KEY (id),
    CONSTRAINT FK_DISTRITO_01 FOREIGN KEY (provincia_id) REFERENCES core.provincia(id)
);

ALTER TABLE auth.sucursal
    ALTER COLUMN moneda_defult_id SET DEFAULT core.fn_moneda_default_pen_id(),
    ALTER COLUMN moneda_defult_id SET NOT NULL,
    ADD CONSTRAINT FK_SUCURSAL_05 FOREIGN KEY (moneda_defult_id) REFERENCES core.moneda(id),
    ADD CONSTRAINT FK_SUCURSAL_01 FOREIGN KEY (pais_id) REFERENCES core.pais(id),
    ADD CONSTRAINT FK_SUCURSAL_02 FOREIGN KEY (departamento_id) REFERENCES core.departamento(id),
    ADD CONSTRAINT FK_SUCURSAL_03 FOREIGN KEY (provincia_id) REFERENCES core.provincia(id),
    ADD CONSTRAINT FK_SUCURSAL_04 FOREIGN KEY (distrito_id) REFERENCES core.distrito(id);

CREATE TABLE core.articulo_equivalencias (
    id BIGSERIAL NOT NULL,
    articulo_id BIGINT NOT NULL,
    articulo_equivalente_id BIGINT NOT NULL,
    factor NUMERIC(18,6) NOT NULL DEFAULT 1,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_ARTICULO_EQUIVALENCIAS PRIMARY KEY (id),
    CONSTRAINT FK_ARTICULO_EQUIVALENCIAS_01 FOREIGN KEY (articulo_id) REFERENCES core.articulo(id),
    CONSTRAINT FK_ARTICULO_EQUIVALENCIAS_02 FOREIGN KEY (articulo_equivalente_id) REFERENCES core.articulo(id)
);

CREATE TABLE core.articulo_impuesto (
    id BIGSERIAL PRIMARY KEY,
    articulo_id BIGINT NOT NULL REFERENCES core.articulo(id) ON DELETE CASCADE,
    tipos_impuesto_id BIGINT NOT NULL REFERENCES core.tipos_impuesto(id),
    orden SMALLINT NOT NULL DEFAULT 1,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT UQ_ARTICULO_IMPUESTO_01 UNIQUE (articulo_id, tipos_impuesto_id)
);

COMMENT ON TABLE core.articulo_impuesto IS
    'Impuestos aplicables por artículo (N:M). Equivale a SIGRE tipo_impuesto1/tipo_impuesto2 en líneas de movimiento.';
COMMENT ON COLUMN core.articulo_impuesto.orden IS
    'Orden de aplicación: 1=principal (tipo_impuesto1), 2=secundario (tipo_impuesto2).';

CREATE TABLE core.art_super_grupo (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_ART_SUPER_GRUPO PRIMARY KEY (id)
);

CREATE TABLE core.tipo_doc_identidad (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(10) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    tipo_doc VARCHAR(10),
    tipo_doc_afpnet VARCHAR(10) NOT NULL DEFAULT '0',
    flag_doc_bbva VARCHAR(1),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_TIPO_DOC_IDENTIDAD PRIMARY KEY (id)
);
CREATE UNIQUE INDEX IX_TIPO_DOC_IDENTIDAD_01 ON core.tipo_doc_identidad (codigo);

-- Tipo documento identidad (RUC/DNI, etc.): pertenece al contribuyente, no a documentos comerciales (OC, factura).
ALTER TABLE core.entidad_contribuyente
    ADD COLUMN tipo_doc_identidad_id BIGINT REFERENCES core.tipo_doc_identidad(id);

CREATE TABLE core.numerador (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(30) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    serie VARCHAR(10),
    ultimo_numero BIGINT NOT NULL DEFAULT 0,
    longitud INTEGER,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_NUMERADOR PRIMARY KEY (id)
);
CREATE UNIQUE INDEX IX_NUMERADOR_01 ON core.numerador (codigo);

-- Correlativo por documento. PK natural = (nombre_tabla, sucursalId, ano).
-- ult_nro = próximo número a emitir (inicia en 1).
-- fn_get_document_number bloquea SOLO la fila con SELECT FOR UPDATE para no bloquear otras numeraciones.
CREATE TABLE IF NOT EXISTS core.numerador_documento (
    nombre_tabla VARCHAR(128) NOT NULL,
    sucursalId BIGINT NOT NULL REFERENCES auth.sucursal(id),
    ano SMALLINT NOT NULL,
    ult_nro BIGINT NOT NULL DEFAULT 1 CHECK (ult_nro >= 1),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_NUMERADOR_DOCUMENTO PRIMARY KEY (nombre_tabla, sucursalId, ano)
);

COMMENT ON TABLE core.numerador_documento IS
    'Correlativo por tabla + sucursalId + año. ult_nro = próximo número a emitir.';

DROP FUNCTION IF EXISTS core.fn_get_document_number_incr(VARCHAR, VARCHAR, INTEGER);
DROP FUNCTION IF EXISTS core.fn_get_document_number_incr(VARCHAR, BIGINT, INTEGER);
DROP FUNCTION IF EXISTS core.fn_siguiente_nro_documento(VARCHAR, BIGINT, INTEGER);
DROP FUNCTION IF EXISTS core.fn_siguiente_nro_documento_compacto(VARCHAR, BIGINT, INTEGER);

-- Genera número de documento: XX + YYYY + 000001 (12 chars fijos).
-- Bloquea SOLO la fila (nombre_tabla, sucursalId, ano) con SELECT FOR UPDATE.
-- Validaciones:
--   * nombre_tabla: obligatorio, se almacena siempre en MAYÚSCULAS.
--   * p_sucursalId: debe existir en auth.sucursal y tener código asignado.
--   * p_ano: no mayor al año en curso; antigüedad máx. desde parámetro NUMERADOR_ANTIGUEDAD_ANIOS (default 5).
-- Flujo:
--   1. Busca fila por PK (nombre_tabla, sucursalId, ano) con FOR UPDATE (bloqueo de fila).
--   2. Si no existe: INSERT con ult_nro = 1, usa 1.
--   3. Lee ult_nro (número a usar), luego UPDATE ult_nro = ult_nro + 1.
-- REQUISITO: debe invocarse dentro de una transacción explícita (en Java: @Transactional).
CREATE OR REPLACE FUNCTION core.fn_get_document_number(
    p_nombre_tabla VARCHAR(128),
    p_sucursalId BIGINT,
    p_ano INTEGER
) RETURNS VARCHAR(12)
LANGUAGE plpgsql
VOLATILE
AS $$
DECLARE
    lint_nro          BIGINT;
    lint_ano_actual   INTEGER;
    lint_antiguedad   INTEGER;
    lvar_nt           VARCHAR(128);
    lvar_cod_suc      VARCHAR(2);
    lvar_suc2         VARCHAR(2);
    lvar_anio4        VARCHAR(4);
BEGIN
    -- 1. Validar parámetros de entrada
    IF p_nombre_tabla IS NULL OR LENGTH(TRIM(BOTH FROM p_nombre_tabla)) = 0 THEN
        RAISE EXCEPTION 'nombre_tabla es obligatorio';
    END IF;
    IF p_sucursalId IS NULL THEN
        RAISE EXCEPTION 'sucursal es obligatoria';
    END IF;
    IF p_ano IS NULL THEN
        RAISE EXCEPTION 'ano es obligatorio';
    END IF;

    lvar_nt := UPPER(TRIM(BOTH FROM p_nombre_tabla));

    -- 2. Validar que la sucursal exista y tenga código
    SELECT COALESCE(TRIM(s.codigo), '')
    INTO lvar_cod_suc
    FROM auth.sucursal s
    WHERE s.id = p_sucursalId;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'sucursalId % no existe en auth.sucursal', p_sucursalId;
    END IF;

    IF LENGTH(lvar_cod_suc) = 0 THEN
        RAISE EXCEPTION 'sucursalId % no tiene código asignado', p_sucursalId;
    END IF;

    -- 3. Validar año: no mayor al actual; antigüedad máx. desde core.configuracion
    lint_ano_actual := EXTRACT(YEAR FROM NOW())::INTEGER;

    IF p_ano > lint_ano_actual THEN
        RAISE EXCEPTION 'ano % supera el año en curso (%)', p_ano, lint_ano_actual;
    END IF;

    lint_antiguedad := core.fn_get_parameter_int('NUMERADOR_ANTIGUEDAD_ANIOS', 5);

    IF p_ano < (lint_ano_actual - lint_antiguedad) THEN
        RAISE EXCEPTION 'ano % excede la antigüedad máxima permitida (% años desde %)',
            p_ano, lint_antiguedad, lint_ano_actual;
    END IF;

    -- 4. Formar los 2 caracteres de sucursal
    lvar_suc2 := CASE WHEN LENGTH(lvar_cod_suc) >= 2 THEN LEFT(lvar_cod_suc, 2)
                      ELSE LPAD(lvar_cod_suc, 2, '0')
                 END;

    lvar_anio4 := LPAD(p_ano::TEXT, 4, '0');

    -- 5. Bloquear SOLO la fila (FOR UPDATE) y leer ult_nro
    SELECT nd.ult_nro
    INTO lint_nro
    FROM core.numerador_documento nd
    WHERE nd.nombre_tabla = lvar_nt
      AND nd.sucursalId = p_sucursalId
      AND nd.ano = p_ano::SMALLINT
    FOR UPDATE;

    IF NOT FOUND THEN
        INSERT INTO core.numerador_documento (nombre_tabla, sucursalId, ano, ult_nro, fec_creacion)
        VALUES (lvar_nt, p_sucursalId, p_ano::SMALLINT, 1, NOW());
        lint_nro := 1;
    END IF;

    -- 6. Validar que no supere 6 dígitos
    IF lint_nro > 999999 THEN
        RAISE EXCEPTION 'secuencial anual supera 6 dígitos para %.%/%', lvar_nt, p_sucursalId, p_ano;
    END IF;

    -- 7. Incrementar ult_nro para la siguiente llamada
    UPDATE core.numerador_documento
    SET ult_nro = lint_nro + 1,
        fec_modificacion = NOW()
    WHERE nombre_tabla = lvar_nt
      AND sucursalId = p_sucursalId
      AND ano = p_ano::SMALLINT;

    -- 8. Retornar número formateado: XX + YYYY + 000001
    RETURN lvar_suc2 || lvar_anio4 || LPAD(lint_nro::TEXT, 6, '0');
END;
$$;

COMMENT ON FUNCTION core.fn_get_document_number(VARCHAR, BIGINT, INTEGER) IS
    'Número [2 sucursal][4 año][6 sec]. Bloquea fila con FOR UPDATE. ult_nro = próximo a emitir. Requiere TX explícita.';

-- Siguiente número SUNAT por serie. Fuente: core.doc_tipo_num_serie.
-- Parámetros: doc_tipo_id, serie (ej. 'F001'), sucursal_id.
-- Formato: serie 4 + '-' + número 10 = 15 caracteres (XXXX-XXXXXXXXXX).
-- Bloquea la fila con SELECT FOR UPDATE. Requiere TX explícita.
CREATE OR REPLACE FUNCTION core.fn_get_number_sunat_documents(
    p_doc_tipo_id BIGINT,
    p_serie       VARCHAR(10),
    p_sucursal_id BIGINT
)
RETURNS TABLE (
    serie VARCHAR(4),
    numero VARCHAR(10),
    nro_documento VARCHAR(15)
)
LANGUAGE plpgsql
VOLATILE
AS $$
DECLARE
    lint_id        BIGINT;
    lvar_serie_raw VARCHAR(10);
    lint_ult       BIGINT;
    lint_sig       BIGINT;
    lvar_serie4    VARCHAR(4);
    lvar_num10     VARCHAR(10);
BEGIN
    IF p_doc_tipo_id IS NULL THEN
        RAISE EXCEPTION 'doc_tipo_id es obligatorio';
    END IF;
    IF p_serie IS NULL OR LENGTH(TRIM(p_serie)) = 0 THEN
        RAISE EXCEPTION 'serie es obligatoria';
    END IF;
    IF p_sucursal_id IS NULL THEN
        RAISE EXCEPTION 'sucursal_id es obligatorio';
    END IF;

    SELECT ns.id, ns.serie, ns.ultimo_numero
    INTO lint_id, lvar_serie_raw, lint_ult
    FROM core.doc_tipo_num_serie ns
    WHERE ns.sucursal_id = p_sucursal_id
      AND ns.doc_tipo_id = p_doc_tipo_id
      AND ns.serie = UPPER(TRIM(p_serie))
      AND ns.flag_estado = '1'
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION
            'no hay numeración en core.doc_tipo_num_serie para doc_tipo_id=%, serie=%, sucursal_id=%',
            p_doc_tipo_id, p_serie, p_sucursal_id;
    END IF;

    lint_sig := lint_ult + 1;
    IF lint_sig > 9999999999 THEN
        RAISE EXCEPTION 'secuencial supera 10 dígitos (doc_tipo_num_serie.id=%)', lint_id;
    END IF;

    UPDATE core.doc_tipo_num_serie
    SET ultimo_numero = lint_sig,
        fec_modificacion = NOW()
    WHERE id = lint_id;

    lvar_serie4 := UPPER(LEFT(RPAD(BTRIM(COALESCE(lvar_serie_raw, '')), 4, '0'), 4));
    lvar_num10 := LPAD(lint_sig::TEXT, 10, '0');

    RETURN QUERY SELECT lvar_serie4::VARCHAR(4), lvar_num10::VARCHAR(10),
        (lvar_serie4 || '-' || lvar_num10)::VARCHAR(15);
END;
$$;

COMMENT ON FUNCTION core.fn_get_number_sunat_documents(BIGINT, VARCHAR, BIGINT) IS
    'Siguiente serie/número desde doc_tipo_num_serie; retorna XXXX-XXXXXXXXXX (15). Requiere TX explícita.';

-- core.ejercicio_periodo = ejercicio/año fiscal (rangos/fechas por año).
-- Si buscas «core.periodo_contable» (tabla que NO existe): el cierre contable mensual está en contabilidad.cntbl_cierre (año/mes).

CREATE TABLE core.ejercicio_periodo (
    id BIGSERIAL NOT NULL,
    anio INTEGER NOT NULL,
    fecha_inicio DATE,
    fecha_fin DATE,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_EJERCICIO_PERIODO PRIMARY KEY (id)
);
COMMENT ON TABLE core.ejercicio_periodo IS
    'Ejercicio fiscal por año (fechas opcionales). No confundir con periodo mensual cerrado en contabilidad: ver contabilidad.cntbl_cierre. No existe core.periodo_contable.';

CREATE UNIQUE INDEX IX_EJERCICIO_PERIODO_01 ON core.ejercicio_periodo (anio);

CREATE TABLE core.parametro_sistema (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(50) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    modulo VARCHAR(30),
    valor VARCHAR(500),
    tipo_dato VARCHAR(20),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_PARAMETRO_SISTEMA PRIMARY KEY (id)
);
CREATE UNIQUE INDEX IX_PARAMETRO_SISTEMA_01 ON core.parametro_sistema (codigo);

CREATE TABLE core.naturaleza_contable (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    cuenta_contable VARCHAR(20),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_NATURALEZA_CONTABLE PRIMARY KEY (id)
);
CREATE UNIQUE INDEX IX_NATURALEZA_CONTABLE_01 ON core.naturaleza_contable (codigo);

CREATE TABLE core.detr_bien_serv (
    id BIGSERIAL NOT NULL,
    bien_serv CHAR(3) NOT NULL UNIQUE,
    descripcion VARCHAR(100),
    flag_estado VARCHAR(1) DEFAULT '1',
    cod_sunat_pdbe CHAR(2),
    tasa_pdbe NUMERIC(4,2) NOT NULL DEFAULT 0,
    flag_ind_imp CHAR(1),
    codigo_sunat CHAR(6),
    monto_min_depre NUMERIC(6,2) NOT NULL DEFAULT 0,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_DETR_BIEN_SERV PRIMARY KEY (id)
);
CREATE INDEX IX_DETR_BIEN_SERV_01 ON core.detr_bien_serv (flag_estado);
CREATE INDEX IX_DETR_BIEN_SERV_02 ON core.detr_bien_serv (codigo_sunat);

-- ============================================================
-- SECCIÓN 3: ÍNDICES
-- ============================================================

CREATE INDEX IX_COLOR_01 ON core.color (flag_estado);
CREATE INDEX IX_ARTICULO_01 ON core.articulo (nombre);
CREATE INDEX IX_ARTICULO_02 ON core.articulo (articulo_categ_id, flag_estado);
CREATE INDEX IX_ARTICULO_03 ON core.articulo (color_id);
CREATE INDEX IX_ENTIDAD_CONTRIBUYENTE_01 ON core.entidad_contribuyente (nro_documento);
CREATE INDEX IX_ENTIDAD_DIRECCION_01 ON core.entidad_direccion (entidad_contribuyente_id, es_principal);
CREATE INDEX IX_ENTIDAD_DIRECCION_02 ON core.entidad_direccion (ubigeo);
CREATE INDEX IX_ENTIDAD_DIRECCION_03 ON core.entidad_direccion (zona_venta);
CREATE INDEX IX_ENTIDAD_DIRECCION_04 ON core.entidad_direccion (zona_despacho);
CREATE INDEX IX_ENTIDAD_DIRECCION_05 ON core.entidad_direccion (cod_tienda);
CREATE INDEX IX_DOC_TIPO_USUARIO_01 ON core.doc_tipo_usuario (usuario_id, flag_estado);
CREATE INDEX IX_DOC_TIPO_NUM_01 ON core.doc_tipo_num (sucursal_id, doc_tipo_id, origen_id, anio, flag_estado);
CREATE INDEX IX_DOC_TIPO_NUM_SERIE_01 ON core.doc_tipo_num_serie (sucursal_id, doc_tipo_id, serie, flag_estado);
CREATE INDEX IX_CONFIGURACION_01 ON core.configuracion (parameter);
CREATE INDEX IX_CATALOGO_SUNAT_DET_01 ON core.catalogo_sunat_det (catalogo_sunat_id, flag_estado);
CREATE INDEX IX_SUNAT_CUBSO_01 ON core.sunat_cubso (cod_clase);
CREATE INDEX IX_SUNAT_CUBSO_02 ON core.sunat_cubso (flag_estado);
CREATE INDEX IX_PAIS_01 ON core.pais (moneda_id);
CREATE UNIQUE INDEX IX_CONVERSION_UNIDAD_01 ON core.conversion_unidad (unidad_origen_id, unidad_destino_id);
CREATE INDEX IX_CONDICION_PAGO_01 ON core.condicion_pago (flag_estado);
CREATE INDEX IX_FORMA_PAGO_01 ON core.forma_pago (tipo, flag_estado);
CREATE INDEX IX_MOTIVO_NOTA_01 ON core.motivo_nota (tipo);
CREATE INDEX IX_DEPARTAMENTO_01 ON core.departamento (pais_id);
CREATE INDEX IX_PROVINCIA_01 ON core.provincia (departamento_id);
CREATE INDEX IX_DISTRITO_01 ON core.distrito (provincia_id);
CREATE INDEX IX_SUCURSAL_01 ON auth.sucursal (pais_id);
CREATE INDEX IX_SUCURSAL_02 ON auth.sucursal (departamento_id);
CREATE INDEX IX_SUCURSAL_03 ON auth.sucursal (provincia_id);
CREATE INDEX IX_SUCURSAL_04 ON auth.sucursal (distrito_id);
CREATE INDEX IX_SUCURSAL_05 ON auth.sucursal (moneda_defult_id);
CREATE INDEX IX_ARTICULO_EQUIVALENCIAS_01 ON core.articulo_equivalencias (articulo_id);
CREATE INDEX IX_ARTICULO_EQUIVALENCIAS_02 ON core.articulo_equivalencias (articulo_equivalente_id);
CREATE INDEX IX_ARTICULO_IMPUESTO_01 ON core.articulo_impuesto (articulo_id);
CREATE INDEX IX_ARTICULO_IMPUESTO_02 ON core.articulo_impuesto (tipos_impuesto_id);
CREATE INDEX IX_ART_SUPER_GRUPO_01 ON core.art_super_grupo (flag_estado);

-- ============================================================
-- SECCIÓN 3B: TABLAS IDEMPOTENTES (CREATE TABLE IF NOT EXISTS)
-- ============================================================

-- Teléfonos de entidad contribuyente (adaptación de SIGRE.TELEFONOS)
CREATE TABLE IF NOT EXISTS core.entidad_contribuyente_telefono (
    id                          BIGSERIAL       NOT NULL,
    entidad_contribuyente_id    BIGINT          NOT NULL REFERENCES core.entidad_contribuyente(id),
    item                        SMALLINT        NOT NULL DEFAULT 1,
    descripcion                 VARCHAR(60),
    codigo_pais                 VARCHAR(5),
    codigo_ciudad               VARCHAR(5),
    numero                      VARCHAR(20)     NOT NULL,
    flag_fax                    VARCHAR(1)      NOT NULL DEFAULT '0',
    flag_estado                 VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by                  BIGINT,
    fec_creacion                TIMESTAMPTZ     DEFAULT NOW(),
    updated_by                  BIGINT,
    fec_modificacion            TIMESTAMPTZ,
    CONSTRAINT PK_ENTIDAD_CONTRIBUYENTE_TELEFONO PRIMARY KEY (id),
    CONSTRAINT UQ_ENTIDAD_TELEFONO_01 UNIQUE (entidad_contribuyente_id, item)
);

CREATE INDEX IF NOT EXISTS IX_ENTIDAD_TELEFONO_01 ON core.entidad_contribuyente_telefono (entidad_contribuyente_id);

COMMENT ON TABLE core.entidad_contribuyente_telefono IS
    'Teléfonos adicionales de proveedores/clientes. Adaptación de SIGRE.TELEFONOS.';

-- Representantes legales de entidad contribuyente (adaptación de SIGRE.REPRESENTANTE)
CREATE TABLE IF NOT EXISTS core.entidad_contribuyente_representante (
    id                          BIGSERIAL       NOT NULL,
    entidad_contribuyente_id    BIGINT          NOT NULL REFERENCES core.entidad_contribuyente(id),
    item                        SMALLINT        NOT NULL DEFAULT 1,
    nombre                      VARCHAR(150)    NOT NULL,
    cargo                       VARCHAR(120),
    telefono                    VARCHAR(20),
    email                       VARCHAR(200),
    flag_estado                 VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by                  BIGINT,
    fec_creacion                TIMESTAMPTZ     DEFAULT NOW(),
    updated_by                  BIGINT,
    fec_modificacion            TIMESTAMPTZ,
    CONSTRAINT PK_ENTIDAD_CONTRIBUYENTE_REPRESENTANTE PRIMARY KEY (id),
    CONSTRAINT UQ_ENTIDAD_REPRESENTANTE_01 UNIQUE (entidad_contribuyente_id, item)
);

CREATE INDEX IF NOT EXISTS IX_ENTIDAD_REPRESENTANTE_01 ON core.entidad_contribuyente_representante (entidad_contribuyente_id);

COMMENT ON TABLE core.entidad_contribuyente_representante IS
    'Representantes legales de proveedores/clientes. Adaptación de SIGRE.REPRESENTANTE.';

-- core.uit: PK id + UNIQUE (ano, fec_ini_vigen) — BD existentes con PK compuesta legacy
ALTER TABLE core.uit ADD COLUMN IF NOT EXISTS id BIGSERIAL;
ALTER TABLE core.uit DROP CONSTRAINT IF EXISTS PK_UIT;
DO $$ BEGIN IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conrelid = 'core.uit'::regclass AND contype = 'p'
) THEN ALTER TABLE core.uit ADD CONSTRAINT PK_UIT PRIMARY KEY (id);
END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_uit_ano_vigen')
    THEN ALTER TABLE core.uit ADD CONSTRAINT UQ_UIT_ANO_VIGEN UNIQUE (ano, fec_ini_vigen);
END IF; END $$;

-- core.doc_tipo: agregar flag_signo para BD existentes
ALTER TABLE core.doc_tipo ADD COLUMN IF NOT EXISTS flag_signo VARCHAR(1) NOT NULL DEFAULT '+';

-- core.articulo_impuesto: enlace artículo ↔ tipos_impuesto (BD existentes)
CREATE TABLE IF NOT EXISTS core.articulo_impuesto (
    id BIGSERIAL PRIMARY KEY,
    articulo_id BIGINT NOT NULL REFERENCES core.articulo(id) ON DELETE CASCADE,
    tipos_impuesto_id BIGINT NOT NULL REFERENCES core.tipos_impuesto(id),
    orden SMALLINT NOT NULL DEFAULT 1,
    created_by BIGINT,
    fec_creacion TIMESTAMPTZ DEFAULT NOW(),
    updated_by BIGINT,
    fec_modificacion TIMESTAMPTZ,
    CONSTRAINT UQ_ARTICULO_IMPUESTO_01 UNIQUE (articulo_id, tipos_impuesto_id)
);
ALTER TABLE core.articulo_impuesto DROP COLUMN IF EXISTS flag_estado;
DROP INDEX IF EXISTS core.IX_ARTICULO_IMPUESTO_01;
CREATE INDEX IF NOT EXISTS IX_ARTICULO_IMPUESTO_01 ON core.articulo_impuesto (articulo_id);
CREATE INDEX IF NOT EXISTS IX_ARTICULO_IMPUESTO_02 ON core.articulo_impuesto (tipos_impuesto_id);

COMMENT ON TABLE core.articulo_impuesto IS
    'Impuestos aplicables por artículo (N:M). Equivale a SIGRE tipo_impuesto1/tipo_impuesto2 en líneas de movimiento.';
COMMENT ON COLUMN core.articulo_impuesto.orden IS
    'Orden de aplicación: 1=principal (tipo_impuesto1), 2=secundario (tipo_impuesto2).';

-- core.tipos_impuesto: tipo de cálculo (BD existentes)
ALTER TABLE core.tipos_impuesto ADD COLUMN IF NOT EXISTS tipo_calculo INTEGER NOT NULL DEFAULT 1;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_tipos_impuesto_tipo_calculo') THEN
        ALTER TABLE core.tipos_impuesto
            ADD CONSTRAINT ck_tipos_impuesto_tipo_calculo CHECK (tipo_calculo IN (1, 2, 3));
    END IF;
END $$;
UPDATE core.tipos_impuesto SET tipo_calculo = 1 WHERE tipo_calculo IS NULL;
ALTER TABLE core.tipos_impuesto ALTER COLUMN tipo_calculo SET DEFAULT 1;
ALTER TABLE core.tipos_impuesto ALTER COLUMN tipo_calculo SET NOT NULL;
COMMENT ON TABLE core.tipos_impuesto IS
    'Catálogo de tipos de impuesto tributarios. '
    'Columna tipo_calculo (INTEGER NOT NULL, default 1) define el modo de cálculo del importe. '
    'Tipos de cálculo permitidos: '
    'Código 1 — Tipo PORCENTAJE — Fórmula: importe = base × tasa / 100 — Ejemplo: IGV 18%, ISC 13%. '
    'Código 2 — Tipo MONTO_FIJO — Fórmula: importe = cantidad × tasa — Ejemplo: ICBPER (bolsa plástica S/0.10 × und). '
    'Código 3 — Tipo BASE_AFFECTING — Fórmula: modifica la base imponible antes de calcular IGV — Ejemplo: ILA 5% (Chile).';

COMMENT ON COLUMN core.tipos_impuesto.tipo_calculo IS
    'Modo de cálculo del importe (NOT NULL, default 1). Valores: '
    '1 PORCENTAJE — importe = base × tasa / 100 — ej. IGV 18%, ISC 13%. '
    '2 MONTO_FIJO — importe = cantidad × tasa — ej. ICBPER (bolsa plástica S/0.10 × und). '
    '3 BASE_AFFECTING — modifica la base antes de IGV — ej. ILA 5% (Chile).';

-- core.detr_bien_serv: tasa_pdbe obligatoria (BD existentes)
UPDATE core.detr_bien_serv SET tasa_pdbe = 0 WHERE tasa_pdbe IS NULL;
ALTER TABLE core.detr_bien_serv ALTER COLUMN tasa_pdbe SET DEFAULT 0;
ALTER TABLE core.detr_bien_serv ALTER COLUMN tasa_pdbe SET NOT NULL;
COMMENT ON COLUMN core.detr_bien_serv.tasa_pdbe IS
    'Tasa de detracción PDBE (%). NOT NULL; 0 cuando no aplica detracción.';

-- Migración idempotente: tipo_doc_identidad alineado SIGRE (RRHH_TIPO_DOC_RTPS.json)
ALTER TABLE core.tipo_doc_identidad ADD COLUMN IF NOT EXISTS tipo_doc VARCHAR(10);
ALTER TABLE core.tipo_doc_identidad ADD COLUMN IF NOT EXISTS tipo_doc_afpnet VARCHAR(10) NOT NULL DEFAULT '0';
ALTER TABLE core.tipo_doc_identidad ADD COLUMN IF NOT EXISTS flag_doc_bbva VARCHAR(1);

-- ============================================================
-- SECCIÓN 4: DATOS INICIALES
-- ============================================================
-- (sin INSERT en core.empresa: la empresa vive en master.empresa)
