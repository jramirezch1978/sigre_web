-- ===============================================================
-- TABLA: origen
-- FECHA: 19/11/2025
-- DESCRIPCIÓN: Catálogo de plantas/ubicaciones del sistema
-- SINCRONIZACIÓN: Solo remota → local (bd_remota → bd_local)
-- ===============================================================

CREATE TABLE IF NOT EXISTS origen (
    COD_ORIGEN CHAR(2) PRIMARY KEY,
    NOMBRE VARCHAR(30),
    DIR_CALLE VARCHAR(100),
    DIR_NUMERO VARCHAR(10),
    DIR_LOTE VARCHAR(10),
    DIR_MNZ VARCHAR(10),
    DIR_URBANIZACION VARCHAR(50),
    DIR_DISTRITO VARCHAR(30),
    DIR_DEPARTAMENTO VARCHAR(30),
    DIR_PROVINCIA VARCHAR(30),
    DIR_COD_POSTAL VARCHAR(10),
    TELEFONO VARCHAR(20),
    FAX VARCHAR(20),
    EMAIL VARCHAR(50),
    FLAG_REPLICACION CHAR(1) DEFAULT '1',
    FLAG_ESTADO CHAR(1) DEFAULT '1',
    CEN_BEF_GEN_OC CHAR(12),
    CEN_BEF_GEN_VTAS CHAR(12),
    CENCOS_OC CHAR(10),
    CNTA_PRSP_OC CHAR(10),
    CENCOS_IGV CHAR(10),
    CNTA_PRSP_IGV CHAR(10),
    FLAG_PRSP_IGV CHAR(1) DEFAULT '1',
    
    -- Campos de sincronización
    FECHA_SYNC DATE,
    ESTADO_SYNC CHAR(1) DEFAULT 'P' -- P=Pendiente, S=Sincronizado, E=Error
);

COMMENT ON TABLE origen IS 'Catálogo de plantas/ubicaciones - Sincronización unidireccional remota → local';
COMMENT ON COLUMN origen.COD_ORIGEN IS 'Código de origen/planta (SE=Sechura, PI=Pisco, LI=Lima)';
COMMENT ON COLUMN origen.NOMBRE IS 'Nombre de la planta';
COMMENT ON COLUMN origen.FLAG_ESTADO IS '1=Activo, 0=Inactivo';
COMMENT ON COLUMN origen.FECHA_SYNC IS 'Última fecha de sincronización';
COMMENT ON COLUMN origen.ESTADO_SYNC IS 'Estado de sincronización: P=Pendiente, S=Sincronizado, E=Error';

-- Índices
CREATE INDEX IF NOT EXISTS idx_origen_estado ON origen(FLAG_ESTADO);
CREATE INDEX IF NOT EXISTS idx_origen_sync ON origen(ESTADO_SYNC);

