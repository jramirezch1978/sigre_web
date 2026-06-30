-- ============================================================
-- SIGRE ERP - Tenant DB - contabilidad schema
-- DROP de esquemas centralizado en 01-core.sql
-- ============================================================
--
-- PROHIBIDO eliminar flag_estado de cualquier tabla.
-- Todas las tablas del proyecto DEBEN tener flag_estado VARCHAR(1) NOT NULL DEFAULT '1'.
-- Las entidades JPA heredan de BaseEntity que mapea este campo.
-- ============================================================
--
-- DIAGRAMA DE RELACIONES (→ = tiene FK hacia):
--
--   plan_contable (sin dependencias): effective_from, flag_estado 0/1
--   plan_contable_det → plan_contable, plan_contable_det (auto-ref: padre_id); referenciado por finanzas.banco_cnta (FK en esta sección)
--   cencos_niv1 (sin dependencias)
--   cencos_niv2 → cencos_niv1
--   cencos_niv3 → cencos_niv2
--   centros_costo → cencos_niv3
--   cntbl_libro (sin dependencias)
--   cntbl_asiento → cntbl_libro, core.moneda, cntbl_preasiento
--   cntbl_asiento_det → cntbl_asiento, plan_contable_det, centros_costo, core.entidad_contribuyente, finanzas.banco_cnta
--   cntbl_preasiento → core.moneda, cntbl_libro, auth.sucursal
--   cntbl_preasiento_det → cntbl_preasiento, plan_contable_det, centros_costo
--   matriz_contable (sin dependencias)
--   matriz_contable_det → matriz_contable, plan_contable_det, centros_costo
--   tipo_mov_matriz_subcat → almacen.articulo_mov_tipo, core.articulo_sub_categ
--   cntbl_tipo_detraccion → plan_contable_det
--   cntbl_cierre (sin dependencias): «periodo contable» mensual; legado erroneo core.periodo_contable apunta aquí (no existe en core).
--   numerador_asiento → auth.sucursal, cntbl_libro (voucher correlativo)
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

CREATE SCHEMA IF NOT EXISTS contabilidad;

-- ============================================================
-- SECCIÓN 1: TABLAS Y CONSTRAINTS
-- ============================================================

CREATE TABLE IF NOT EXISTS contabilidad.grupo_contable (
    id              BIGSERIAL       NOT NULL,
    codigo          VARCHAR(10)     NOT NULL UNIQUE,
    nombre          VARCHAR(200)    NOT NULL,
    flag_estado VARCHAR(1)         NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_GRUPO_CONTABLE PRIMARY KEY (id)
);

CREATE TABLE contabilidad.plan_contable (
    id                  BIGSERIAL       NOT NULL,
    codigo              VARCHAR(20)     NOT NULL UNIQUE,
    nombre              VARCHAR(200)    NOT NULL,
    anio                INTEGER         NOT NULL,
    effective_from      DATE            NOT NULL,
    flag_estado         VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_PLAN_CONTABLE PRIMARY KEY (id),
    CONSTRAINT CK_PLAN_CONTABLE_FLAG_ESTADO CHECK (flag_estado IN ('0', '1'))
);

COMMENT ON TABLE contabilidad.plan_contable IS
    'Plan de cuentas vigente por tenant; effective_from=inicio vigencia; flag_estado 0=anulado 1=vigente.';
COMMENT ON COLUMN contabilidad.plan_contable.effective_from IS
    'Fecha desde la cual el plan de cuentas tiene vigencia (inicio ciclo aplicacion).';
COMMENT ON COLUMN contabilidad.plan_contable.flag_estado IS
    'Dominio obligatorio: 0=anulado, 1=vigente/activo.';

CREATE TABLE contabilidad.plan_contable_det (
    id                      BIGSERIAL       NOT NULL,
    plan_contable_id        BIGINT          NOT NULL,
    cnta_ctbl               VARCHAR(10)     NOT NULL,
    desc_cnta               VARCHAR(200)    NOT NULL,
    niv_cnta                INTEGER         NOT NULL DEFAULT 1,
    flag_cencos             VARCHAR(1)      NOT NULL DEFAULT '0',
    flag_cod_relacion       VARCHAR(1)      NOT NULL DEFAULT '0',
    flag_doc_ref            VARCHAR(1)      NOT NULL DEFAULT '0',
    flag_permite_mov        VARCHAR(1)      NOT NULL DEFAULT '0',
    flag_ctabco             VARCHAR(1)      NOT NULL DEFAULT '0',
    flag_tipo_saldo         VARCHAR(1)      NOT NULL DEFAULT 'D',
    cnta_cntbl_sunat        VARCHAR(10),
    flag_estado             VARCHAR(1)         NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_PLAN_CONTABLE_DET PRIMARY KEY (id),
    CONSTRAINT UQ_PLAN_CONTABLE_DET_01 UNIQUE (plan_contable_id, cnta_ctbl),
    CONSTRAINT FK_PLAN_CONTABLE_DET_01 FOREIGN KEY (plan_contable_id) REFERENCES contabilidad.plan_contable(id),
    CONSTRAINT CK_PLAN_CONTABLE_DET_SALDO CHECK (flag_tipo_saldo IN ('D', 'H', 'A'))
);

-- FK diferida: core.tipos_impuesto.plan_contable_det_id → contabilidad.plan_contable_det (cuenta por plan de cuentas)
ALTER TABLE core.tipos_impuesto
    ADD CONSTRAINT FK_TIPOS_IMPUESTO_PLAN_CONTABLE_DET
    FOREIGN KEY (plan_contable_det_id) REFERENCES contabilidad.plan_contable_det(id);

-- FK diferida: finanzas.banco_cnta (05-finanzas.sql) → plan contable detalle (cuenta del PCGE)
ALTER TABLE finanzas.banco_cnta
    ADD CONSTRAINT FK_BANCO_CNTA_PLAN_CONTABLE_DET
    FOREIGN KEY (plan_contable_det_id) REFERENCES contabilidad.plan_contable_det(id);

CREATE TABLE contabilidad.cencos_niv1 (
    id              BIGSERIAL       NOT NULL,
    cod_n1          VARCHAR(20)     NOT NULL UNIQUE,
    descripcion     VARCHAR(200)    NOT NULL,
    flag_estado VARCHAR(1)         NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_CENCOS_NIV1 PRIMARY KEY (id)
);

CREATE TABLE contabilidad.cencos_niv2 (
    id              BIGSERIAL       NOT NULL,
    cencos_niv1_id  BIGINT          NOT NULL,
    cod_n2          VARCHAR(20)     NOT NULL UNIQUE,
    descripcion     VARCHAR(200)    NOT NULL,
    flag_estado VARCHAR(1)         NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_CENCOS_NIV2 PRIMARY KEY (id),
    CONSTRAINT FK_CENCOS_NIV2_01 FOREIGN KEY (cencos_niv1_id) REFERENCES contabilidad.cencos_niv1(id)
);

CREATE TABLE contabilidad.cencos_niv3 (
    id              BIGSERIAL       NOT NULL,
    cencos_niv2_id  BIGINT          NOT NULL,
    cod_n3          VARCHAR(20)     NOT NULL UNIQUE,
    descripcion     VARCHAR(200)    NOT NULL,
    flag_estado VARCHAR(1)         NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_CENCOS_NIV3 PRIMARY KEY (id),
    CONSTRAINT FK_CENCOS_NIV3_01 FOREIGN KEY (cencos_niv2_id) REFERENCES contabilidad.cencos_niv2(id)
);

CREATE TABLE contabilidad.centros_costo (
    id              BIGSERIAL       NOT NULL,
    cencos_niv3_id  BIGINT,
    cencos          VARCHAR(30)     NOT NULL UNIQUE,
    desc_cencos     VARCHAR(200)    NOT NULL,
    flag_estado VARCHAR(1)         NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_CENTROS_COSTO PRIMARY KEY (id),
    CONSTRAINT FK_CENTROS_COSTO_01 FOREIGN KEY (cencos_niv3_id) REFERENCES contabilidad.cencos_niv3(id)
);

CREATE TABLE contabilidad.cntbl_libro (
    id              BIGSERIAL       NOT NULL,
    codigo          VARCHAR(20)     NOT NULL UNIQUE,
    nombre          VARCHAR(120)    NOT NULL,
    flag_estado VARCHAR(1)         NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_CNTBL_LIBRO PRIMARY KEY (id)
);

-- FK diferida cross-schema: cada tipo de almacén amarra un libro contable (asientos de almacén).
ALTER TABLE almacen.almacen_tipo
    ADD CONSTRAINT FK_ALMACEN_TIPO_CNTBL_LIBRO
    FOREIGN KEY (cntbl_libro_id) REFERENCES contabilidad.cntbl_libro(id);


CREATE TABLE contabilidad.cntbl_asiento (
    id                      BIGSERIAL       NOT NULL,
    voucher                 CHAR(16)        NOT NULL UNIQUE,
    libro_id                BIGINT          NOT NULL,
    fecha                   DATE            NOT NULL,
    glosa                   VARCHAR(3000)   NOT NULL,
    naturaleza_asiento      VARCHAR(1)      NOT NULL,
    modulo_origen           VARCHAR(1)      NOT NULL,
    cntbl_preasiento_id     BIGINT,
    moneda_id               BIGINT          NOT NULL,
    tasa_cambio             NUMERIC(18, 6)  NOT NULL    ,
    flag_estado             VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_CNTBL_ASIENTO PRIMARY KEY (id),
    CONSTRAINT FK_CNTBL_ASIENTO_01 FOREIGN KEY (libro_id) REFERENCES contabilidad.cntbl_libro(id),
    CONSTRAINT FK_CNTBL_ASIENTO_02 FOREIGN KEY (moneda_id) REFERENCES core.moneda(id),
    CONSTRAINT CK_CNTBL_ASIENTO_NATURALEZA CHECK (naturaleza_asiento IN ('1','2','3','4','5','6','7','8','A','B','C','D','E','F','G','H','I','M')),
    CONSTRAINT CK_CNTBL_ASIENTO_MODULO_ORIGEN CHECK (modulo_origen IN ('C', 'F', 'V', 'O', 'A', 'P'))
);

COMMENT ON COLUMN contabilidad.cntbl_asiento.naturaleza_asiento IS
    'Naturaleza del asiento VARCHAR(1): 1=CARTERA_PAGOS, 2=CARTERA_COBROS, 3=TRANSFERENCIA, 4=LIQUIDACION_GIRO, 5=APLICACION_DOCUMENTOS, 6=CANJE_DOCUMENTOS, 7=REGISTRO_CNTAS_PAGAR, 8=REGISTRO_CNTAS_COBRAR, A=AF_DEPRECIACION, B=AF_REVALUACION, C=AF_INDEXACION, D=AF_DEVENGO_SEGUROS, E=AF_VENTA, F=AF_ALTA_ACTIVO, G=AF_ADAPTACION, H=AF_BAJA_ACTIVO, I=AF_TRASLADO, M=MANUAL.';
COMMENT ON COLUMN contabilidad.cntbl_asiento.modulo_origen IS
    'Módulo de origen VARCHAR(1): C=Contabilidad, F=Finanzas, V=Ventas, O=Activos Fijos, A=Almacén, P=Compras.';

CREATE TABLE contabilidad.cntbl_asiento_det (
    id                          BIGSERIAL       NOT NULL,
    cntbl_asiento_id            BIGINT          NOT NULL,
    plan_contable_det_id        BIGINT          NOT NULL,
    centros_costo_id            BIGINT,
    entidad_contribuyente_id    BIGINT,
    glosa_detalle               VARCHAR(3000)   NOT NULL,
    doc_tipo_id                 BIGINT,
    nro_referencia              VARCHAR(12),
    cntas_pagar_id              BIGINT,
    cntas_cobrar_id             BIGINT,
    solicitud_giro_id           BIGINT,
    af_maestro_id               BIGINT,
    caja_bancos_id              BIGINT,
    liquidacion_id              BIGINT,
    flag_debe_haber             VARCHAR(1)      NOT NULL,
    importe_sol                 NUMERIC(18, 4)  DEFAULT 0,
    importe_dol                 NUMERIC(18, 4)  DEFAULT 0,
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_CNTBL_ASIENTO_DET PRIMARY KEY (id),
    CONSTRAINT FK_CNTBL_ASIENTO_DET_01 FOREIGN KEY (cntbl_asiento_id) REFERENCES contabilidad.cntbl_asiento(id),
    CONSTRAINT FK_CNTBL_ASIENTO_DET_02 FOREIGN KEY (plan_contable_det_id) REFERENCES contabilidad.plan_contable_det(id),
    CONSTRAINT FK_CNTBL_ASIENTO_DET_03 FOREIGN KEY (centros_costo_id) REFERENCES contabilidad.centros_costo(id),
    CONSTRAINT FK_CNTBL_ASIENTO_DET_04 FOREIGN KEY (entidad_contribuyente_id) REFERENCES core.entidad_contribuyente(id),
    CONSTRAINT FK_CNTBL_ASIENTO_DET_05 FOREIGN KEY (doc_tipo_id) REFERENCES core.doc_tipo(id),
    CONSTRAINT FK_CNTBL_ASIENTO_DET_06 FOREIGN KEY (cntas_pagar_id) REFERENCES finanzas.cntas_pagar(id),
    CONSTRAINT FK_CNTBL_ASIENTO_DET_07 FOREIGN KEY (cntas_cobrar_id) REFERENCES ventas.cntas_cobrar(id),
    CONSTRAINT FK_CNTBL_ASIENTO_DET_08 FOREIGN KEY (solicitud_giro_id) REFERENCES finanzas.solicitud_giro(id),
    CONSTRAINT FK_CNTBL_ASIENTO_DET_09 FOREIGN KEY (caja_bancos_id) REFERENCES finanzas.caja_bancos(id),
    CONSTRAINT FK_CNTBL_ASIENTO_DET_10 FOREIGN KEY (liquidacion_id) REFERENCES finanzas.liquidacion(id)
);

CREATE TABLE contabilidad.cntbl_preasiento (
    id                          BIGSERIAL       NOT NULL,
    voucher                     CHAR(16)        NOT NULL UNIQUE,
    libro_id                    BIGINT          NOT NULL,
    sucursal_id                 BIGINT          NOT NULL,
    modulo_origen               VARCHAR(1)     NOT NULL,
    naturaleza_asiento          VARCHAR(1)     NOT NULL,
    glosa                       VARCHAR(3000)   NOT NULL,
    fecha                       DATE            NOT NULL,
    moneda_id                   BIGINT          NOT NULL,
    tasa_cambio                 NUMERIC(18, 6)  NOT NULL,
    fecha_procesamiento         DATE,
    flag_estado                 VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_CNTBL_PREASIENTO PRIMARY KEY (id),
    CONSTRAINT FK_CNTBL_PREASIENTO_01 FOREIGN KEY (moneda_id) REFERENCES core.moneda(id),
    CONSTRAINT FK_CNTBL_PREASIENTO_03 FOREIGN KEY (libro_id) REFERENCES contabilidad.cntbl_libro(id),
    CONSTRAINT FK_CNTBL_PREASIENTO_04 FOREIGN KEY (sucursal_id) REFERENCES auth.sucursal(id)
);

-- FK diferida: cntbl_asiento.cntbl_preasiento_id → cntbl_preasiento (creada después)
ALTER TABLE contabilidad.cntbl_asiento
    ADD CONSTRAINT FK_CNTBL_ASIENTO_03 FOREIGN KEY (cntbl_preasiento_id) REFERENCES contabilidad.cntbl_preasiento(id);

CREATE TABLE contabilidad.cntbl_preasiento_det (
    id                          BIGSERIAL       NOT NULL,
    cntbl_preasiento_id         BIGINT          NOT NULL,
    secuencia                   INTEGER         NOT NULL,
    glosa                       VARCHAR(3000),
    plan_contable_det_id        BIGINT,
    centros_costo_id            BIGINT,
    entidad_contribuyente_id    BIGINT,
    doc_tipo_id                 BIGINT,
    nro_referencia              VARCHAR(12),
    cntas_pagar_id              BIGINT,
    cntas_cobrar_id             BIGINT,
    solicitud_giro_id           BIGINT,
    af_maestro_id               BIGINT,
    caja_bancos_id              BIGINT,
    liquidacion_id              BIGINT,
    flag_debe_haber             VARCHAR(1)      NOT NULL,
    importe_sol                 NUMERIC(18, 4)  DEFAULT 0,
    importe_dol                 NUMERIC(18, 4)  DEFAULT 0,
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_CNTBL_PREASIENTO_DET PRIMARY KEY (id),
    CONSTRAINT FK_CNTBL_PREASIENTO_DET_01 FOREIGN KEY (cntbl_preasiento_id) REFERENCES contabilidad.cntbl_preasiento(id),
    CONSTRAINT FK_CNTBL_PREASIENTO_DET_02 FOREIGN KEY (plan_contable_det_id) REFERENCES contabilidad.plan_contable_det(id),
    CONSTRAINT FK_CNTBL_PREASIENTO_DET_03 FOREIGN KEY (centros_costo_id) REFERENCES contabilidad.centros_costo(id),
    CONSTRAINT FK_CNTBL_PREASIENTO_DET_04 FOREIGN KEY (entidad_contribuyente_id) REFERENCES core.entidad_contribuyente(id),
    CONSTRAINT FK_CNTBL_PREASIENTO_DET_05 FOREIGN KEY (doc_tipo_id) REFERENCES core.doc_tipo(id),
    CONSTRAINT FK_CNTBL_PREASIENTO_DET_06 FOREIGN KEY (cntas_pagar_id) REFERENCES finanzas.cntas_pagar(id),
    CONSTRAINT FK_CNTBL_PREASIENTO_DET_07 FOREIGN KEY (cntas_cobrar_id) REFERENCES ventas.cntas_cobrar(id),
    CONSTRAINT FK_CNTBL_PREASIENTO_DET_08 FOREIGN KEY (solicitud_giro_id) REFERENCES finanzas.solicitud_giro(id),
    CONSTRAINT FK_CNTBL_PREASIENTO_DET_09 FOREIGN KEY (caja_bancos_id) REFERENCES finanzas.caja_bancos(id),
    CONSTRAINT FK_CNTBL_PREASIENTO_DET_10 FOREIGN KEY (liquidacion_id) REFERENCES finanzas.liquidacion(id)
);


-- Agrupación de matrices contables (LC, LP, NI, VS, CP, etc.)
CREATE TABLE contabilidad.grupo_matriz_cntbl (
    id              BIGSERIAL       NOT NULL,
    codigo          VARCHAR(6)      NOT NULL UNIQUE,
    nombre          VARCHAR(120)    NOT NULL,
    flag_estado     VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_GRUPO_MATRIZ_CNTBL PRIMARY KEY (id)
);

CREATE TABLE contabilidad.matriz_contable (
    id              BIGSERIAL       NOT NULL,
    grupo_matriz_cntbl_id BIGINT    NOT NULL,
    codigo          VARCHAR(10)     NOT NULL UNIQUE,
    descripcion     VARCHAR(3000),
    flag_estado     VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_MATRIZ_CONTABLE PRIMARY KEY (id),
    CONSTRAINT FK_MATRIZ_CONTABLE_01 FOREIGN KEY (grupo_matriz_cntbl_id) REFERENCES contabilidad.grupo_matriz_cntbl(id)
);

CREATE TABLE contabilidad.matriz_contable_det (
    id                  BIGSERIAL       NOT NULL,
    matriz_contable_id  BIGINT          NOT NULL,
    secuencia           INTEGER         NOT NULL,
    plan_contable_det_id BIGINT,
    flag_deb_hab        VARCHAR(1)     NOT NULL,
    referencia_campo    VARCHAR(60),
    campo               VARCHAR(30),
    formula             VARCHAR(500),
    glosa_texto         VARCHAR(500),
    glosa_campo         VARCHAR(500),
    flag_cencos         VARCHAR(1),
    flag_ctabco         VARCHAR(1),
    flag_docref         VARCHAR(1),
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_MATRIZ_CONTABLE_DET PRIMARY KEY (id),
    CONSTRAINT UQ_MATRIZ_CONTABLE_DET_SEQ UNIQUE (matriz_contable_id, secuencia),
    CONSTRAINT FK_MATRIZ_CONTABLE_DET_01 FOREIGN KEY (matriz_contable_id) REFERENCES contabilidad.matriz_contable(id),
    CONSTRAINT FK_MATRIZ_CONTABLE_DET_02 FOREIGN KEY (plan_contable_det_id) REFERENCES contabilidad.plan_contable_det(id),
    CONSTRAINT CK_MATRIZ_CONTABLE_DET_DH CHECK (flag_deb_hab IN ('D', 'H'))
);


-- Matriz contable por tipo de movimiento y subcategoría.
-- Replica la lógica legacy de AL302 / f_asigna_matriz_subcat:
--   - Si el tipo NO afecta presupuesto, la búsqueda efectiva usa tipo_mov + cod_sub_cat
--     y grp_cntbl = '20' como valor por defecto.
--   - Si el tipo SI afecta presupuesto, la búsqueda usa tipo_mov + grp_cntbl + cod_sub_cat.
CREATE TABLE contabilidad.tipo_mov_matriz_subcat (
    tipo_mov                VARCHAR(10) NOT NULL,
    grp_cntbl               VARCHAR(2) NOT NULL DEFAULT '20',
    cod_sub_cat             VARCHAR(10) NOT NULL,
    item                    NUMERIC(4,0) NOT NULL DEFAULT 1,
    matriz_contable_id      BIGINT NOT NULL REFERENCES contabilidad.matriz_contable(id),
    created_by              BIGINT,
    fec_creacion            TIMESTAMP DEFAULT NOW(),
    updated_by              BIGINT,
    fec_modificacion        TIMESTAMP,
    CONSTRAINT PK_TIPO_MOV_MATRIZ_SUBCAT PRIMARY KEY (tipo_mov, grp_cntbl, cod_sub_cat, item),
    CONSTRAINT FK_TIPO_MOV_MATRIZ_SUBCAT_01 FOREIGN KEY (tipo_mov) REFERENCES almacen.articulo_mov_tipo(tipo_mov),
    CONSTRAINT FK_TIPO_MOV_MATRIZ_SUBCAT_02 FOREIGN KEY (cod_sub_cat) REFERENCES core.articulo_sub_categ(cod_sub_cat)
);

CREATE TABLE contabilidad.cntbl_tipo_detraccion (
    id              BIGSERIAL       NOT NULL,
    codigo          VARCHAR(20)     NOT NULL UNIQUE,
    descripcion     VARCHAR(200)    NOT NULL,
    porcentaje      NUMERIC(8, 4)   NOT NULL,
    plan_contable_det_id BIGINT,
    vigencia_desde  DATE,
    vigencia_hasta  DATE,
    flag_estado VARCHAR(1)         NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_CNTBL_TIPO_DETRACCION PRIMARY KEY (id),
    CONSTRAINT FK_CNTBL_TIPO_DETRACCION_01 FOREIGN KEY (plan_contable_det_id) REFERENCES contabilidad.plan_contable_det(id)
);

-- -----------------------------------------------------------------------------
-- Periodo contable (cierre por año/mes): NO existe la tabla core.periodo_contable
-- en este proyecto (nombre legado / documentación antigua equivocada). El estado
-- de cierre por periodo mensual se modela aquí en contabilidad.cntbl_cierre (PK año+mes).
-- Para ubicar desde búsquedas: «periodo contable», «cierre mensual», legado SIGRE período.
-- -----------------------------------------------------------------------------
CREATE TABLE contabilidad.cntbl_cierre (
    ano                 INTEGER         NOT NULL,
    mes                 INTEGER         NOT NULL,
    flag_reg_cntbl      VARCHAR(1)      DEFAULT '1',
    flag_mov_banco      VARCHAR(1)      DEFAULT '1',
    flag_cierre_mes     VARCHAR(1)      DEFAULT '1',
    flag_gen_asnt_autom VARCHAR(1)      DEFAULT '0',
    pd_campo            VARCHAR(1)      DEFAULT '1',
    pd_dma              VARCHAR(1)      DEFAULT '1',
    pd_mtto_fab         VARCHAR(1)      DEFAULT '1',
    pd_mtto_maq         VARCHAR(1)      DEFAULT '1',
    flag_almacen        VARCHAR(1)      DEFAULT '0',
    flag_oper_ot        VARCHAR(1)      DEFAULT '0',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_CNTBL_CIERRE PRIMARY KEY (ano, mes)
);

COMMENT ON TABLE contabilidad.cntbl_cierre IS
    'Cierre por periodo contable (año, mes): flags por módulo. No existe core.periodo_contable; ese nombre equivale a esta tabla en el DDL actual del ERP.';

CREATE TABLE contabilidad.distribucion_contable (
    id                          BIGSERIAL       NOT NULL,
    cntbl_cnta_origen_id        BIGINT,
    centros_costo_origen_id     BIGINT,
    cntbl_cnta_destino_id       BIGINT,
    centros_costo_destino_id    BIGINT,
    porcentaje                  NUMERIC(8, 4),
    flag_estado                 VARCHAR(1)      NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_DISTRIBUCION_CONTABLE PRIMARY KEY (id),
    CONSTRAINT FK_DISTRIBUCION_CONTABLE_01 FOREIGN KEY (centros_costo_origen_id) REFERENCES contabilidad.centros_costo(id),
    CONSTRAINT FK_DISTRIBUCION_CONTABLE_02 FOREIGN KEY (centros_costo_destino_id) REFERENCES contabilidad.centros_costo(id),
    CONSTRAINT FK_DISTRIBUCION_CONTABLE_03 FOREIGN KEY (cntbl_cnta_origen_id) REFERENCES contabilidad.plan_contable_det(id),
    CONSTRAINT FK_DISTRIBUCION_CONTABLE_04 FOREIGN KEY (cntbl_cnta_destino_id) REFERENCES contabilidad.plan_contable_det(id)
);


-- Correlativo de voucher por sucursal + año + mes + libro.
-- ult_nro = próximo número a emitir (inicia en 1).
-- fn_get_voucher_number bloquea la fila con SELECT FOR UPDATE.
CREATE TABLE IF NOT EXISTS contabilidad.numerador_asiento (
    sucursal_id     BIGINT      NOT NULL REFERENCES auth.sucursal(id),
    anio            SMALLINT    NOT NULL,
    mes             SMALLINT    NOT NULL CHECK (mes BETWEEN 1 AND 12),
    cntbl_libro_id  BIGINT      NOT NULL REFERENCES contabilidad.cntbl_libro(id),
    ult_nro         BIGINT      NOT NULL DEFAULT 1 CHECK (ult_nro >= 1),
    created_by      BIGINT,
    fec_creacion    TIMESTAMP DEFAULT NOW(),
    updated_by      BIGINT,
    fec_modificacion TIMESTAMP,
    CONSTRAINT PK_NUMERADOR_ASIENTO PRIMARY KEY (sucursal_id, anio, mes, cntbl_libro_id)
);

COMMENT ON TABLE contabilidad.numerador_asiento IS
    'Correlativo de voucher: PK (sucursal, año, mes, libro). ult_nro = próximo a emitir. Ver fn_get_voucher_number.';

-- Genera voucher CHAR(16): SS + YYYY + MM + LL + 000001
-- SS   = 2 chars del código de sucursal (desde auth.sucursal.codigo)
-- YYYY = año (parámetro)
-- MM   = mes (parámetro, 01-12)
-- LL   = código del libro contable en 2 dígitos (desde contabilidad.cntbl_libro.codigo)
-- 6 dígitos secuenciales con ceros a la izquierda.
-- Bloquea fila con SELECT FOR UPDATE. Requiere transacción explícita.
CREATE OR REPLACE FUNCTION contabilidad.fn_get_voucher_number(
    p_sucursal_id    BIGINT,
    p_anio           INTEGER,
    p_mes            INTEGER,
    p_cntbl_libro_id BIGINT
) RETURNS CHAR(16)
LANGUAGE plpgsql
VOLATILE
AS $$
DECLARE
    lint_nro        BIGINT;
    lvar_cod_suc    VARCHAR(2);
    lvar_suc2       CHAR(2);
    lvar_anio4      CHAR(4);
    lvar_mes2       CHAR(2);
    lvar_cod_libro  VARCHAR(20);
    lvar_libro2     CHAR(2);
BEGIN
    -- 1. Validar parámetros
    IF p_sucursal_id IS NULL THEN
        RAISE EXCEPTION 'sucursal_id es obligatorio';
    END IF;
    IF p_anio IS NULL THEN
        RAISE EXCEPTION 'anio es obligatorio';
    END IF;
    IF p_mes IS NULL OR p_mes < 1 OR p_mes > 12 THEN
        RAISE EXCEPTION 'mes debe estar entre 1 y 12';
    END IF;
    IF p_cntbl_libro_id IS NULL THEN
        RAISE EXCEPTION 'cntbl_libro_id es obligatorio';
    END IF;

    -- 2. Obtener código de sucursal (2 chars)
    SELECT COALESCE(TRIM(s.codigo), '')
    INTO lvar_cod_suc
    FROM auth.sucursal s
    WHERE s.id = p_sucursal_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'sucursal_id % no existe en auth.sucursal', p_sucursal_id;
    END IF;
    IF LENGTH(lvar_cod_suc) = 0 THEN
        RAISE EXCEPTION 'sucursal_id % no tiene código asignado', p_sucursal_id;
    END IF;

    lvar_suc2 := CASE WHEN LENGTH(lvar_cod_suc) >= 2 THEN LEFT(lvar_cod_suc, 2)
                      ELSE LPAD(lvar_cod_suc, 2, '0')
                 END;

    -- 3. Obtener código del libro contable (2 chars)
    SELECT COALESCE(TRIM(l.codigo), '')
    INTO lvar_cod_libro
    FROM contabilidad.cntbl_libro l
    WHERE l.id = p_cntbl_libro_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'cntbl_libro_id % no existe en contabilidad.cntbl_libro', p_cntbl_libro_id;
    END IF;

    lvar_libro2 := CASE WHEN LENGTH(lvar_cod_libro) >= 2 THEN LEFT(lvar_cod_libro, 2)
                        ELSE LPAD(lvar_cod_libro, 2, '0')
                   END;

    -- 4. Formatear año y mes
    lvar_anio4 := LPAD(p_anio::TEXT, 4, '0');
    lvar_mes2  := LPAD(p_mes::TEXT, 2, '0');

    -- 5. Bloquear fila del numerador (FOR UPDATE)
    SELECT na.ult_nro
    INTO lint_nro
    FROM contabilidad.numerador_asiento na
    WHERE na.sucursal_id = p_sucursal_id
      AND na.anio = p_anio::SMALLINT
      AND na.mes = p_mes::SMALLINT
      AND na.cntbl_libro_id = p_cntbl_libro_id
    FOR UPDATE;

    IF NOT FOUND THEN
        INSERT INTO contabilidad.numerador_asiento
            (sucursal_id, anio, mes, cntbl_libro_id, ult_nro, fec_creacion)
        VALUES
            (p_sucursal_id, p_anio::SMALLINT, p_mes::SMALLINT, p_cntbl_libro_id, 1, NOW());
        lint_nro := 1;
    END IF;

    -- 6. Validar que no supere 6 dígitos
    IF lint_nro > 999999 THEN
        RAISE EXCEPTION 'secuencial de voucher supera 6 dígitos para suc=%, año=%, mes=%, libro=%',
            p_sucursal_id, p_anio, p_mes, p_cntbl_libro_id;
    END IF;

    -- 7. Incrementar para la siguiente llamada
    UPDATE contabilidad.numerador_asiento
    SET ult_nro = lint_nro + 1,
        fec_modificacion = NOW()
    WHERE sucursal_id = p_sucursal_id
      AND anio = p_anio::SMALLINT
      AND mes = p_mes::SMALLINT
      AND cntbl_libro_id = p_cntbl_libro_id;

    -- 8. Retornar SSYYYYMMLL000001 (16 chars)
    RETURN lvar_suc2 || lvar_anio4 || lvar_mes2 || lvar_libro2 || LPAD(lint_nro::TEXT, 6, '0');
END;
$$;

COMMENT ON FUNCTION contabilidad.fn_get_voucher_number(BIGINT, INTEGER, INTEGER, BIGINT) IS
    'Voucher CHAR(16): SS(sucursal) + YYYY(año) + MM(mes) + LL(libro) + 000001(seq). FOR UPDATE. Requiere TX explícita.';

-- ============================================================
-- SECCIÓN 3: ÍNDICES
-- ============================================================

CREATE INDEX IX_DISTRIBUCION_CONTABLE_01  ON contabilidad.distribucion_contable (centros_costo_origen_id);
CREATE INDEX IX_DISTRIBUCION_CONTABLE_02  ON contabilidad.distribucion_contable (centros_costo_destino_id);
CREATE INDEX IX_DISTRIBUCION_CONTABLE_03  ON contabilidad.distribucion_contable (cntbl_cnta_origen_id);
CREATE INDEX IX_DISTRIBUCION_CONTABLE_04  ON contabilidad.distribucion_contable (cntbl_cnta_destino_id);
CREATE INDEX IX_PLAN_CONTABLE_01          ON contabilidad.plan_contable (anio);
CREATE INDEX IX_PLAN_CONTABLE_02          ON contabilidad.plan_contable (effective_from);
CREATE INDEX IX_PLAN_CONTABLE_DET_01      ON contabilidad.plan_contable_det (plan_contable_id);
CREATE INDEX IX_CENCOS_NIV2_01            ON contabilidad.cencos_niv2 (cencos_niv1_id);
CREATE INDEX IX_CENCOS_NIV3_01            ON contabilidad.cencos_niv3 (cencos_niv2_id);
CREATE INDEX IX_CENTROS_COSTO_01          ON contabilidad.centros_costo (cencos_niv3_id);
CREATE INDEX IX_CNTBL_ASIENTO_01          ON contabilidad.cntbl_asiento (libro_id, fecha);
CREATE INDEX IX_CNTBL_ASIENTO_02          ON contabilidad.cntbl_asiento (fecha);
CREATE INDEX IX_CNTBL_ASIENTO_03          ON contabilidad.cntbl_asiento (modulo_origen);
CREATE INDEX IX_CNTBL_ASIENTO_04          ON contabilidad.cntbl_asiento (cntbl_preasiento_id);
CREATE INDEX IX_CNTBL_ASIENTO_DET_01      ON contabilidad.cntbl_asiento_det (cntbl_asiento_id);
CREATE INDEX IX_CNTBL_ASIENTO_DET_02      ON contabilidad.cntbl_asiento_det (plan_contable_det_id);
CREATE INDEX IX_CNTBL_ASIENTO_DET_03      ON contabilidad.cntbl_asiento_det (centros_costo_id);
CREATE INDEX IX_CNTBL_ASIENTO_DET_04      ON contabilidad.cntbl_asiento_det (entidad_contribuyente_id);
CREATE INDEX IX_CNTBL_PREASIENTO_01       ON contabilidad.cntbl_preasiento (modulo_origen);
CREATE INDEX IX_CNTBL_PREASIENTO_02       ON contabilidad.cntbl_preasiento (fecha);
CREATE INDEX IX_CNTBL_PREASIENTO_03       ON contabilidad.cntbl_preasiento (naturaleza_asiento);
CREATE INDEX IX_CNTBL_PREASIENTO_DET_01   ON contabilidad.cntbl_preasiento_det (cntbl_preasiento_id);
CREATE INDEX IX_CNTBL_PREASIENTO_DET_02   ON contabilidad.cntbl_preasiento_det (plan_contable_det_id);
CREATE INDEX IX_MATRIZ_CONTABLE_01        ON contabilidad.matriz_contable (grupo_matriz_cntbl_id);
CREATE INDEX IX_MATRIZ_CONTABLE_DET_01    ON contabilidad.matriz_contable_det (matriz_contable_id);
CREATE INDEX IX_MATRIZ_CONTABLE_DET_02    ON contabilidad.matriz_contable_det (plan_contable_det_id);
CREATE INDEX IX_TIPO_MOV_MATRIZ_SUBCAT_01 ON contabilidad.tipo_mov_matriz_subcat (tipo_mov, cod_sub_cat);
CREATE INDEX IX_TIPO_MOV_MATRIZ_SUBCAT_02 ON contabilidad.tipo_mov_matriz_subcat (tipo_mov, grp_cntbl, cod_sub_cat);
CREATE INDEX IX_CNTBL_TIPO_DETRACCION_01  ON contabilidad.cntbl_tipo_detraccion (plan_contable_det_id);
CREATE INDEX IX_CNTBL_CIERRE_01           ON contabilidad.cntbl_cierre (ano, mes);
CREATE INDEX IX_CNTBL_CIERRE_02           ON contabilidad.cntbl_cierre (flag_cierre_mes);
CREATE INDEX IX_NUMERADOR_ASIENTO_01      ON contabilidad.numerador_asiento (sucursal_id, anio, mes);

-- FKs diferidas: esquemas anteriores referencian contabilidad.centros_costo
ALTER TABLE almacen.vale_mov_det
    ADD CONSTRAINT FK_VALE_MOV_DET_CENCOS FOREIGN KEY (centros_costo_id) REFERENCES contabilidad.centros_costo(id);

ALTER TABLE almacen.vale_mov_det
    ADD CONSTRAINT FK_VALE_MOV_DET_MATRIZ FOREIGN KEY (matriz_contable_id) REFERENCES contabilidad.matriz_contable(id);

ALTER TABLE compras.orden_compra_det
    ADD CONSTRAINT FK_OC_DET_CENCOS FOREIGN KEY (centros_costo_id) REFERENCES contabilidad.centros_costo(id);

ALTER TABLE compras.orden_servicio_det
    ADD CONSTRAINT FK_OS_DET_CENCOS FOREIGN KEY (centros_costo_id) REFERENCES contabilidad.centros_costo(id);

ALTER TABLE finanzas.liquidacion_det
    ADD CONSTRAINT FK_LIQ_DET_CENCOS FOREIGN KEY (centros_costo_id) REFERENCES contabilidad.centros_costo(id);

ALTER TABLE finanzas.caja_bancos_det
    ADD CONSTRAINT FK_CAJA_BANCOS_DET_CENCOS FOREIGN KEY (centros_costo_id) REFERENCES contabilidad.centros_costo(id);

ALTER TABLE finanzas.autorizador_giro
    ADD CONSTRAINT FK_AUT_GIRO_CENCOS FOREIGN KEY (centros_costo_id) REFERENCES contabilidad.centros_costo(id);

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cpd_centros_costo')
    THEN ALTER TABLE finanzas.cntas_pagar_det ADD CONSTRAINT fk_cpd_centros_costo FOREIGN KEY (centros_costo_id) REFERENCES contabilidad.centros_costo(id); END IF; END $$;

-- Backfill cntbl_libro_id en CxP/CxC (contabilidad.cntbl_libro ya existe en este script)
UPDATE finanzas.cntas_pagar cp
   SET cntbl_libro_id = cl.id
  FROM contabilidad.cntbl_libro cl
 WHERE cp.cntbl_libro_id IS NULL
   AND cl.codigo = '3';
UPDATE ventas.cntas_cobrar cc
   SET cntbl_libro_id = cl.id
  FROM contabilidad.cntbl_libro cl
 WHERE cc.cntbl_libro_id IS NULL
   AND cl.codigo = '4';
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM finanzas.cntas_pagar WHERE cntbl_libro_id IS NULL) THEN
        ALTER TABLE finanzas.cntas_pagar ALTER COLUMN cntbl_libro_id SET NOT NULL;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM ventas.cntas_cobrar WHERE cntbl_libro_id IS NULL) THEN
        ALTER TABLE ventas.cntas_cobrar ALTER COLUMN cntbl_libro_id SET NOT NULL;
    END IF;
END $$;

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cntas_pagar_cntbl_libro')
    THEN ALTER TABLE finanzas.cntas_pagar ADD CONSTRAINT fk_cntas_pagar_cntbl_libro FOREIGN KEY (cntbl_libro_id) REFERENCES contabilidad.cntbl_libro(id); END IF; END $$;

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cntas_cobrar_cntbl_libro')
    THEN ALTER TABLE ventas.cntas_cobrar ADD CONSTRAINT fk_cntas_cobrar_cntbl_libro FOREIGN KEY (cntbl_libro_id) REFERENCES contabilidad.cntbl_libro(id); END IF; END $$;

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cntas_pagar_cntbl_asiento')
    THEN ALTER TABLE finanzas.cntas_pagar ADD CONSTRAINT fk_cntas_pagar_cntbl_asiento FOREIGN KEY (cntbl_asiento_id) REFERENCES contabilidad.cntbl_asiento(id); END IF; END $$;

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_solicitud_giro_cencos')
    THEN ALTER TABLE finanzas.solicitud_giro ADD CONSTRAINT fk_solicitud_giro_cencos FOREIGN KEY (centros_costo_id) REFERENCES contabilidad.centros_costo(id); END IF; END $$;

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_compra_fondo_cencos')
    THEN ALTER TABLE compras.compra_fondo ADD CONSTRAINT fk_compra_fondo_cencos FOREIGN KEY (centros_costo_id) REFERENCES contabilidad.centros_costo(id); END IF; END $$;

-- FK diferida: finanzas.concepto_financiero.matriz_contable_id → contabilidad.matriz_contable
ALTER TABLE finanzas.concepto_financiero
    ADD CONSTRAINT FK_CONCEPTO_FINANCIERO_MATRIZ FOREIGN KEY (matriz_contable_id) REFERENCES contabilidad.matriz_contable(id);

CREATE INDEX IX_CONCEPTO_FINANCIERO_01 ON finanzas.concepto_financiero (matriz_contable_id);

-- FK diferida: compras.entidad_detraccion.cntbl_tipo_detraccion_id → contabilidad.cntbl_tipo_detraccion
ALTER TABLE compras.entidad_detraccion
    ADD CONSTRAINT FK_ENTIDAD_DETRACCION_TIPO FOREIGN KEY (cntbl_tipo_detraccion_id) REFERENCES contabilidad.cntbl_tipo_detraccion(id);

-- cntbl_asiento_det: cuenta bancaria asociada al movimiento contable (legacy cod_ctabco)
ALTER TABLE contabilidad.cntbl_asiento_det ADD COLUMN IF NOT EXISTS banco_cnta_id BIGINT;

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_cntbl_asiento_det_banco_cnta')
    THEN ALTER TABLE contabilidad.cntbl_asiento_det ADD CONSTRAINT fk_cntbl_asiento_det_banco_cnta FOREIGN KEY (banco_cnta_id) REFERENCES finanzas.banco_cnta(id); END IF; END $$;

CREATE INDEX IF NOT EXISTS IX_CNTBL_ASIENTO_DET_05 ON contabilidad.cntbl_asiento_det (banco_cnta_id);
