-- ============================================================
-- SIGRE ERP - Security DB - config schema
-- Estrategia: DROP + CREATE (reconstrucción completa)
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

CREATE SCHEMA IF NOT EXISTS config;

-- ============================================================
-- SECCIÓN 1: DROP (eliminar tablas en orden correcto por FK)
-- ============================================================
--
-- DIAGRAMA DE RELACIONES (→ = tiene FK hacia):
--
--   configuracion (sin dependencias)
--   config_traduccion (sin dependencias)
--
-- ORDEN DE DROP (sin dependencias entre ellas, orden libre):
--   1. config_traduccion
--   2. configuracion
-- ============================================================

DROP TABLE IF EXISTS config.config_traduccion CASCADE;
DROP TABLE IF EXISTS config.configuracion CASCADE;

-- ============================================================
-- SECCIÓN 2: CREATE (crear tablas, constraints e índices)
-- ============================================================

CREATE TABLE config.configuracion (
    id BIGSERIAL PRIMARY KEY,
    modulo VARCHAR(60) NOT NULL,
    parametro VARCHAR(120) NOT NULL,
    tipo_dato VARCHAR(20) NOT NULL,
    valor_texto TEXT,
    valor_entero INTEGER,
    valor_decimal NUMERIC(18, 6),
    valor_fecha DATE,
    editable BOOLEAN NOT NULL DEFAULT TRUE,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    modificado_en TIMESTAMPTZ,
    UNIQUE (modulo, parametro)
);

CREATE TABLE config.config_traduccion (
    id BIGSERIAL PRIMARY KEY,
    idioma VARCHAR(10) NOT NULL,
    clave VARCHAR(180) NOT NULL,
    texto TEXT NOT NULL,
    modulo VARCHAR(60),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    modificado_en TIMESTAMPTZ,
    UNIQUE (idioma, clave)
);

-- ============================================================
-- SECCIÓN 3: ÍNDICES
-- ============================================================

CREATE INDEX IX_CONFIGURACION_01 ON config.configuracion (modulo, activo);
CREATE INDEX IX_CONFIG_TRADUCCION_01 ON config.config_traduccion (idioma, modulo);

-- ============================================================
-- Funciones de acceso a config.configuracion (BD security).
-- Si el parámetro no existe lo INSERTA con el valor por defecto y lo retorna.
-- Nomenclatura: config.fn_get_parametro_<sufijo>(modulo, parametro, default).
-- ============================================================

CREATE OR REPLACE FUNCTION config.fn_get_parametro_txt(
    p_modulo VARCHAR(60),
    p_parametro VARCHAR(120),
    p_default TEXT DEFAULT NULL
) RETURNS TEXT
LANGUAGE plpgsql VOLATILE AS $$
DECLARE
    lvar_valor TEXT;
BEGIN
    SELECT c.valor_texto INTO lvar_valor
    FROM config.configuracion c
    WHERE c.modulo = p_modulo
      AND c.parametro = p_parametro
      AND c.activo = TRUE;

    IF NOT FOUND THEN
        INSERT INTO config.configuracion (modulo, parametro, tipo_dato, valor_texto, editable, activo)
        VALUES (p_modulo, p_parametro, 'TEXT', p_default, TRUE, TRUE);
        RETURN p_default;
    END IF;

    RETURN COALESCE(NULLIF(TRIM(lvar_valor), ''), p_default);
END;
$$;

CREATE OR REPLACE FUNCTION config.fn_get_parametro_int(
    p_modulo VARCHAR(60),
    p_parametro VARCHAR(120),
    p_default INTEGER DEFAULT 0
) RETURNS INTEGER
LANGUAGE plpgsql VOLATILE AS $$
DECLARE
    lint_valor INTEGER;
BEGIN
    SELECT c.valor_entero INTO lint_valor
    FROM config.configuracion c
    WHERE c.modulo = p_modulo
      AND c.parametro = p_parametro
      AND c.activo = TRUE;

    IF NOT FOUND THEN
        INSERT INTO config.configuracion (modulo, parametro, tipo_dato, valor_entero, editable, activo)
        VALUES (p_modulo, p_parametro, 'INTEGER', p_default, TRUE, TRUE);
        RETURN p_default;
    END IF;

    RETURN COALESCE(lint_valor, p_default);
END;
$$;

CREATE OR REPLACE FUNCTION config.fn_get_parametro_dec(
    p_modulo VARCHAR(60),
    p_parametro VARCHAR(120),
    p_default NUMERIC DEFAULT 0
) RETURNS NUMERIC(18, 6)
LANGUAGE plpgsql VOLATILE AS $$
DECLARE
    ldec_valor NUMERIC(18, 6);
BEGIN
    SELECT c.valor_decimal INTO ldec_valor
    FROM config.configuracion c
    WHERE c.modulo = p_modulo
      AND c.parametro = p_parametro
      AND c.activo = TRUE;

    IF NOT FOUND THEN
        INSERT INTO config.configuracion (modulo, parametro, tipo_dato, valor_decimal, editable, activo)
        VALUES (p_modulo, p_parametro, 'DECIMAL', p_default, TRUE, TRUE);
        RETURN p_default;
    END IF;

    RETURN COALESCE(ldec_valor, p_default);
END;
$$;

CREATE OR REPLACE FUNCTION config.fn_get_parametro_bool(
    p_modulo VARCHAR(60),
    p_parametro VARCHAR(120),
    p_default BOOLEAN DEFAULT FALSE
) RETURNS BOOLEAN
LANGUAGE plpgsql VOLATILE AS $$
DECLARE
    lbol_valor BOOLEAN;
BEGIN
    SELECT CASE
               WHEN UPPER(TRIM(COALESCE(c.valor_texto, ''))) IN ('1', 'S', 'SI', 'TRUE', 'Y', 'YES') THEN TRUE
               WHEN UPPER(TRIM(COALESCE(c.valor_texto, ''))) IN ('0', 'N', 'NO', 'FALSE') THEN FALSE
               ELSE NULL
           END INTO lbol_valor
    FROM config.configuracion c
    WHERE c.modulo = p_modulo
      AND c.parametro = p_parametro
      AND c.activo = TRUE;

    IF NOT FOUND THEN
        INSERT INTO config.configuracion (modulo, parametro, tipo_dato, valor_texto, editable, activo)
        VALUES (p_modulo, p_parametro, 'BOOLEAN', CASE WHEN p_default THEN '1' ELSE '0' END, TRUE, TRUE);
        RETURN p_default;
    END IF;

    RETURN COALESCE(lbol_valor, p_default);
END;
$$;

COMMENT ON FUNCTION config.fn_get_parametro_txt(VARCHAR, VARCHAR, TEXT)
    IS 'Parámetro TEXT de config.configuracion (security); si no existe lo crea con el default.';
COMMENT ON FUNCTION config.fn_get_parametro_int(VARCHAR, VARCHAR, INTEGER)
    IS 'Parámetro INTEGER de config.configuracion (security); si no existe lo crea con el default.';
COMMENT ON FUNCTION config.fn_get_parametro_dec(VARCHAR, VARCHAR, NUMERIC)
    IS 'Parámetro DECIMAL de config.configuracion (security); si no existe lo crea con el default.';
COMMENT ON FUNCTION config.fn_get_parametro_bool(VARCHAR, VARCHAR, BOOLEAN)
    IS 'Parámetro BOOLEAN de config.configuracion (security); si no existe lo crea con el default.';
