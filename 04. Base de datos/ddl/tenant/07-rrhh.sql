-- ============================================================
-- SIGRE ERP - Tenant DB - rrhh schema
-- DROP de esquemas centralizado en 01-core.sql
-- ============================================================
--
-- DIAGRAMA DE RELACIONES (→ = tiene FK hacia):
--
--   area → area (self-ref padre_id)
--   cargo (sin dependencias)
--   admin_afp (sin dependencias)
--   turno (sin dependencias)
--   concepto_planilla (sin dependencias)
--   tipo_novedad_rrhh (sin dependencias)
--   capacitacion (sin dependencias)
--   sexo, estado_civil, regimen_laboral, tipo_contrato, tipo_mov_asistencia,
--   tipo_subsidio, tipo_suspension_laboral, tipo_sancion, tipo_planilla,
--   tipo_concepto_calculo, tipo_movimiento_cnta_crrte, periodo_gratificacion, periodo_cts (sin dependencias)
--   calculo → tipo_planilla
--   trabajador → core.entidad_contribuyente, core.tipo_doc_identidad, sexo, estado_civil,
--                regimen_laboral, admin_afp, area, cargo, auth.sucursal
--   contrato → trabajador, tipo_contrato
--   asistencia → trabajador, tipo_mov_asistencia
--   permiso_licencia → trabajador, tipo_suspension_laboral
--   vacacion → trabajador
--   liquidacion → trabajador
--   prestamo → trabajador
--   cnta_crrte → trabajador
--   horario_trabajador → trabajador, turno
--   evaluacion_desempeno → trabajador
--   capacitacion_trabajador → capacitacion, trabajador
--   sancion_amonestacion → trabajador, tipo_sancion
--   control_subsidio → trabajador, tipo_subsidio
--   gan_desct_fijo → trabajador, concepto_planilla
--   gan_desct_variable → trabajador, concepto_planilla, tipo_planilla
--   program_vacacion → trabajador
--   novedad_rrhh → trabajador, tipo_novedad_rrhh
--   calculo_det → calculo, trabajador, concepto_planilla, tipo_concepto_calculo
--   cnta_crrte_det → cnta_crrte, tipo_movimiento_cnta_crrte
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

CREATE TABLE rrhh.concepto_planilla (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    formula TEXT,
    valor_fijo NUMERIC(18, 4),
    afecto_quinta BOOLEAN NOT NULL DEFAULT FALSE,
    afecto_essalud BOOLEAN NOT NULL DEFAULT FALSE,
    aplica_todos BOOLEAN NOT NULL DEFAULT TRUE,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CONCEPTO_PLANILLA PRIMARY KEY (id)
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

CREATE TABLE rrhh.calculo (
    id BIGSERIAL NOT NULL,
    anio INTEGER NOT NULL,
    mes INTEGER NOT NULL,
    tipo_planilla_id BIGINT NOT NULL,
    total_ingresos NUMERIC(18, 4) DEFAULT 0,
    total_descuentos NUMERIC(18, 4) DEFAULT 0,
    total_neto NUMERIC(18, 4) DEFAULT 0,
    total_aportes NUMERIC(18, 4) DEFAULT 0,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CALCULO PRIMARY KEY (id),
    CONSTRAINT FK_CALCULO_01 FOREIGN KEY (tipo_planilla_id) REFERENCES rrhh.tipo_planilla(id)
);

-- ============================================================
-- SECCIÓN 2: TABLA PRINCIPAL - TRABAJADOR
-- ============================================================

CREATE TABLE rrhh.trabajador (
    id BIGSERIAL NOT NULL,
    entidad_contribuyente_id BIGINT,
    codigo_trabajador VARCHAR(20) NOT NULL UNIQUE,
    nombres VARCHAR(120) NOT NULL,
    apellido_paterno VARCHAR(120),
    apellido_materno VARCHAR(120),
    tipo_doc_identidad_id BIGINT,
    numero_documento VARCHAR(30) UNIQUE,
    fecha_nacimiento DATE,
    sexo_id BIGINT,
    estado_civil_id BIGINT,
    direccion VARCHAR(300),
    telefono VARCHAR(40),
    email VARCHAR(150),
    cuenta_bancaria_sueldo VARCHAR(60),
    cuenta_cts VARCHAR(60),
    admin_afp_id BIGINT,
    cuspp VARCHAR(30),
    regimen_laboral_id BIGINT,
    area_id BIGINT,
    cargo_id BIGINT,
    sucursal_id BIGINT,
    fecha_ingreso DATE,
    fecha_cese DATE,
    motivo_cese VARCHAR(120),
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
    CONSTRAINT FK_TRABAJADOR_09 FOREIGN KEY (sucursal_id) REFERENCES auth.sucursal(id)
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

CREATE TABLE rrhh.permiso_licencia (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    tipo_suspension_laboral_id BIGINT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    dias INTEGER,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    sustento TEXT,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_PERMISO_LICENCIA PRIMARY KEY (id),
    CONSTRAINT FK_PERMISO_LICENCIA_01 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id),
    CONSTRAINT FK_PERMISO_LICENCIA_02 FOREIGN KEY (tipo_suspension_laboral_id) REFERENCES rrhh.tipo_suspension_laboral(id),
    CONSTRAINT CK_PERMISO_LICENCIA_ESTADO CHECK (flag_estado IN ('0','1','2','3','4','5','6','7','8'))
    -- 1=Solicitado, 2=Aprobado, 3=Observado, 4=Anulado, 5=Cerrado,
    -- 6=Procesado, 7=En Planilla, 8=Ref.Boleta, 0=Rechazado
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

CREATE TABLE rrhh.liquidacion (
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
    CONSTRAINT PK_LIQUIDACION PRIMARY KEY (id),
    CONSTRAINT FK_LIQUIDACION_01 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id)
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

CREATE TABLE rrhh.cnta_crrte (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    fecha_apertura DATE,
    saldo_inicial NUMERIC(18, 4) DEFAULT 0,
    saldo_actual NUMERIC(18, 4) DEFAULT 0,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CNTA_CRRTE PRIMARY KEY (id),
    CONSTRAINT FK_CNTA_CRRTE_01 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id)
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

-- ============================================================
-- SECCIÓN 4: TABLAS CON DEPENDENCIAS MÚLTIPLES
-- ============================================================

CREATE TABLE rrhh.calculo_det (
    id BIGSERIAL NOT NULL,
    calculo_id BIGINT NOT NULL,
    trabajador_id BIGINT NOT NULL,
    concepto_id BIGINT NOT NULL,
    monto NUMERIC(18, 4) NOT NULL,
    tipo_concepto_calculo_id BIGINT NOT NULL,
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CALCULO_DET PRIMARY KEY (id),
    CONSTRAINT FK_CALCULO_DET_01 FOREIGN KEY (calculo_id) REFERENCES rrhh.calculo(id),
    CONSTRAINT FK_CALCULO_DET_02 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id),
    CONSTRAINT FK_CALCULO_DET_03 FOREIGN KEY (concepto_id) REFERENCES rrhh.concepto_planilla(id),
    CONSTRAINT FK_CALCULO_DET_04 FOREIGN KEY (tipo_concepto_calculo_id) REFERENCES rrhh.tipo_concepto_calculo(id)
);

CREATE TABLE rrhh.cnta_crrte_det (
    id BIGSERIAL NOT NULL,
    cnta_crrte_id BIGINT NOT NULL,
    fecha_movimiento DATE NOT NULL,
    tipo_movimiento_cnta_crrte_id BIGINT NOT NULL,
    concepto TEXT,
    monto NUMERIC(18, 4) NOT NULL,
    referencia VARCHAR(120),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_CNTA_CRRTE_DET PRIMARY KEY (id),
    CONSTRAINT FK_CNTA_CRRTE_DET_01 FOREIGN KEY (cnta_crrte_id) REFERENCES rrhh.cnta_crrte(id),
    CONSTRAINT FK_CNTA_CRRTE_DET_02 FOREIGN KEY (tipo_movimiento_cnta_crrte_id) REFERENCES rrhh.tipo_movimiento_cnta_crrte(id),
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

CREATE TABLE rrhh.quinta_categoria (
    id BIGSERIAL NOT NULL,
    trabajador_id BIGINT NOT NULL,
    anio INTEGER NOT NULL,
    mes INTEGER NOT NULL,
    renta_bruta_acumulada NUMERIC(18,4),
    renta_bruta_proyectada NUMERIC(18,4),
    deduccion_7uit NUMERIC(18,4),
    renta_neta NUMERIC(18,4),
    impuesto_anual_proyectado NUMERIC(18,4),
    retencion_mensual NUMERIC(18,4),
    retencion_acumulada NUMERIC(18,4),
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,
    CONSTRAINT PK_QUINTA_CATEGORIA PRIMARY KEY (id),
    CONSTRAINT FK_QUINTA_CATEGORIA_01 FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id)
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
CREATE INDEX IX_PERMISO_LICENCIA_01     ON rrhh.permiso_licencia (trabajador_id, fecha_inicio);
CREATE INDEX IX_PERMISO_LICENCIA_02     ON rrhh.permiso_licencia (tipo_suspension_laboral_id);
CREATE INDEX IX_CALCULO_01              ON rrhh.calculo (anio, mes, tipo_planilla_id);
CREATE INDEX IX_CALCULO_DET_01          ON rrhh.calculo_det (calculo_id, trabajador_id);
CREATE INDEX IX_CALCULO_DET_02          ON rrhh.calculo_det (concepto_id);
CREATE INDEX IX_GAN_DESCT_FIJO_01       ON rrhh.gan_desct_fijo (trabajador_id, concepto_id);
CREATE INDEX IX_GAN_DESCT_VARIABLE_01   ON rrhh.gan_desct_variable (trabajador_id, fec_movim);
CREATE INDEX IX_GAN_DESCT_VARIABLE_02   ON rrhh.gan_desct_variable (concepto_id);
CREATE INDEX IX_GAN_DESCT_VARIABLE_03   ON rrhh.gan_desct_variable (tipo_planilla_id);
CREATE INDEX IX_VACACION_01             ON rrhh.vacacion (trabajador_id, periodo_anio);
CREATE INDEX IX_LIQUIDACION_01          ON rrhh.liquidacion (trabajador_id, fecha_cese);
CREATE INDEX IX_PRESTAMO_01             ON rrhh.prestamo (trabajador_id, flag_estado);
CREATE INDEX IX_CNTA_CRRTE_01           ON rrhh.cnta_crrte (trabajador_id);
CREATE INDEX IX_CNTA_CRRTE_DET_01       ON rrhh.cnta_crrte_det (cnta_crrte_id, fecha_movimiento);
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
CREATE INDEX IX_QUINTA_CATEGORIA_01     ON rrhh.quinta_categoria (trabajador_id, anio, mes);

-- Migración idempotente: columna estado (texto legado) → flag_estado
ALTER TABLE rrhh.capacitacion DROP COLUMN IF EXISTS estado;
ALTER TABLE rrhh.capacitacion ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE rrhh.contrato DROP COLUMN IF EXISTS estado;
ALTER TABLE rrhh.contrato ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE rrhh.permiso_licencia DROP COLUMN IF EXISTS estado;
ALTER TABLE rrhh.permiso_licencia ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE rrhh.vacacion DROP COLUMN IF EXISTS estado;
ALTER TABLE rrhh.vacacion ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE rrhh.liquidacion DROP COLUMN IF EXISTS estado;
ALTER TABLE rrhh.liquidacion ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
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

-- Migración idempotente: catálogos VARCHAR → FK (legado sin tablas maestro)
ALTER TABLE rrhh.trabajador DROP COLUMN IF EXISTS tipo_documento;
ALTER TABLE rrhh.trabajador DROP COLUMN IF EXISTS sexo;
ALTER TABLE rrhh.trabajador DROP COLUMN IF EXISTS estado_civil;
ALTER TABLE rrhh.trabajador DROP COLUMN IF EXISTS regimen_laboral;
ALTER TABLE rrhh.trabajador ADD COLUMN IF NOT EXISTS tipo_doc_identidad_id BIGINT;
ALTER TABLE rrhh.trabajador ADD COLUMN IF NOT EXISTS sexo_id BIGINT;
ALTER TABLE rrhh.trabajador ADD COLUMN IF NOT EXISTS estado_civil_id BIGINT;
ALTER TABLE rrhh.trabajador ADD COLUMN IF NOT EXISTS regimen_laboral_id BIGINT;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_trabajador_tipo_doc_identidad')
    THEN ALTER TABLE rrhh.trabajador ADD CONSTRAINT fk_trabajador_tipo_doc_identidad FOREIGN KEY (tipo_doc_identidad_id) REFERENCES core.tipo_doc_identidad(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_trabajador_sexo')
    THEN ALTER TABLE rrhh.trabajador ADD CONSTRAINT fk_trabajador_sexo FOREIGN KEY (sexo_id) REFERENCES rrhh.sexo(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_trabajador_estado_civil')
    THEN ALTER TABLE rrhh.trabajador ADD CONSTRAINT fk_trabajador_estado_civil FOREIGN KEY (estado_civil_id) REFERENCES rrhh.estado_civil(id); END IF; END $$;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_trabajador_regimen_laboral')
    THEN ALTER TABLE rrhh.trabajador ADD CONSTRAINT fk_trabajador_regimen_laboral FOREIGN KEY (regimen_laboral_id) REFERENCES rrhh.regimen_laboral(id); END IF; END $$;

ALTER TABLE rrhh.contrato DROP COLUMN IF EXISTS tipo;
ALTER TABLE rrhh.contrato ADD COLUMN IF NOT EXISTS tipo_contrato_id BIGINT;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_contrato_tipo_contrato')
    THEN ALTER TABLE rrhh.contrato ADD CONSTRAINT fk_contrato_tipo_contrato FOREIGN KEY (tipo_contrato_id) REFERENCES rrhh.tipo_contrato(id); END IF; END $$;

ALTER TABLE rrhh.asistencia DROP COLUMN IF EXISTS tipo_marca;
ALTER TABLE rrhh.asistencia ADD COLUMN IF NOT EXISTS tipo_mov_asistencia_id BIGINT;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_asistencia_tipo_mov')
    THEN ALTER TABLE rrhh.asistencia ADD CONSTRAINT fk_asistencia_tipo_mov FOREIGN KEY (tipo_mov_asistencia_id) REFERENCES rrhh.tipo_mov_asistencia(id); END IF; END $$;

ALTER TABLE rrhh.permiso_licencia DROP COLUMN IF EXISTS tipo;
ALTER TABLE rrhh.permiso_licencia ADD COLUMN IF NOT EXISTS tipo_suspension_laboral_id BIGINT;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_permiso_licencia_tipo_susp')
    THEN ALTER TABLE rrhh.permiso_licencia ADD CONSTRAINT fk_permiso_licencia_tipo_susp FOREIGN KEY (tipo_suspension_laboral_id) REFERENCES rrhh.tipo_suspension_laboral(id); END IF; END $$;

ALTER TABLE rrhh.sancion_amonestacion DROP COLUMN IF EXISTS tipo;
ALTER TABLE rrhh.sancion_amonestacion ADD COLUMN IF NOT EXISTS tipo_sancion_id BIGINT;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_sancion_amonestacion_tipo')
    THEN ALTER TABLE rrhh.sancion_amonestacion ADD CONSTRAINT fk_sancion_amonestacion_tipo FOREIGN KEY (tipo_sancion_id) REFERENCES rrhh.tipo_sancion(id); END IF; END $$;

ALTER TABLE rrhh.control_subsidio DROP COLUMN IF EXISTS tipo;
ALTER TABLE rrhh.control_subsidio ADD COLUMN IF NOT EXISTS tipo_subsidio_id BIGINT;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_control_subsidio_tipo')
    THEN ALTER TABLE rrhh.control_subsidio ADD CONSTRAINT fk_control_subsidio_tipo FOREIGN KEY (tipo_subsidio_id) REFERENCES rrhh.tipo_subsidio(id); END IF; END $$;

ALTER TABLE rrhh.calculo DROP COLUMN IF EXISTS tipo;
ALTER TABLE rrhh.calculo ADD COLUMN IF NOT EXISTS tipo_planilla_id BIGINT;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_calculo_tipo_planilla')
    THEN ALTER TABLE rrhh.calculo ADD CONSTRAINT fk_calculo_tipo_planilla FOREIGN KEY (tipo_planilla_id) REFERENCES rrhh.tipo_planilla(id); END IF; END $$;

ALTER TABLE rrhh.calculo_det DROP COLUMN IF EXISTS tipo;
ALTER TABLE rrhh.calculo_det ADD COLUMN IF NOT EXISTS tipo_concepto_calculo_id BIGINT;
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_calculo_det_tipo_concepto')
    THEN ALTER TABLE rrhh.calculo_det ADD CONSTRAINT fk_calculo_det_tipo_concepto FOREIGN KEY (tipo_concepto_calculo_id) REFERENCES rrhh.tipo_concepto_calculo(id); END IF; END $$;

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

-- FK diferida: finanzas.cntas_pagar_det.trabajador_id → rrhh.trabajador(id)
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_cpd_trabajador')
    THEN ALTER TABLE finanzas.cntas_pagar_det ADD CONSTRAINT fk_cpd_trabajador FOREIGN KEY (trabajador_id) REFERENCES rrhh.trabajador(id); END IF; END $$;
