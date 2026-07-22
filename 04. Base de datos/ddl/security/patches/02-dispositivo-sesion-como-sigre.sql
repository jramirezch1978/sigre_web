-- ============================================================
-- Patch incremental (sigre_security):
-- Alinea auth.dispositivo / auth.dispositivo_login al modelo SIGRE:
--   DEVICE_MOBILE    → auth.dispositivo       (maestro, SIN nro_registro)
--   SEG_LOGIN_DEVICE → auth.dispositivo_login (sesiones, PK = nro_registro)
-- Idempotente: dropea y recrea (datos de prueba de dispositivos se pierden).
-- Requiere config.numerador DISPOSITIVO (patch-security-numerador).
-- ============================================================

DROP TABLE IF EXISTS auth.dispositivo_login CASCADE;
DROP TABLE IF EXISTS auth.dispositivo CASCADE;

CREATE TABLE auth.dispositivo (
    id BIGSERIAL PRIMARY KEY,
    device_id VARCHAR(200) NOT NULL,
    nombre_dispositivo VARCHAR(200),
    fabricante VARCHAR(200),
    modelo VARCHAR(200),
    flag_autorizado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_autorizado IN ('0', '1')),
    fec_registro TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    fec_ultimo_login TIMESTAMPTZ,
    fec_creacion TIMESTAMPTZ DEFAULT NOW(),
    fec_modificacion TIMESTAMPTZ,
    created_by BIGINT,
    updated_by BIGINT,
    CONSTRAINT uq_dispositivo_device_id UNIQUE (device_id)
);

COMMENT ON TABLE auth.dispositivo IS
    'Maestro de equipos moviles (SIGRE DEVICE_MOBILE). Sin nro_registro: ese correlativo es de la sesion.';

CREATE TABLE auth.dispositivo_login (
    nro_registro VARCHAR(15) PRIMARY KEY,
    dispositivo_id BIGINT NOT NULL REFERENCES auth.dispositivo(id),
    device_id VARCHAR(200) NOT NULL,
    imei VARCHAR(200),
    software VARCHAR(200),
    nombre_dispositivo VARCHAR(200),
    fabricante VARCHAR(200),
    modelo VARCHAR(200),
    usuario_id BIGINT REFERENCES auth.usuario(id),
    fec_login TIMESTAMPTZ,
    fec_logout TIMESTAMPTZ,
    fec_registro TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_dispositivo_login_device
        FOREIGN KEY (device_id) REFERENCES auth.dispositivo(device_id)
);

COMMENT ON TABLE auth.dispositivo_login IS
    'Sesiones de dispositivos moviles (SIGRE SEG_LOGIN_DEVICE). PK = nro_registro autonumerico.';

CREATE INDEX ix_dispositivo_login_dispositivo ON auth.dispositivo_login (dispositivo_id, fec_registro DESC);
CREATE INDEX ix_dispositivo_login_device ON auth.dispositivo_login (device_id, fec_registro DESC);
CREATE INDEX ix_dispositivo_login_usuario ON auth.dispositivo_login (usuario_id);
CREATE INDEX ix_dispositivo_login_abierta ON auth.dispositivo_login (device_id)
    WHERE fec_logout IS NULL;

-- Asegura numerador (por si el patch 01 no se aplicó).
INSERT INTO config.numerador (codigo, nombre, serie, ultimo_numero, longitud, flag_estado)
VALUES ('DISPOSITIVO', 'Sesiones de dispositivos móviles (SEG_LOGIN_DEVICE)', 'DM', 0, 10, '1')
ON CONFLICT (codigo) DO UPDATE SET
    nombre = EXCLUDED.nombre,
    serie = EXCLUDED.serie,
    longitud = EXCLUDED.longitud,
    flag_estado = EXCLUDED.flag_estado,
    fec_modificacion = NOW();
