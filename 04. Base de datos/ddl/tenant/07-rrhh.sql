-- ============================================================
-- Restaurant.pe ERP - Tenant DB - rrhh schema
-- DROP de esquemas centralizado en 01-core.sql
-- ============================================================
--
-- DIAGRAMA DE RELACIONES (→ = tiene FK hacia):
--
--   area → area (self-ref padre_id)
--   cargo (sin dependencias)
--   admin_afp (sin dependencias)
--   turno (sin dependencias)
--   grupo_conceptos_planilla (SIGRE GRUPO_CALC_CONCEPTO, sin dependencias)
--   concepto_planilla → grupo_conceptos_planilla
--   grupo_calculo (SIGRE GRUPO_CALCULO) → concepto_planilla
--   grupo_calculo_det → grupo_calculo, concepto_planilla
--   remuneracion_minima_vital (SIGRE RMV_X_TIPO_TRABAJ) → tipo_trabajador
--   impuesto_renta_tramos (SIGRE RRHH_IMPUESTO_RENTA)
--   tipo_novedad_rrhh (sin dependencias)
--   capacitacion (sin dependencias)
--   sexo, estado_civil, regimen_laboral, tipo_contrato, tipo_mov_asistencia,
--   tipo_subsidio, tipo_suspension_laboral, tipo_sancion, tipo_planilla,
--   tipo_concepto_calculo, tipo_movimiento_cnta_crrte, periodo_gratificacion, periodo_cts (sin dependencias)
--   fechas_proceso → tipo_trabajador, tipo_planilla
--   calculo (boleta cabecera) → trabajador, tipo_planilla, auth.sucursal
--   trabajador → core.entidad_contribuyente, core.tipo_doc_identidad, sexo, estado_civil,
--                regimen_laboral, admin_afp, area, cargo, auth.sucursal
--   contrato → trabajador, tipo_contrato
--   asistencia → trabajador, tipo_mov_asistencia
--   inasistencia → trabajador, concepto_planilla (SIGRE: cod_trabajador, concep, fec_desde/hasta/movim, dias_inasist)
--   permiso_licencia → trabajador, concepto_planilla (cabecera/saldo por periodo)
--   permiso_licencia_det → permiso_licencia, tipo_suspension_laboral, tipo_doc_identidad
--   vacacion → trabajador
--   liquidacion_benef → trabajador (SIGRE: LIQUIDACION_BENEF / LBS)
--   prestamo → trabajador
--   cnta_crrte → trabajador
--   horario_trabajador → trabajador, turno
--   evaluacion_desempeno → trabajador
--   capacitacion_trabajador → capacitacion, trabajador
--   sancion_amonestacion → trabajador, tipo_sancion
--   control_subsidio → trabajador, tipo_subsidio
--   gan_desct_fijo → trabajador, concepto_planilla
--   gan_desct_variable → trabajador, concepto_planilla, tipo_planilla
--   adelanto_quincena → trabajador, concepto_planilla (SIGRE ADELANTO_QUINCENA)
--   retencion_judicial → trabajador, concepto_planilla, entidad_contribuyente, finanzas.banco (SIGRE JUDICIAL)
--   calculo_judicial → retencion_judicial, tipo_trabajador, tipo_planilla, auth.sucursal (SIGRE CALCULO_JUDICIAL)
--   grupo_conceptos_seccion → grupo_calculo, seccion (SIGRE GRUPO_CALC_X_SECCION)
--   historico_calculo SIGRE → rrhh.calculo + rrhh.calculo_det (sin tabla histórica separada)
--   program_vacacion → trabajador
--   novedad_rrhh → trabajador, tipo_novedad_rrhh
--   calculo_det (boleta línea) → calculo, concepto_planilla, tipo_concepto_calculo,
--                               contabilidad.centros_costo, core.entidad_contribuyente,
--                               cnta_crrte, cnta_crrte_det
--   cnta_crrte → trabajador, core.doc_tipo, concepto_planilla, core.moneda, core.entidad_contribuyente,
--                finanzas.cntas_pagar, ventas.cntas_cobrar
--   cnta_crrte_det → cnta_crrte, tipo_movimiento_cnta_crrte, rrhh.liquidacion_benef, calculo_det
--   gratificacion → trabajador, periodo_gratificacion
--   cts → trabajador, periodo_cts
--   novedad_rrhh_det → novedad_rrhh
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

CREATE SCHEMA IF NOT EXISTS rrhh;

-- ============================================================
-- SECCIÓN 1: TABLAS MAESTRAS / INDEPENDIENTES
-- ============================================================

CREATE TABLE rrhh.area (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(10),
    nombre VARCHAR(120) NOT NULL,
    padre_id BIGINT,
    responsable_id BIGINT,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_AREA PRIMARY KEY (id),
    CONSTRAINT FK_AREA_01 FOREIGN KEY (padre_id) REFERENCES rrhh.area(id)
);
CREATE UNIQUE INDEX UQ_AREA_CODIGO ON rrhh.area (codigo) WHERE codigo IS NOT NULL;

CREATE TABLE rrhh.cargo (
    id BIGSERIAL NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    nivel VARCHAR(30),
    sueldo_minimo NUMERIC(18, 4),
    sueldo_maximo NUMERIC(18, 4),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CARGO PRIMARY KEY (id)
);

CREATE TABLE rrhh.admin_afp (
    id BIGSERIAL NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    comision_porcentaje NUMERIC(8, 4),
    prima_seguro NUMERIC(8, 4),
    aporte_obligatorio NUMERIC(8, 4),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_ADMIN_AFP PRIMARY KEY (id)
);

CREATE TABLE rrhh.turno (
    id BIGSERIAL NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    hora_entrada TIME,
    hora_salida TIME,
    minutos_tolerancia INTEGER DEFAULT 0,
    aplica_lunes BOOLEAN DEFAULT TRUE,
    aplica_martes BOOLEAN DEFAULT TRUE,
    aplica_miercoles BOOLEAN DEFAULT TRUE,
    aplica_jueves BOOLEAN DEFAULT TRUE,
    aplica_viernes BOOLEAN DEFAULT TRUE,
    aplica_sabado BOOLEAN DEFAULT FALSE,
    aplica_domingo BOOLEAN DEFAULT FALSE,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_TURNO PRIMARY KEY (id)
);

CREATE TABLE rrhh.grupo_conceptos_planilla (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(10) NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    concepto_codigo VARCHAR(20),
    flag_replicacion VARCHAR(1) NOT NULL DEFAULT '1',
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_GRUPO_CONCEPTOS_PLANILLA PRIMARY KEY (id),
    CONSTRAINT UQ_GRUPO_CONCEPTOS_PLANILLA_CODIGO UNIQUE (codigo)
);

CREATE TABLE rrhh.concepto_planilla (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    descripcion_breve VARCHAR(150),
    factor_pago NUMERIC(18, 6) NOT NULL DEFAULT 1,
    importe_tope_min NUMERIC(18, 4) NOT NULL DEFAULT 0,
    importe_tope_max NUMERIC(18, 4) NOT NULL DEFAULT 0,
    numero_horas NUMERIC(6, 2),
    grupo_conceptos_planilla_id BIGINT NOT NULL,
    flag_replicacion VARCHAR(1) NOT NULL DEFAULT '1',
    concepto_rtps VARCHAR(10),
    flag_subsidio VARCHAR(1) NOT NULL DEFAULT '0',
    flag_reporte_quinta VARCHAR(1) NOT NULL DEFAULT '0',
    numero_orden VARCHAR(20),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CONCEPTO_PLANILLA PRIMARY KEY (id),
    CONSTRAINT FK_CONCEPTO_PLANILLA_GRUPO FOREIGN KEY (grupo_conceptos_planilla_id)
        REFERENCES rrhh.grupo_conceptos_planilla(id)
);

-- Grupos de suma del motor de planilla. SIGRE: GRUPO_CALCULO (≠ GRUPO_CALC_CONCEPTO).
CREATE TABLE rrhh.grupo_calculo (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(3) NOT NULL,
    nombre VARCHAR(50),
    concepto_gen_id BIGINT,
    concepto_reg_lab_id BIGINT,
    flag_seccion VARCHAR(1) NOT NULL DEFAULT '0',
    flag_replicacion VARCHAR(1) NOT NULL DEFAULT '1',
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_GRUPO_CALCULO PRIMARY KEY (id),
    CONSTRAINT UQ_GRUPO_CALCULO_CODIGO UNIQUE (codigo),
    CONSTRAINT FK_GRUPO_CALCULO_CONCEPTO_GEN FOREIGN KEY (concepto_gen_id) REFERENCES rrhh.concepto_planilla(id),
    CONSTRAINT FK_GRUPO_CALCULO_CONCEPTO_REG_LAB FOREIGN KEY (concepto_reg_lab_id) REFERENCES rrhh.concepto_planilla(id)
);

-- Detalle concepto × grupo de cálculo. SIGRE: GRUPO_CALCULO_DET.
CREATE TABLE rrhh.grupo_calculo_det (
    id BIGSERIAL NOT NULL,
    grupo_calculo_id BIGINT NOT NULL,
    concepto_planilla_id BIGINT NOT NULL,
    flag_replicacion VARCHAR(1) NOT NULL DEFAULT '1',
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_GRUPO_CALCULO_DET PRIMARY KEY (id),
    CONSTRAINT FK_GRUPO_CALCULO_DET_01 FOREIGN KEY (grupo_calculo_id) REFERENCES rrhh.grupo_calculo(id),
    CONSTRAINT FK_GRUPO_CALCULO_DET_02 FOREIGN KEY (concepto_planilla_id) REFERENCES rrhh.concepto_planilla(id),
    CONSTRAINT UQ_GRUPO_CALCULO_DET UNIQUE (grupo_calculo_id, concepto_planilla_id)
);

-- Tramos retención quinta categoría. SIGRE: RRHH_IMPUESTO_RENTA.
CREATE TABLE rrhh.impuesto_renta_tramos (
    id BIGSERIAL NOT NULL,
    secuencia INTEGER NOT NULL,
    tasa NUMERIC(5, 2) NOT NULL,
    tope_ini NUMERIC(13, 2) NOT NULL DEFAULT 0,
    tope_fin NUMERIC(13, 2) NOT NULL DEFAULT 0,
    fecha_vig_ini DATE NOT NULL,
    fecha_vig_fin DATE,
    cod_usr VARCHAR(6),
    flag_replicacion VARCHAR(1) NOT NULL DEFAULT '1',
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_IMPUESTO_RENTA_TRAMOS PRIMARY KEY (id),
    CONSTRAINT UQ_IMPUESTO_RENTA_VIG_SEC UNIQUE (fecha_vig_ini, secuencia)
);

CREATE TABLE rrhh.tipo_novedad_rrhh (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(120) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE rrhh.capacitacion (
    id BIGSERIAL NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATE,
    fecha_fin DATE,
    horas INTEGER,
    proveedor VARCHAR(200),
    costo NUMERIC(18, 4),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CAPACITACION PRIMARY KEY (id)
);

-- Catálogos RRHH (SIGRE: RRHH_*_RTPS, TIPO_MOV_ASISTENCIA, RRHH_REGIMEN_LABORAL, etc.)

CREATE TABLE rrhh.sexo (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(10) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_SEXO PRIMARY KEY (id),
    CONSTRAINT UQ_SEXO_CODIGO UNIQUE (codigo)
);

CREATE TABLE rrhh.estado_civil (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(10) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_ESTADO_CIVIL PRIMARY KEY (id),
    CONSTRAINT UQ_ESTADO_CIVIL_CODIGO UNIQUE (codigo)
);

CREATE TABLE rrhh.regimen_laboral (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(10) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    factor_gratificacion NUMERIC(8, 4) DEFAULT 1,
    factor_vacacion NUMERIC(8, 4) DEFAULT 1,
    factor_cts NUMERIC(8, 4) DEFAULT 1,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_REGIMEN_LABORAL PRIMARY KEY (id),
    CONSTRAINT UQ_REGIMEN_LABORAL_CODIGO UNIQUE (codigo)
);

CREATE TABLE rrhh.tipo_contrato (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(10) NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_TIPO_CONTRATO PRIMARY KEY (id),
    CONSTRAINT UQ_TIPO_CONTRATO_CODIGO UNIQUE (codigo)
);

CREATE TABLE rrhh.tipo_mov_asistencia (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(10) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_TIPO_MOV_ASISTENCIA PRIMARY KEY (id),
    CONSTRAINT UQ_TIPO_MOV_ASISTENCIA_CODIGO UNIQUE (codigo)
);

CREATE TABLE rrhh.tipo_subsidio (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(10) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    nro_dias INTEGER,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_TIPO_SUBSIDIO PRIMARY KEY (id),
    CONSTRAINT UQ_TIPO_SUBSIDIO_CODIGO UNIQUE (codigo)
);

CREATE TABLE rrhh.tipo_suspension_laboral (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(10) NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    flag_tipo_susp VARCHAR(1),
    tipo_subsidio_id BIGINT,
    flag_citt VARCHAR(1) NOT NULL DEFAULT '0',
    flag_datos_lesion VARCHAR(1) NOT NULL DEFAULT '0',
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_TIPO_SUSPENSION_LABORAL PRIMARY KEY (id),
    CONSTRAINT UQ_TIPO_SUSPENSION_LABORAL_CODIGO UNIQUE (codigo),
    CONSTRAINT FK_TIPO_SUSPENSION_LABORAL_01 FOREIGN KEY (tipo_subsidio_id) REFERENCES rrhh.tipo_subsidio(id)
);

CREATE TABLE rrhh.tipo_sancion (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(30) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_TIPO_SANCION PRIMARY KEY (id),
    CONSTRAINT UQ_TIPO_SANCION_CODIGO UNIQUE (codigo)
);

CREATE TABLE rrhh.tipo_planilla (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(10) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_TIPO_PLANILLA PRIMARY KEY (id),
    CONSTRAINT UQ_TIPO_PLANILLA_CODIGO UNIQUE (codigo)
);

CREATE TABLE rrhh.tipo_concepto_calculo (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(30) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_TIPO_CONCEPTO_CALCULO PRIMARY KEY (id),
    CONSTRAINT UQ_TIPO_CONCEPTO_CALCULO_CODIGO UNIQUE (codigo)
);

CREATE TABLE rrhh.tipo_movimiento_cnta_crrte (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_TIPO_MOVIMIENTO_CNTA_CRRTE PRIMARY KEY (id),
    CONSTRAINT UQ_TIPO_MOVIMIENTO_CNTA_CRRTE_CODIGO UNIQUE (codigo)
);

CREATE TABLE rrhh.periodo_gratificacion (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_PERIODO_GRATIFICACION PRIMARY KEY (id),
    CONSTRAINT UQ_PERIODO_GRATIFICACION_CODIGO UNIQUE (codigo)
);

CREATE TABLE rrhh.periodo_cts (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_PERIODO_CTS PRIMARY KEY (id),
    CONSTRAINT UQ_PERIODO_CTS_CODIGO UNIQUE (codigo)
);

-- Catálogos SIGRE para maestro de trabajadores (dependencias de rrhh.trabajador)
CREATE TABLE rrhh.tipo_sangre (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_TIPO_SANGRE PRIMARY KEY (id),
    CONSTRAINT UQ_TIPO_SANGRE_CODIGO UNIQUE (codigo)
);

CREATE TABLE rrhh.pension_rtps (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_PENSION_RTPS PRIMARY KEY (id),
    CONSTRAINT UQ_PENSION_RTPS_CODIGO UNIQUE (codigo)
);

CREATE TABLE rrhh.regimen_pensionario (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_REGIMEN_PENSIONARIO PRIMARY KEY (id),
    CONSTRAINT UQ_REGIMEN_PENSIONARIO_CODIGO UNIQUE (codigo)
);

CREATE TABLE rrhh.tipo_trabajador (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(10) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    flag_emision_boleta VARCHAR(1),
    libro_planilla INTEGER,
    libro_prov_remuneracion INTEGER,
    libro_prov_gratificacion INTEGER,
    libro_prov_cts INTEGER,
    dias_trab_hab_fijo INTEGER,
    factor_costo_hr NUMERIC(10, 4),
    flag_sector_agrario VARCHAR(1),
    periodo_boleta VARCHAR(1),
    flag_ingreso_boleta VARCHAR(1),
    flag_replicacion VARCHAR(1) NOT NULL DEFAULT '1',
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_TIPO_TRABAJADOR PRIMARY KEY (id),
    CONSTRAINT UQ_TIPO_TRABAJADOR_CODIGO UNIQUE (codigo)
);

CREATE TABLE rrhh.remuneracion_minima_vital (
    id BIGSERIAL NOT NULL,
    tipo_trabajador_id BIGINT NOT NULL,
    rmv NUMERIC(13, 2) NOT NULL,
    fecha_desde DATE NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by BIGINT,
    fec_creacion TIMESTAMPTZ DEFAULT NOW(),
    updated_by BIGINT,
    fec_modificacion TIMESTAMPTZ,
    CONSTRAINT PK_REMUNERACION_MINIMA_VITAL PRIMARY KEY (id),
    CONSTRAINT UQ_RMV_TIPO_FECHA UNIQUE (tipo_trabajador_id, rmv, fecha_desde),
    CONSTRAINT FK_RMV_TIPO_TRABAJADOR FOREIGN KEY (tipo_trabajador_id) REFERENCES rrhh.tipo_trabajador(id)
);
CREATE INDEX IX_RMV_01 ON rrhh.remuneracion_minima_vital (tipo_trabajador_id, fecha_desde);

CREATE TABLE rrhh.fechas_proceso (
    id BIGSERIAL NOT NULL,
    origen VARCHAR(5) NOT NULL,
    fec_proceso DATE NOT NULL,
    fec_inicio DATE NOT NULL,
    fec_final DATE NOT NULL,
    flag_replicacion VARCHAR(1) NOT NULL DEFAULT '1',
    cod_relacion VARCHAR(20) NOT NULL,
    tipo_trabajador_id BIGINT NOT NULL,
    porc_aplica_ctacte NUMERIC(18, 4),
    flag_calc_vacaciones VARCHAR(1) NOT NULL DEFAULT '0',
    flag_calc_cts VARCHAR(1) NOT NULL DEFAULT '0',
    flag_calc_gratificacion VARCHAR(1) NOT NULL DEFAULT '0',
    flag_bonificacion_pesca VARCHAR(1) NOT NULL DEFAULT '0',
    tipo_planilla_id BIGINT NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_FECHAS_PROCESO PRIMARY KEY (id),
    CONSTRAINT UQ_FECHAS_PROCESO_NATURAL UNIQUE (
        origen, fec_proceso, fec_inicio, fec_final, cod_relacion, tipo_trabajador_id, tipo_planilla_id
    ),
    CONSTRAINT FK_FECHAS_PROCESO_TIPO_TRABAJADOR FOREIGN KEY (tipo_trabajador_id) REFERENCES rrhh.tipo_trabajador(id),
    CONSTRAINT FK_FECHAS_PROCESO_TIPO_PLANILLA FOREIGN KEY (tipo_planilla_id) REFERENCES rrhh.tipo_planilla(id)
);
CREATE INDEX IX_FECHAS_PROCESO_01 ON rrhh.fechas_proceso (fec_proceso, tipo_planilla_id);
CREATE INDEX IX_FECHAS_PROCESO_02 ON rrhh.fechas_proceso (tipo_trabajador_id, fec_proceso);
CREATE INDEX IX_FECHAS_PROCESO_03 ON rrhh.fechas_proceso (fec_inicio, fec_final);

CREATE TABLE rrhh.tipo_trabajador_rtps (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    flag_pensionista VARCHAR(1),
    CONSTRAINT PK_TIPO_TRABAJADOR_RTPS PRIMARY KEY (id),
    CONSTRAINT UQ_TIPO_TRABAJADOR_RTPS_CODIGO UNIQUE (codigo)
);

CREATE TABLE rrhh.ocupacion_rtps (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_OCUPACION_RTPS PRIMARY KEY (id),
    CONSTRAINT UQ_OCUPACION_RTPS_CODIGO UNIQUE (codigo)
);

CREATE TABLE rrhh.seccion (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    area_id BIGINT NOT NULL,
    porc_sctr_onp NUMERIC(4, 2) NOT NULL DEFAULT 0,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    CONSTRAINT PK_SECCION PRIMARY KEY (id),
    CONSTRAINT UQ_SECCION_AREA_CODIGO UNIQUE (area_id, codigo),
    CONSTRAINT FK_SECCION_AREA FOREIGN KEY (area_id) REFERENCES rrhh.area(id)
);

CREATE TABLE rrhh.motivo_cese (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_MOTIVO_CESE PRIMARY KEY (id),
    CONSTRAINT UQ_MOTIVO_CESE_CODIGO UNIQUE (codigo)
);

CREATE TABLE rrhh.tipo_via (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_TIPO_VIA PRIMARY KEY (id),
    CONSTRAINT UQ_TIPO_VIA_CODIGO UNIQUE (codigo)
);

CREATE TABLE rrhh.tipo_zona (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_TIPO_ZONA PRIMARY KEY (id),
    CONSTRAINT UQ_TIPO_ZONA_CODIGO UNIQUE (codigo)
);

CREATE TABLE rrhh.tipo_vivienda (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_TIPO_VIVIENDA PRIMARY KEY (id),
    CONSTRAINT UQ_TIPO_VIVIENDA_CODIGO UNIQUE (codigo)
);

-- ============================================================
-- SECCIÓN 2: TABLA PRINCIPAL - TRABAJADOR
-- ============================================================

CREATE TABLE rrhh.trabajador (
    id BIGSERIAL NOT NULL,
    entidad_contribuyente_id BIGINT,
    codigo_trabajador VARCHAR(20) NOT NULL UNIQUE,
    nombres VARCHAR(120) NOT NULL,
    nombre1 VARCHAR(60),
    nombre2 VARCHAR(60),
    apellido_paterno VARCHAR(120),
    apellido_materno VARCHAR(120),
    tipo_doc_identidad_id BIGINT,
    numero_documento VARCHAR(30) UNIQUE,
    fecha_nacimiento DATE,
    sexo_id BIGINT,
    estado_civil_id BIGINT,
    alergias VARCHAR(300),
    tipo_sangre_id BIGINT,
    foto_blob BYTEA,
    dni_blob BYTEA,
    nro_brevete VARCHAR(30),
    autogenerado_essalud VARCHAR(30),
    direccion VARCHAR(300),
    telefono_fijo VARCHAR(40),
    celular1 VARCHAR(40),
    celular2 VARCHAR(40),
    codigo_tel_ciudad VARCHAR(10),
    email VARCHAR(150),
    flag_discapacidad VARCHAR(1) NOT NULL DEFAULT '0',
    flag_domiciliado VARCHAR(1) NOT NULL DEFAULT '1',
    flag_comision_afp VARCHAR(1) NOT NULL DEFAULT '0',
    flag_pensionista VARCHAR(1) NOT NULL DEFAULT '0',
    flag_afiliado_eps VARCHAR(1) NOT NULL DEFAULT '0',
    flag_essalud_vida VARCHAR(1) NOT NULL DEFAULT '0',
    flag_sctr_pension VARCHAR(1) NOT NULL DEFAULT '0',
    flag_sctr_salud VARCHAR(1) NOT NULL DEFAULT '0',
    flag_quinta_exonerado VARCHAR(1) NOT NULL DEFAULT '0',
    distrito_id BIGINT,
    tipo_via_id BIGINT,
    nombre_via VARCHAR(200),
    numero_via VARCHAR(20),
    tipo_zona_id BIGINT,
    nombre_zona VARCHAR(200),
    tipo_vivienda_id BIGINT,
    interior VARCHAR(50),
    referencia VARCHAR(300),
    cuenta_bancaria_sueldo VARCHAR(60),
    cuenta_cts VARCHAR(60),
    banco_sueldo_id BIGINT,
    banco_cts_id BIGINT,
    moneda_sueldo_id BIGINT,
    moneda_cts_id BIGINT,
    admin_afp_id BIGINT,
    cuspp VARCHAR(30),
    pension_rtps_id BIGINT,
    regimen_pensionario_id BIGINT,
    fec_ini_afil_afp DATE,
    fec_fin_afil_afp DATE,
    regimen_laboral_id BIGINT,
    tipo_trabajador_id BIGINT,
    tipo_trabajador_rtps_id BIGINT,
    ocupacion_rtps_id BIGINT,
    area_id BIGINT,
    seccion_id BIGINT,
    cargo_id BIGINT,
    centro_costo_id BIGINT,
    sucursal_id BIGINT NOT NULL,
    fecha_ingreso DATE,
    fecha_cese DATE,
    motivo_cese_id BIGINT,
    motivo_cese VARCHAR(120),
    comentario VARCHAR(500),
    procedencia VARCHAR(10),
    porc_judicial NUMERIC(4, 2) NOT NULL DEFAULT 0,
    porc_jud_util NUMERIC(5, 2) NOT NULL DEFAULT 0,
    -- SIGRE MAESTRO.flag_cat_trab (PowerBuilder d_abc_maestro_personal_rtps_ff.srd):
    --   '1' = TRABAJADOR          — motor planilla: NVL(...,'1'); aplica AFP/SNP solo si = '1' (usp_rh_cal_calcula_planilla)
    --   '2' = PENSIONISTA
    --   '3' = PRES. DE SERVICIOS
    --   '4' = PERSONAL DE TERCEROS — RTPS: requiere RUC empresa (DECODE flag_categoria '3'/'4')
    --   '5' = PRACTICANTE
    flag_cat_trab VARCHAR(1) NOT NULL DEFAULT '1',
    flag_dscto_comedor VARCHAR(1) NOT NULL DEFAULT '0',
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_TRABAJADOR PRIMARY KEY (id),
    CONSTRAINT FK_TRABAJADOR_01 FOREIGN KEY (entidad_contribuyente_id) REFERENCES core.entidad_contribuyente(id),
    CONSTRAINT FK_TRABAJADOR_02 FOREIGN KEY (tipo_doc_identidad_id) REFERENCES core.tipo_doc_identidad(id),
    CONSTRAINT FK_TRABAJADOR_03 FOREIGN KEY (sexo_id) REFERENCES rrhh.sexo(id),
    CONSTRAINT FK_TRABAJADOR_04 FOREIGN KEY (estado_civil_id) REFERENCES rrhh.estado_civil(id),
    CONSTRAINT FK_TRABAJADOR_05 FOREIGN KEY (regimen_laboral_id) REFERENCES rrhh.regimen_laboral(id),
    CONSTRAINT FK_TRABAJADOR_06 FOREIGN KEY (admin_afp_id) REFERENCES rrhh.admin_afp(id),
    CONSTRAINT FK_TRABAJADOR_07 FOREIGN KEY (area_id) REFERENCES rrhh.area(id),
    CONSTRAINT FK_TRABAJADOR_08 FOREIGN KEY (cargo_id) REFERENCES rrhh.cargo(id),
    CONSTRAINT FK_TRABAJADOR_09 FOREIGN KEY (sucursal_id) REFERENCES auth.sucursal(id),
    CONSTRAINT FK_TRABAJADOR_10 FOREIGN KEY (tipo_sangre_id) REFERENCES rrhh.tipo_sangre(id),
    CONSTRAINT FK_TRABAJADOR_11 FOREIGN KEY (distrito_id) REFERENCES core.distrito(id),
    CONSTRAINT FK_TRABAJADOR_12 FOREIGN KEY (tipo_via_id) REFERENCES rrhh.tipo_via(id),
    CONSTRAINT FK_TRABAJADOR_13 FOREIGN KEY (tipo_zona_id) REFERENCES rrhh.tipo_zona(id),
    CONSTRAINT FK_TRABAJADOR_14 FOREIGN KEY (tipo_vivienda_id) REFERENCES rrhh.tipo_vivienda(id),
    CONSTRAINT FK_TRABAJADOR_15 FOREIGN KEY (banco_sueldo_id) REFERENCES finanzas.banco(id),
    CONSTRAINT FK_TRABAJADOR_16 FOREIGN KEY (banco_cts_id) REFERENCES finanzas.banco(id),
    CONSTRAINT FK_TRABAJADOR_17 FOREIGN KEY (moneda_sueldo_id) REFERENCES core.moneda(id),
    CONSTRAINT FK_TRABAJADOR_18 FOREIGN KEY (moneda_cts_id) REFERENCES core.moneda(id),
    CONSTRAINT FK_TRABAJADOR_19 FOREIGN KEY (pension_rtps_id) REFERENCES rrhh.pension_rtps(id),
    CONSTRAINT FK_TRABAJADOR_20 FOREIGN KEY (regimen_pensionario_id) REFERENCES rrhh.regimen_pensionario(id),
    CONSTRAINT FK_TRABAJADOR_21 FOREIGN KEY (tipo_trabajador_id) REFERENCES rrhh.tipo_trabajador(id),
    CONSTRAINT FK_TRABAJADOR_22 FOREIGN KEY (tipo_trabajador_rtps_id) REFERENCES rrhh.tipo_trabajador_rtps(id),
    CONSTRAINT FK_TRABAJADOR_23 FOREIGN KEY (ocupacion_rtps_id) REFERENCES rrhh.ocupacion_rtps(id),
    CONSTRAINT FK_TRABAJADOR_24 FOREIGN KEY (seccion_id) REFERENCES rrhh.seccion(id),
    CONSTRAINT FK_TRABAJADOR_25 FOREIGN KEY (centro_costo_id) REFERENCES contabilidad.centros_costo(id),
    CONSTRAINT FK_TRABAJADOR_26 FOREIGN KEY (motivo_cese_id) REFERENCES rrhh.motivo_cese(id),
    CONSTRAINT CK_TRABAJADOR_FLAG_CAT_TRAB CHECK (flag_cat_trab IN ('1','2','3','4','5'))
);

-- ============================================================
-- SECCIÓN 3: TABLAS DEPENDIENTES
-- ============================================================

CREATE TABLE rrhh.contrato (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    tipo_contrato_id BIGINT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    remuneracion NUMERIC(18, 4),
    asignacion_familiar BOOLEAN NOT NULL DEFAULT FALSE,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CONTRATO PRIMARY KEY (id),
    CONSTRAINT FK_CONTRATO_01 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id),
    CONSTRAINT FK_CONTRATO_02 FOREIGN KEY (tipo_contrato_id) REFERENCES rrhh.tipo_contrato(id)
);

CREATE TABLE rrhh.asistencia (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    fecha DATE NOT NULL,
    hora_entrada TIME,
    hora_salida TIME,
    tipo_mov_asistencia_id BIGINT,
    horas_trabajadas NUMERIC(8, 2),
    horas_extra NUMERIC(8, 2),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_ASISTENCIA PRIMARY KEY (id),
    CONSTRAINT FK_ASISTENCIA_01 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id),
    CONSTRAINT FK_ASISTENCIA_02 FOREIGN KEY (tipo_mov_asistencia_id) REFERENCES rrhh.tipo_mov_asistencia(id)
);

-- Cabecera permiso/licencia (ref. SIGRE RRHH_VACACIONES_TRABAJ): saldo por trabajador, concepto y periodo.
CREATE TABLE rrhh.permiso_licencia (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    concepto_planilla_id BIGINT,
    periodo_inicio INTEGER NOT NULL,
    periodo_fin INTEGER,
    dias_totales INTEGER NOT NULL DEFAULT 0,
    dias_gozados INTEGER NOT NULL DEFAULT 0,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_PERMISO_LICENCIA PRIMARY KEY (id),
    CONSTRAINT FK_PERMISO_LICENCIA_01 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id),
    CONSTRAINT FK_PERMISO_LICENCIA_02 FOREIGN KEY (concepto_planilla_id) REFERENCES rrhh.concepto_planilla(id),
    CONSTRAINT CK_PERMISO_LICENCIA_ESTADO CHECK (flag_estado IN ('0','1','2','3','4','5','6','7','8'))
    -- 1=Solicitado, 2=Aprobado, 3=Observado, 4=Anulado, 5=Cerrado,
    -- 6=Procesado, 7=En Planilla, 8=Ref.Boleta, 0=Rechazado
);

-- Detalle por tramos (ref. SIGRE RRHH_VACAC_TRABAJ_DET + campos operativos de INASISTENCIA).
CREATE TABLE rrhh.permiso_licencia_det (
    id BIGSERIAL NOT NULL,
    permiso_licencia_id BIGINT NOT NULL,
    item INTEGER NOT NULL,
    tipo_suspension_laboral_id BIGINT,
    tipo_doc_identidad_id BIGINT,
    numero_documento VARCHAR(30),
    periodo_inicio INTEGER,
    mes_periodo INTEGER,
    fecha_solicitud DATE NOT NULL DEFAULT CURRENT_DATE,
    fecha_movimiento DATE,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    dias NUMERIC(4, 2) NOT NULL DEFAULT 0,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_PERMISO_LICENCIA_DET PRIMARY KEY (id),
    CONSTRAINT UQ_PERMISO_LICENCIA_DET UNIQUE (permiso_licencia_id, item),
    CONSTRAINT FK_PERMISO_LICENCIA_DET_01 FOREIGN KEY (permiso_licencia_id) REFERENCES rrhh.permiso_licencia(id) ON DELETE CASCADE,
    CONSTRAINT FK_PERMISO_LICENCIA_DET_02 FOREIGN KEY (tipo_suspension_laboral_id) REFERENCES rrhh.tipo_suspension_laboral(id),
    CONSTRAINT FK_PERMISO_LICENCIA_DET_03 FOREIGN KEY (tipo_doc_identidad_id) REFERENCES core.tipo_doc_identidad(id)
);

-- Adaptado de SIGRE INASISTENCIA (CANTABRIA.INASISTENCIA):
-- cod_trabajador→trabajador_id, concep→concepto_planilla_id, fec_desde/hasta/movim,
-- dias_inasist, cod_usr→created_by, flag_vacac_adelantadas, importe
CREATE TABLE rrhh.inasistencia (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    concepto_planilla_id BIGINT,
    fecha_desde DATE NOT NULL,
    fecha_hasta DATE,
    fecha_movimiento DATE,
    dias_inasistencia NUMERIC(4, 2) NOT NULL DEFAULT 0,
    flag_vacaciones_adelantadas VARCHAR(1) NOT NULL DEFAULT '0',
    importe NUMERIC(18, 4) NOT NULL DEFAULT 0,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_INASISTENCIA PRIMARY KEY (id),
    CONSTRAINT FK_INASISTENCIA_01 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id),
    CONSTRAINT FK_INASISTENCIA_02 FOREIGN KEY (concepto_planilla_id) REFERENCES rrhh.concepto_planilla(id),
    CONSTRAINT CK_INASISTENCIA_ESTADO CHECK (flag_estado IN ('0','1','2','3','4'))
    -- 1=Registrado/Pendiente, 2=Justificada, 3=Injustificada, 4=Descanso médico, 0=Anulada
);

CREATE TABLE rrhh.vacacion (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    periodo_anio INTEGER NOT NULL,
    dias_derecho INTEGER NOT NULL DEFAULT 30,
    dias_gozados INTEGER NOT NULL DEFAULT 0,
    dias_pendientes INTEGER NOT NULL DEFAULT 30,
    fecha_inicio DATE,
    fecha_fin DATE,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_VACACION PRIMARY KEY (id),
    CONSTRAINT FK_VACACION_01 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id),
    CONSTRAINT CK_VACACION_ESTADO CHECK (flag_estado IN ('0','1','2','3','4','5'))
    -- 0=Anulado, 1=Registrado, 2=Pendiente(solicitado goce),
    -- 3=Aprobado, 4=Rechazado, 5=Cerrado
);

-- Liquidación de beneficios sociales (cese). SIGRE: LIQUIDACION_BENEF (LBS).
-- No confundir con finanzas.liquidacion (SIGRE: LIQUIDACION = rendición orden de giro).
CREATE TABLE rrhh.liquidacion_benef (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    fecha_cese DATE NOT NULL,
    cts_pendiente NUMERIC(18, 4) DEFAULT 0,
    vacaciones_truncas NUMERIC(18, 4) DEFAULT 0,
    gratificacion_trunca NUMERIC(18, 4) DEFAULT 0,
    indemnizacion NUMERIC(18, 4) DEFAULT 0,
    total_beneficios NUMERIC(18, 4) DEFAULT 0,
    total_descuentos NUMERIC(18, 4) DEFAULT 0,
    neto_pagar NUMERIC(18, 4) DEFAULT 0,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_LIQUIDACION_BENEF PRIMARY KEY (id),
    CONSTRAINT FK_LIQUIDACION_BENEF_01 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id)
);

CREATE TABLE rrhh.prestamo (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    monto_total NUMERIC(18, 4) NOT NULL,
    cuotas INTEGER NOT NULL,
    cuota_mensual NUMERIC(18, 4),
    saldo NUMERIC(18, 4),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_PRESTAMO PRIMARY KEY (id),
    CONSTRAINT FK_PRESTAMO_01 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id)
);

-- Documento de cuenta corriente del trabajador (préstamo/adelanto). SIGRE: CNTA_CRRTE.
CREATE TABLE rrhh.cnta_crrte (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    doc_tipo_id BIGINT NOT NULL,
    nro_doc VARCHAR(20) NOT NULL,
    cntas_pagar_id BIGINT,
    cntas_cobrar_id BIGINT,
    concepto_planilla_id BIGINT NOT NULL,
    fec_prestamo DATE NOT NULL,
    fecha_inicio_descuento DATE,
    nro_cuotas SMALLINT NOT NULL DEFAULT 1,
    monto_original NUMERIC(18, 5) NOT NULL DEFAULT 0,
    monto_cuota NUMERIC(18, 5) NOT NULL DEFAULT 0,
    saldo_prestamo NUMERIC(18, 5) NOT NULL DEFAULT 0,
    moneda_id BIGINT,
    entidad_contribuyente_id BIGINT,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CNTA_CRRTE PRIMARY KEY (id),
    CONSTRAINT FK_CNTA_CRRTE_01 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id),
    CONSTRAINT FK_CNTA_CRRTE_02 FOREIGN KEY (concepto_planilla_id) REFERENCES rrhh.concepto_planilla(id),
    CONSTRAINT FK_CNTA_CRRTE_03 FOREIGN KEY (moneda_id) REFERENCES core.moneda(id),
    CONSTRAINT FK_CNTA_CRRTE_04 FOREIGN KEY (entidad_contribuyente_id) REFERENCES core.entidad_contribuyente(id),
    CONSTRAINT FK_CNTA_CRRTE_05 FOREIGN KEY (doc_tipo_id) REFERENCES core.doc_tipo(id),
    CONSTRAINT FK_CNTA_CRRTE_06 FOREIGN KEY (cntas_pagar_id) REFERENCES finanzas.cntas_pagar(id),
    CONSTRAINT FK_CNTA_CRRTE_07 FOREIGN KEY (cntas_cobrar_id) REFERENCES ventas.cntas_cobrar(id),
    CONSTRAINT UQ_CNTA_CRRTE_DOC UNIQUE (trabajador_id, doc_tipo_id, nro_doc)
);

CREATE TABLE rrhh.horario_trabajador (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    turno_id BIGINT NOT NULL,
    fecha_desde DATE NOT NULL,
    fecha_hasta DATE,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_HORARIO_TRABAJADOR PRIMARY KEY (id),
    CONSTRAINT FK_HORARIO_TRABAJADOR_01 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id),
    CONSTRAINT FK_HORARIO_TRABAJADOR_02 FOREIGN KEY (turno_id) REFERENCES rrhh.turno(id)
);

CREATE TABLE rrhh.evaluacion_desempeno (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    periodo_anio INTEGER NOT NULL,
    periodo_semestre INTEGER,
    calificacion NUMERIC(8, 2),
    observaciones TEXT,
    evaluador_id BIGINT,
    fecha_evaluacion DATE,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_EVALUACION_DESEMPENO PRIMARY KEY (id),
    CONSTRAINT FK_EVALUACION_DESEMPENO_01 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id)
);

CREATE TABLE rrhh.capacitacion_trabajador (
    id BIGSERIAL NOT NULL,
    capacitacion_id BIGINT NOT NULL,
    trabajador_id BIGINT NOT NULL,
    asistio BOOLEAN NOT NULL DEFAULT FALSE,
    calificacion NUMERIC(8, 2),
    certificado BOOLEAN NOT NULL DEFAULT FALSE,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CAPACITACION_TRABAJADOR PRIMARY KEY (id),
    CONSTRAINT FK_CAPACITACION_TRABAJADOR_01 FOREIGN KEY (capacitacion_id) REFERENCES rrhh.capacitacion(id),
    CONSTRAINT FK_CAPACITACION_TRABAJADOR_02 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id)
);

CREATE TABLE rrhh.sancion_amonestacion (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    tipo_sancion_id BIGINT NOT NULL,
    fecha DATE NOT NULL,
    motivo TEXT,
    documento VARCHAR(60),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_SANCION_AMONESTACION PRIMARY KEY (id),
    CONSTRAINT FK_SANCION_AMONESTACION_01 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id),
    CONSTRAINT FK_SANCION_AMONESTACION_02 FOREIGN KEY (tipo_sancion_id) REFERENCES rrhh.tipo_sancion(id)
);

CREATE TABLE rrhh.control_subsidio (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    tipo_subsidio_id BIGINT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    dias INTEGER,
    monto_subsidio NUMERIC(18, 4),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CONTROL_SUBSIDIO PRIMARY KEY (id),
    CONSTRAINT FK_CONTROL_SUBSIDIO_01 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id),
    CONSTRAINT FK_CONTROL_SUBSIDIO_02 FOREIGN KEY (tipo_subsidio_id) REFERENCES rrhh.tipo_subsidio(id)
);

CREATE TABLE rrhh.gan_desct_fijo (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    concepto_id BIGINT NOT NULL,
    imp_gan_desc NUMERIC(18, 4),
    porcentaje NUMERIC(8, 4),
    imp_max_gan_desc NUMERIC(18, 4),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_GAN_DESCT_FIJO PRIMARY KEY (id),
    CONSTRAINT FK_GAN_DESCT_FIJO_01 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id),
    CONSTRAINT FK_GAN_DESCT_FIJO_02 FOREIGN KEY (concepto_id) REFERENCES rrhh.concepto_planilla(id)
);

CREATE TABLE rrhh.gan_desct_variable (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    fec_movim DATE NOT NULL,
    concepto_id BIGINT NOT NULL,
    nro_doc VARCHAR(30),
    imp_var NUMERIC(18, 4),
    centros_costo_id BIGINT,
    cant_labor NUMERIC(18, 4),
    nro_dias NUMERIC(8, 2),
    nro_horas NUMERIC(8, 2),
    nro_cuotas INTEGER,
    tipo_planilla_id BIGINT,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_GAN_DESCT_VARIABLE PRIMARY KEY (id),
    CONSTRAINT FK_GAN_DESCT_VARIABLE_01 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id),
    CONSTRAINT FK_GAN_DESCT_VARIABLE_02 FOREIGN KEY (concepto_id) REFERENCES rrhh.concepto_planilla(id),
    CONSTRAINT FK_GAN_DESCT_VARIABLE_03 FOREIGN KEY (tipo_planilla_id) REFERENCES rrhh.tipo_planilla(id)
);

CREATE TABLE rrhh.program_vacacion (
    id BIGSERIAL PRIMARY KEY,
    trabajador_id BIGINT NOT NULL REFERENCES rrhh.trabajador(id),
    anio INTEGER NOT NULL,
    mes INTEGER NOT NULL,
    dias_programados INTEGER NOT NULL,
    observacion VARCHAR(250),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE rrhh.novedad_rrhh (
    id BIGSERIAL PRIMARY KEY,
    trabajador_id BIGINT NOT NULL REFERENCES rrhh.trabajador(id),
    tipo_novedad_rrhh_id BIGINT NOT NULL REFERENCES rrhh.tipo_novedad_rrhh(id),
    citt VARCHAR(40),
    fecha_ini DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    dias_teoricos INTEGER,
    dias_reales INTEGER,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

-- SIGRE: ADELANTO_QUINCENA — descuento adelanto quincena por trabajador y concepto.
-- PK SIGRE: (cod_trabajador, concep, fec_proceso). PostgreSQL: id + UQ natural.
-- Usado por usp_rh_cal_add_diferi_quincena → inserta en gan_desct_variable.
CREATE TABLE rrhh.adelanto_quincena (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    concepto_planilla_id BIGINT NOT NULL,
    fec_proceso DATE NOT NULL,
    imp_adelanto NUMERIC(13, 2) NOT NULL DEFAULT 0,
    flag_replicacion VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_ADELANTO_QUINCENA PRIMARY KEY (id),
    CONSTRAINT FK_ADELANTO_QUINCENA_01 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id),
    CONSTRAINT FK_ADELANTO_QUINCENA_02 FOREIGN KEY (concepto_planilla_id) REFERENCES rrhh.concepto_planilla(id),
    CONSTRAINT UQ_ADELANTO_QUINCENA UNIQUE (trabajador_id, concepto_planilla_id, fec_proceso)
);
CREATE INDEX IX_ADELANTO_QUINCENA_01 ON rrhh.adelanto_quincena (trabajador_id, fec_proceso);

-- SIGRE: JUDICIAL — retención judicial por alimentista (porcentaje/importe fijo por concepto).
-- PK SIGRE: (cod_trabajador, concep, secuencia). PostgreSQL: id + UQ natural.
CREATE TABLE rrhh.retencion_judicial (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    concepto_planilla_id BIGINT NOT NULL,
    secuencia SMALLINT NOT NULL,
    flag_estado VARCHAR(1) DEFAULT '1',
    porcentaje NUMERIC(4, 2) DEFAULT 0,
    nom_pension VARCHAR(200),
    importe NUMERIC(13, 2) DEFAULT 0,
    entidad_contribuyente_id BIGINT,
    flag_replicacion VARCHAR(1) NOT NULL DEFAULT '1',
    nro_cnta_ahorro VARCHAR(16),
    porc_utilidad NUMERIC(4, 2) NOT NULL DEFAULT 0,
    banco_id BIGINT,
    porc_cts NUMERIC(4, 2) NOT NULL DEFAULT 0,
    porc_grati NUMERIC(4, 2) NOT NULL DEFAULT 0,
    porc_vac NUMERIC(4, 2) NOT NULL DEFAULT 0,
    imp_fijo_grati NUMERIC(13, 2) NOT NULL DEFAULT 0,
    imp_fijo_bonif NUMERIC(13, 2) NOT NULL DEFAULT 0,
    imp_fijo_vaca NUMERIC(13, 2) NOT NULL DEFAULT 0,
    imp_fijo_cts NUMERIC(13, 2) NOT NULL DEFAULT 0,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_RETENCION_JUDICIAL PRIMARY KEY (id),
    CONSTRAINT UQ_RETENCION_JUDICIAL_NATURAL UNIQUE (trabajador_id, concepto_planilla_id, secuencia),
    CONSTRAINT FK_RETENCION_JUDICIAL_01 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id),
    CONSTRAINT FK_RETENCION_JUDICIAL_02 FOREIGN KEY (concepto_planilla_id) REFERENCES rrhh.concepto_planilla(id),
    CONSTRAINT FK_RETENCION_JUDICIAL_03 FOREIGN KEY (entidad_contribuyente_id) REFERENCES core.entidad_contribuyente(id),
    CONSTRAINT FK_RETENCION_JUDICIAL_04 FOREIGN KEY (banco_id) REFERENCES finanzas.banco(id)
);
CREATE INDEX IX_RETENCION_JUDICIAL_01 ON rrhh.retencion_judicial (trabajador_id, flag_estado);

-- SIGRE: CALCULO_JUDICIAL — detalle calculado de descuento judicial por proceso.
-- PK SIGRE: (cod_trabajador, concep, secuencia, fec_proceso). PostgreSQL: id + UQ natural.
CREATE TABLE rrhh.calculo_judicial (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    concepto_planilla_id BIGINT NOT NULL,
    secuencia SMALLINT NOT NULL,
    fec_proceso DATE NOT NULL,
    imp_dolar NUMERIC(15, 4) NOT NULL DEFAULT 0,
    imp_soles NUMERIC(15, 4) NOT NULL DEFAULT 0,
    imp_bruto NUMERIC(15, 4) NOT NULL DEFAULT 0,
    sucursal_id BIGINT,
    tipo_trabajador_id BIGINT NOT NULL,
    tipo_planilla_id BIGINT NOT NULL,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CALCULO_JUDICIAL PRIMARY KEY (id),
    CONSTRAINT UQ_CALCULO_JUDICIAL_NATURAL UNIQUE (trabajador_id, concepto_planilla_id, secuencia, fec_proceso),
    CONSTRAINT FK_CALCULO_JUDICIAL_01 FOREIGN KEY (trabajador_id, concepto_planilla_id, secuencia)
        REFERENCES rrhh.retencion_judicial (trabajador_id, concepto_planilla_id, secuencia),
    CONSTRAINT FK_CALCULO_JUDICIAL_02 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id),
    CONSTRAINT FK_CALCULO_JUDICIAL_03 FOREIGN KEY (concepto_planilla_id) REFERENCES rrhh.concepto_planilla(id),
    CONSTRAINT FK_CALCULO_JUDICIAL_04 FOREIGN KEY (sucursal_id) REFERENCES auth.sucursal(id),
    CONSTRAINT FK_CALCULO_JUDICIAL_05 FOREIGN KEY (tipo_trabajador_id) REFERENCES rrhh.tipo_trabajador(id),
    CONSTRAINT FK_CALCULO_JUDICIAL_06 FOREIGN KEY (tipo_planilla_id) REFERENCES rrhh.tipo_planilla(id)
);
CREATE INDEX IX_CALCULO_JUDICIAL_01 ON rrhh.calculo_judicial (trabajador_id, fec_proceso);

-- SIGRE: GRUPO_CALC_X_SECCION — grupos de cálculo aplicables por sección (p. ej. SENATI).
-- PK SIGRE: (grupo_calculo, cod_area, cod_seccion). PostgreSQL: id + UQ (grupo_calculo_id, seccion_id).
CREATE TABLE rrhh.grupo_conceptos_seccion (
    id BIGSERIAL NOT NULL,
    grupo_calculo_id BIGINT NOT NULL,
    seccion_id BIGINT NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_GRUPO_CONCEPTOS_SECCION PRIMARY KEY (id),
    CONSTRAINT UQ_GRUPO_CONCEPTOS_SECCION UNIQUE (grupo_calculo_id, seccion_id),
    CONSTRAINT FK_GRUPO_CONCEPTOS_SECCION_01 FOREIGN KEY (grupo_calculo_id) REFERENCES rrhh.grupo_calculo(id),
    CONSTRAINT FK_GRUPO_CONCEPTOS_SECCION_02 FOREIGN KEY (seccion_id) REFERENCES rrhh.seccion(id)
);
CREATE INDEX IX_GRUPO_CONCEPTOS_SECCION_01 ON rrhh.grupo_conceptos_seccion (grupo_calculo_id, flag_estado);

-- ============================================================
-- SECCIÓN 4: TABLAS CON DEPENDENCIAS MÚLTIPLES
-- ============================================================

-- Boleta de pagos (cabecera). Una fila por trabajador + fecha proceso + tipo planilla + sucursal.
-- Equivalente SIGRE: agrupa CALCULO.json por (COD_TRABAJADOR, FEC_PROCESO, TIPO_PLANILLA, COD_ORIGEN).
-- SIGRE COD_ORIGEN → sucursal_id (FK auth.sucursal).
-- PK: id (BIGSERIAL). Clave natural SIGRE → UQ_CALCULO_BOLETA (no es PK).
CREATE TABLE rrhh.calculo (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    fec_proceso DATE NOT NULL,
    tipo_planilla_id BIGINT NOT NULL,
    sucursal_id BIGINT,
    tipo_cambio NUMERIC(18, 6) DEFAULT 1,
    admin_afp_id BIGINT NOT NULL,
    dias_trabajados NUMERIC(6, 2) DEFAULT 0,
    total_ingresos_soles NUMERIC(18, 5) DEFAULT 0,
    total_descuentos_soles NUMERIC(18, 5) DEFAULT 0,
    total_neto_soles NUMERIC(18, 5) DEFAULT 0,
    total_aportes_soles NUMERIC(18, 5) DEFAULT 0,
    total_ingresos_dolar NUMERIC(18, 5) DEFAULT 0,
    total_descuentos_dolar NUMERIC(18, 5) DEFAULT 0,
    total_neto_dolar NUMERIC(18, 5) DEFAULT 0,
    total_aportes_dolar NUMERIC(18, 5) DEFAULT 0,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CALCULO PRIMARY KEY (id),
    CONSTRAINT FK_CALCULO_01 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id),
    CONSTRAINT FK_CALCULO_02 FOREIGN KEY (tipo_planilla_id) REFERENCES rrhh.tipo_planilla(id),
    CONSTRAINT FK_CALCULO_03 FOREIGN KEY (sucursal_id) REFERENCES auth.sucursal(id),
    CONSTRAINT FK_CALCULO_04 FOREIGN KEY (admin_afp_id) REFERENCES rrhh.admin_afp(id),
    CONSTRAINT UQ_CALCULO_BOLETA UNIQUE (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id)
);

-- Línea de boleta. SIGRE: fila CALCULO por (trabajador, concep, fec_proceso, tipo_planilla, item).
-- PK: id (BIGSERIAL). Upsert motor por UQ_CALCULO_DET_LINEA (calculo_id, concepto_id, item).
CREATE TABLE rrhh.calculo_det (
    id BIGSERIAL NOT NULL,
    calculo_id BIGINT NOT NULL,
    concepto_id BIGINT NOT NULL,
    item SMALLINT NOT NULL DEFAULT 1,
    centro_costo_id BIGINT,
    entidad_contribuyente_id BIGINT,
    cnta_crrte_id BIGINT,
    doc_tipo_id BIGINT,
    nro_doc_cc VARCHAR(20),
    horas_trabajadas NUMERIC(8, 2) DEFAULT 0,
    horas_pagadas NUMERIC(8, 2) DEFAULT 0,
    dias_trabajados NUMERIC(6, 2) DEFAULT 0,
    imp_soles NUMERIC(18, 5) NOT NULL DEFAULT 0,
    imp_dolar NUMERIC(18, 5) NOT NULL DEFAULT 0,
    tipo_concepto_calculo_id BIGINT NOT NULL,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CALCULO_DET PRIMARY KEY (id),
    CONSTRAINT FK_CALCULO_DET_01 FOREIGN KEY (calculo_id) REFERENCES rrhh.calculo(id),
    CONSTRAINT FK_CALCULO_DET_02 FOREIGN KEY (concepto_id) REFERENCES rrhh.concepto_planilla(id),
    CONSTRAINT FK_CALCULO_DET_03 FOREIGN KEY (tipo_concepto_calculo_id) REFERENCES rrhh.tipo_concepto_calculo(id),
    CONSTRAINT FK_CALCULO_DET_04 FOREIGN KEY (centro_costo_id) REFERENCES contabilidad.centros_costo(id),
    CONSTRAINT FK_CALCULO_DET_05 FOREIGN KEY (entidad_contribuyente_id) REFERENCES core.entidad_contribuyente(id),
    CONSTRAINT FK_CALCULO_DET_06 FOREIGN KEY (cnta_crrte_id) REFERENCES rrhh.cnta_crrte(id),
    CONSTRAINT FK_CALCULO_DET_07 FOREIGN KEY (doc_tipo_id) REFERENCES core.doc_tipo(id),
    CONSTRAINT UQ_CALCULO_DET_LINEA UNIQUE (calculo_id, concepto_id, item)
);

-- Cuota/movimiento del documento de cuenta corriente. SIGRE: CNTA_CRRTE_DETALLE.
CREATE TABLE rrhh.cnta_crrte_det (
    id BIGSERIAL NOT NULL,
    cnta_crrte_id BIGINT NOT NULL,
    nro_dscto SMALLINT NOT NULL DEFAULT 1,
    fecha_movimiento DATE NOT NULL,
    tipo_movimiento_cnta_crrte_id BIGINT NOT NULL,
    imp_dscto NUMERIC(18, 4) NOT NULL,
    flag_digitado VARCHAR(1) NOT NULL DEFAULT '0',
    liquidacion_benef_id BIGINT,
    calculo_det_id BIGINT,
    referencia VARCHAR(120),
    observaciones VARCHAR(120),
    flag_proceso VARCHAR(1),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CNTA_CRRTE_DET PRIMARY KEY (id),
    CONSTRAINT FK_CNTA_CRRTE_DET_01 FOREIGN KEY (cnta_crrte_id) REFERENCES rrhh.cnta_crrte(id),
    CONSTRAINT FK_CNTA_CRRTE_DET_02 FOREIGN KEY (tipo_movimiento_cnta_crrte_id) REFERENCES rrhh.tipo_movimiento_cnta_crrte(id),
    CONSTRAINT FK_CNTA_CRRTE_DET_03 FOREIGN KEY (liquidacion_benef_id) REFERENCES rrhh.liquidacion_benef(id),
    CONSTRAINT FK_CNTA_CRRTE_DET_04 FOREIGN KEY (calculo_det_id) REFERENCES rrhh.calculo_det(id),
    CONSTRAINT UQ_CNTA_CRRTE_DET_CUOTA UNIQUE (cnta_crrte_id, nro_dscto),
    CONSTRAINT CK_CNTA_CRRTE_DET_ESTADO CHECK (flag_estado IN ('0','1','2','3','5','6'))
    -- Segun catalogo global: 0=Anulado, 1=Activo, 2=Cerrado,
    -- 3=Pendiente, 5=Pagado total(Aplicado), 6=En proceso(En Planilla)
);

CREATE TABLE rrhh.novedad_rrhh_det (
    id BIGSERIAL PRIMARY KEY,
    novedad_rrhh_id BIGINT NOT NULL REFERENCES rrhh.novedad_rrhh(id),
    fecha_proceso DATE NOT NULL,
    monto_planilla NUMERIC(18, 4),
    monto_seguro NUMERIC(18, 4),
    referencia_doc VARCHAR(80),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ
);

CREATE TABLE rrhh.gratificacion (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    anio INTEGER NOT NULL,
    periodo_gratificacion_id BIGINT NOT NULL,
    remuneracion_computable NUMERIC(18,4) NOT NULL,
    meses_laborados INTEGER NOT NULL,
    monto_gratificacion NUMERIC(18,4) NOT NULL,
    bonificacion_extraordinaria NUMERIC(18,4) DEFAULT 0,
    total NUMERIC(18,4) NOT NULL,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_GRATIFICACION PRIMARY KEY (id),
    CONSTRAINT FK_GRATIFICACION_01 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id),
    CONSTRAINT FK_GRATIFICACION_02 FOREIGN KEY (periodo_gratificacion_id) REFERENCES rrhh.periodo_gratificacion(id)
);

CREATE TABLE rrhh.cts (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    anio INTEGER NOT NULL,
    periodo_cts_id BIGINT NOT NULL,
    remuneracion_computable NUMERIC(18,4) NOT NULL,
    meses_computables INTEGER NOT NULL,
    dias_computables INTEGER NOT NULL DEFAULT 0,
    monto_cts NUMERIC(18,4) NOT NULL,
    entidad_financiera VARCHAR(120),
    numero_cuenta_cts VARCHAR(30),
    fecha_deposito DATE,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CTS PRIMARY KEY (id),
    CONSTRAINT FK_CTS_01 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id),
    CONSTRAINT FK_CTS_02 FOREIGN KEY (periodo_cts_id) REFERENCES rrhh.periodo_cts(id)
);

DROP TABLE IF EXISTS rrhh.quinta_categoria CASCADE;

-- SIGRE: QUINTA_CATEGORIA — proyección y retención mensual IR por fecha proceso.
-- PK SIGRE: (cod_trabajador, fec_proceso, flag_automatico, tipo_planilla). PostgreSQL: id + UQ natural.
CREATE TABLE rrhh.quinta_categoria (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    fec_proceso DATE NOT NULL,
    rem_proyectable NUMERIC(13, 2) NOT NULL DEFAULT 0,
    rem_imprecisa NUMERIC(13, 2) NOT NULL DEFAULT 0,
    rem_retencion NUMERIC(13, 2) NOT NULL DEFAULT 0,
    rem_gratif NUMERIC(13, 2) NOT NULL DEFAULT 0,
    flag_replicacion VARCHAR(1) NOT NULL DEFAULT '1',
    nro_dias SMALLINT NOT NULL DEFAULT 0,
    sueldo NUMERIC(13, 2) NOT NULL DEFAULT 0,
    flag_automatico VARCHAR(1) NOT NULL DEFAULT '1',
    gratif_proyect NUMERIC(13, 2) NOT NULL DEFAULT 0,
    rem_externa NUMERIC(13, 2) NOT NULL DEFAULT 0,
    tipo_planilla_id BIGINT NOT NULL,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_QUINTA_CATEGORIA PRIMARY KEY (id),
    CONSTRAINT UQ_QUINTA_CATEGORIA_NATURAL UNIQUE (trabajador_id, fec_proceso, flag_automatico, tipo_planilla_id),
    CONSTRAINT FK_QUINTA_CATEGORIA_01 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id),
    CONSTRAINT FK_QUINTA_CATEGORIA_02 FOREIGN KEY (tipo_planilla_id) REFERENCES rrhh.tipo_planilla(id)
);

-- ============================================================
-- SECCIÓN 5: ÍNDICES
-- ============================================================

CREATE INDEX IX_TRABAJADOR_01           ON rrhh.trabajador (entidad_contribuyente_id);
CREATE INDEX IX_TRABAJADOR_02           ON rrhh.trabajador (tipo_doc_identidad_id);
CREATE INDEX IX_TRABAJADOR_03           ON rrhh.trabajador (sexo_id);
CREATE INDEX IX_TRABAJADOR_04           ON rrhh.trabajador (estado_civil_id);
CREATE INDEX IX_TRABAJADOR_05           ON rrhh.trabajador (regimen_laboral_id);
CREATE INDEX IX_TRABAJADOR_06           ON rrhh.trabajador (area_id);
CREATE INDEX IX_TRABAJADOR_07           ON rrhh.trabajador (cargo_id);
CREATE INDEX IX_TRABAJADOR_08           ON rrhh.trabajador (sucursal_id);
CREATE INDEX IX_CONTRATO_01             ON rrhh.contrato (trabajador_id, flag_estado);
CREATE INDEX IX_CONTRATO_02             ON rrhh.contrato (tipo_contrato_id);
CREATE INDEX IX_ASISTENCIA_01           ON rrhh.asistencia (trabajador_id, fecha);
CREATE INDEX IX_ASISTENCIA_02           ON rrhh.asistencia (tipo_mov_asistencia_id);
CREATE INDEX IX_INASISTENCIA_01         ON rrhh.inasistencia (trabajador_id, fecha_desde);
CREATE INDEX IX_INASISTENCIA_02         ON rrhh.inasistencia (concepto_planilla_id);
CREATE INDEX IX_PERMISO_LICENCIA_01     ON rrhh.permiso_licencia (trabajador_id, periodo_inicio);
CREATE INDEX IX_PERMISO_LICENCIA_02     ON rrhh.permiso_licencia (concepto_planilla_id);
CREATE INDEX IX_PERMISO_LICENCIA_DET_01 ON rrhh.permiso_licencia_det (permiso_licencia_id, fecha_inicio);
CREATE INDEX IX_PERMISO_LICENCIA_DET_02 ON rrhh.permiso_licencia_det (tipo_suspension_laboral_id);
CREATE INDEX IX_CALCULO_01              ON rrhh.calculo (trabajador_id, fec_proceso, tipo_planilla_id);
CREATE INDEX IX_CALCULO_03              ON rrhh.calculo (sucursal_id);
CREATE INDEX IX_CALCULO_DET_01          ON rrhh.calculo_det (calculo_id);
CREATE INDEX IX_CALCULO_DET_02          ON rrhh.calculo_det (concepto_id);
CREATE INDEX IX_CALCULO_DET_03          ON rrhh.calculo_det (centro_costo_id);
CREATE INDEX IX_CALCULO_DET_04          ON rrhh.calculo_det (cnta_crrte_id);
CREATE INDEX IX_GAN_DESCT_FIJO_01       ON rrhh.gan_desct_fijo (trabajador_id, concepto_id);
CREATE INDEX IX_GAN_DESCT_VARIABLE_01   ON rrhh.gan_desct_variable (trabajador_id, fec_movim);
CREATE INDEX IX_GAN_DESCT_VARIABLE_02   ON rrhh.gan_desct_variable (concepto_id);
CREATE INDEX IX_GAN_DESCT_VARIABLE_03   ON rrhh.gan_desct_variable (tipo_planilla_id);
CREATE INDEX IX_GRUPO_CALCULO_01           ON rrhh.grupo_calculo (codigo);
CREATE INDEX IX_GRUPO_CALCULO_DET_01       ON rrhh.grupo_calculo_det (grupo_calculo_id);
CREATE INDEX IX_GRUPO_CALCULO_DET_02       ON rrhh.grupo_calculo_det (concepto_planilla_id);
CREATE INDEX IX_IMPUESTO_RENTA_TRAMOS_01  ON rrhh.impuesto_renta_tramos (fecha_vig_ini, secuencia);
CREATE INDEX IX_VACACION_01             ON rrhh.vacacion (trabajador_id, periodo_anio);
CREATE INDEX IX_LIQUIDACION_BENEF_01   ON rrhh.liquidacion_benef (trabajador_id, fecha_cese);
CREATE INDEX IX_PRESTAMO_01             ON rrhh.prestamo (trabajador_id, flag_estado);
CREATE INDEX IX_CNTA_CRRTE_01           ON rrhh.cnta_crrte (trabajador_id);
CREATE INDEX IX_CNTA_CRRTE_02           ON rrhh.cnta_crrte (trabajador_id, doc_tipo_id, nro_doc);
CREATE INDEX IX_CNTA_CRRTE_DET_01       ON rrhh.cnta_crrte_det (cnta_crrte_id, fecha_movimiento);
CREATE INDEX IX_CNTA_CRRTE_DET_02       ON rrhh.cnta_crrte_det (calculo_det_id);
CREATE INDEX IX_HORARIO_TRABAJADOR_01   ON rrhh.horario_trabajador (trabajador_id, turno_id);
CREATE INDEX IX_EVALUACION_DESEMPENO_01 ON rrhh.evaluacion_desempeno (trabajador_id, periodo_anio);
CREATE INDEX IX_CAPACITACION_TRABAJADOR_01 ON rrhh.capacitacion_trabajador (capacitacion_id, trabajador_id);
CREATE INDEX IX_SANCION_AMONESTACION_01 ON rrhh.sancion_amonestacion (trabajador_id, fecha);
CREATE INDEX IX_SANCION_AMONESTACION_02 ON rrhh.sancion_amonestacion (tipo_sancion_id);
CREATE INDEX IX_CONTROL_SUBSIDIO_01     ON rrhh.control_subsidio (trabajador_id, tipo_subsidio_id);
CREATE INDEX IX_NOVEDAD_RRHH_01         ON rrhh.novedad_rrhh (trabajador_id, fecha_ini, fecha_fin);
CREATE INDEX IX_GRATIFICACION_01        ON rrhh.gratificacion (trabajador_id, anio);
CREATE INDEX IX_GRATIFICACION_02        ON rrhh.gratificacion (periodo_gratificacion_id);
CREATE INDEX IX_CTS_01                  ON rrhh.cts (trabajador_id, anio);
CREATE INDEX IX_CTS_02                  ON rrhh.cts (periodo_cts_id);
CREATE INDEX IX_QUINTA_CATEGORIA_01     ON rrhh.quinta_categoria (trabajador_id, fec_proceso);
CREATE INDEX IX_QUINTA_CATEGORIA_02     ON rrhh.quinta_categoria (tipo_planilla_id, fec_proceso);

-- Migración idempotente: columnas SIGRE TIPO_TRABAJADOR (libro_int_remun/grati/cts)
ALTER TABLE rrhh.tipo_trabajador ADD COLUMN IF NOT EXISTS libro_prov_remuneracion INTEGER;
ALTER TABLE rrhh.tipo_trabajador ADD COLUMN IF NOT EXISTS libro_prov_gratificacion INTEGER;
ALTER TABLE rrhh.tipo_trabajador ADD COLUMN IF NOT EXISTS libro_prov_cts INTEGER;

-- Migración idempotente: columna estado (texto legado) → flag_estado
ALTER TABLE rrhh.capacitacion DROP COLUMN IF EXISTS estado;
ALTER TABLE rrhh.capacitacion ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE rrhh.contrato DROP COLUMN IF EXISTS estado;
ALTER TABLE rrhh.contrato ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE rrhh.permiso_licencia DROP COLUMN IF EXISTS estado;
ALTER TABLE rrhh.permiso_licencia ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE rrhh.vacacion DROP COLUMN IF EXISTS estado;
ALTER TABLE rrhh.vacacion ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'rrhh' AND table_name = 'liquidacion')
       AND NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'rrhh' AND table_name = 'liquidacion_benef')
    THEN ALTER TABLE rrhh.liquidacion RENAME TO liquidacion_benef;
    END IF;
END $$;
ALTER TABLE rrhh.liquidacion_benef DROP COLUMN IF EXISTS estado;
ALTER TABLE rrhh.liquidacion_benef ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE rrhh.prestamo DROP COLUMN IF EXISTS estado;
ALTER TABLE rrhh.prestamo ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE rrhh.cnta_crrte DROP COLUMN IF EXISTS estado;
ALTER TABLE rrhh.cnta_crrte ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE rrhh.sancion_amonestacion DROP COLUMN IF EXISTS estado;
ALTER TABLE rrhh.sancion_amonestacion ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE rrhh.control_subsidio DROP COLUMN IF EXISTS estado;
ALTER TABLE rrhh.control_subsidio ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE rrhh.gan_desct_fijo DROP COLUMN IF EXISTS estado;
ALTER TABLE rrhh.gan_desct_fijo ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE rrhh.asistencia DROP COLUMN IF EXISTS estado;
ALTER TABLE rrhh.asistencia ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE rrhh.evaluacion_desempeno DROP COLUMN IF EXISTS estado;
ALTER TABLE rrhh.evaluacion_desempeno ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE rrhh.capacitacion_trabajador DROP COLUMN IF EXISTS estado;
ALTER TABLE rrhh.capacitacion_trabajador ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE rrhh.cnta_crrte_det DROP COLUMN IF EXISTS estado;
ALTER TABLE rrhh.cnta_crrte_det ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';

-- Idempotente: eliminar tabla obsoleta boleta_pago
DROP INDEX IF EXISTS rrhh.ix_boleta_pago_01;
DROP INDEX IF EXISTS rrhh.ix_boleta_pago_02;
DROP TABLE IF EXISTS rrhh.boleta_pago CASCADE;

-- Migración idempotente: maestros RRHH sin flag_estado
ALTER TABLE rrhh.area ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE rrhh.cargo ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE rrhh.admin_afp ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE rrhh.turno ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE rrhh.concepto_planilla ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';

-- Migración idempotente: catálogos VARCHAR → FK (legado sin tablas maestro) — contrato, asistencia, etc.
ALTER TABLE rrhh.contrato DROP COLUMN IF EXISTS tipo;
ALTER TABLE rrhh.contrato ADD COLUMN IF NOT EXISTS tipo_contrato_id BIGINT;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_contrato_tipo_contrato')
    THEN ALTER TABLE rrhh.contrato ADD CONSTRAINT fk_contrato_tipo_contrato FOREIGN KEY (tipo_contrato_id) REFERENCES rrhh.tipo_contrato(id); END IF; END $$;

ALTER TABLE rrhh.asistencia DROP COLUMN IF EXISTS tipo_marca;
ALTER TABLE rrhh.asistencia ADD COLUMN IF NOT EXISTS tipo_mov_asistencia_id BIGINT;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_asistencia_tipo_mov')
    THEN ALTER TABLE rrhh.asistencia ADD CONSTRAINT fk_asistencia_tipo_mov FOREIGN KEY (tipo_mov_asistencia_id) REFERENCES rrhh.tipo_mov_asistencia(id); END IF; END $$;

ALTER TABLE rrhh.permiso_licencia DROP COLUMN IF EXISTS tipo;
ALTER TABLE rrhh.permiso_licencia ADD COLUMN IF NOT EXISTS concepto_planilla_id BIGINT;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_permiso_licencia_concepto')
    THEN ALTER TABLE rrhh.permiso_licencia ADD CONSTRAINT fk_permiso_licencia_concepto
        FOREIGN KEY (concepto_planilla_id) REFERENCES rrhh.concepto_planilla(id); END IF; END $$;
DO $$ BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'rrhh' AND table_name = 'permiso_licencia' AND column_name = 'tipo_suspension_laboral_id'
    ) THEN
        UPDATE rrhh.permiso_licencia_det d SET tipo_suspension_laboral_id = p.tipo_suspension_laboral_id
        FROM rrhh.permiso_licencia p
        WHERE d.permiso_licencia_id = p.id AND d.item = 1
          AND d.tipo_suspension_laboral_id IS NULL AND p.tipo_suspension_laboral_id IS NOT NULL;
        ALTER TABLE rrhh.permiso_licencia DROP CONSTRAINT IF EXISTS fk_permiso_licencia_tipo_susp;
        ALTER TABLE rrhh.permiso_licencia DROP COLUMN IF EXISTS tipo_suspension_laboral_id;
    END IF;
END $$;

ALTER TABLE rrhh.sancion_amonestacion DROP COLUMN IF EXISTS tipo;
ALTER TABLE rrhh.sancion_amonestacion ADD COLUMN IF NOT EXISTS tipo_sancion_id BIGINT;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_sancion_amonestacion_tipo')
    THEN ALTER TABLE rrhh.sancion_amonestacion ADD CONSTRAINT fk_sancion_amonestacion_tipo FOREIGN KEY (tipo_sancion_id) REFERENCES rrhh.tipo_sancion(id); END IF; END $$;

ALTER TABLE rrhh.control_subsidio DROP COLUMN IF EXISTS tipo;
ALTER TABLE rrhh.control_subsidio ADD COLUMN IF NOT EXISTS tipo_subsidio_id BIGINT;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_control_subsidio_tipo')
    THEN ALTER TABLE rrhh.control_subsidio ADD CONSTRAINT fk_control_subsidio_tipo FOREIGN KEY (tipo_subsidio_id) REFERENCES rrhh.tipo_subsidio(id); END IF; END $$;

ALTER TABLE rrhh.calculo DROP COLUMN IF EXISTS tipo;
ALTER TABLE rrhh.calculo ADD COLUMN IF NOT EXISTS trabajador_id BIGINT;
ALTER TABLE rrhh.calculo ADD COLUMN IF NOT EXISTS fec_proceso DATE;
ALTER TABLE rrhh.calculo ADD COLUMN IF NOT EXISTS fec_inicio DATE;
ALTER TABLE rrhh.calculo ADD COLUMN IF NOT EXISTS fec_final DATE;
ALTER TABLE rrhh.calculo ADD COLUMN IF NOT EXISTS sucursal_id BIGINT;
ALTER TABLE rrhh.calculo ADD COLUMN IF NOT EXISTS tipo_cambio NUMERIC(18, 6) DEFAULT 1;
ALTER TABLE rrhh.calculo ADD COLUMN IF NOT EXISTS dias_trabajados NUMERIC(6, 2) DEFAULT 0;
ALTER TABLE rrhh.calculo ADD COLUMN IF NOT EXISTS periodo VARCHAR(9);
ALTER TABLE rrhh.calculo ADD COLUMN IF NOT EXISTS flag_replicacion VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE rrhh.calculo ADD COLUMN IF NOT EXISTS total_ingresos_soles NUMERIC(18, 5) DEFAULT 0;
ALTER TABLE rrhh.calculo ADD COLUMN IF NOT EXISTS total_descuentos_soles NUMERIC(18, 5) DEFAULT 0;
ALTER TABLE rrhh.calculo ADD COLUMN IF NOT EXISTS total_neto_soles NUMERIC(18, 5) DEFAULT 0;
ALTER TABLE rrhh.calculo ADD COLUMN IF NOT EXISTS total_aportes_soles NUMERIC(18, 5) DEFAULT 0;
ALTER TABLE rrhh.calculo ADD COLUMN IF NOT EXISTS total_ingresos_dolar NUMERIC(18, 5) DEFAULT 0;
ALTER TABLE rrhh.calculo ADD COLUMN IF NOT EXISTS total_descuentos_dolar NUMERIC(18, 5) DEFAULT 0;
ALTER TABLE rrhh.calculo ADD COLUMN IF NOT EXISTS total_neto_dolar NUMERIC(18, 5) DEFAULT 0;
ALTER TABLE rrhh.calculo ADD COLUMN IF NOT EXISTS total_aportes_dolar NUMERIC(18, 5) DEFAULT 0;
ALTER TABLE rrhh.calculo ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE rrhh.calculo ADD COLUMN IF NOT EXISTS tipo_planilla_id BIGINT;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_calculo_trabajador')
    THEN ALTER TABLE rrhh.calculo ADD CONSTRAINT fk_calculo_trabajador FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_calculo_tipo_planilla')
    THEN ALTER TABLE rrhh.calculo ADD CONSTRAINT fk_calculo_tipo_planilla FOREIGN KEY (tipo_planilla_id) REFERENCES rrhh.tipo_planilla(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_calculo_sucursal')
    THEN ALTER TABLE rrhh.calculo ADD CONSTRAINT fk_calculo_sucursal FOREIGN KEY (sucursal_id) REFERENCES auth.sucursal(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='uq_calculo_boleta')
    THEN ALTER TABLE rrhh.calculo ADD CONSTRAINT uq_calculo_boleta UNIQUE (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id); END IF; END $$;

ALTER TABLE rrhh.calculo_det DROP COLUMN IF EXISTS tipo;
ALTER TABLE rrhh.calculo_det DROP COLUMN IF EXISTS trabajador_id;
ALTER TABLE rrhh.calculo_det DROP COLUMN IF EXISTS monto;
ALTER TABLE rrhh.calculo_det ADD COLUMN IF NOT EXISTS item SMALLINT NOT NULL DEFAULT 1;
ALTER TABLE rrhh.calculo_det ADD COLUMN IF NOT EXISTS centro_costo_id BIGINT;
ALTER TABLE rrhh.calculo_det ADD COLUMN IF NOT EXISTS entidad_contribuyente_id BIGINT;
ALTER TABLE rrhh.calculo_det ADD COLUMN IF NOT EXISTS cnta_crrte_id BIGINT;
ALTER TABLE rrhh.calculo_det ADD COLUMN IF NOT EXISTS cnta_crrte_det_id BIGINT;
ALTER TABLE rrhh.calculo_det DROP COLUMN IF EXISTS tipo_doc_cc;
ALTER TABLE rrhh.calculo_det ADD COLUMN IF NOT EXISTS doc_tipo_id BIGINT;
ALTER TABLE rrhh.calculo_det ADD COLUMN IF NOT EXISTS nro_doc_cc VARCHAR(20);
ALTER TABLE rrhh.calculo_det ADD COLUMN IF NOT EXISTS horas_trabajadas NUMERIC(8, 2) DEFAULT 0;
ALTER TABLE rrhh.calculo_det ADD COLUMN IF NOT EXISTS horas_pagadas NUMERIC(8, 2) DEFAULT 0;
ALTER TABLE rrhh.calculo_det ADD COLUMN IF NOT EXISTS dias_trabajados NUMERIC(6, 2) DEFAULT 0;
ALTER TABLE rrhh.calculo_det ADD COLUMN IF NOT EXISTS imp_soles NUMERIC(18, 5) NOT NULL DEFAULT 0;
ALTER TABLE rrhh.calculo_det ADD COLUMN IF NOT EXISTS imp_dolar NUMERIC(18, 5) NOT NULL DEFAULT 0;
ALTER TABLE rrhh.calculo_det ADD COLUMN IF NOT EXISTS pesca_capturada NUMERIC(12, 4) NOT NULL DEFAULT 0;
ALTER TABLE rrhh.calculo_det ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE rrhh.calculo_det ADD COLUMN IF NOT EXISTS tipo_concepto_calculo_id BIGINT;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_calculo_det_tipo_concepto')
    THEN ALTER TABLE rrhh.calculo_det ADD CONSTRAINT fk_calculo_det_tipo_concepto FOREIGN KEY (tipo_concepto_calculo_id) REFERENCES rrhh.tipo_concepto_calculo(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_calculo_det_centro_costo')
    THEN ALTER TABLE rrhh.calculo_det ADD CONSTRAINT fk_calculo_det_centro_costo FOREIGN KEY (centro_costo_id) REFERENCES contabilidad.centros_costo(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_calculo_det_entidad')
    THEN ALTER TABLE rrhh.calculo_det ADD CONSTRAINT fk_calculo_det_entidad FOREIGN KEY (entidad_contribuyente_id) REFERENCES core.entidad_contribuyente(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_calculo_det_cnta_crrte')
    THEN ALTER TABLE rrhh.calculo_det ADD CONSTRAINT fk_calculo_det_cnta_crrte FOREIGN KEY (cnta_crrte_id) REFERENCES rrhh.cnta_crrte(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_calculo_det_doc_tipo')
    THEN ALTER TABLE rrhh.calculo_det ADD CONSTRAINT fk_calculo_det_doc_tipo FOREIGN KEY (doc_tipo_id) REFERENCES core.doc_tipo(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='uq_calculo_det_linea')
    THEN ALTER TABLE rrhh.calculo_det ADD CONSTRAINT uq_calculo_det_linea UNIQUE (calculo_id, concepto_id, item); END IF; END $$;

-- Legacy QA: tablas calculo_referencia / calculo_det_referencia eliminadas
DROP TABLE IF EXISTS rrhh.calculo_det_referencia CASCADE;
DROP TABLE IF EXISTS rrhh.calculo_referencia CASCADE;
DROP FUNCTION IF EXISTS rrhh.fn_validar_calculo_referencia(VARCHAR, DATE, BIGINT, NUMERIC);

ALTER TABLE rrhh.cnta_crrte ADD COLUMN IF NOT EXISTS doc_tipo_id BIGINT;
ALTER TABLE rrhh.cnta_crrte ADD COLUMN IF NOT EXISTS nro_doc VARCHAR(20);
ALTER TABLE rrhh.cnta_crrte ADD COLUMN IF NOT EXISTS cntas_pagar_id BIGINT;
ALTER TABLE rrhh.cnta_crrte ADD COLUMN IF NOT EXISTS cntas_cobrar_id BIGINT;
ALTER TABLE rrhh.cnta_crrte ADD COLUMN IF NOT EXISTS concepto_planilla_id BIGINT;
ALTER TABLE rrhh.cnta_crrte ADD COLUMN IF NOT EXISTS fec_prestamo DATE;
ALTER TABLE rrhh.cnta_crrte ADD COLUMN IF NOT EXISTS fecha_inicio_descuento DATE;
ALTER TABLE rrhh.cnta_crrte ADD COLUMN IF NOT EXISTS nro_cuotas SMALLINT NOT NULL DEFAULT 1;
ALTER TABLE rrhh.cnta_crrte ADD COLUMN IF NOT EXISTS monto_original NUMERIC(18, 5) NOT NULL DEFAULT 0;
ALTER TABLE rrhh.cnta_crrte ADD COLUMN IF NOT EXISTS monto_cuota NUMERIC(18, 5) NOT NULL DEFAULT 0;
ALTER TABLE rrhh.cnta_crrte ADD COLUMN IF NOT EXISTS saldo_prestamo NUMERIC(18, 5) NOT NULL DEFAULT 0;
ALTER TABLE rrhh.cnta_crrte ADD COLUMN IF NOT EXISTS moneda_id BIGINT;
ALTER TABLE rrhh.cnta_crrte ADD COLUMN IF NOT EXISTS entidad_contribuyente_id BIGINT;
ALTER TABLE rrhh.cnta_crrte DROP COLUMN IF EXISTS tipo_doc;
ALTER TABLE rrhh.cnta_crrte DROP COLUMN IF EXISTS fecha_apertura;
ALTER TABLE rrhh.cnta_crrte DROP COLUMN IF EXISTS saldo_inicial;
ALTER TABLE rrhh.cnta_crrte DROP COLUMN IF EXISTS saldo_actual;
ALTER TABLE rrhh.cnta_crrte DROP COLUMN IF EXISTS flag_replicacion;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cnta_crrte_concepto')
    THEN ALTER TABLE rrhh.cnta_crrte ADD CONSTRAINT fk_cnta_crrte_concepto FOREIGN KEY (concepto_planilla_id) REFERENCES rrhh.concepto_planilla(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cnta_crrte_moneda')
    THEN ALTER TABLE rrhh.cnta_crrte ADD CONSTRAINT fk_cnta_crrte_moneda FOREIGN KEY (moneda_id) REFERENCES core.moneda(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cnta_crrte_entidad')
    THEN ALTER TABLE rrhh.cnta_crrte ADD CONSTRAINT fk_cnta_crrte_entidad FOREIGN KEY (entidad_contribuyente_id) REFERENCES core.entidad_contribuyente(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cnta_crrte_doc_tipo')
    THEN ALTER TABLE rrhh.cnta_crrte ADD CONSTRAINT fk_cnta_crrte_doc_tipo FOREIGN KEY (doc_tipo_id) REFERENCES core.doc_tipo(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cnta_crrte_cntas_pagar')
    THEN ALTER TABLE rrhh.cnta_crrte ADD CONSTRAINT fk_cnta_crrte_cntas_pagar FOREIGN KEY (cntas_pagar_id) REFERENCES finanzas.cntas_pagar(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cnta_crrte_cntas_cobrar')
    THEN ALTER TABLE rrhh.cnta_crrte ADD CONSTRAINT fk_cnta_crrte_cntas_cobrar FOREIGN KEY (cntas_cobrar_id) REFERENCES ventas.cntas_cobrar(id); END IF; END $$;
DO $$ BEGIN IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname='uq_cnta_crrte_doc')
    THEN ALTER TABLE rrhh.cnta_crrte DROP CONSTRAINT uq_cnta_crrte_doc; END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='uq_cnta_crrte_doc')
    THEN ALTER TABLE rrhh.cnta_crrte ADD CONSTRAINT uq_cnta_crrte_doc UNIQUE (trabajador_id, doc_tipo_id, nro_doc); END IF; END $$;
DROP INDEX IF EXISTS rrhh.ix_cnta_crrte_02;
CREATE INDEX IF NOT EXISTS IX_CNTA_CRRTE_02 ON rrhh.cnta_crrte (trabajador_id, doc_tipo_id, nro_doc);

ALTER TABLE rrhh.cnta_crrte_det ADD COLUMN IF NOT EXISTS nro_dscto SMALLINT NOT NULL DEFAULT 1;
ALTER TABLE rrhh.cnta_crrte_det ADD COLUMN IF NOT EXISTS flag_digitado VARCHAR(1) NOT NULL DEFAULT '0';
ALTER TABLE rrhh.cnta_crrte_det ADD COLUMN IF NOT EXISTS liquidacion_benef_id BIGINT;
DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'rrhh' AND table_name = 'cnta_crrte_det' AND column_name = 'liquidacion_id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'rrhh' AND table_name = 'cnta_crrte_det' AND column_name = 'liquidacion_benef_id')
    THEN ALTER TABLE rrhh.cnta_crrte_det RENAME COLUMN liquidacion_id TO liquidacion_benef_id;
    END IF;
END $$;
ALTER TABLE rrhh.cnta_crrte_det ADD COLUMN IF NOT EXISTS calculo_det_id BIGINT;
ALTER TABLE rrhh.cnta_crrte_det ADD COLUMN IF NOT EXISTS observaciones VARCHAR(120);
ALTER TABLE rrhh.cnta_crrte_det ADD COLUMN IF NOT EXISTS flag_proceso VARCHAR(1);
ALTER TABLE rrhh.cnta_crrte_det ADD COLUMN IF NOT EXISTS imp_dscto NUMERIC(18, 4);
ALTER TABLE rrhh.cnta_crrte_det DROP COLUMN IF EXISTS entidad_contribuyente_id;
ALTER TABLE rrhh.cnta_crrte_det DROP COLUMN IF EXISTS imp_soles;
ALTER TABLE rrhh.cnta_crrte_det DROP COLUMN IF EXISTS imp_dolar;
ALTER TABLE rrhh.cnta_crrte_det DROP COLUMN IF EXISTS nro_liquidacion;
ALTER TABLE rrhh.cnta_crrte_det DROP COLUMN IF EXISTS concepto_planilla_id;
ALTER TABLE rrhh.cnta_crrte_det DROP COLUMN IF EXISTS flag_replicacion;
ALTER TABLE rrhh.cnta_crrte_det DROP COLUMN IF EXISTS concepto;
DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'rrhh' AND table_name = 'cnta_crrte_det' AND column_name = 'monto')
    THEN
        UPDATE rrhh.cnta_crrte_det SET imp_dscto = monto WHERE imp_dscto IS NULL;
    END IF;
END $$;
ALTER TABLE rrhh.cnta_crrte_det DROP COLUMN IF EXISTS monto;
DO $$ BEGIN IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cnta_crrte_det_entidad')
    THEN ALTER TABLE rrhh.cnta_crrte_det DROP CONSTRAINT fk_cnta_crrte_det_entidad; END IF; END $$;
DO $$ BEGIN IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cnta_crrte_det_concepto')
    THEN ALTER TABLE rrhh.cnta_crrte_det DROP CONSTRAINT fk_cnta_crrte_det_concepto; END IF; END $$;
DO $$ BEGIN IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cnta_crrte_det_liquidacion')
    THEN ALTER TABLE rrhh.cnta_crrte_det DROP CONSTRAINT fk_cnta_crrte_det_liquidacion; END IF; END $$;
DO $$ BEGIN IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cnta_crrte_det_03')
    THEN ALTER TABLE rrhh.cnta_crrte_det DROP CONSTRAINT fk_cnta_crrte_det_03; END IF; END $$;
ALTER TABLE rrhh.cnta_crrte_det DROP COLUMN IF EXISTS liquidacion_id;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cnta_crrte_det_liquidacion_benef')
    THEN ALTER TABLE rrhh.cnta_crrte_det ADD CONSTRAINT fk_cnta_crrte_det_liquidacion_benef
        FOREIGN KEY (liquidacion_benef_id) REFERENCES rrhh.liquidacion_benef(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cnta_crrte_det_calculo_det')
    THEN ALTER TABLE rrhh.cnta_crrte_det ADD CONSTRAINT fk_cnta_crrte_det_calculo_det FOREIGN KEY (calculo_det_id) REFERENCES rrhh.calculo_det(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_calculo_det_cnta_crrte_det')
    THEN ALTER TABLE rrhh.calculo_det ADD CONSTRAINT fk_calculo_det_cnta_crrte_det FOREIGN KEY (cnta_crrte_det_id) REFERENCES rrhh.cnta_crrte_det(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='uq_cnta_crrte_det_cuota')
    THEN ALTER TABLE rrhh.cnta_crrte_det ADD CONSTRAINT uq_cnta_crrte_det_cuota UNIQUE (cnta_crrte_id, nro_dscto); END IF; END $$;

ALTER TABLE rrhh.gan_desct_variable DROP COLUMN IF EXISTS tipo_planilla;
ALTER TABLE rrhh.gan_desct_variable ADD COLUMN IF NOT EXISTS tipo_planilla_id BIGINT;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_gan_desct_variable_tipo_planilla')
    THEN ALTER TABLE rrhh.gan_desct_variable ADD CONSTRAINT fk_gan_desct_variable_tipo_planilla FOREIGN KEY (tipo_planilla_id) REFERENCES rrhh.tipo_planilla(id); END IF; END $$;

ALTER TABLE rrhh.cnta_crrte_det DROP COLUMN IF EXISTS tipo_movimiento;
ALTER TABLE rrhh.cnta_crrte_det ADD COLUMN IF NOT EXISTS tipo_movimiento_cnta_crrte_id BIGINT;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cnta_crrte_det_tipo_mov')
    THEN ALTER TABLE rrhh.cnta_crrte_det ADD CONSTRAINT fk_cnta_crrte_det_tipo_mov FOREIGN KEY (tipo_movimiento_cnta_crrte_id) REFERENCES rrhh.tipo_movimiento_cnta_crrte(id); END IF; END $$;

ALTER TABLE rrhh.gratificacion DROP COLUMN IF EXISTS tipo;
ALTER TABLE rrhh.gratificacion ADD COLUMN IF NOT EXISTS periodo_gratificacion_id BIGINT;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_gratificacion_periodo')
    THEN ALTER TABLE rrhh.gratificacion ADD CONSTRAINT fk_gratificacion_periodo FOREIGN KEY (periodo_gratificacion_id) REFERENCES rrhh.periodo_gratificacion(id); END IF; END $$;

ALTER TABLE rrhh.cts DROP COLUMN IF EXISTS periodo;
ALTER TABLE rrhh.cts ADD COLUMN IF NOT EXISTS periodo_cts_id BIGINT;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cts_periodo')
    THEN ALTER TABLE rrhh.cts ADD CONSTRAINT fk_cts_periodo FOREIGN KEY (periodo_cts_id) REFERENCES rrhh.periodo_cts(id); END IF; END $$;

-- CHECK flag_estado de cnta_crrte_det (retenciones de planilla)
-- Segun catalogo global: 0=Anulado, 1=Activo, 2=Cerrado, 3=Pendiente, 5=Aplicado, 6=En Planilla
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='ck_cnta_crrte_det_estado')
    THEN ALTER TABLE rrhh.cnta_crrte_det
        ADD CONSTRAINT CK_CNTA_CRRTE_DET_ESTADO CHECK (flag_estado IN ('0','1','2','3','5','6'));
END IF; END $$;

-- Migrar valores legacy de vacacion.flag_estado (letras → dígitos)
UPDATE rrhh.vacacion SET flag_estado = '2' WHERE flag_estado = 'P';
UPDATE rrhh.vacacion SET flag_estado = '3' WHERE flag_estado = 'A';
UPDATE rrhh.vacacion SET flag_estado = '4' WHERE flag_estado = 'R';
UPDATE rrhh.vacacion SET flag_estado = '2' WHERE flag_estado = 'O';
UPDATE rrhh.vacacion SET flag_estado = '5' WHERE flag_estado = 'C';

-- CHECK flag_estado de vacacion
-- 0=Anulado, 1=Registrado, 2=Pendiente, 3=Aprobado, 4=Rechazado, 5=Cerrado
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='ck_vacacion_estado')
    THEN ALTER TABLE rrhh.vacacion
        ADD CONSTRAINT CK_VACACION_ESTADO CHECK (flag_estado IN ('0','1','2','3','4','5'));
END IF; END $$;

-- Migrar valores legacy de permiso_licencia.flag_estado (letras → dígitos)
UPDATE rrhh.permiso_licencia SET flag_estado = '1' WHERE flag_estado IN ('P', 'S');
UPDATE rrhh.permiso_licencia SET flag_estado = '2' WHERE flag_estado = 'A';
UPDATE rrhh.permiso_licencia SET flag_estado = '0' WHERE flag_estado = 'R';
UPDATE rrhh.permiso_licencia SET flag_estado = '3' WHERE flag_estado = 'O';
UPDATE rrhh.permiso_licencia SET flag_estado = '5' WHERE flag_estado = 'C';

-- CHECK flag_estado de permiso_licencia (máquina de estados completa)
-- 1=Solicitado, 2=Aprobado, 3=Observado, 4=Anulado, 5=Cerrado,
-- 6=Procesado, 7=En Planilla, 8=Ref.Boleta, 0=Rechazado
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='ck_permiso_licencia_estado')
    THEN ALTER TABLE rrhh.permiso_licencia
        ADD CONSTRAINT CK_PERMISO_LICENCIA_ESTADO CHECK (flag_estado IN ('0','1','2','3','4','5','6','7','8'));
END IF; END $$;

-- Corregir chk_fe_* genérico (solo 0/1) que impide aprobar (flag_estado='2'); idempotente con 11-auditoria
DO $$ DECLARE v_chk TEXT := 'chk_fe_' || substr(md5('rrhh.permiso_licencia'), 1, 20);
BEGIN
    UPDATE rrhh.permiso_licencia SET flag_estado = '1' WHERE flag_estado IN ('P', 'S');
    UPDATE rrhh.permiso_licencia SET flag_estado = '2' WHERE flag_estado = 'A';
    UPDATE rrhh.permiso_licencia SET flag_estado = '0' WHERE flag_estado = 'R';
    UPDATE rrhh.permiso_licencia SET flag_estado = '3' WHERE flag_estado = 'O';
    UPDATE rrhh.permiso_licencia SET flag_estado = '5' WHERE flag_estado = 'C';
    EXECUTE format('ALTER TABLE rrhh.permiso_licencia DROP CONSTRAINT IF EXISTS %I', v_chk);
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint c
        JOIN pg_class t ON t.oid = c.conrelid
        JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = 'rrhh' AND t.relname = 'permiso_licencia' AND c.conname = v_chk
    ) THEN
        EXECUTE format(
            'ALTER TABLE rrhh.permiso_licencia ADD CONSTRAINT %I CHECK (flag_estado ~ ''^[0-9]$'')',
            v_chk
        );
    END IF;
END $$;

-- Corregir chk_fe_* genérico (solo 0/1) y alinear letras legacy P/A/R/O/C → dígitos
DO $$ DECLARE v_chk TEXT := 'chk_fe_' || substr(md5('rrhh.vacacion'), 1, 20);
BEGIN
    UPDATE rrhh.vacacion SET flag_estado = '2' WHERE flag_estado = 'P';
    UPDATE rrhh.vacacion SET flag_estado = '3' WHERE flag_estado = 'A';
    UPDATE rrhh.vacacion SET flag_estado = '4' WHERE flag_estado = 'R';
    UPDATE rrhh.vacacion SET flag_estado = '2' WHERE flag_estado = 'O';
    UPDATE rrhh.vacacion SET flag_estado = '5' WHERE flag_estado = 'C';
    EXECUTE format('ALTER TABLE rrhh.vacacion DROP CONSTRAINT IF EXISTS %I', v_chk);
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint c
        JOIN pg_class t ON t.oid = c.conrelid
        JOIN pg_namespace n ON n.oid = t.relnamespace
        WHERE n.nspname = 'rrhh' AND t.relname = 'vacacion' AND c.conname = v_chk
    ) THEN
        EXECUTE format(
            'ALTER TABLE rrhh.vacacion ADD CONSTRAINT %I CHECK (flag_estado ~ ''^[0-9]$'')',
            v_chk
        );
    END IF;
END $$;

-- Migración permiso_licencia plano → cabecera/detalle (SIGRE RRHH_PERMISO_VACAC + RRHH_VACAC_TRABAJ_DET)
CREATE TABLE IF NOT EXISTS rrhh.permiso_licencia_det (
    id BIGSERIAL NOT NULL,
    permiso_licencia_id BIGINT NOT NULL,
    item INTEGER NOT NULL,
    tipo_suspension_laboral_id BIGINT,
    tipo_doc_identidad_id BIGINT,
    numero_documento VARCHAR(30),
    periodo_inicio INTEGER,
    mes_periodo INTEGER,
    fecha_solicitud DATE NOT NULL DEFAULT CURRENT_DATE,
    fecha_movimiento DATE,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    dias NUMERIC(4, 2) NOT NULL DEFAULT 0,
    created_by BIGINT,
    fec_creacion TIMESTAMPTZ DEFAULT NOW(),
    updated_by BIGINT,
    fec_modificacion TIMESTAMPTZ,
    CONSTRAINT PK_PERMISO_LICENCIA_DET PRIMARY KEY (id)
);
ALTER TABLE rrhh.permiso_licencia_det DROP COLUMN IF EXISTS hora_inicio;
ALTER TABLE rrhh.permiso_licencia_det DROP COLUMN IF EXISTS hora_fin;
ALTER TABLE rrhh.permiso_licencia_det DROP COLUMN IF EXISTS fecha_proceso;
ALTER TABLE rrhh.permiso_licencia_det DROP COLUMN IF EXISTS flag_manual;
ALTER TABLE rrhh.permiso_licencia_det DROP COLUMN IF EXISTS flag_estado;
ALTER TABLE rrhh.permiso_licencia_det DROP CONSTRAINT IF EXISTS fk_permiso_licencia_det_02;
ALTER TABLE rrhh.permiso_licencia_det DROP CONSTRAINT IF EXISTS fk_permiso_licencia_det_04;
ALTER TABLE rrhh.permiso_licencia_det DROP COLUMN IF EXISTS concepto_planilla_id;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='uq_permiso_licencia_det')
    THEN ALTER TABLE rrhh.permiso_licencia_det ADD CONSTRAINT uq_permiso_licencia_det UNIQUE (permiso_licencia_id, item); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_permiso_licencia_det_01')
    THEN ALTER TABLE rrhh.permiso_licencia_det ADD CONSTRAINT fk_permiso_licencia_det_01
        FOREIGN KEY (permiso_licencia_id) REFERENCES rrhh.permiso_licencia(id) ON DELETE CASCADE; END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_permiso_licencia_det_02')
    THEN ALTER TABLE rrhh.permiso_licencia_det ADD CONSTRAINT fk_permiso_licencia_det_02
        FOREIGN KEY (tipo_suspension_laboral_id) REFERENCES rrhh.tipo_suspension_laboral(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_permiso_licencia_det_03')
    THEN ALTER TABLE rrhh.permiso_licencia_det ADD CONSTRAINT fk_permiso_licencia_det_03
        FOREIGN KEY (tipo_doc_identidad_id) REFERENCES core.tipo_doc_identidad(id); END IF; END $$;

ALTER TABLE rrhh.tipo_suspension_laboral ADD COLUMN IF NOT EXISTS flag_datos_lesion VARCHAR(1) NOT NULL DEFAULT '0';

ALTER TABLE rrhh.permiso_licencia_det ADD COLUMN IF NOT EXISTS tipo_suspension_laboral_id BIGINT;
ALTER TABLE rrhh.permiso_licencia_det ADD COLUMN IF NOT EXISTS tipo_doc_identidad_id BIGINT;
ALTER TABLE rrhh.permiso_licencia_det ADD COLUMN IF NOT EXISTS numero_documento VARCHAR(30);
ALTER TABLE rrhh.permiso_licencia_det ADD COLUMN IF NOT EXISTS fecha_solicitud DATE NOT NULL DEFAULT CURRENT_DATE;
ALTER TABLE rrhh.permiso_licencia_det ADD COLUMN IF NOT EXISTS fecha_movimiento DATE;

ALTER TABLE rrhh.permiso_licencia ADD COLUMN IF NOT EXISTS periodo_inicio INTEGER;
ALTER TABLE rrhh.permiso_licencia ADD COLUMN IF NOT EXISTS periodo_fin INTEGER;
ALTER TABLE rrhh.permiso_licencia ADD COLUMN IF NOT EXISTS dias_totales INTEGER NOT NULL DEFAULT 0;
ALTER TABLE rrhh.permiso_licencia ADD COLUMN IF NOT EXISTS dias_gozados INTEGER NOT NULL DEFAULT 0;

ALTER TABLE rrhh.permiso_licencia_det ADD COLUMN IF NOT EXISTS periodo_inicio INTEGER;
ALTER TABLE rrhh.permiso_licencia_det ADD COLUMN IF NOT EXISTS mes_periodo INTEGER;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'rrhh' AND table_name = 'permiso_licencia' AND column_name = 'fecha_inicio'
    ) THEN
        INSERT INTO rrhh.permiso_licencia_det (
            permiso_licencia_id, item, tipo_suspension_laboral_id, periodo_inicio, mes_periodo,
            fecha_solicitud, fecha_inicio, fecha_fin, dias, created_by, fec_creacion
        )
        SELECT p.id, 1, p.tipo_suspension_laboral_id,
               EXTRACT(YEAR FROM p.fecha_inicio)::integer,
               EXTRACT(MONTH FROM p.fecha_inicio)::integer,
               COALESCE(p.fecha_solicitud, p.fecha_inicio),
               p.fecha_inicio, p.fecha_fin,
               COALESCE(p.dias, 0)::numeric(4, 2), p.created_by, p.fec_creacion
        FROM rrhh.permiso_licencia p
        WHERE p.fecha_inicio IS NOT NULL
          AND NOT EXISTS (
              SELECT 1 FROM rrhh.permiso_licencia_det d
              WHERE d.permiso_licencia_id = p.id AND d.item = 1
          );

        UPDATE rrhh.permiso_licencia p SET
            periodo_inicio = COALESCE(p.periodo_inicio, EXTRACT(YEAR FROM p.fecha_inicio)::integer),
            dias_totales = COALESCE(NULLIF(p.dias_totales, 0), COALESCE(p.dias, 0))
        WHERE p.fecha_inicio IS NOT NULL;

        ALTER TABLE rrhh.inasistencia DROP CONSTRAINT IF EXISTS fk_inasistencia_05;
        ALTER TABLE rrhh.inasistencia DROP COLUMN IF EXISTS permiso_licencia_id;

        ALTER TABLE rrhh.permiso_licencia DROP COLUMN IF EXISTS fecha_inicio;
        ALTER TABLE rrhh.permiso_licencia DROP COLUMN IF EXISTS fecha_fin;
        ALTER TABLE rrhh.permiso_licencia DROP COLUMN IF EXISTS dias;
    END IF;

    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'rrhh' AND table_name = 'permiso_licencia_det' AND column_name = 'concepto_planilla_id'
    ) THEN
        UPDATE rrhh.permiso_licencia p SET concepto_planilla_id = COALESCE(p.concepto_planilla_id, d.concepto_planilla_id)
        FROM rrhh.permiso_licencia_det d
        WHERE d.permiso_licencia_id = p.id AND d.item = 1
          AND d.concepto_planilla_id IS NOT NULL;
        ALTER TABLE rrhh.permiso_licencia_det DROP CONSTRAINT IF EXISTS fk_permiso_licencia_det_02;
        ALTER TABLE rrhh.permiso_licencia_det DROP COLUMN IF EXISTS concepto_planilla_id;
    END IF;
END $$;

ALTER TABLE rrhh.permiso_licencia DROP CONSTRAINT IF EXISTS uq_permiso_licencia_codigo;
ALTER TABLE rrhh.permiso_licencia DROP COLUMN IF EXISTS codigo_permiso;
ALTER TABLE rrhh.permiso_licencia DROP COLUMN IF EXISTS dias_program;
ALTER TABLE rrhh.permiso_licencia DROP COLUMN IF EXISTS item_laboral;
ALTER TABLE rrhh.permiso_licencia DROP COLUMN IF EXISTS fecha_solicitud;
ALTER TABLE rrhh.permiso_licencia DROP COLUMN IF EXISTS fecha_aprobacion;

UPDATE rrhh.permiso_licencia SET periodo_inicio = EXTRACT(YEAR FROM CURRENT_DATE)::integer
WHERE periodo_inicio IS NULL;

ALTER TABLE rrhh.inasistencia DROP COLUMN IF EXISTS flag_replicacion;
ALTER TABLE rrhh.permiso_licencia DROP COLUMN IF EXISTS flag_replicacion;
ALTER TABLE rrhh.permiso_licencia_det DROP COLUMN IF EXISTS flag_replicacion;

DROP INDEX IF EXISTS rrhh.ix_inasistencia_03;
DROP INDEX IF EXISTS rrhh.ix_inasistencia_04;
ALTER TABLE rrhh.inasistencia DROP CONSTRAINT IF EXISTS fk_inasistencia_03;
ALTER TABLE rrhh.inasistencia DROP CONSTRAINT IF EXISTS fk_inasistencia_04;
ALTER TABLE rrhh.inasistencia DROP CONSTRAINT IF EXISTS fk_inasistencia_05;
ALTER TABLE rrhh.inasistencia DROP COLUMN IF EXISTS tipo_suspension_laboral_id;
ALTER TABLE rrhh.inasistencia DROP COLUMN IF EXISTS tipo_doc_identidad_id;
ALTER TABLE rrhh.inasistencia DROP COLUMN IF EXISTS numero_documento;
ALTER TABLE rrhh.inasistencia DROP COLUMN IF EXISTS periodo_inicio;
ALTER TABLE rrhh.inasistencia DROP COLUMN IF EXISTS mes_periodo;
ALTER TABLE rrhh.inasistencia DROP COLUMN IF EXISTS item_laboral;
ALTER TABLE rrhh.inasistencia DROP COLUMN IF EXISTS permiso_licencia_det_id;
ALTER TABLE rrhh.inasistencia DROP COLUMN IF EXISTS permiso_licencia_id;
ALTER TABLE rrhh.inasistencia DROP COLUMN IF EXISTS sustento;

CREATE INDEX IF NOT EXISTS IX_PERMISO_LICENCIA_02 ON rrhh.permiso_licencia (concepto_planilla_id);
CREATE INDEX IF NOT EXISTS IX_PERMISO_LICENCIA_DET_01 ON rrhh.permiso_licencia_det (permiso_licencia_id, fecha_inicio);
CREATE INDEX IF NOT EXISTS IX_PERMISO_LICENCIA_DET_02 ON rrhh.permiso_licencia_det (tipo_suspension_laboral_id);

-- Migración idempotente: concepto_planilla alineado SIGRE (CONCEPTO.json)
ALTER TABLE rrhh.concepto_planilla ADD COLUMN IF NOT EXISTS descripcion_breve VARCHAR(150);
ALTER TABLE rrhh.concepto_planilla ADD COLUMN IF NOT EXISTS factor_pago NUMERIC(18, 6) NOT NULL DEFAULT 1;
ALTER TABLE rrhh.concepto_planilla ADD COLUMN IF NOT EXISTS importe_tope_min NUMERIC(18, 4) NOT NULL DEFAULT 0;
ALTER TABLE rrhh.concepto_planilla ADD COLUMN IF NOT EXISTS importe_tope_max NUMERIC(18, 4) NOT NULL DEFAULT 0;
ALTER TABLE rrhh.concepto_planilla ADD COLUMN IF NOT EXISTS numero_horas NUMERIC(6, 2);
ALTER TABLE rrhh.concepto_planilla ADD COLUMN IF NOT EXISTS grupo_calculo VARCHAR(10);
ALTER TABLE rrhh.concepto_planilla ADD COLUMN IF NOT EXISTS flag_replicacion VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE rrhh.concepto_planilla ADD COLUMN IF NOT EXISTS concepto_rtps VARCHAR(10);
ALTER TABLE rrhh.concepto_planilla ADD COLUMN IF NOT EXISTS flag_subsidio VARCHAR(1) NOT NULL DEFAULT '0';
ALTER TABLE rrhh.concepto_planilla ADD COLUMN IF NOT EXISTS flag_reporte_quinta VARCHAR(1) NOT NULL DEFAULT '0';
ALTER TABLE rrhh.concepto_planilla ADD COLUMN IF NOT EXISTS numero_orden VARCHAR(20);
DO $$ BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'rrhh' AND table_name = 'concepto_planilla' AND column_name = 'tipo'
    ) THEN
        UPDATE rrhh.concepto_planilla SET grupo_calculo = CASE
            WHEN tipo = 'INGRESO' THEN '10'
            WHEN tipo = 'DESCUENTO' THEN '20'
            WHEN tipo = 'APORTE' THEN '30'
            ELSE '10'
        END WHERE grupo_calculo IS NULL;
        UPDATE rrhh.concepto_planilla SET factor_pago = COALESCE(valor_fijo, 1)
            WHERE factor_pago IS NULL OR factor_pago = 0;
        UPDATE rrhh.concepto_planilla SET flag_reporte_quinta = CASE WHEN afecto_quinta THEN '1' ELSE '0' END
            WHERE flag_reporte_quinta IS NULL OR flag_reporte_quinta = '0';
        ALTER TABLE rrhh.concepto_planilla DROP COLUMN IF EXISTS tipo;
        ALTER TABLE rrhh.concepto_planilla DROP COLUMN IF EXISTS formula;
        ALTER TABLE rrhh.concepto_planilla DROP COLUMN IF EXISTS valor_fijo;
        ALTER TABLE rrhh.concepto_planilla DROP COLUMN IF EXISTS afecto_quinta;
        ALTER TABLE rrhh.concepto_planilla DROP COLUMN IF EXISTS afecto_essalud;
        ALTER TABLE rrhh.concepto_planilla DROP COLUMN IF EXISTS aplica_todos;
    END IF;
END $$;
UPDATE rrhh.concepto_planilla SET grupo_calculo = '10' WHERE grupo_calculo IS NULL;
ALTER TABLE rrhh.concepto_planilla ALTER COLUMN grupo_calculo SET NOT NULL;

-- Migración idempotente: grupo_conceptos_planilla + FK en concepto_planilla (GRUPO_CALC_CONCEPTO.json)
CREATE TABLE IF NOT EXISTS rrhh.grupo_conceptos_planilla (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(10) NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    concepto_codigo VARCHAR(20),
    flag_replicacion VARCHAR(1) NOT NULL DEFAULT '1',
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_GRUPO_CONCEPTOS_PLANILLA PRIMARY KEY (id),
    CONSTRAINT UQ_GRUPO_CONCEPTOS_PLANILLA_CODIGO UNIQUE (codigo)
);

INSERT INTO rrhh.grupo_conceptos_planilla (codigo, nombre, concepto_codigo, flag_replicacion, flag_estado)
VALUES
    ('13', 'FLOTA PROPIA', NULL, '1', '1'),
    ('24', 'DESCUENTOS DE INASISTENCIAS', NULL, '1', '1'),
    ('23', 'DESCUENTOS VARIABLES', NULL, '1', '1'),
    ('14', 'GANANCIAS VARIABLES', NULL, '1', '1'),
    ('10', 'GANANCIAS FIJAS', NULL, '1', '1'),
    ('11', 'SOBRETIEMPOS', NULL, '1', '1'),
    ('12', 'DESTAJO', NULL, '1', '1'),
    ('20', 'DESCUENTOS DE LEY', NULL, '1', '1'),
    ('21', 'DESCUENTOS DE CUENTA CORRIENTE', NULL, '1', '1'),
    ('22', 'DESCUENTOS FIJOS', NULL, '1', '1'),
    ('30', 'APORTACIONES DE LA EMPRESA', NULL, '1', '1'),
    ('70', 'CONCEPTOS VARIOS', NULL, '1', '1')
ON CONFLICT (codigo) DO NOTHING;

ALTER TABLE rrhh.concepto_planilla ADD COLUMN IF NOT EXISTS grupo_conceptos_planilla_id BIGINT;

DO $$ BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'rrhh' AND table_name = 'concepto_planilla' AND column_name = 'grupo_calculo'
    ) THEN
        UPDATE rrhh.concepto_planilla cp
        SET grupo_conceptos_planilla_id = g.id
        FROM rrhh.grupo_conceptos_planilla g
        WHERE cp.grupo_conceptos_planilla_id IS NULL
          AND g.codigo = cp.grupo_calculo;

        UPDATE rrhh.concepto_planilla cp
        SET grupo_conceptos_planilla_id = g.id
        FROM rrhh.grupo_conceptos_planilla g
        WHERE cp.grupo_conceptos_planilla_id IS NULL
          AND g.codigo = '10';

        ALTER TABLE rrhh.concepto_planilla DROP COLUMN IF EXISTS grupo_calculo;
    END IF;
END $$;

UPDATE rrhh.concepto_planilla cp
SET grupo_conceptos_planilla_id = g.id
FROM rrhh.grupo_conceptos_planilla g
WHERE cp.grupo_conceptos_planilla_id IS NULL
  AND g.codigo = '10';

ALTER TABLE rrhh.concepto_planilla ALTER COLUMN grupo_conceptos_planilla_id SET NOT NULL;

DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_concepto_planilla_grupo')
    THEN ALTER TABLE rrhh.concepto_planilla ADD CONSTRAINT fk_concepto_planilla_grupo
        FOREIGN KEY (grupo_conceptos_planilla_id) REFERENCES rrhh.grupo_conceptos_planilla(id);
END IF; END $$;

CREATE INDEX IF NOT EXISTS IX_GRUPO_CONCEPTOS_PLANILLA_01 ON rrhh.grupo_conceptos_planilla (codigo);
CREATE INDEX IF NOT EXISTS IX_CONCEPTO_PLANILLA_02 ON rrhh.concepto_planilla (grupo_conceptos_planilla_id);

CREATE TABLE IF NOT EXISTS rrhh.grupo_calculo (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(3) NOT NULL,
    nombre VARCHAR(50),
    concepto_gen_id BIGINT,
    concepto_reg_lab_id BIGINT,
    flag_seccion VARCHAR(1) NOT NULL DEFAULT '0',
    flag_replicacion VARCHAR(1) NOT NULL DEFAULT '1',
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by BIGINT,
    fec_creacion TIMESTAMPTZ DEFAULT NOW(),
    updated_by BIGINT,
    fec_modificacion TIMESTAMPTZ,
    CONSTRAINT PK_GRUPO_CALCULO PRIMARY KEY (id),
    CONSTRAINT UQ_GRUPO_CALCULO_CODIGO UNIQUE (codigo)
);
CREATE TABLE IF NOT EXISTS rrhh.grupo_calculo_det (
    id BIGSERIAL NOT NULL,
    grupo_calculo_id BIGINT NOT NULL,
    concepto_planilla_id BIGINT NOT NULL,
    flag_replicacion VARCHAR(1) NOT NULL DEFAULT '1',
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by BIGINT,
    fec_creacion TIMESTAMPTZ DEFAULT NOW(),
    updated_by BIGINT,
    fec_modificacion TIMESTAMPTZ,
    CONSTRAINT PK_GRUPO_CALCULO_DET PRIMARY KEY (id),
    CONSTRAINT UQ_GRUPO_CALCULO_DET UNIQUE (grupo_calculo_id, concepto_planilla_id)
);
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_grupo_calculo_concepto_gen')
    THEN ALTER TABLE rrhh.grupo_calculo ADD CONSTRAINT fk_grupo_calculo_concepto_gen
        FOREIGN KEY (concepto_gen_id) REFERENCES rrhh.concepto_planilla(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_grupo_calculo_concepto_reg_lab')
    THEN ALTER TABLE rrhh.grupo_calculo ADD CONSTRAINT fk_grupo_calculo_concepto_reg_lab
        FOREIGN KEY (concepto_reg_lab_id) REFERENCES rrhh.concepto_planilla(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_grupo_calculo_det_grupo')
    THEN ALTER TABLE rrhh.grupo_calculo_det ADD CONSTRAINT fk_grupo_calculo_det_grupo
        FOREIGN KEY (grupo_calculo_id) REFERENCES rrhh.grupo_calculo(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_grupo_calculo_det_concepto')
    THEN ALTER TABLE rrhh.grupo_calculo_det ADD CONSTRAINT fk_grupo_calculo_det_concepto
        FOREIGN KEY (concepto_planilla_id) REFERENCES rrhh.concepto_planilla(id); END IF; END $$;
CREATE INDEX IF NOT EXISTS IX_GRUPO_CALCULO_01 ON rrhh.grupo_calculo (codigo);
CREATE INDEX IF NOT EXISTS IX_GRUPO_CALCULO_DET_01 ON rrhh.grupo_calculo_det (grupo_calculo_id);
CREATE INDEX IF NOT EXISTS IX_GRUPO_CALCULO_DET_02 ON rrhh.grupo_calculo_det (concepto_planilla_id);

CREATE TABLE IF NOT EXISTS rrhh.impuesto_renta_tramos (
    id BIGSERIAL NOT NULL,
    secuencia INTEGER NOT NULL,
    tasa NUMERIC(5, 2) NOT NULL,
    tope_ini NUMERIC(13, 2) NOT NULL DEFAULT 0,
    tope_fin NUMERIC(13, 2) NOT NULL DEFAULT 0,
    fecha_vig_ini DATE NOT NULL,
    fecha_vig_fin DATE,
    cod_usr VARCHAR(6),
    flag_replicacion VARCHAR(1) NOT NULL DEFAULT '1',
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by BIGINT,
    fec_creacion TIMESTAMPTZ DEFAULT NOW(),
    updated_by BIGINT,
    fec_modificacion TIMESTAMPTZ,
    CONSTRAINT PK_IMPUESTO_RENTA_TRAMOS PRIMARY KEY (id),
    CONSTRAINT UQ_IMPUESTO_RENTA_VIG_SEC UNIQUE (fecha_vig_ini, secuencia)
);
CREATE INDEX IF NOT EXISTS IX_IMPUESTO_RENTA_TRAMOS_01 ON rrhh.impuesto_renta_tramos (fecha_vig_ini, secuencia);

-- Migración idempotente: fechas_proceso sin calendario semanal (SIGRE SEMANAS no aplica)
ALTER TABLE rrhh.fechas_proceso DROP COLUMN IF EXISTS nro_semana;

-- Migración idempotente: tablas motor planilla (judicial, SENATI×sección)
CREATE TABLE IF NOT EXISTS rrhh.retencion_judicial (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    concepto_planilla_id BIGINT NOT NULL,
    secuencia SMALLINT NOT NULL,
    flag_estado VARCHAR(1) DEFAULT '1',
    porcentaje NUMERIC(4, 2) DEFAULT 0,
    nom_pension VARCHAR(200),
    importe NUMERIC(13, 2) DEFAULT 0,
    entidad_contribuyente_id BIGINT,
    flag_replicacion VARCHAR(1) NOT NULL DEFAULT '1',
    nro_cnta_ahorro VARCHAR(16),
    porc_utilidad NUMERIC(4, 2) NOT NULL DEFAULT 0,
    banco_id BIGINT,
    porc_cts NUMERIC(4, 2) NOT NULL DEFAULT 0,
    porc_grati NUMERIC(4, 2) NOT NULL DEFAULT 0,
    porc_vac NUMERIC(4, 2) NOT NULL DEFAULT 0,
    imp_fijo_grati NUMERIC(13, 2) NOT NULL DEFAULT 0,
    imp_fijo_bonif NUMERIC(13, 2) NOT NULL DEFAULT 0,
    imp_fijo_vaca NUMERIC(13, 2) NOT NULL DEFAULT 0,
    imp_fijo_cts NUMERIC(13, 2) NOT NULL DEFAULT 0,
    created_by BIGINT,
    fec_creacion TIMESTAMPTZ DEFAULT NOW(),
    updated_by BIGINT,
    fec_modificacion TIMESTAMPTZ,
    CONSTRAINT PK_RETENCION_JUDICIAL PRIMARY KEY (id),
    CONSTRAINT UQ_RETENCION_JUDICIAL_NATURAL UNIQUE (trabajador_id, concepto_planilla_id, secuencia)
);
CREATE TABLE IF NOT EXISTS rrhh.calculo_judicial (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    concepto_planilla_id BIGINT NOT NULL,
    secuencia SMALLINT NOT NULL,
    fec_proceso DATE NOT NULL,
    imp_dolar NUMERIC(15, 4) NOT NULL DEFAULT 0,
    imp_soles NUMERIC(15, 4) NOT NULL DEFAULT 0,
    imp_bruto NUMERIC(15, 4) NOT NULL DEFAULT 0,
    sucursal_id BIGINT,
    tipo_trabajador_id BIGINT NOT NULL,
    tipo_planilla_id BIGINT NOT NULL,
    created_by BIGINT,
    fec_creacion TIMESTAMPTZ DEFAULT NOW(),
    updated_by BIGINT,
    fec_modificacion TIMESTAMPTZ,
    CONSTRAINT PK_CALCULO_JUDICIAL PRIMARY KEY (id),
    CONSTRAINT UQ_CALCULO_JUDICIAL_NATURAL UNIQUE (trabajador_id, concepto_planilla_id, secuencia, fec_proceso)
);
CREATE TABLE IF NOT EXISTS rrhh.grupo_conceptos_seccion (
    id BIGSERIAL NOT NULL,
    grupo_calculo_id BIGINT NOT NULL,
    seccion_id BIGINT NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by BIGINT,
    fec_creacion TIMESTAMPTZ DEFAULT NOW(),
    updated_by BIGINT,
    fec_modificacion TIMESTAMPTZ,
    CONSTRAINT PK_GRUPO_CONCEPTOS_SECCION PRIMARY KEY (id),
    CONSTRAINT UQ_GRUPO_CONCEPTOS_SECCION UNIQUE (grupo_calculo_id, seccion_id)
);
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_retencion_judicial_trabajador')
    THEN ALTER TABLE rrhh.retencion_judicial ADD CONSTRAINT fk_retencion_judicial_trabajador
        FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_retencion_judicial_concepto')
    THEN ALTER TABLE rrhh.retencion_judicial ADD CONSTRAINT fk_retencion_judicial_concepto
        FOREIGN KEY (concepto_planilla_id) REFERENCES rrhh.concepto_planilla(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_retencion_judicial_entidad')
    THEN ALTER TABLE rrhh.retencion_judicial ADD CONSTRAINT fk_retencion_judicial_entidad
        FOREIGN KEY (entidad_contribuyente_id) REFERENCES core.entidad_contribuyente(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_retencion_judicial_banco')
    THEN ALTER TABLE rrhh.retencion_judicial ADD CONSTRAINT fk_retencion_judicial_banco
        FOREIGN KEY (banco_id) REFERENCES finanzas.banco(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_calculo_judicial_retencion')
    THEN ALTER TABLE rrhh.calculo_judicial ADD CONSTRAINT fk_calculo_judicial_retencion
        FOREIGN KEY (trabajador_id, concepto_planilla_id, secuencia)
        REFERENCES rrhh.retencion_judicial (trabajador_id, concepto_planilla_id, secuencia); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_calculo_judicial_trabajador')
    THEN ALTER TABLE rrhh.calculo_judicial ADD CONSTRAINT fk_calculo_judicial_trabajador
        FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_calculo_judicial_concepto')
    THEN ALTER TABLE rrhh.calculo_judicial ADD CONSTRAINT fk_calculo_judicial_concepto
        FOREIGN KEY (concepto_planilla_id) REFERENCES rrhh.concepto_planilla(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_calculo_judicial_sucursal')
    THEN ALTER TABLE rrhh.calculo_judicial ADD CONSTRAINT fk_calculo_judicial_sucursal
        FOREIGN KEY (sucursal_id) REFERENCES auth.sucursal(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_calculo_judicial_tipo_trab')
    THEN ALTER TABLE rrhh.calculo_judicial ADD CONSTRAINT fk_calculo_judicial_tipo_trab
        FOREIGN KEY (tipo_trabajador_id) REFERENCES rrhh.tipo_trabajador(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_calculo_judicial_tipo_planilla')
    THEN ALTER TABLE rrhh.calculo_judicial ADD CONSTRAINT fk_calculo_judicial_tipo_planilla
        FOREIGN KEY (tipo_planilla_id) REFERENCES rrhh.tipo_planilla(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_grupo_conceptos_seccion_grupo')
    THEN ALTER TABLE rrhh.grupo_conceptos_seccion ADD CONSTRAINT fk_grupo_conceptos_seccion_grupo
        FOREIGN KEY (grupo_calculo_id) REFERENCES rrhh.grupo_calculo(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_grupo_conceptos_seccion_seccion')
    THEN ALTER TABLE rrhh.grupo_conceptos_seccion ADD CONSTRAINT fk_grupo_conceptos_seccion_seccion
        FOREIGN KEY (seccion_id) REFERENCES rrhh.seccion(id); END IF; END $$;
CREATE INDEX IF NOT EXISTS IX_RETENCION_JUDICIAL_01 ON rrhh.retencion_judicial (trabajador_id, flag_estado);
CREATE INDEX IF NOT EXISTS IX_CALCULO_JUDICIAL_01 ON rrhh.calculo_judicial (trabajador_id, fec_proceso);
CREATE INDEX IF NOT EXISTS IX_GRUPO_CONCEPTOS_SECCION_01 ON rrhh.grupo_conceptos_seccion (grupo_calculo_id, flag_estado);

-- Migración idempotente: quinta_categoria esquema SIGRE (reemplaza anio/mes)
DO $$ BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'rrhh' AND table_name = 'quinta_categoria' AND column_name = 'anio'
    ) THEN
        DROP TABLE rrhh.quinta_categoria CASCADE;
    END IF;
END $$;
CREATE TABLE IF NOT EXISTS rrhh.quinta_categoria (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    fec_proceso DATE NOT NULL,
    rem_proyectable NUMERIC(13, 2) NOT NULL DEFAULT 0,
    rem_imprecisa NUMERIC(13, 2) NOT NULL DEFAULT 0,
    rem_retencion NUMERIC(13, 2) NOT NULL DEFAULT 0,
    rem_gratif NUMERIC(13, 2) NOT NULL DEFAULT 0,
    flag_replicacion VARCHAR(1) NOT NULL DEFAULT '1',
    nro_dias SMALLINT NOT NULL DEFAULT 0,
    sueldo NUMERIC(13, 2) NOT NULL DEFAULT 0,
    flag_automatico VARCHAR(1) NOT NULL DEFAULT '1',
    gratif_proyect NUMERIC(13, 2) NOT NULL DEFAULT 0,
    rem_externa NUMERIC(13, 2) NOT NULL DEFAULT 0,
    tipo_planilla_id BIGINT NOT NULL,
    created_by BIGINT,
    fec_creacion TIMESTAMPTZ DEFAULT NOW(),
    updated_by BIGINT,
    fec_modificacion TIMESTAMPTZ,
    CONSTRAINT PK_QUINTA_CATEGORIA PRIMARY KEY (id),
    CONSTRAINT UQ_QUINTA_CATEGORIA_NATURAL UNIQUE (trabajador_id, fec_proceso, flag_automatico, tipo_planilla_id)
);
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_quinta_categoria_trabajador')
    THEN ALTER TABLE rrhh.quinta_categoria ADD CONSTRAINT fk_quinta_categoria_trabajador
        FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_quinta_categoria_tipo_planilla')
    THEN ALTER TABLE rrhh.quinta_categoria ADD CONSTRAINT fk_quinta_categoria_tipo_planilla
        FOREIGN KEY (tipo_planilla_id) REFERENCES rrhh.tipo_planilla(id); END IF; END $$;
CREATE INDEX IF NOT EXISTS IX_QUINTA_CATEGORIA_01 ON rrhh.quinta_categoria (trabajador_id, fec_proceso);
CREATE INDEX IF NOT EXISTS IX_QUINTA_CATEGORIA_02 ON rrhh.quinta_categoria (tipo_planilla_id, fec_proceso);

-- Migración idempotente: trabajador.sucursal_id obligatorio (Piura por defecto en legado)
UPDATE rrhh.trabajador t
SET sucursal_id = s.id
FROM auth.sucursal s
WHERE t.sucursal_id IS NULL
  AND s.codigo = 'PI';
ALTER TABLE rrhh.trabajador ALTER COLUMN sucursal_id SET NOT NULL;

-- FK diferida: finanzas.cntas_pagar_det.trabajador_id → rrhh.trabajador(id)
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cpd_trabajador')
    THEN ALTER TABLE finanzas.cntas_pagar_det ADD CONSTRAINT fk_cpd_trabajador FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id); END IF; END $$;
