-- PATCH: Definición comercial y técnica de ediciones SIGRE y módulos por edición

INSERT INTO auth.modulo (codigo, nombre, flag_estado)
VALUES ('ASISTENCIA', 'Asistencia', '1')
ON CONFLICT (codigo) DO UPDATE SET
    nombre = EXCLUDED.nombre,
    flag_estado = EXCLUDED.flag_estado;

UPDATE auth.edicion_erp SET
    descripcion = 'Venta, compra e inventario con facturación y control básico de series y numeradores.'
WHERE codigo = 'MYPE';

UPDATE auth.edicion_erp SET
    descripcion = 'Mype ampliado con finanzas completas, planilla, RR.HH. y control de asistencia.'
WHERE codigo = 'SMALL_BUSINESS';

UPDATE auth.edicion_erp SET
    descripcion = 'Operaciones con OT, mantenimiento, producción y aprovisionamiento avanzado.'
WHERE codigo = 'PROFESSIONAL';

UPDATE auth.edicion_erp SET
    descripcion = 'Suite completa multi-empresa con módulos sectoriales según su giro de negocio.'
WHERE codigo = 'ENTERPRISE';

DELETE FROM auth.edicion_modulo em
USING auth.edicion_erp e
WHERE em.edicion_id = e.id
  AND e.codigo IN ('MYPE', 'SMALL_BUSINESS', 'PROFESSIONAL', 'ENTERPRISE');

INSERT INTO auth.edicion_modulo (edicion_id, modulo_id)
SELECT e.id, m.id
FROM auth.edicion_erp e
JOIN auth.modulo m ON m.codigo IN (
    'ALMACEN', 'COMPRAS', 'COMERCIALIZACION', 'FINANZAS', 'SEGURIDAD'
)
WHERE e.codigo = 'MYPE'
ON CONFLICT (edicion_id, modulo_id) DO NOTHING;

INSERT INTO auth.edicion_modulo (edicion_id, modulo_id)
SELECT e.id, m.id
FROM auth.edicion_erp e
JOIN auth.modulo m ON m.codigo IN (
    'ALMACEN', 'COMPRAS', 'COMERCIALIZACION', 'FINANZAS', 'SEGURIDAD',
    'RRHH', 'ASISTENCIA'
)
WHERE e.codigo = 'SMALL_BUSINESS'
ON CONFLICT (edicion_id, modulo_id) DO NOTHING;

INSERT INTO auth.edicion_modulo (edicion_id, modulo_id)
SELECT e.id, m.id
FROM auth.edicion_erp e
JOIN auth.modulo m ON m.codigo IN (
    'ALMACEN', 'COMPRAS', 'COMERCIALIZACION', 'FINANZAS', 'SEGURIDAD',
    'RRHH', 'ASISTENCIA',
    'PRODUCCION', 'MANTENIMIENTO', 'OPERACIONES', 'APROVISIONAMIENTO'
)
WHERE e.codigo = 'PROFESSIONAL'
ON CONFLICT (edicion_id, modulo_id) DO NOTHING;

INSERT INTO auth.edicion_modulo (edicion_id, modulo_id)
SELECT e.id, m.id
FROM auth.edicion_erp e
JOIN auth.modulo m ON m.flag_estado = '1'
WHERE e.codigo = 'ENTERPRISE'
ON CONFLICT (edicion_id, modulo_id) DO NOTHING;

UPDATE auth.plan_suscripcion SET
    caracteristicas = '["Hasta 5 usuarios incluidos","Almacén, Compras y Comercialización","Finanzas: series y numeradores de venta","Seguridad y permisos","SIGRE Online","Soporte por email"]'::jsonb
WHERE codigo = 'STANDARD';

UPDATE auth.plan_suscripcion SET
    caracteristicas = '["Hasta 10 usuarios incluidos","Todo SIGRE Mype","Finanzas completo (tesorería y CxC/CxP)","RR.HH. y planilla","Control de asistencia","Soporte por email"]'::jsonb
WHERE codigo = 'SMALL_BUSINESS';

UPDATE auth.plan_suscripcion SET
    caracteristicas = '["Hasta 20 usuarios incluidos","Todo Small Business","Operaciones (OT) y Mantenimiento","Producción y aprovisionamiento","Multi-sucursal","Soporte prioritario"]'::jsonb
WHERE codigo = 'PERSONALIZADO';

UPDATE auth.plan_suscripcion SET
    caracteristicas = '["Hasta 40 usuarios incluidos","Todos los módulos SIGRE","Contabilidad, Presupuesto y Activos fijos","Flota, HORECA, Campo según giro","API e integraciones","Soporte 24/7 dedicado"]'::jsonb
WHERE codigo = 'ENTERPRISE';

INSERT INTO auth.modulo (codigo, nombre, flag_estado)
VALUES ('APROVISIONAMIENTO', 'Aprovisionamiento', '1')
ON CONFLICT (codigo) DO UPDATE SET
    nombre = EXCLUDED.nombre,
    flag_estado = EXCLUDED.flag_estado;

INSERT INTO auth.edicion_modulo (edicion_id, modulo_id)
SELECT e.id, m.id
FROM auth.edicion_erp e
JOIN auth.modulo m ON m.codigo = 'APROVISIONAMIENTO'
WHERE e.codigo IN ('PROFESSIONAL', 'ENTERPRISE')
ON CONFLICT (edicion_id, modulo_id) DO NOTHING;
