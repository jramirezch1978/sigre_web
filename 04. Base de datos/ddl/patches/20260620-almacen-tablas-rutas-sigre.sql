-- Rutas frontend SIGRE para tablas maestras de Almacén (Fase 1)
-- Ejecutar contra BD security (auth.opcion_menu)
-- NOTA: ver patch 20260621-almacen-menu-opciones-canonicas.sql para nombres canónicos.

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/tablas/almacenes', nombre = 'Maestro de almacenes', orden = 1, flag_estado = '1'
WHERE codigo = 'ALMACEN_TABLAS_ALMACEN';

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/tablas/tipos-movimiento', nombre = 'Tipos de movimientos de almacenes', orden = 2, flag_estado = '1'
WHERE codigo = 'ALMACEN_TABLAS_TIPO_MOV';

UPDATE auth.opcion_menu SET flag_estado = '0'
WHERE codigo IN ('ALMACEN_TABLAS_CLASES_PRODUCTOS', 'ALMACEN_TABLAS_MAESTRO_PRODUCTOS', 'ALMACEN_TABLAS_TIPOS_MOV_CAT');

INSERT INTO auth.opcion_menu (modulo_id, codigo, nombre, ruta_frontend, opcion_padre_id, orden, flag_estado)
SELECT m.id, v.codigo, v.nombre, v.ruta, p.id, v.orden, '1'
FROM (VALUES
    ('ALMACEN_TABLAS_UBICACION', 'Ubicacion de Articulo', '/sigre/almacen/tablas/ubicaciones', 3),
    ('ALMACEN_TABLAS_MOV_POR_ALM', 'Movimientos por almacen', '/sigre/almacen/tablas/movimientos-almacen', 4),
    ('ALMACEN_TABLAS_POSICIONES', 'Posiciones por Almacen', '/sigre/almacen/tablas/posiciones', 5),
    ('ALMACEN_TABLAS_MOTIVO_TRASL', 'Motivos de traslado', '/sigre/almacen/tablas/motivos-traslado', 6),
    ('ALMACEN_TABLAS_LOTES', 'Ingreso de Lotes', '/sigre/almacen/tablas/lotes', 7),
    ('ALMACEN_TABLAS_UNID_CONV', 'Unidades de Conversión', '/sigre/almacen/tablas/unidades-conversion', 8),
    ('ALMACEN_TABLAS_NUM_VALES', 'Vales', '/sigre/almacen/tablas/numeracion-vales', 9),
    ('ALMACEN_TABLAS_NUM_OTR', 'Orden de Traslado', '/sigre/almacen/tablas/numeracion-otr', 10),
    ('ALMACEN_TABLAS_PARAMETROS', 'Parametros del Sistema', '/sigre/almacen/tablas/parametros', 11)
) AS v(codigo, nombre, ruta, orden)
JOIN auth.modulo m ON m.codigo = 'ALMACEN'
JOIN auth.opcion_menu p ON p.codigo = 'ALMACEN_TABLAS'
ON CONFLICT (codigo) DO UPDATE SET
    nombre = EXCLUDED.nombre,
    ruta_frontend = EXCLUDED.ruta_frontend,
    opcion_padre_id = EXCLUDED.opcion_padre_id,
    orden = EXCLUDED.orden,
    flag_estado = '1';
