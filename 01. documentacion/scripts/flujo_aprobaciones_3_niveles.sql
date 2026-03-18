-- ============================================================
-- FLUJO DE APROBACIONES 3 NIVELES
-- Solicitado por: Wilfredo Merma (10/12/2025)
-- Desarrollado por: Jhonny Ramirez
-- Fecha: 08/02/2026
--
-- Alcance:
--   - Orden de Compra (OC) → detalle: ARTICULO_MOV_PROY
--   - Orden de Trabajo (OT) → detalle: ARTICULO_MOV_PROY + OPERACIONES
--   - Programa de Compras (PC) → detalle: PROG_COMPRAS_DET
--
-- Niveles:
--   1 = V1B1 (Gerencias / Control Presupuestal)
--   2 = V2B2 (Control Interno)
--   3 = GAF  (Gerencia de Administracion y Finanzas - Aprobacion Final)
-- ============================================================

-- ============================================================
-- 1. TABLA NUEVA: APROBADORES
--    Configuracion de niveles de aprobacion por usuario
-- ============================================================

CREATE TABLE APROBADORES (
    COD_USR              CHAR(6)   NOT NULL,
    FLAG_ESTADO          CHAR(1)   DEFAULT '1' NOT NULL,
    NIV_ORDEN_COMPRA     CHAR(1),
    NIV_PROGRAMA_COMPRAS CHAR(1),
    NIV_ORDEN_TRABAJO    CHAR(1),
    CONSTRAINT PK_APROBADORES PRIMARY KEY (COD_USR),
    CONSTRAINT FK_APROB_USR FOREIGN KEY (COD_USR) REFERENCES USUARIO(COD_USR),
    CONSTRAINT CK_NIV_OC CHECK (NIV_ORDEN_COMPRA IN ('1','2','3')),
    CONSTRAINT CK_NIV_PC CHECK (NIV_PROGRAMA_COMPRAS IN ('1','2','3')),
    CONSTRAINT CK_NIV_OT CHECK (NIV_ORDEN_TRABAJO IN ('1','2','3'))
);

COMMENT ON TABLE APROBADORES IS 'Configuracion de niveles de aprobacion por usuario y tipo de documento';
COMMENT ON COLUMN APROBADORES.COD_USR IS 'Codigo de usuario (FK a USUARIO)';
COMMENT ON COLUMN APROBADORES.FLAG_ESTADO IS 'Estado del registro: 1=Activo, 0=Inactivo';
COMMENT ON COLUMN APROBADORES.NIV_ORDEN_COMPRA IS 'Nivel de aprobacion para OC: 1=V1B1, 2=V2B2, 3=GAF';
COMMENT ON COLUMN APROBADORES.NIV_PROGRAMA_COMPRAS IS 'Nivel de aprobacion para Prog.Compras: 1=V1B1, 2=V2B2, 3=GAF';
COMMENT ON COLUMN APROBADORES.NIV_ORDEN_TRABAJO IS 'Nivel de aprobacion para OT: 1=V1B1, 2=V2B2, 3=GAF';

-- ============================================================
-- 2. ALTER TABLE: ARTICULO_MOV_PROY
--    Detalle de Ordenes de Compra y Ordenes de Trabajo
-- ============================================================

ALTER TABLE ARTICULO_MOV_PROY ADD (
    USUARIO_NIV1     CHAR(6),
    FECHA_APROB1     DATE,
    FECHA_RECHAZO1   DATE,
    MOTIVO_RECHAZO1  VARCHAR2(2000),
    USUARIO_NIV2     CHAR(6),
    FECHA_APROB2     DATE,
    FECHA_RECHAZO2   DATE,
    MOTIVO_RECHAZO2  VARCHAR2(2000),
    USUARIO_NIV3     CHAR(6),
    FECHA_APROB3     DATE,
    FECHA_RECHAZO3   DATE,
    MOTIVO_RECHAZO3  VARCHAR2(2000)
);

COMMENT ON COLUMN ARTICULO_MOV_PROY.USUARIO_NIV1 IS 'Usuario que aprobo/rechazo en Nivel 1 (V1B1)';
COMMENT ON COLUMN ARTICULO_MOV_PROY.FECHA_APROB1 IS 'Fecha de aprobacion Nivel 1';
COMMENT ON COLUMN ARTICULO_MOV_PROY.FECHA_RECHAZO1 IS 'Fecha de rechazo Nivel 1';
COMMENT ON COLUMN ARTICULO_MOV_PROY.MOTIVO_RECHAZO1 IS 'Motivo de rechazo Nivel 1';
COMMENT ON COLUMN ARTICULO_MOV_PROY.USUARIO_NIV2 IS 'Usuario que aprobo/rechazo en Nivel 2 (V2B2)';
COMMENT ON COLUMN ARTICULO_MOV_PROY.FECHA_APROB2 IS 'Fecha de aprobacion Nivel 2';
COMMENT ON COLUMN ARTICULO_MOV_PROY.FECHA_RECHAZO2 IS 'Fecha de rechazo Nivel 2';
COMMENT ON COLUMN ARTICULO_MOV_PROY.MOTIVO_RECHAZO2 IS 'Motivo de rechazo Nivel 2';
COMMENT ON COLUMN ARTICULO_MOV_PROY.USUARIO_NIV3 IS 'Usuario que aprobo/rechazo en Nivel 3 (GAF)';
COMMENT ON COLUMN ARTICULO_MOV_PROY.FECHA_APROB3 IS 'Fecha de aprobacion Nivel 3';
COMMENT ON COLUMN ARTICULO_MOV_PROY.FECHA_RECHAZO3 IS 'Fecha de rechazo Nivel 3';
COMMENT ON COLUMN ARTICULO_MOV_PROY.MOTIVO_RECHAZO3 IS 'Motivo de rechazo Nivel 3';

-- ============================================================
-- 3. ALTER TABLE: OPERACIONES
--    Detalle de Ordenes de Trabajo (servicios de terceros)
-- ============================================================

ALTER TABLE OPERACIONES ADD (
    USUARIO_NIV1     CHAR(6),
    FECHA_APROB1     DATE,
    FECHA_RECHAZO1   DATE,
    MOTIVO_RECHAZO1  VARCHAR2(2000),
    USUARIO_NIV2     CHAR(6),
    FECHA_APROB2     DATE,
    FECHA_RECHAZO2   DATE,
    MOTIVO_RECHAZO2  VARCHAR2(2000),
    USUARIO_NIV3     CHAR(6),
    FECHA_APROB3     DATE,
    FECHA_RECHAZO3   DATE,
    MOTIVO_RECHAZO3  VARCHAR2(2000)
);

COMMENT ON COLUMN OPERACIONES.USUARIO_NIV1 IS 'Usuario que aprobo/rechazo en Nivel 1 (V1B1)';
COMMENT ON COLUMN OPERACIONES.FECHA_APROB1 IS 'Fecha de aprobacion Nivel 1';
COMMENT ON COLUMN OPERACIONES.FECHA_RECHAZO1 IS 'Fecha de rechazo Nivel 1';
COMMENT ON COLUMN OPERACIONES.MOTIVO_RECHAZO1 IS 'Motivo de rechazo Nivel 1';
COMMENT ON COLUMN OPERACIONES.USUARIO_NIV2 IS 'Usuario que aprobo/rechazo en Nivel 2 (V2B2)';
COMMENT ON COLUMN OPERACIONES.FECHA_APROB2 IS 'Fecha de aprobacion Nivel 2';
COMMENT ON COLUMN OPERACIONES.FECHA_RECHAZO2 IS 'Fecha de rechazo Nivel 2';
COMMENT ON COLUMN OPERACIONES.MOTIVO_RECHAZO2 IS 'Motivo de rechazo Nivel 2';
COMMENT ON COLUMN OPERACIONES.USUARIO_NIV3 IS 'Usuario que aprobo/rechazo en Nivel 3 (GAF)';
COMMENT ON COLUMN OPERACIONES.FECHA_APROB3 IS 'Fecha de aprobacion Nivel 3';
COMMENT ON COLUMN OPERACIONES.FECHA_RECHAZO3 IS 'Fecha de rechazo Nivel 3';
COMMENT ON COLUMN OPERACIONES.MOTIVO_RECHAZO3 IS 'Motivo de rechazo Nivel 3';

-- ============================================================
-- 4. ALTER TABLE: PROG_COMPRAS_DET
--    Detalle de Programa de Compras
-- ============================================================

ALTER TABLE PROG_COMPRAS_DET ADD (
    USUARIO_NIV1     CHAR(6),
    FECHA_APROB1     DATE,
    FECHA_RECHAZO1   DATE,
    MOTIVO_RECHAZO1  VARCHAR2(2000),
    USUARIO_NIV2     CHAR(6),
    FECHA_APROB2     DATE,
    FECHA_RECHAZO2   DATE,
    MOTIVO_RECHAZO2  VARCHAR2(2000),
    USUARIO_NIV3     CHAR(6),
    FECHA_APROB3     DATE,
    FECHA_RECHAZO3   DATE,
    MOTIVO_RECHAZO3  VARCHAR2(2000)
);

COMMENT ON COLUMN PROG_COMPRAS_DET.USUARIO_NIV1 IS 'Usuario que aprobo/rechazo en Nivel 1 (V1B1)';
COMMENT ON COLUMN PROG_COMPRAS_DET.FECHA_APROB1 IS 'Fecha de aprobacion Nivel 1';
COMMENT ON COLUMN PROG_COMPRAS_DET.FECHA_RECHAZO1 IS 'Fecha de rechazo Nivel 1';
COMMENT ON COLUMN PROG_COMPRAS_DET.MOTIVO_RECHAZO1 IS 'Motivo de rechazo Nivel 1';
COMMENT ON COLUMN PROG_COMPRAS_DET.USUARIO_NIV2 IS 'Usuario que aprobo/rechazo en Nivel 2 (V2B2)';
COMMENT ON COLUMN PROG_COMPRAS_DET.FECHA_APROB2 IS 'Fecha de aprobacion Nivel 2';
COMMENT ON COLUMN PROG_COMPRAS_DET.FECHA_RECHAZO2 IS 'Fecha de rechazo Nivel 2';
COMMENT ON COLUMN PROG_COMPRAS_DET.MOTIVO_RECHAZO2 IS 'Motivo de rechazo Nivel 2';
COMMENT ON COLUMN PROG_COMPRAS_DET.USUARIO_NIV3 IS 'Usuario que aprobo/rechazo en Nivel 3 (GAF)';
COMMENT ON COLUMN PROG_COMPRAS_DET.FECHA_APROB3 IS 'Fecha de aprobacion Nivel 3';
COMMENT ON COLUMN PROG_COMPRAS_DET.FECHA_RECHAZO3 IS 'Fecha de rechazo Nivel 3';
COMMENT ON COLUMN PROG_COMPRAS_DET.MOTIVO_RECHAZO3 IS 'Motivo de rechazo Nivel 3';

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================
