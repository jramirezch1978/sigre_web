-- PATCH: Límites de usuarios por plan, plan Small Business y nombres alineados a ediciones

UPDATE auth.plan_suscripcion SET
    nombre = 'Mype',
    max_usuarios = 5,
    orden = 2,
    caracteristicas = '["Hasta 5 usuarios incluidos","Edición SIGRE Mype","SIGRE Online","Módulos incluidos en Mype","Soporte por email","Actualizaciones incluidas"]'::jsonb
WHERE codigo = 'STANDARD';

INSERT INTO auth.plan_suscripcion (
    codigo, nombre, precio, descripcion, edicion_codigo, color, destacado,
    dias_demo, max_usuarios, orden, caracteristicas, flag_estado
)
VALUES (
    'SMALL_BUSINESS', 'Small Business', 12,
    'Edición SIGRE Small Business — SIGRE Online',
    'SMALL_BUSINESS', '#26a69a', FALSE, NULL, 10, 3,
    '["Hasta 10 usuarios incluidos","Edición SIGRE Small Business","SIGRE Online","Módulos Mype + Compras, RR.HH. y más","Soporte por email","Actualizaciones incluidas"]'::jsonb,
    '1'
)
ON CONFLICT (codigo) DO UPDATE SET
    nombre = EXCLUDED.nombre,
    precio = EXCLUDED.precio,
    descripcion = EXCLUDED.descripcion,
    edicion_codigo = EXCLUDED.edicion_codigo,
    color = EXCLUDED.color,
    destacado = EXCLUDED.destacado,
    max_usuarios = EXCLUDED.max_usuarios,
    orden = EXCLUDED.orden,
    caracteristicas = EXCLUDED.caracteristicas,
    flag_estado = EXCLUDED.flag_estado;

UPDATE auth.plan_suscripcion SET
    nombre = 'Professional',
    max_usuarios = 20,
    orden = 4,
    caracteristicas = '["Hasta 20 usuarios incluidos","Edición SIGRE Professional","SIGRE Online / On-premise","Multi-sucursal","Módulos operativos completos","Soporte prioritario"]'::jsonb
WHERE codigo = 'PERSONALIZADO';

UPDATE auth.plan_suscripcion SET
    max_usuarios = 40,
    orden = 5,
    caracteristicas = '["Hasta 40 usuarios incluidos","Edición SIGRE Enterprise","Todos los módulos","Multi-empresa ilimitado","API de integración","Personalización avanzada","Soporte 24/7 dedicado"]'::jsonb
WHERE codigo = 'ENTERPRISE';
