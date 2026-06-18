-- PATCH: Planes de suscripción comercial del ERP SIGRE

CREATE TABLE IF NOT EXISTS auth.plan_suscripcion (
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

CREATE INDEX IF NOT EXISTS IX_PLAN_SUSCRIPCION_ORDEN ON auth.plan_suscripcion (orden);

INSERT INTO auth.plan_suscripcion (
    codigo, nombre, precio, descripcion, edicion_codigo, color, destacado,
    dias_demo, max_usuarios, orden, caracteristicas, flag_estado
)
VALUES
    (
        'DEMO', 'Demo gratuito', 0,
        'Acceso completo al SIGRE por 15 días',
        NULL, '#00bcd4', FALSE, 15, 5, 1,
        '["Todo el SIGRE","Máximo 5 usuarios","15 días de acceso","Sin tarjeta de crédito"]'::jsonb,
        '1'
    ),
    (
        'STANDARD', 'Estándar', 8,
        'Edición SIGRE Mype — SIGRE Online',
        'MYPE', '#f5a623', FALSE, NULL, NULL, 2,
        '["Edición SIGRE Mype","SIGRE Online","Módulos incluidos en Mype","Soporte por email","Actualizaciones incluidas"]'::jsonb,
        '1'
    ),
    (
        'PERSONALIZADO', 'Personalizado', 12,
        'Edición SIGRE Professional — SIGRE Online / On-premise',
        'PROFESSIONAL', '#714b67', TRUE, NULL, NULL, 3,
        '["Edición SIGRE Professional","SIGRE Online / On-premise","Multi-sucursal","Módulos operativos completos","Soporte prioritario"]'::jsonb,
        '1'
    ),
    (
        'ENTERPRISE', 'Enterprise', 20,
        'Edición SIGRE Enterprise — acceso completo',
        'ENTERPRISE', '#e11d48', FALSE, NULL, NULL, 4,
        '["Edición SIGRE Enterprise","Todos los módulos","Multi-empresa ilimitado","API de integración","Personalización avanzada","Soporte 24/7 dedicado"]'::jsonb,
        '1'
    )
ON CONFLICT (codigo) DO UPDATE SET
    nombre = EXCLUDED.nombre,
    precio = EXCLUDED.precio,
    descripcion = EXCLUDED.descripcion,
    edicion_codigo = EXCLUDED.edicion_codigo,
    color = EXCLUDED.color,
    destacado = EXCLUDED.destacado,
    dias_demo = EXCLUDED.dias_demo,
    max_usuarios = EXCLUDED.max_usuarios,
    orden = EXCLUDED.orden,
    caracteristicas = EXCLUDED.caracteristicas,
    flag_estado = EXCLUDED.flag_estado;
