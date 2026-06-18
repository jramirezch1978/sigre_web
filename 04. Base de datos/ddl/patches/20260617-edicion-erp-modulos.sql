-- PATCH: Ediciones del ERP y relación edición-módulo
-- Permite definir qué módulos incluye cada edición de SIGRE

CREATE TABLE IF NOT EXISTS auth.edicion_erp (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(40) NOT NULL UNIQUE,
    nombre VARCHAR(120) NOT NULL,
    descripcion VARCHAR(500),
    orden INTEGER NOT NULL DEFAULT 0,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1' CHECK (flag_estado IN ('0', '1'))
);

CREATE TABLE IF NOT EXISTS auth.edicion_modulo (
    id BIGSERIAL PRIMARY KEY,
    edicion_id BIGINT NOT NULL REFERENCES auth.edicion_erp(id) ON DELETE CASCADE,
    modulo_id BIGINT NOT NULL REFERENCES auth.modulo(id) ON DELETE CASCADE,
    UNIQUE (edicion_id, modulo_id)
);

CREATE INDEX IF NOT EXISTS IX_EDICION_MODULO_EDICION ON auth.edicion_modulo (edicion_id);
CREATE INDEX IF NOT EXISTS IX_EDICION_MODULO_MODULO ON auth.edicion_modulo (modulo_id);

-- Ediciones del ERP
INSERT INTO auth.edicion_erp (codigo, nombre, descripcion, orden, flag_estado)
VALUES
    ('MYPE', 'SIGRE Mype', 'Para microempresas y emprendedores', 1, '1'),
    ('SMALL_BUSINESS', 'SIGRE Small Business', 'Para pequeñas empresas en crecimiento', 2, '1'),
    ('PROFESSIONAL', 'SIGRE Professional', 'Para medianas empresas con operaciones completas', 3, '1'),
    ('ENTERPRISE', 'SIGRE Enterprise', 'Para grandes corporaciones con todos los módulos', 4, '1')
ON CONFLICT (codigo) DO UPDATE SET
    nombre = EXCLUDED.nombre,
    descripcion = EXCLUDED.descripcion,
    orden = EXCLUDED.orden,
    flag_estado = EXCLUDED.flag_estado;

-- Módulos por edición
INSERT INTO auth.edicion_modulo (edicion_id, modulo_id)
SELECT e.id, m.id
FROM auth.edicion_erp e
JOIN auth.modulo m ON m.codigo IN (
    'CONTABILIDAD', 'COMERCIALIZACION', 'ALMACEN', 'FINANZAS', 'SEGURIDAD'
)
WHERE e.codigo = 'MYPE'
ON CONFLICT (edicion_id, modulo_id) DO NOTHING;

INSERT INTO auth.edicion_modulo (edicion_id, modulo_id)
SELECT e.id, m.id
FROM auth.edicion_erp e
JOIN auth.modulo m ON m.codigo IN (
    'CONTABILIDAD', 'COMERCIALIZACION', 'ALMACEN', 'FINANZAS', 'SEGURIDAD',
    'COMPRAS', 'RRHH', 'ACTIVOS_FIJOS', 'PRESUPUESTO'
)
WHERE e.codigo = 'SMALL_BUSINESS'
ON CONFLICT (edicion_id, modulo_id) DO NOTHING;

INSERT INTO auth.edicion_modulo (edicion_id, modulo_id)
SELECT e.id, m.id
FROM auth.edicion_erp e
JOIN auth.modulo m ON m.codigo IN (
    'CONTABILIDAD', 'COMERCIALIZACION', 'ALMACEN', 'FINANZAS', 'SEGURIDAD',
    'COMPRAS', 'RRHH', 'ACTIVOS_FIJOS', 'PRESUPUESTO',
    'PRODUCCION', 'FLOTA', 'MANTENIMIENTO', 'COMEDOR', 'HORECA', 'CAMPO', 'OPERACIONES'
)
WHERE e.codigo = 'PROFESSIONAL'
ON CONFLICT (edicion_id, modulo_id) DO NOTHING;

INSERT INTO auth.edicion_modulo (edicion_id, modulo_id)
SELECT e.id, m.id
FROM auth.edicion_erp e
JOIN auth.modulo m ON m.flag_estado = '1'
WHERE e.codigo = 'ENTERPRISE'
ON CONFLICT (edicion_id, modulo_id) DO NOTHING;
