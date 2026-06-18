-- PATCH: Actualizar planes de suscripción con ediciones correctas

UPDATE auth.plan_suscripcion SET
    descripcion = 'Acceso completo al SIGRE por 15 días',
    dias_demo = 15,
    max_usuarios = 5,
    edicion_codigo = NULL,
    caracteristicas = '["Todo el SIGRE","Máximo 5 usuarios","15 días de acceso","Sin tarjeta de crédito"]'::jsonb
WHERE codigo = 'DEMO';

UPDATE auth.plan_suscripcion SET
    descripcion = 'Edición SIGRE Mype — SIGRE Online',
    edicion_codigo = 'MYPE',
    caracteristicas = '["Edición SIGRE Mype","SIGRE Online","Módulos incluidos en Mype","Soporte por email","Actualizaciones incluidas"]'::jsonb
WHERE codigo = 'STANDARD';

UPDATE auth.plan_suscripcion SET
    descripcion = 'Edición SIGRE Professional — SIGRE Online / On-premise',
    edicion_codigo = 'PROFESSIONAL',
    caracteristicas = '["Edición SIGRE Professional","SIGRE Online / On-premise","Multi-sucursal","Módulos operativos completos","Soporte prioritario"]'::jsonb
WHERE codigo = 'PERSONALIZADO';

UPDATE auth.plan_suscripcion SET
    descripcion = 'Edición SIGRE Enterprise — acceso completo',
    edicion_codigo = 'ENTERPRISE',
    caracteristicas = '["Edición SIGRE Enterprise","Todos los módulos","Multi-empresa ilimitado","API de integración","Personalización avanzada","Soporte 24/7 dedicado"]'::jsonb
WHERE codigo = 'ENTERPRISE';
