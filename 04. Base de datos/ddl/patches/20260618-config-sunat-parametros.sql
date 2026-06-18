-- PATCH: Funciones get parametro en config (security) y seed SUNAT API

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

INSERT INTO config.configuracion (modulo, parametro, tipo_dato, valor_texto, editable, activo)
VALUES
    ('SUNAT', 'API_BASE_URL', 'TEXT', 'http://pegazus.serveftp.com:9080/SunatWebServices', TRUE, TRUE),
    ('SUNAT', 'API_USUARIO', 'TEXT', 'sigre', TRUE, TRUE),
    ('SUNAT', 'API_CLAVE', 'TEXT', 'sigre1234', TRUE, TRUE),
    ('SUNAT', 'API_EMPRESA', 'TEXT', 'TRANSMARINA', TRUE, TRUE),
    ('SUNAT', 'API_RUC_ORIGEN', 'TEXT', '20100070970', TRUE, TRUE),
    ('SUNAT', 'API_IP_LOCAL', 'TEXT', '192.168.1.100', TRUE, TRUE),
    ('SUNAT', 'API_COMPUTER_NAME', 'TEXT', 'SIGRE-WEB', TRUE, TRUE)
ON CONFLICT (modulo, parametro) DO UPDATE SET
    tipo_dato = EXCLUDED.tipo_dato,
    valor_texto = EXCLUDED.valor_texto,
    editable = EXCLUDED.editable,
    activo = EXCLUDED.activo,
    modificado_en = NOW();
