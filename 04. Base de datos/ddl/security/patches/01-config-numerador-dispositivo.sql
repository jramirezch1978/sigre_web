-- ============================================================
-- Patch incremental (sigre_security):
--   - config.numerador + config.fn_siguiente_numerador
--   - seed codigo DISPOSITIVO (serie DM, longitud 10)
--   - sincroniza ultimo_numero con dispositivos ya existentes
-- Idempotente: se puede reejecutar sin romper datos.
-- ============================================================

CREATE TABLE IF NOT EXISTS config.numerador (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(30) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    serie VARCHAR(10),
    ultimo_numero BIGINT NOT NULL DEFAULT 0 CHECK (ultimo_numero >= 0),
    longitud INTEGER NOT NULL DEFAULT 10 CHECK (longitud BETWEEN 1 AND 20),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_estado IN ('0', '1')),
    fec_creacion TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    fec_modificacion TIMESTAMPTZ,
    CONSTRAINT uq_config_numerador_codigo UNIQUE (codigo)
);

COMMENT ON TABLE config.numerador IS
    'Autonumericos de security. ultimo_numero = ultimo emitido; fn_siguiente_numerador incrementa y formatea serie+padding.';

CREATE INDEX IF NOT EXISTS IX_CONFIG_NUMERADOR_01 ON config.numerador (flag_estado);

CREATE OR REPLACE FUNCTION config.fn_siguiente_numerador(p_codigo VARCHAR(30))
RETURNS VARCHAR
LANGUAGE plpgsql VOLATILE AS $$
DECLARE
    v_serie     VARCHAR(10);
    v_longitud  INTEGER;
    v_numero    BIGINT;
BEGIN
    IF p_codigo IS NULL OR TRIM(p_codigo) = '' THEN
        RAISE EXCEPTION 'Codigo de numerador requerido';
    END IF;

    UPDATE config.numerador
    SET ultimo_numero = ultimo_numero + 1,
        fec_modificacion = NOW()
    WHERE codigo = UPPER(TRIM(p_codigo))
      AND flag_estado = '1'
    RETURNING COALESCE(serie, ''), longitud, ultimo_numero
    INTO v_serie, v_longitud, v_numero;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Numerador % no existe o esta inactivo', UPPER(TRIM(p_codigo));
    END IF;

    RETURN v_serie || lpad(v_numero::text, v_longitud, '0');
END;
$$;

COMMENT ON FUNCTION config.fn_siguiente_numerador(VARCHAR)
    IS 'Obtiene el siguiente correlativo de config.numerador (UPDATE+1 con bloqueo de fila). Formato: serie + numero padded.';

INSERT INTO config.numerador (codigo, nombre, serie, ultimo_numero, longitud, flag_estado)
VALUES ('DISPOSITIVO', 'Dispositivos móviles (Hermes / apps nativas)', 'DM', 0, 10, '1')
ON CONFLICT (codigo) DO UPDATE SET
    nombre = EXCLUDED.nombre,
    serie = EXCLUDED.serie,
    longitud = EXCLUDED.longitud,
    flag_estado = EXCLUDED.flag_estado,
    fec_modificacion = NOW();

-- Evita colisión con nro_registro ya emitidos (DM########## o solo dígitos legacy).
UPDATE config.numerador n
SET ultimo_numero = GREATEST(
        n.ultimo_numero,
        COALESCE((
            SELECT MAX(
                CASE
                    WHEN d.nro_registro ~ '^DM[0-9]+$' THEN substring(d.nro_registro FROM 3)::bigint
                    WHEN d.nro_registro ~ '^[0-9]+$' THEN d.nro_registro::bigint
                    ELSE 0
                END
            )
            FROM auth.dispositivo d
        ), 0)
    ),
    fec_modificacion = NOW()
WHERE n.codigo = 'DISPOSITIVO';
