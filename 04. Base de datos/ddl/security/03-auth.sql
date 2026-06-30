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
DROP TABLE IF EXISTS auth.grupo_usuario_det CASCADE;
DROP TABLE IF EXISTS auth.grupo_usuario CASCADE;
DROP TABLE IF EXISTS auth.log_acceso CASCADE;
DROP TABLE IF EXISTS auth.licencia CASCADE;
DROP TABLE IF EXISTS auth.plan_suscripcion CASCADE;
DROP TABLE IF EXISTS auth.edicion_modulo CASCADE;
DROP TABLE IF EXISTS auth.edicion_erp CASCADE;
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
    numero_documento VARCHAR(20),      -- DNI/CE; usado para evitar registros demo repetidos
    dos_factor_habilitado BOOLEAN NOT NULL DEFAULT FALSE,
    bloqueado BOOLEAN NOT NULL DEFAULT FALSE,
    intentos_fallidos INTEGER NOT NULL DEFAULT 0,
    bloqueado_hasta TIMESTAMPTZ,
    ultimo_login_en TIMESTAMPTZ,
    flag_demo VARCHAR(1) NOT NULL DEFAULT '0' CHECK (flag_demo IN ('0', '1')),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_estado IN ('0', '1')),
    flag_admin_sistema VARCHAR(1) NOT NULL DEFAULT '0' CHECK (flag_admin_sistema IN ('0', '1')),
    tipo_sales VARCHAR(10) CHECK (tipo_sales IN ('LICENSING', 'SALES')),  -- perfil licencias: LICENSING (todo) / SALES (solo renovar); NULL = sin perfil
    fec_creacion TIMESTAMPTZ DEFAULT NOW(),
    fec_modificacion TIMESTAMPTZ,
    created_by BIGINT,
    updated_by BIGINT
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

CREATE TABLE auth.edicion_erp (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(40) NOT NULL UNIQUE,
    nombre VARCHAR(120) NOT NULL,
    descripcion VARCHAR(500),
    orden INTEGER NOT NULL DEFAULT 0,
    logo BYTEA,                 -- ícono/logo de la edición (PNG), cargado en seed/04
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_estado IN ('0', '1'))
);

CREATE TABLE auth.edicion_modulo (
    id BIGSERIAL PRIMARY KEY,
    edicion_id BIGINT NOT NULL REFERENCES auth.edicion_erp(id) ON DELETE CASCADE,
    modulo_id BIGINT NOT NULL REFERENCES auth.modulo(id) ON DELETE CASCADE,
    UNIQUE (edicion_id, modulo_id)
);

CREATE INDEX IX_EDICION_MODULO_EDICION ON auth.edicion_modulo (edicion_id);
CREATE INDEX IX_EDICION_MODULO_MODULO ON auth.edicion_modulo (modulo_id);

CREATE TABLE auth.plan_suscripcion (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(40) NOT NULL UNIQUE,
    nombre VARCHAR(120) NOT NULL,
    precio NUMERIC(10, 2) NOT NULL DEFAULT 0,
    descripcion VARCHAR(500),
    edicion_codigo VARCHAR(40) REFERENCES auth.edicion_erp(codigo),
    color VARCHAR(20),
    destacado BOOLEAN NOT NULL DEFAULT FALSE,
    dias_demo INTEGER,
    max_usuarios INTEGER,
    orden INTEGER NOT NULL DEFAULT 0,
    caracteristicas JSONB NOT NULL DEFAULT '[]'::jsonb,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_estado IN ('0', '1'))
);

CREATE INDEX IX_PLAN_SUSCRIPCION_ORDEN ON auth.plan_suscripcion (orden);

-- Licencias del ERP (demo y de pago). codigo_licencia: 16 hex estilo Windows (XXXX-XXXX-XXXX-XXXX).
CREATE TABLE auth.licencia (
    id BIGSERIAL PRIMARY KEY,
    empresa_id BIGINT NOT NULL REFERENCES master.empresa(id),
    codigo_licencia VARCHAR(19) NOT NULL UNIQUE,
    edicion_codigo VARCHAR(40) REFERENCES auth.edicion_erp(codigo),
    tipo VARCHAR(1) NOT NULL DEFAULT 'D' CHECK (tipo IN ('D', 'P')),  -- D=demo, P=pago
    max_usuarios INTEGER,
    correo_responsable VARCHAR(150),   -- responsable de la licencia (avisos de renovación)
    fecha_aviso_renovacion TIMESTAMPTZ,  -- último aviso de renovación enviado (evita reenvíos en el mismo ciclo)
    fecha_inicio TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    fecha_vencimiento TIMESTAMPTZ NOT NULL,            -- demo: inicio + 15 dias
    fecha_eliminacion_bd TIMESTAMPTZ,                  -- demo: inicio + 20 dias (la procesa worker-service)
    fecha_baja TIMESTAMPTZ,                            -- cuando se desactiva (vencida)
    bd_eliminada BOOLEAN NOT NULL DEFAULT FALSE,
    estado VARCHAR(1) NOT NULL DEFAULT 'A' CHECK (estado IN ('A', 'V', 'E')),  -- A=activa, V=vencida, E=BD eliminada
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_estado IN ('0', '1'))
);

CREATE INDEX IX_LICENCIA_EMPRESA ON auth.licencia (empresa_id);
CREATE INDEX IX_LICENCIA_VENCIMIENTO ON auth.licencia (estado, fecha_vencimiento);
CREATE INDEX IX_LICENCIA_ELIM_BD ON auth.licencia (bd_eliminada, fecha_eliminacion_bd);

-- Control de usuarios EN EXCESO sobre el limite de la edicion. Se registra una fila el mes en
-- que un usuario excedente se activa; el costo del exceso se cobra solo en ese periodo. Al renovar
-- la licencia se recuentan los activos y, si persiste el exceso, se generan nuevas filas del periodo.
CREATE TABLE auth.licencia_usuario_exceso (
    id BIGSERIAL PRIMARY KEY,
    licencia_id BIGINT NOT NULL REFERENCES auth.licencia(id),
    usuario_id BIGINT NOT NULL REFERENCES auth.usuario(id),
    periodo CHAR(7) NOT NULL,                       -- 'YYYY-MM' del mes facturado
    monto NUMERIC(10, 2) NOT NULL DEFAULT 0,        -- recargo cobrado por este usuario en el periodo
    fecha_activacion TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_estado IN ('0', '1')),
    UNIQUE (licencia_id, usuario_id, periodo)
);
CREATE INDEX IX_LIC_USR_EXCESO_PERIODO ON auth.licencia_usuario_exceso (licencia_id, periodo);

-- Histórico de pagos de licencia: cada renovación exige fecha de pago + voucher del cliente,
-- y registra qué usuario (perfil ventas/licensing) la renovó.
CREATE TABLE auth.licencia_pago (
    id BIGSERIAL PRIMARY KEY,
    licencia_id BIGINT NOT NULL REFERENCES auth.licencia(id),
    fecha_pago DATE NOT NULL,
    voucher VARCHAR(80) NOT NULL,
    monto NUMERIC(10, 2) NOT NULL DEFAULT 0,
    periodo CHAR(7) NOT NULL,                        -- 'YYYY-MM' del mes renovado
    usuario_renovo_id BIGINT REFERENCES auth.usuario(id),
    fec_creacion TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IX_LICENCIA_PAGO_LIC ON auth.licencia_pago (licencia_id, fecha_pago DESC);

CREATE TABLE auth.opcion_menu (
    id BIGSERIAL PRIMARY KEY,
    modulo_id BIGINT NOT NULL REFERENCES auth.modulo(id),
    codigo VARCHAR(80) NOT NULL UNIQUE,
    nombre VARCHAR(160) NOT NULL,
    ruta_frontend VARCHAR(250),
    -- Ruta RELATIVA del componente/pagina Angular a cargar al hacer click.
    -- NULL/vacio => la opcion muestra la pagina "en construccion / no desarrollada".
    path_url VARCHAR(250),
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
    -- Nullable: los eventos de sistema/provisión (token temporal) no tienen empresa asociada.
    empresa_id BIGINT REFERENCES master.empresa(id),
    evento VARCHAR(60) NOT NULL,
    exito BOOLEAN NOT NULL,
    flag_nivel VARCHAR(1) NOT NULL DEFAULT 'I' CHECK (flag_nivel IN ('I', 'W', 'E')),
    ip VARCHAR(64),
    ip_privada VARCHAR(64),
    sistema_operativo VARCHAR(120),
    user_agent TEXT,
    fecha_login TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    fecha_logout TIMESTAMPTZ
);

-- Grupos de usuarios: destino colectivo de notificaciones.
CREATE TABLE auth.grupo_usuario (
    id BIGSERIAL PRIMARY KEY,
    empresa_id BIGINT NOT NULL REFERENCES master.empresa(id),
    codigo VARCHAR(80) NOT NULL,
    descripcion VARCHAR(220) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_estado IN ('0', '1')),
    UNIQUE (empresa_id, codigo)
);

-- Detalle: usuarios que pertenecen a cada grupo.
CREATE TABLE auth.grupo_usuario_det (
    id BIGSERIAL PRIMARY KEY,
    grupo_usuario_id BIGINT NOT NULL REFERENCES auth.grupo_usuario(id),
    usuario_id BIGINT NOT NULL REFERENCES auth.usuario(id),
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_estado IN ('0', '1')),
    UNIQUE (grupo_usuario_id, usuario_id)
);

CREATE TABLE auth.notificacion (
    id BIGSERIAL PRIMARY KEY,
    -- usuario_id: ORIGEN de la notificación (usuario que la genera). Siempre un usuario.
    usuario_id BIGINT NOT NULL REFERENCES auth.usuario(id),
    empresa_id BIGINT NOT NULL REFERENCES master.empresa(id),
    titulo VARCHAR(220) NOT NULL,
    descripcion TEXT NOT NULL,
    tipo VARCHAR(1) NOT NULL DEFAULT 'I' CHECK (tipo IN ('I', 'S', 'W', 'E')),
    destino_tipo VARCHAR(1) NOT NULL DEFAULT 'U' CHECK (destino_tipo IN ('U', 'G')),
    -- DESTINO (quién debe verla): usuario_destino_id si destino_tipo='U', grupo si destino_tipo='G'.
    usuario_destino_id BIGINT REFERENCES auth.usuario(id),
    grupo_usuario_destino_id BIGINT REFERENCES auth.grupo_usuario(id),
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
CREATE INDEX IX_USUARIO_DOCUMENTO ON auth.usuario (numero_documento) WHERE numero_documento IS NOT NULL;
CREATE INDEX IX_CODIGO_RECUPERACION_01 ON auth.codigo_recuperacion (usuario_id, usado, expira_en DESC);
CREATE INDEX IX_ROL_01 ON auth.rol (empresa_id, flag_estado);
CREATE INDEX IX_ROL_USUARIO_01 ON auth.rol_usuario (usuario_id, flag_estado);
CREATE INDEX IX_ROL_OPCION_MENU_01 ON auth.rol_opcion_menu (rol_id, opcion_menu_id);
CREATE INDEX IX_ROL_OPCION_MENU_ACCION_01 ON auth.rol_opcion_menu_accion (rol_opcion_menu_id, accion_id);
CREATE INDEX IX_USUARIO_OPCION_MENU_01 ON auth.usuario_opcion_menu (empresa_id, usuario_id, flag_estado);
CREATE INDEX IX_LOG_ACCESO_01 ON auth.log_acceso (empresa_id, usuario_id, fecha_login DESC);
CREATE INDEX IX_NOTIFICACION_01 ON auth.notificacion (usuario_id, empresa_id, flag_estado, enviado_en DESC);
CREATE INDEX IX_NOTIFICACION_02 ON auth.notificacion (empresa_id, leido, enviado_en DESC);
CREATE INDEX IX_NOTIFICACION_03 ON auth.notificacion (destino_tipo, grupo_usuario_destino_id);
CREATE INDEX IX_NOTIFICACION_04 ON auth.notificacion (usuario_destino_id);
CREATE INDEX IX_GRUPO_USUARIO_01 ON auth.grupo_usuario (empresa_id, flag_estado);
CREATE INDEX IX_GRUPO_USUARIO_DET_01 ON auth.grupo_usuario_det (grupo_usuario_id, flag_estado);
CREATE INDEX IX_GRUPO_USUARIO_DET_02 ON auth.grupo_usuario_det (usuario_id);
CREATE INDEX IX_SESION_01 ON auth.sesion (usuario_id, flag_estado);
CREATE INDEX IX_TOKENS_SESSION_01 ON auth.tokens_session (usuario_id, empresa_id, flag_estado);
CREATE INDEX IX_TOKENS_SESSION_02 ON auth.tokens_session (empresa_id);
CREATE INDEX IX_TOKEN_USO_LOG_01 ON auth.token_uso_log (tokens_session_id, fecha DESC);
CREATE INDEX IX_TOKEN_USO_LOG_02 ON auth.token_uso_log (fecha DESC);
CREATE INDEX IX_TOKEN_USO_LOG_03 ON auth.token_uso_log (ip, fecha DESC);

-- Eliminar resto de versiones anteriores (auth.usuario_sucursal solo existe en tenant).
DROP TABLE IF EXISTS auth.usuario_sucursal CASCADE;
