-- ============================================================
-- SIGRE ERP - Security DB - auth schema
-- Estrategia: DROP + CREATE (reconstrucción completa)
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

CREATE SCHEMA IF NOT EXISTS auth;
CREATE SCHEMA IF NOT EXISTS auditoria;

-- ============================================================
-- SECCIÓN 1: DROP (eliminar tablas en orden correcto por FK)
-- ============================================================
--
-- DIAGRAMA DE RELACIONES (→ = tiene FK hacia):
--
--   usuario (sin dependencias)
--   rol → master.empresa
--   modulo (sin dependencias)
--   accion (sin dependencias)
--   opcion_menu → modulo, opcion_menu (auto-ref: opcion_padre_id)
--   rol_opcion_menu → rol, opcion_menu
--   rol_opcion_menu_accion → rol_opcion_menu, accion
--   usuario_empresa → usuario, master.empresa
--   rol_usuario → usuario, rol
--   usuario_opcion_menu → usuario, master.empresa, opcion_menu
--   sesion → usuario
--   tokens_session → usuario, master.empresa
--   log_acceso → usuario, master.empresa
--   codigo_recuperacion → usuario
--
-- ORDEN DE DROP (hijos antes que padres):
--   1. codigo_recuperacion → usuario
--   2. log_acceso → usuario, master.empresa
--   3. tokens_session → usuario, master.empresa
--   4. sesion → usuario
--   5. usuario_opcion_menu → usuario, master.empresa, opcion_menu
--   6. rol_usuario → usuario, rol
--   7. usuario_empresa → usuario, master.empresa
--   8. rol_opcion_menu_accion → rol_opcion_menu, accion
--   9. rol_opcion_menu → rol, opcion_menu
--  10. accion
--  11. opcion_menu → modulo
--  12. modulo
--  13. rol → master.empresa
--  14. usuario
-- ============================================================

DROP TABLE IF EXISTS auth.token_uso_log CASCADE;
DROP TABLE IF EXISTS auth.codigo_recuperacion CASCADE;
DROP TABLE IF EXISTS auth.notificacion CASCADE;
DROP TABLE IF EXISTS auth.log_acceso CASCADE;
DROP TABLE IF EXISTS auth.tokens_session CASCADE;
DROP TABLE IF EXISTS auth.sesion CASCADE;
DROP TABLE IF EXISTS auth.usuario_opcion_menu CASCADE;
DROP TABLE IF EXISTS auth.usuario_sucursal CASCADE;
DROP TABLE IF EXISTS auth.sucursal CASCADE;
DROP TABLE IF EXISTS auth.rol_usuario CASCADE;
DROP TABLE IF EXISTS auth.usuario_empresa CASCADE;
DROP TABLE IF EXISTS auth.rol_opcion_menu_accion CASCADE;
DROP TABLE IF EXISTS auth.rol_opcion_menu CASCADE;
DROP TABLE IF EXISTS auth.accion CASCADE;
DROP TABLE IF EXISTS auth.opcion_menu CASCADE;
DROP TABLE IF EXISTS auth.modulo CASCADE;
DROP TABLE IF EXISTS auth.rol CASCADE;
DROP TABLE IF EXISTS auth.usuario CASCADE;

-- ============================================================
-- SECCIÓN 2: CREATE (crear tablas, constraints e índices)
-- ============================================================

CREATE TABLE auth.usuario (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(80) NOT NULL UNIQUE,
    email VARCHAR(150) UNIQUE,
    password TEXT NOT NULL,
    nombres VARCHAR(120) NOT NULL,
    apellidos VARCHAR(120),
    nombre_completo VARCHAR(200) NOT NULL,
    dos_factor_habilitado BOOLEAN NOT NULL DEFAULT FALSE,
    bloqueado BOOLEAN NOT NULL DEFAULT FALSE,
    intentos_fallidos INTEGER NOT NULL DEFAULT 0,
    bloqueado_hasta TIMESTAMPTZ,
    ultimo_login_en TIMESTAMPTZ,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_estado IN ('0', '1')),
    flag_admin_sistema VARCHAR(1) NOT NULL DEFAULT '0' CHECK (flag_admin_sistema IN ('0', '1')),
    fec_creacion TIMESTAMPTZ DEFAULT NOW(),
    fec_modificacion TIMESTAMPTZ
);

CREATE TABLE auth.rol (
    id BIGSERIAL PRIMARY KEY,
    empresa_id BIGINT NOT NULL REFERENCES master.empresa(id),
    codigo VARCHAR(40) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    es_admin BOOLEAN NOT NULL DEFAULT FALSE,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_estado IN ('0', '1')),
    UNIQUE (empresa_id, codigo),
    UNIQUE (id, empresa_id)
);

CREATE TABLE auth.modulo (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(40) NOT NULL UNIQUE,
    nombre VARCHAR(120) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_estado IN ('0', '1'))
);

CREATE TABLE auth.opcion_menu (
    id BIGSERIAL PRIMARY KEY,
    modulo_id BIGINT NOT NULL REFERENCES auth.modulo(id),
    codigo VARCHAR(80) NOT NULL UNIQUE,
    nombre VARCHAR(160) NOT NULL,
    ruta_frontend VARCHAR(250),
    opcion_padre_id BIGINT REFERENCES auth.opcion_menu(id),
    orden INTEGER NOT NULL DEFAULT 0,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_estado IN ('0', '1'))
);

CREATE TABLE auth.accion (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(40) NOT NULL UNIQUE,
    nombre VARCHAR(120) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_estado IN ('0', '1'))
);

CREATE TABLE auth.rol_opcion_menu (
    id BIGSERIAL PRIMARY KEY,
    rol_id BIGINT NOT NULL REFERENCES auth.rol(id),
    opcion_menu_id BIGINT NOT NULL REFERENCES auth.opcion_menu(id),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_estado IN ('0', '1')),
    UNIQUE (rol_id, opcion_menu_id)
);

CREATE TABLE auth.rol_opcion_menu_accion (
    id BIGSERIAL PRIMARY KEY,
    rol_opcion_menu_id BIGINT NOT NULL REFERENCES auth.rol_opcion_menu(id),
    accion_id BIGINT NOT NULL REFERENCES auth.accion(id),
    permitido BOOLEAN NOT NULL DEFAULT TRUE,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_estado IN ('0', '1')),
    UNIQUE (rol_opcion_menu_id, accion_id)
);

CREATE TABLE auth.usuario_empresa (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT NOT NULL REFERENCES auth.usuario(id),
    empresa_id BIGINT NOT NULL REFERENCES master.empresa(id),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_estado IN ('0', '1')),
    UNIQUE (usuario_id, empresa_id)
);

-- auth.usuario_sucursal: solo en BD tenant/template (auth.usuario_sucursal), no en security.

CREATE TABLE auth.rol_usuario (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT NOT NULL REFERENCES auth.usuario(id),
    rol_id BIGINT NOT NULL REFERENCES auth.rol(id),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_estado IN ('0', '1')),
    UNIQUE (usuario_id, rol_id)
);

CREATE TABLE auth.usuario_opcion_menu (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT NOT NULL REFERENCES auth.usuario(id),
    empresa_id BIGINT NOT NULL REFERENCES master.empresa(id),
    opcion_menu_id BIGINT NOT NULL REFERENCES auth.opcion_menu(id),
    habilitado BOOLEAN NOT NULL DEFAULT TRUE,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_estado IN ('0', '1')),
    UNIQUE (usuario_id, empresa_id, opcion_menu_id)
);

CREATE TABLE auth.sesion (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT NOT NULL REFERENCES auth.usuario(id),
    token_id VARCHAR(120) NOT NULL UNIQUE,
    ip VARCHAR(64),
    user_agent TEXT,
    expira_en TIMESTAMPTZ NOT NULL,
    cerrado_en TIMESTAMPTZ,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_estado IN ('0', '1'))
);

-- Token definitivo post-empresa/sucursal: JWT almacenado, reutilización hasta expiración; flag_estado '0' = inactivo.
CREATE TABLE auth.tokens_session (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT NOT NULL REFERENCES auth.usuario(id),
    empresa_id BIGINT NOT NULL REFERENCES master.empresa(id),
    sucursal_id BIGINT NOT NULL,
    jwt_compacto TEXT,
    expira_en TIMESTAMPTZ NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_estado IN ('0', '1')),
    fec_creacion TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    cerrado_en TIMESTAMPTZ
);

CREATE UNIQUE INDEX uq_tokens_session_activa_triple ON auth.tokens_session (usuario_id, empresa_id, sucursal_id)
    WHERE flag_estado = '1';

CREATE TABLE auth.codigo_recuperacion (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT NOT NULL REFERENCES auth.usuario(id),
    codigo VARCHAR(8) NOT NULL,
    expira_en TIMESTAMPTZ NOT NULL,
    usado BOOLEAN NOT NULL DEFAULT FALSE,
    fec_creacion TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE auth.log_acceso (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT REFERENCES auth.usuario(id),
    empresa_id BIGINT NOT NULL REFERENCES master.empresa(id),
    evento VARCHAR(60) NOT NULL,
    exito BOOLEAN NOT NULL,
    nivel VARCHAR(10) NOT NULL DEFAULT 'INFO',
    ip VARCHAR(64),
    ip_privada VARCHAR(64),
    sistema_operativo VARCHAR(120),
    user_agent TEXT,
    fecha_login TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    fecha_logout TIMESTAMPTZ
);

CREATE TABLE auth.notificacion (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT NOT NULL REFERENCES auth.usuario(id),
    empresa_id BIGINT NOT NULL REFERENCES master.empresa(id),
    titulo VARCHAR(220) NOT NULL,
    descripcion TEXT NOT NULL,
    tipo VARCHAR(30) NOT NULL DEFAULT 'INFO',
    destino_tipo VARCHAR(20) NOT NULL DEFAULT 'USUARIO',
    grupo_codigo VARCHAR(80),
    origen_usuario_id BIGINT REFERENCES auth.usuario(id),
    leido BOOLEAN NOT NULL DEFAULT FALSE,
    leido_en TIMESTAMPTZ,
    enviado_en TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_estado IN ('0', '1')),
    UNIQUE (usuario_id, empresa_id, titulo, enviado_en)
);

-- Registro de cada llamada API autenticada: detección de uso fraudulento de tokens.
CREATE TABLE auth.token_uso_log (
    id BIGSERIAL PRIMARY KEY,
    tokens_session_id BIGINT NOT NULL REFERENCES auth.tokens_session(id),
    metodo VARCHAR(10) NOT NULL,
    uri VARCHAR(500) NOT NULL,
    ip VARCHAR(64),
    ip_privada VARCHAR(64),
    user_agent TEXT,
    microservicio VARCHAR(60),
    status_code INTEGER,
    duracion_ms BIGINT,
    fecha TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- SECCIÓN 3: ÍNDICES
-- ============================================================

CREATE INDEX IX_USUARIO_EMPRESA_01 ON auth.usuario_empresa (empresa_id, flag_estado);
CREATE INDEX IX_CODIGO_RECUPERACION_01 ON auth.codigo_recuperacion (usuario_id, usado, expira_en DESC);
CREATE INDEX IX_ROL_01 ON auth.rol (empresa_id, flag_estado);
CREATE INDEX IX_ROL_USUARIO_01 ON auth.rol_usuario (usuario_id, flag_estado);
CREATE INDEX IX_ROL_OPCION_MENU_01 ON auth.rol_opcion_menu (rol_id, opcion_menu_id);
CREATE INDEX IX_ROL_OPCION_MENU_ACCION_01 ON auth.rol_opcion_menu_accion (rol_opcion_menu_id, accion_id);
CREATE INDEX IX_USUARIO_OPCION_MENU_01 ON auth.usuario_opcion_menu (empresa_id, usuario_id, flag_estado);
CREATE INDEX IX_LOG_ACCESO_01 ON auth.log_acceso (empresa_id, usuario_id, fecha_login DESC);
CREATE INDEX IX_NOTIFICACION_01 ON auth.notificacion (usuario_id, empresa_id, flag_estado, enviado_en DESC);
CREATE INDEX IX_NOTIFICACION_02 ON auth.notificacion (empresa_id, leido, enviado_en DESC);
CREATE INDEX IX_NOTIFICACION_03 ON auth.notificacion (destino_tipo, grupo_codigo);
CREATE INDEX IX_SESION_01 ON auth.sesion (usuario_id, flag_estado);
CREATE INDEX IX_TOKENS_SESSION_01 ON auth.tokens_session (usuario_id, empresa_id, flag_estado);
CREATE INDEX IX_TOKENS_SESSION_02 ON auth.tokens_session (empresa_id);
CREATE INDEX IX_TOKEN_USO_LOG_01 ON auth.token_uso_log (tokens_session_id, fecha DESC);
CREATE INDEX IX_TOKEN_USO_LOG_02 ON auth.token_uso_log (fecha DESC);
CREATE INDEX IX_TOKEN_USO_LOG_03 ON auth.token_uso_log (ip, fecha DESC);

-- Eliminar resto de versiones anteriores (auth.usuario_sucursal solo existe en tenant).
DROP TABLE IF EXISTS auth.usuario_sucursal CASCADE;
