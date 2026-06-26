-- ============================================================
-- Restaurant.pe ERP - Tenant DB - produccion schema
-- DROP de esquemas centralizado en 01-core.sql
-- ============================================================
--
-- DIAGRAMA DE RELACIONES (→ = tiene FK hacia):
--
--   ot_tipo (sin dependencias)
--   ot_administracion (sin dependencias)
--   ot_admin_uder → ot_administracion
--   orden_trabajo → auth.sucursal, ot_tipo, ot_administracion
--   almacen.vale_mov.orden_trabajo_id → orden_trabajo (FK tras CREATE orden_trabajo)
--   labor (sin dependencias)
--   receta_labor → core.articulo, labor
--   receta_labor_consumible → receta_labor, core.articulo, core.unidad_medida
--   operacion → orden_trabajo
--   operaciones_det (detalle requerimientos OT; líneas de operación)
--     → operacion, labor, core.articulo, core.unidad_medida
--   compras.orden_compra_det → operaciones_det (FK opcional, columna en 03-compras.sql)
--   programacion_produccion → auth.sucursal, receta, orden_trabajo (OT obligatoria)
--   parte_produccion → orden_trabajo
--   parte_produccion_insumo → parte_produccion, core.articulo, core.unidad_medida, almacen.vale_mov
--   parte_produccion_producido → parte_produccion, core.articulo, core.unidad_medida
--   articulo_doc_tecnica → core.articulo
--   articulo_doc_tecnica_caract_det → articulo_doc_tecnica, core.unidad_medida
--   costeo_produccion → orden_trabajo
--   control_calidad → orden_trabajo
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

CREATE SCHEMA IF NOT EXISTS produccion;

-- ============================================================
-- CREATE (tablas, constraints e índices)
-- ============================================================

CREATE TABLE produccion.receta (
    id BIGSERIAL NOT NULL,
    nro_receta VARCHAR(12) NOT NULL UNIQUE,
    nombre VARCHAR(200) NOT NULL,
    version INTEGER NOT NULL DEFAULT 1,
    articulo_producido_id BIGINT NOT NULL REFERENCES core.articulo(id),
    rendimiento_esperado NUMERIC(18,4),
    porcentaje_merma NUMERIC(8,4),
    -- P=Plato, B=Bebida, G=Guarnición, S=Salsa, D=Postre, E=Entrada, I=Insumo intermedio
    flag_tipo_receta VARCHAR(1) NOT NULL DEFAULT 'P'
        CHECK (flag_tipo_receta IN ('P','B','G','S','D','E','I')),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    costo_mano_obra NUMERIC(18,4) DEFAULT 0,
    costo_indirecto NUMERIC(18,4) DEFAULT 0,
    costo_total_estimado NUMERIC(18,4) DEFAULT 0,
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_RECETA PRIMARY KEY (id),
    CONSTRAINT FK_RECETA_01 FOREIGN KEY (articulo_producido_id) REFERENCES core.articulo(id)
);

CREATE TABLE produccion.ot_tipo (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(120) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP
);

CREATE TABLE produccion.ot_administracion (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    flag_tipo_costo VARCHAR(1) NOT NULL DEFAULT '0',
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT CK_OT_ADMINISTRACION_TIPO_COSTO CHECK (flag_tipo_costo IN ('0', 'D', 'I', 'F'))
);

CREATE TABLE produccion.ot_admin_uder (
    id BIGSERIAL PRIMARY KEY,
    ot_administracion_id BIGINT NOT NULL REFERENCES produccion.ot_administracion(id),
    usuario_id BIGINT NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP
);

CREATE TABLE produccion.orden_trabajo (
    id BIGSERIAL PRIMARY KEY,
    sucursal_id BIGINT NOT NULL REFERENCES auth.sucursal(id),
    ot_tipo_id BIGINT NOT NULL REFERENCES produccion.ot_tipo(id),
    ot_administracion_id BIGINT NOT NULL REFERENCES produccion.ot_administracion(id),
    codigo VARCHAR(12) NOT NULL UNIQUE,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP
);

-- almacen.vale_mov → produccion: FK diferida (columna en 02-almacen.sql) tras CREATE orden_trabajo.
ALTER TABLE almacen.vale_mov
    ADD CONSTRAINT FK_VALE_MOV_ORDEN_TRABAJO FOREIGN KEY (orden_trabajo_id) REFERENCES produccion.orden_trabajo(id);

-- almacen.vale_mov_det → produccion.operaciones_det: FK diferida (columna en 02-almacen.sql)
-- tras CREATE operaciones_det. Se crea aquí porque operaciones_det se define más abajo en este mismo archivo,
-- luego de orden_trabajo.

CREATE INDEX IX_VALE_MOV_08 ON almacen.vale_mov (orden_trabajo_id);

CREATE TABLE produccion.labor (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP
);

CREATE TABLE produccion.ejecutor (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(120) NOT NULL,
    centros_costo_id BIGINT REFERENCES contabilidad.centros_costo(id),
    -- 0=Interno, 1=Externo
    flag_externo VARCHAR(1) NOT NULL DEFAULT '0'
        CHECK (flag_externo IN ('0','1')),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP
);

CREATE TABLE produccion.labor_ejecutor (
    id BIGSERIAL PRIMARY KEY,
    labor_id BIGINT NOT NULL REFERENCES produccion.labor(id),
    ejecutor_id BIGINT NOT NULL REFERENCES produccion.ejecutor(id),
    unidad_medida_alt_id BIGINT REFERENCES core.unidad_medida(id),
    moneda_id BIGINT REFERENCES core.moneda(id),
    factor_conversion NUMERIC(7, 4) DEFAULT 0,
    nro_personas INTEGER,
    ratio_estimado NUMERIC(12, 4) DEFAULT 0,
    costo_unitario NUMERIC(18, 4) DEFAULT 0,
    -- 0=Costo variable, 1=Costo fijo
    flag_costo_fijo VARCHAR(1) NOT NULL DEFAULT '0'
        CHECK (flag_costo_fijo IN ('0','1')),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP
);

CREATE TABLE produccion.receta_labor (
    id BIGSERIAL NOT NULL,
    receta_id BIGINT NOT NULL,
    labor_id BIGINT NOT NULL,
    secuencia INTEGER NOT NULL DEFAULT 1,
    descripcion_paso VARCHAR(3000),
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_RECETA_LABOR PRIMARY KEY (id),
    CONSTRAINT FK_RECETA_LABOR_01 FOREIGN KEY (receta_id) REFERENCES produccion.receta(id),
    CONSTRAINT FK_RECETA_LABOR_02 FOREIGN KEY (labor_id) REFERENCES produccion.labor(id)
);

CREATE TABLE produccion.receta_labor_consumible (
    id BIGSERIAL NOT NULL,
    receta_padre_id BIGINT NOT NULL,
    articulo_id BIGINT NOT NULL REFERENCES core.articulo(id),
    cantidad NUMERIC(18,4) NOT NULL DEFAULT 1,
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_RECETA_LABOR_CONSUMIBLE PRIMARY KEY (id),
    CONSTRAINT FK_RECETA_LABOR_CONSUMIBLE_01 FOREIGN KEY (receta_padre_id) REFERENCES produccion.receta(id)
);

CREATE TABLE produccion.operacion (
    id BIGSERIAL PRIMARY KEY,
    orden_trabajo_id BIGINT NOT NULL REFERENCES produccion.orden_trabajo(id),
    nro_operacion INTEGER NOT NULL,
    labor_id BIGINT REFERENCES produccion.labor(id),
    ejecutor_id BIGINT REFERENCES produccion.ejecutor(id),
    entidad_contribuyente_id BIGINT REFERENCES core.entidad_contribuyente(id),
    centros_costo_id BIGINT REFERENCES contabilidad.centros_costo(id),
    unidad_medida_id BIGINT REFERENCES core.unidad_medida(id),
    descripcion VARCHAR(2000),
    nro_personas INTEGER,
    fec_inicio_estimado DATE,
    fec_inicio DATE,
    fec_fin DATE,
    dias_para_inicio NUMERIC(5, 2),
    dias_duracion_proy NUMERIC(5, 2),
    dias_holgura INTEGER,
    cantidad_proyectada NUMERIC(18, 4),
    cantidad_real NUMERIC(18, 4),
    costo_unitario NUMERIC(18, 4) DEFAULT 0,
    costo_proyectado NUMERIC(18, 4) DEFAULT 0,
    observacion VARCHAR(3000),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP
);

CREATE TABLE produccion.operaciones_det (
    id BIGSERIAL PRIMARY KEY,
    operacion_id BIGINT NOT NULL REFERENCES produccion.operacion(id),
    articulo_id BIGINT NOT NULL REFERENCES core.articulo(id),
    cantidad_requerida NUMERIC(18, 4) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP
);

-- FK opcional: línea de OC vinculada a requerimiento de material en operación de OT
ALTER TABLE compras.orden_compra_det
    ADD CONSTRAINT FK_OC_DET_OPERACIONES_DET FOREIGN KEY (operaciones_det_id) REFERENCES produccion.operaciones_det(id);

-- FK opcional: línea de OS vinculada a una operación de OT (equivalente a OPER_SEC en SIGRE).
ALTER TABLE compras.orden_servicio_det
    ADD CONSTRAINT FK_OS_DET_OPERACIONES_DET FOREIGN KEY (operaciones_det_id) REFERENCES produccion.operaciones_det(id);

-- FK diferida: vale_mov_det.operaciones_det_id → produccion.operaciones_det
-- (columna definida en 02-almacen.sql sin REFERENCES; constraint se crea aquí tras CREATE operaciones_det).
-- Idempotente: DROP IF EXISTS + ADD permite re-ejecutar el script sin fallar.
ALTER TABLE almacen.vale_mov_det DROP CONSTRAINT IF EXISTS FK_VALE_MOV_DET_OPER_DET;
ALTER TABLE almacen.vale_mov_det
    ADD CONSTRAINT FK_VALE_MOV_DET_OPER_DET FOREIGN KEY (operaciones_det_id) REFERENCES produccion.operaciones_det(id);

CREATE INDEX IF NOT EXISTS IX_VALE_MOV_DET_07 ON almacen.vale_mov_det (operaciones_det_id);

-- Programacion recurrente de una OT de produccion (diaria, semanal, quincenal, mensual o anual)
-- flag_frecuencia: D=Diaria, S=Semanal, Q=Quincenal, M=Mensual, A=Anual
-- flag_turno: M=Mañana, T=Tarde, N=Noche
CREATE TABLE produccion.programacion_produccion (
    id BIGSERIAL NOT NULL,
    orden_trabajo_id BIGINT NOT NULL,
    sucursal_id BIGINT,
    receta_id BIGINT NOT NULL,
    flag_frecuencia VARCHAR(1) NOT NULL DEFAULT 'D',
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    cantidad_por_periodo NUMERIC(18,4) NOT NULL,
    flag_turno VARCHAR(1),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_PROGRAMACION_PRODUCCION PRIMARY KEY (id),
    CONSTRAINT FK_PROGRAMACION_PRODUCCION_01 FOREIGN KEY (sucursal_id) REFERENCES auth.sucursal(id),
    CONSTRAINT FK_PROGRAMACION_PRODUCCION_02 FOREIGN KEY (receta_id) REFERENCES produccion.receta(id),
    CONSTRAINT FK_PROGRAMACION_PRODUCCION_03 FOREIGN KEY (orden_trabajo_id) REFERENCES produccion.orden_trabajo(id),
    CONSTRAINT CK_PROG_PRODUCCION_FRECUENCIA CHECK (flag_frecuencia IN ('D', 'S', 'Q', 'M', 'A')),
    CONSTRAINT CK_PROG_PRODUCCION_TURNO CHECK (flag_turno IN ('M', 'T', 'N'))
);

CREATE TABLE produccion.parte_produccion (
    id BIGSERIAL PRIMARY KEY,
    orden_trabajo_id BIGINT NOT NULL REFERENCES produccion.orden_trabajo(id),
    fecha DATE NOT NULL,
    turno_id BIGINT,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP
);

CREATE TABLE produccion.parte_produccion_insumo (
    id BIGSERIAL PRIMARY KEY,
    parte_produccion_id BIGINT NOT NULL REFERENCES produccion.parte_produccion(id),
    articulo_id BIGINT NOT NULL REFERENCES core.articulo(id),
    unidad_medida_id BIGINT REFERENCES core.unidad_medida(id),
    cantidad_consumida NUMERIC(18, 4) NOT NULL,
    vale_mov_id BIGINT REFERENCES almacen.vale_mov(id),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP
);

CREATE TABLE produccion.parte_produccion_producido (
    id BIGSERIAL PRIMARY KEY,
    parte_produccion_id BIGINT NOT NULL REFERENCES produccion.parte_produccion(id),
    articulo_id BIGINT NOT NULL REFERENCES core.articulo(id),
    unidad_medida_id BIGINT REFERENCES core.unidad_medida(id),
    cantidad_producida NUMERIC(18, 4) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP
);

CREATE TABLE produccion.articulo_doc_tecnica (
    id BIGSERIAL PRIMARY KEY,
    articulo_id BIGINT NOT NULL REFERENCES core.articulo(id),
    doc_tipo_id BIGINT NOT NULL REFERENCES core.doc_tipo(id),
    nombre_documento VARCHAR(200) NOT NULL,
    documento_extension VARCHAR(10),
    archivo_url VARCHAR(3000),
    documento_blob BYTEA,
    observacion VARCHAR(3000),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP
);

CREATE TABLE produccion.articulo_doc_tecnica_caract_det (
    id BIGSERIAL PRIMARY KEY,
    articulo_doc_tecnica_id BIGINT NOT NULL REFERENCES produccion.articulo_doc_tecnica(id),
    caracteristica VARCHAR(120) NOT NULL,
    valor VARCHAR(220) NOT NULL,
    unidad_medida_id BIGINT REFERENCES core.unidad_medida(id),
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP
);

CREATE TABLE produccion.costeo_produccion (
    id BIGSERIAL NOT NULL,
    orden_trabajo_id BIGINT,
    anio INTEGER NOT NULL,
    mes INTEGER NOT NULL,
    costo_materia_prima NUMERIC(18, 4) DEFAULT 0,
    costo_mano_obra NUMERIC(18, 4) DEFAULT 0,
    costo_indirecto NUMERIC(18, 4) DEFAULT 0,
    costo_total NUMERIC(18, 4) DEFAULT 0,
    costo_unitario NUMERIC(18, 4) DEFAULT 0,
    rendimiento_real NUMERIC(18, 4),
    porcentaje_merma_real NUMERIC(8, 4),
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_COSTEO_PRODUCCION PRIMARY KEY (id),
    CONSTRAINT FK_COSTEO_PRODUCCION_01 FOREIGN KEY (orden_trabajo_id) REFERENCES produccion.orden_trabajo(id),
    CONSTRAINT CK_COSTEO_PRODUCCION_MES CHECK (mes BETWEEN 1 AND 12),
    CONSTRAINT UQ_COSTEO_PRODUCCION_OT_PERIODO UNIQUE (orden_trabajo_id, anio, mes)
);

-- flag_estado en control_calidad: 0=Anulado, 1=Aprobado, 9=Observado
CREATE TABLE produccion.control_calidad (
    id BIGSERIAL NOT NULL,
    orden_trabajo_id BIGINT,
    inspector_id BIGINT,
    fecha DATE NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '9',
    observaciones VARCHAR(3000),
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_CONTROL_CALIDAD PRIMARY KEY (id),
    CONSTRAINT FK_CONTROL_CALIDAD_01 FOREIGN KEY (orden_trabajo_id) REFERENCES produccion.orden_trabajo(id),
    CONSTRAINT CK_CONTROL_CALIDAD_ESTADO CHECK (flag_estado IN ('0', '1', '9'))
);

CREATE TABLE produccion.labor_insumo (
    id BIGSERIAL NOT NULL,
    labor_id BIGINT NOT NULL,
    articulo_id BIGINT NOT NULL,
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_LABOR_INSUMO PRIMARY KEY (id),
    CONSTRAINT FK_LABOR_INSUMO_01 FOREIGN KEY (labor_id) REFERENCES produccion.labor(id),
    CONSTRAINT FK_LABOR_INSUMO_02 FOREIGN KEY (articulo_id) REFERENCES core.articulo(id)
);

CREATE TABLE produccion.labor_produccion (
    id BIGSERIAL NOT NULL,
    labor_id BIGINT NOT NULL,
    articulo_id BIGINT NOT NULL,
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_LABOR_PRODUCCION PRIMARY KEY (id),
    CONSTRAINT FK_LABOR_PRODUCCION_01 FOREIGN KEY (labor_id) REFERENCES produccion.labor(id),
    CONSTRAINT FK_LABOR_PRODUCCION_02 FOREIGN KEY (articulo_id) REFERENCES core.articulo(id)
);

-- flag_tipo_dieta: R=Regular, V=Vegetariana, G=Vegana, S=Sin Gluten, K=Keto
-- flag_temperatura_servicio: C=Caliente, F=Frio, T=Templado, A=Ambiente
CREATE TABLE produccion.ficha_tecnica (
    id BIGSERIAL NOT NULL,
    receta_id BIGINT NOT NULL,
    alergenos VARCHAR(200),
    calorias NUMERIC(10,2),
    proteinas_g NUMERIC(10,2),
    carbohidratos_g NUMERIC(10,2),
    grasas_g NUMERIC(10,2),
    fibra_g NUMERIC(10,2),
    sodio_mg NUMERIC(10,2),
    flag_tipo_dieta VARCHAR(1) DEFAULT 'R',
    foto_presentacion_url VARCHAR(3000),
    foto_blob BYTEA,
    instrucciones_emplatado VARCHAR(3000),
    tiempo_preparacion_min INTEGER,
    tiempo_coccion_min INTEGER,
    flag_temperatura_servicio VARCHAR(1),
    created_by          BIGINT,
    fec_creacion        TIMESTAMP     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMP,
    CONSTRAINT PK_FICHA_TECNICA PRIMARY KEY (id),
    CONSTRAINT FK_FICHA_TECNICA_01 FOREIGN KEY (receta_id) REFERENCES produccion.receta(id),
    CONSTRAINT CK_FICHA_TECNICA_TIPO_DIETA CHECK (flag_tipo_dieta IN ('R', 'V', 'G', 'S', 'K')),
    CONSTRAINT CK_FICHA_TECNICA_TEMPERATURA CHECK (flag_temperatura_servicio IN ('C', 'F', 'T', 'A'))
);

-- ============================================================
-- SECCIÓN 3: ÍNDICES
-- ============================================================

CREATE INDEX IX_RECETA_01 ON produccion.receta (articulo_producido_id);
CREATE INDEX IX_LABOR_INSUMO_01 ON produccion.labor_insumo (labor_id);
CREATE INDEX IX_LABOR_INSUMO_02 ON produccion.labor_insumo (articulo_id);
CREATE INDEX IX_LABOR_PRODUCCION_01 ON produccion.labor_produccion (labor_id);
CREATE INDEX IX_LABOR_PRODUCCION_02 ON produccion.labor_produccion (articulo_id);
CREATE INDEX IX_FICHA_TECNICA_01 ON produccion.ficha_tecnica (receta_id);
CREATE INDEX IX_PROGRAMACION_PRODUCCION_01 ON produccion.programacion_produccion (orden_trabajo_id);
CREATE INDEX IX_ORDEN_TRABAJO_01 ON produccion.orden_trabajo (sucursal_id);
DROP INDEX IF EXISTS produccion.ix_operacion_01;
CREATE INDEX IX_OPERACION_01 ON produccion.operacion (orden_trabajo_id, fec_inicio);
DROP INDEX IF EXISTS produccion.ix_operaciones_det_01;
CREATE INDEX IX_OPERACIONES_DET_01 ON produccion.operaciones_det (operacion_id, articulo_id);
CREATE INDEX IX_PARTE_PRODUCCION_01 ON produccion.parte_produccion (orden_trabajo_id, fecha);
CREATE INDEX IX_PARTE_PRODUCCION_INSUMO_01 ON produccion.parte_produccion_insumo (parte_produccion_id, articulo_id);
CREATE INDEX IX_COSTEO_PRODUCCION_01 ON produccion.costeo_produccion (orden_trabajo_id, anio, mes);
CREATE INDEX IX_COSTEO_PRODUCCION_02 ON produccion.costeo_produccion (anio, mes);
CREATE INDEX IX_CONTROL_CALIDAD_01 ON produccion.control_calidad (orden_trabajo_id, fecha);

-- Idempotente: migrar legado estado → flag_estado en receta / programacion_produccion
ALTER TABLE produccion.receta DROP COLUMN IF EXISTS estado;
ALTER TABLE produccion.receta ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE produccion.programacion_produccion DROP COLUMN IF EXISTS estado;
ALTER TABLE produccion.programacion_produccion ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
DROP INDEX IF EXISTS produccion.ix_receta_02;
CREATE INDEX IX_RECETA_02 ON produccion.receta (flag_tipo_receta, flag_estado);

-- Idempotente: migrar tipo_costo → flag_tipo_costo en ot_administracion
ALTER TABLE produccion.ot_administracion ADD COLUMN IF NOT EXISTS flag_tipo_costo VARCHAR(1) NOT NULL DEFAULT '0';
DO $$ BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'produccion' AND table_name = 'ot_administracion' AND column_name = 'tipo_costo'
    ) THEN
        UPDATE produccion.ot_administracion
        SET flag_tipo_costo = CASE UPPER(TRIM(tipo_costo))
            WHEN 'D' THEN 'D'
            WHEN 'DIRECTO' THEN 'D'
            WHEN 'I' THEN 'I'
            WHEN 'INDIRECTO' THEN 'I'
            WHEN 'F' THEN 'F'
            WHEN 'FIJO' THEN 'F'
            ELSE '0'
        END;
        ALTER TABLE produccion.ot_administracion DROP COLUMN tipo_costo;
    END IF;
END $$;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_ot_administracion_tipo_costo')
    THEN ALTER TABLE produccion.ot_administracion
        ADD CONSTRAINT CK_OT_ADMINISTRACION_TIPO_COSTO CHECK (flag_tipo_costo IN ('0', 'D', 'I', 'F'));
    END IF;
END $$;

-- Idempotente: agregar periodo (anio, mes) en costeo_produccion
ALTER TABLE produccion.costeo_produccion ADD COLUMN IF NOT EXISTS anio INTEGER;
ALTER TABLE produccion.costeo_produccion ADD COLUMN IF NOT EXISTS mes INTEGER;
UPDATE produccion.costeo_produccion
SET anio = EXTRACT(YEAR FROM fec_creacion)::INTEGER,
    mes = EXTRACT(MONTH FROM fec_creacion)::INTEGER
WHERE anio IS NULL OR mes IS NULL;
ALTER TABLE produccion.costeo_produccion ALTER COLUMN anio SET NOT NULL;
ALTER TABLE produccion.costeo_produccion ALTER COLUMN mes SET NOT NULL;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_costeo_produccion_mes')
    THEN ALTER TABLE produccion.costeo_produccion
        ADD CONSTRAINT CK_COSTEO_PRODUCCION_MES CHECK (mes BETWEEN 1 AND 12);
    END IF;
END $$;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_costeo_produccion_ot_periodo')
    THEN ALTER TABLE produccion.costeo_produccion
        ADD CONSTRAINT UQ_COSTEO_PRODUCCION_OT_PERIODO UNIQUE (orden_trabajo_id, anio, mes);
    END IF;
END $$;
DROP INDEX IF EXISTS produccion.ix_costeo_produccion_01;
CREATE INDEX IF NOT EXISTS IX_COSTEO_PRODUCCION_01 ON produccion.costeo_produccion (orden_trabajo_id, anio, mes);
CREATE INDEX IF NOT EXISTS IX_COSTEO_PRODUCCION_02 ON produccion.costeo_produccion (anio, mes);

-- ============================================================
-- Idempotente: migrar tipo_dieta → flag_tipo_dieta en ficha_tecnica
-- Valores: R=Regular, V=Vegetariana, G=Vegana, S=Sin Gluten, K=Keto
-- ============================================================
ALTER TABLE produccion.ficha_tecnica ADD COLUMN IF NOT EXISTS flag_tipo_dieta VARCHAR(1) DEFAULT 'R';
DO $$ BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'produccion' AND table_name = 'ficha_tecnica' AND column_name = 'tipo_dieta'
    ) THEN
        UPDATE produccion.ficha_tecnica
        SET flag_tipo_dieta = CASE UPPER(TRIM(tipo_dieta))
            WHEN 'REGULAR'      THEN 'R'
            WHEN 'VEGETARIANA'  THEN 'V'
            WHEN 'VEGANA'       THEN 'G'
            WHEN 'SIN_GLUTEN'   THEN 'S'
            WHEN 'KETO'         THEN 'K'
            ELSE 'R'
        END;
        ALTER TABLE produccion.ficha_tecnica DROP COLUMN tipo_dieta;
    END IF;
END $$;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_ficha_tecnica_tipo_dieta')
    THEN ALTER TABLE produccion.ficha_tecnica
        ADD CONSTRAINT CK_FICHA_TECNICA_TIPO_DIETA CHECK (flag_tipo_dieta IN ('R', 'V', 'G', 'S', 'K'));
    END IF;
END $$;

-- ============================================================
-- Idempotente: migrar temperatura_servicio → flag_temperatura_servicio en ficha_tecnica
-- Valores: C=Caliente, F=Frio, T=Templado, A=Ambiente
-- ============================================================
ALTER TABLE produccion.ficha_tecnica ADD COLUMN IF NOT EXISTS flag_temperatura_servicio VARCHAR(1);
DO $$ BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'produccion' AND table_name = 'ficha_tecnica' AND column_name = 'temperatura_servicio'
    ) THEN
        UPDATE produccion.ficha_tecnica
        SET flag_temperatura_servicio = CASE UPPER(TRIM(temperatura_servicio))
            WHEN 'CALIENTE'  THEN 'C'
            WHEN 'FRIO'      THEN 'F'
            WHEN 'TEMPLADO'  THEN 'T'
            WHEN 'AMBIENTE'  THEN 'A'
            ELSE NULL
        END;
        ALTER TABLE produccion.ficha_tecnica DROP COLUMN temperatura_servicio;
    END IF;
END $$;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_ficha_tecnica_temperatura')
    THEN ALTER TABLE produccion.ficha_tecnica
        ADD CONSTRAINT CK_FICHA_TECNICA_TEMPERATURA CHECK (flag_temperatura_servicio IN ('C', 'F', 'T', 'A'));
    END IF;
END $$;

-- ============================================================
-- Idempotente: migrar frecuencia → flag_frecuencia en programacion_produccion
-- Valores: D=Diaria, S=Semanal, Q=Quincenal, M=Mensual, A=Anual
-- ============================================================
ALTER TABLE produccion.programacion_produccion ADD COLUMN IF NOT EXISTS flag_frecuencia VARCHAR(1) NOT NULL DEFAULT 'D';
DO $$ BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'produccion' AND table_name = 'programacion_produccion' AND column_name = 'frecuencia'
    ) THEN
        UPDATE produccion.programacion_produccion
        SET flag_frecuencia = CASE UPPER(TRIM(frecuencia))
            WHEN 'DIARIA'     THEN 'D'
            WHEN 'SEMANAL'    THEN 'S'
            WHEN 'QUINCENAL'  THEN 'Q'
            WHEN 'MENSUAL'    THEN 'M'
            WHEN 'ANUAL'      THEN 'A'
            ELSE 'D'
        END;
        ALTER TABLE produccion.programacion_produccion DROP COLUMN frecuencia;
    END IF;
END $$;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_prog_produccion_frecuencia')
    THEN ALTER TABLE produccion.programacion_produccion
        ADD CONSTRAINT CK_PROG_PRODUCCION_FRECUENCIA CHECK (flag_frecuencia IN ('D', 'S', 'Q', 'M', 'A'));
    END IF;
END $$;

-- ============================================================
-- Idempotente: migrar turno → flag_turno en programacion_produccion
-- Valores: M=Mañana, T=Tarde, N=Noche
-- ============================================================
ALTER TABLE produccion.programacion_produccion ADD COLUMN IF NOT EXISTS flag_turno VARCHAR(1);
DO $$ BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'produccion' AND table_name = 'programacion_produccion' AND column_name = 'turno'
    ) THEN
        UPDATE produccion.programacion_produccion
        SET flag_turno = CASE UPPER(TRIM(turno))
            WHEN 'MANANA'  THEN 'M'
            WHEN 'MAÑANA'  THEN 'M'
            WHEN 'TARDE'   THEN 'T'
            WHEN 'NOCHE'   THEN 'N'
            ELSE NULL
        END;
        ALTER TABLE produccion.programacion_produccion DROP COLUMN turno;
    END IF;
END $$;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_prog_produccion_turno')
    THEN ALTER TABLE produccion.programacion_produccion
        ADD CONSTRAINT CK_PROG_PRODUCCION_TURNO CHECK (flag_turno IN ('M', 'T', 'N'));
    END IF;
END $$;

-- ============================================================
-- Idempotente: migrar resultado → flag_estado en control_calidad
-- Subconjunto dominio: 0=Anulado, 1=Aprobado, 9=Observado
-- ============================================================
ALTER TABLE produccion.control_calidad ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '9';
DO $$ BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'produccion' AND table_name = 'control_calidad' AND column_name = 'resultado'
    ) THEN
        UPDATE produccion.control_calidad
        SET flag_estado = CASE UPPER(TRIM(resultado))
            WHEN 'APROBADO'   THEN '1'
            WHEN 'RECHAZADO'  THEN '0'
            WHEN 'OBSERVADO'  THEN '9'
            ELSE '9'
        END;
        ALTER TABLE produccion.control_calidad DROP COLUMN resultado;
    END IF;
END $$;
-- Normalizar valores fuera del subconjunto permitido (legado 2, 3, A, R, O, etc.)
UPDATE produccion.control_calidad
SET flag_estado = CASE flag_estado
    WHEN '0' THEN '0'
    WHEN '1' THEN '1'
    WHEN '9' THEN '9'
    WHEN '2' THEN '1'
    WHEN '3' THEN '9'
    WHEN 'A' THEN '1'
    WHEN 'R' THEN '0'
    WHEN 'O' THEN '9'
    ELSE '9'
END
WHERE flag_estado NOT IN ('0', '1', '9');
-- Recrear CHECK con subconjunto correcto
DO $$ BEGIN
    IF EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'ck_control_calidad_estado'
    ) THEN
        ALTER TABLE produccion.control_calidad DROP CONSTRAINT ck_control_calidad_estado;
    END IF;
END $$;
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ck_control_calidad_estado')
    THEN ALTER TABLE produccion.control_calidad
        ADD CONSTRAINT CK_CONTROL_CALIDAD_ESTADO CHECK (flag_estado IN ('0', '1', '9'));
    END IF;
END $$;
ALTER TABLE produccion.control_calidad ALTER COLUMN flag_estado SET DEFAULT '9';

-- ============================================================
-- Idempotente: orden_trabajo_id obligatorio en programacion_produccion
-- La programacion siempre vincula una OT de produccion.
-- ============================================================
DELETE FROM produccion.programacion_produccion WHERE orden_trabajo_id IS NULL;
DO $$ BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'produccion'
          AND table_name = 'programacion_produccion'
          AND column_name = 'orden_trabajo_id'
          AND is_nullable = 'YES'
    ) THEN
        ALTER TABLE produccion.programacion_produccion
            ALTER COLUMN orden_trabajo_id SET NOT NULL;
    END IF;
END $$;
CREATE INDEX IF NOT EXISTS IX_PROGRAMACION_PRODUCCION_01
    ON produccion.programacion_produccion (orden_trabajo_id);

-- ============================================================
-- COMMENT ON COLUMN: documentar valores de cada flag
-- ============================================================
COMMENT ON COLUMN produccion.programacion_produccion.orden_trabajo_id IS 'OT de produccion que se programa (diaria, semanal, quincenal, mensual o anual)';
COMMENT ON COLUMN produccion.ficha_tecnica.flag_tipo_dieta IS 'Tipo de dieta: R=Regular, V=Vegetariana, G=Vegana, S=Sin Gluten, K=Keto';
COMMENT ON COLUMN produccion.ficha_tecnica.flag_temperatura_servicio IS 'Temperatura de servicio: C=Caliente, F=Frio, T=Templado, A=Ambiente';
COMMENT ON COLUMN produccion.programacion_produccion.flag_frecuencia IS 'Frecuencia de produccion: D=Diaria, S=Semanal, Q=Quincenal, M=Mensual, A=Anual';
COMMENT ON COLUMN produccion.programacion_produccion.flag_turno IS 'Turno de produccion: M=Mañana, T=Tarde, N=Noche';
COMMENT ON COLUMN produccion.control_calidad.flag_estado IS 'Resultado control calidad: 0=Anulado, 1=Aprobado, 9=Observado';
COMMENT ON COLUMN produccion.ot_administracion.flag_tipo_costo IS 'Tipo de costo: D=Directo, I=Indirecto, F=Fijo, 0=Sin definir';
