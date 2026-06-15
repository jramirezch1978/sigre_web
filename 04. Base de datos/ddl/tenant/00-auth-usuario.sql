-- ============================================================
-- SIGRE ERP — auth.usuario en BD tenant (y template)
-- ============================================================
-- Ejecutar en: template_sigre y en cada sigre_emp_*.
-- Idempotente: CREATE IF NOT EXISTS + ALTER ADD COLUMN IF NOT EXISTS.
-- Requerido por ms-auth-security (sync usuario security → tenant).
-- Orden: 00-auth-usuario → 01-auth.sql (auth.sucursal) → 01-core.sql (ver database-deploy.bat).
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

CREATE SCHEMA IF NOT EXISTS auth;

-- En template solo deben existir estas tablas auth:
--   auth.usuario, auth.usuario_sucursal (sucursal_id apunta a auth.sucursal)
-- El resto de objetos auth pertenecen solo a la BD security.
DROP TABLE IF EXISTS auth.token_uso_log CASCADE;
DROP TABLE IF EXISTS auth.codigo_recuperacion CASCADE;
DROP TABLE IF EXISTS auth.notificacion CASCADE;
DROP TABLE IF EXISTS auth.log_acceso CASCADE;
DROP TABLE IF EXISTS auth.tokens_session CASCADE;
DROP TABLE IF EXISTS auth.sesion CASCADE;
DROP TABLE IF EXISTS auth.usuario_opcion_menu CASCADE;
DROP TABLE IF EXISTS auth.rol_usuario CASCADE;
DROP TABLE IF EXISTS auth.usuario_empresa CASCADE;
DROP TABLE IF EXISTS auth.rol_opcion_menu_accion CASCADE;
DROP TABLE IF EXISTS auth.rol_opcion_menu CASCADE;
DROP TABLE IF EXISTS auth.accion CASCADE;
DROP TABLE IF EXISTS auth.opcion_menu CASCADE;
DROP TABLE IF EXISTS auth.modulo CASCADE;
DROP TABLE IF EXISTS auth.rol CASCADE;
DROP TABLE IF EXISTS auth.usuario_sucursal CASCADE;
DROP TABLE IF EXISTS auth.sucursal CASCADE;
DROP TABLE IF EXISTS auth.usuario CASCADE;

CREATE TABLE IF NOT EXISTS auth.usuario (
    id BIGINT PRIMARY KEY,
    username VARCHAR(80) NOT NULL UNIQUE,
    email VARCHAR(150) UNIQUE,
    password TEXT NOT NULL,
    nombres VARCHAR(120) NOT NULL,
    apellidos VARCHAR(120),
    nombre_completo VARCHAR(200) NOT NULL,
    dos_factor_habilitado BOOLEAN NOT NULL DEFAULT FALSE,
    bloqueado BOOLEAN NOT NULL DEFAULT FALSE,
    ultimo_login_en TIMESTAMPTZ,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    created_by BIGINT NOT NULL DEFAULT 1,
    fec_creacion TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_by BIGINT DEFAULT 1,
    fec_modificacion TIMESTAMPTZ
);

-- Tablas antiguas: normalizar create_by/modified_by -> created_by/updated_by.
DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'auth'
          AND table_name = 'usuario'
          AND column_name = 'create_by'
    ) AND NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'auth'
          AND table_name = 'usuario'
          AND column_name = 'created_by'
    ) THEN
        ALTER TABLE auth.usuario RENAME COLUMN create_by TO created_by;
    END IF;

    IF EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'auth'
          AND table_name = 'usuario'
          AND column_name = 'modified_by'
    ) AND NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'auth'
          AND table_name = 'usuario'
          AND column_name = 'updated_by'
    ) THEN
        ALTER TABLE auth.usuario RENAME COLUMN modified_by TO updated_by;
    END IF;
END $$;

-- Tablas antiguas: el CREATE anterior no añade columnas nuevas.
ALTER TABLE auth.usuario ADD COLUMN IF NOT EXISTS flag_estado VARCHAR(1) NOT NULL DEFAULT '1';
ALTER TABLE auth.usuario ADD COLUMN IF NOT EXISTS created_by BIGINT NOT NULL DEFAULT 1;
ALTER TABLE auth.usuario ADD COLUMN IF NOT EXISTS fec_creacion TIMESTAMPTZ NOT NULL DEFAULT NOW();
ALTER TABLE auth.usuario ADD COLUMN IF NOT EXISTS updated_by BIGINT DEFAULT 1;
ALTER TABLE auth.usuario ADD COLUMN IF NOT EXISTS fec_modificacion TIMESTAMPTZ;
-- Si existia columna legacy 'activo', migrar su valor a flag_estado y eliminarla.
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'auth' AND table_name = 'usuario' AND column_name = 'activo'
    ) THEN
        EXECUTE 'UPDATE auth.usuario SET flag_estado = CASE WHEN activo THEN ''1'' ELSE ''0'' END';
        EXECUTE 'ALTER TABLE auth.usuario DROP COLUMN activo';
    END IF;
END $$;
UPDATE auth.usuario SET created_by = 1 WHERE created_by IS NULL;
UPDATE auth.usuario SET fec_creacion = NOW() WHERE fec_creacion IS NULL;
UPDATE auth.usuario SET updated_by = 1 WHERE updated_by IS NULL;
ALTER TABLE auth.usuario ALTER COLUMN created_by SET DEFAULT 1;
ALTER TABLE auth.usuario ALTER COLUMN fec_creacion SET DEFAULT NOW();
ALTER TABLE auth.usuario ALTER COLUMN updated_by SET DEFAULT 1;
ALTER TABLE auth.usuario ALTER COLUMN created_by SET NOT NULL;
ALTER TABLE auth.usuario ALTER COLUMN fec_creacion SET NOT NULL;

-- Estructura minima auth para template tenant (sin empresa_id: el tenant es ya de una empresa).
CREATE TABLE IF NOT EXISTS auth.usuario_sucursal (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT NOT NULL REFERENCES auth.usuario(id),
    sucursal_id BIGINT NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_estado IN ('0', '1')),
    UNIQUE (usuario_id, sucursal_id)
);

CREATE INDEX IF NOT EXISTS IX_USUARIO_SUCURSAL_01
    ON auth.usuario_sucursal (usuario_id, flag_estado);

-- Migración idempotente: quitar empresa_id en BD ya desplegadas; recrear unicidad (usuario, sucursal).
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = 'auth' AND table_name = 'usuario_sucursal' AND column_name = 'empresa_id'
    ) THEN
        DELETE FROM auth.usuario_sucursal u1
        WHERE EXISTS (
            SELECT 1 FROM auth.usuario_sucursal u2
            WHERE u2.usuario_id = u1.usuario_id
              AND u2.sucursal_id = u1.sucursal_id
              AND u2.id < u1.id
        );
        ALTER TABLE auth.usuario_sucursal DROP COLUMN empresa_id CASCADE;
        CREATE UNIQUE INDEX IF NOT EXISTS uq_auth_usuario_sucursal_usuario_sucursal
            ON auth.usuario_sucursal (usuario_id, sucursal_id);
    END IF;
END $$;

-- Usuario tecnico para migraciones/integraciones (WORK, id=1).
-- Evita fallos FK cuando created_by/updated_by = 1 en seeds tenant.
DO $$
DECLARE
    v_username VARCHAR(80);
BEGIN
    IF NOT EXISTS (SELECT 1 FROM auth.usuario WHERE id = 1) THEN
        IF EXISTS (SELECT 1 FROM auth.usuario WHERE username = 'work') THEN
            v_username := 'work-id1';
        ELSE
            v_username := 'work';
        END IF;

        INSERT INTO auth.usuario (
            id, username, email, password, nombres, apellidos, nombre_completo,
            dos_factor_habilitado, bloqueado, created_by, fec_creacion, updated_by, fec_modificacion
        ) VALUES (
            1, v_username, NULL, '$2a$10$work.user.seed.placeholder.hash',
            'WORK', 'SYSTEM', 'WORK SYSTEM',
            FALSE, FALSE, 1, NOW(), 1, NOW()
        );
    END IF;
END $$;

DO $$
BEGIN
    RAISE NOTICE '[DDL tenant] auth minimal (usuario, usuario_sucursal) listo.';
END $$;
