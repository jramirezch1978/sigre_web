-- Alinear menú Tablas de Almacén con opciones_menu.txt (canónico)
-- Elimina opciones legacy RestPE que no existen en el canon SIGRE.

-- Desactivar opciones incorrectas / duplicadas
UPDATE auth.opcion_menu SET flag_estado = '0'
WHERE codigo IN (
    'ALMACEN_TABLAS_CLASES_PRODUCTOS',
    'ALMACEN_TABLAS_MAESTRO_PRODUCTOS',
    'ALMACEN_TABLAS_TIPOS_MOV_CAT'
);

-- Renombrar y reordenar según opciones_menu.txt [TABLAS]
UPDATE auth.opcion_menu SET nombre = 'Maestro de almacenes', ruta_frontend = '/sigre/almacen/tablas/almacenes', orden = 1, flag_estado = '1'
WHERE codigo = 'ALMACEN_TABLAS_ALMACEN';

UPDATE auth.opcion_menu SET nombre = 'Tipos de movimientos de almacenes', ruta_frontend = '/sigre/almacen/tablas/tipos-movimiento', orden = 2, flag_estado = '1'
WHERE codigo = 'ALMACEN_TABLAS_TIPO_MOV';

UPDATE auth.opcion_menu SET nombre = 'Ubicacion de Articulo', ruta_frontend = '/sigre/almacen/tablas/ubicaciones', orden = 3, flag_estado = '1'
WHERE codigo = 'ALMACEN_TABLAS_UBICACION';

UPDATE auth.opcion_menu SET nombre = 'Posiciones por Almacen', ruta_frontend = '/sigre/almacen/tablas/posiciones', orden = 5, flag_estado = '1'
WHERE codigo = 'ALMACEN_TABLAS_POSICIONES';

UPDATE auth.opcion_menu SET nombre = 'Motivos de traslado', ruta_frontend = '/sigre/almacen/tablas/motivos-traslado', orden = 6, flag_estado = '1'
WHERE codigo = 'ALMACEN_TABLAS_MOTIVO_TRASL';

UPDATE auth.opcion_menu SET nombre = 'Ingreso de Lotes', ruta_frontend = '/sigre/almacen/tablas/lotes', orden = 7, flag_estado = '1'
WHERE codigo = 'ALMACEN_TABLAS_LOTES';

UPDATE auth.opcion_menu SET nombre = 'Unidades de Conversión', ruta_frontend = '/sigre/almacen/tablas/unidades-conversion', orden = 8, flag_estado = '1'
WHERE codigo = 'ALMACEN_TABLAS_UNID_CONV';

UPDATE auth.opcion_menu SET nombre = 'Vales', ruta_frontend = '/sigre/almacen/tablas/numeracion-vales', orden = 9, flag_estado = '1'
WHERE codigo = 'ALMACEN_TABLAS_NUM_VALES';

UPDATE auth.opcion_menu SET nombre = 'Orden de Traslado', ruta_frontend = '/sigre/almacen/tablas/numeracion-otr', orden = 10, flag_estado = '1'
WHERE codigo = 'ALMACEN_TABLAS_NUM_OTR';

UPDATE auth.opcion_menu SET nombre = 'Parametros del Sistema', ruta_frontend = '/sigre/almacen/tablas/parametros', orden = 11, flag_estado = '1'
WHERE codigo = 'ALMACEN_TABLAS_PARAMETROS';

-- Movimientos por almacen (canónico, no existía con nombre correcto)
INSERT INTO auth.opcion_menu (modulo_id, codigo, nombre, ruta_frontend, opcion_padre_id, orden, flag_estado)
SELECT m.id, 'ALMACEN_TABLAS_MOV_POR_ALM', 'Movimientos por almacen', '/sigre/almacen/tablas/movimientos-almacen', p.id, 4, '1'
FROM auth.modulo m
JOIN auth.opcion_menu p ON p.codigo = 'ALMACEN_TABLAS'
WHERE m.codigo = 'ALMACEN'
ON CONFLICT (codigo) DO UPDATE SET
    nombre = EXCLUDED.nombre,
    ruta_frontend = EXCLUDED.ruta_frontend,
    opcion_padre_id = EXCLUDED.opcion_padre_id,
    orden = EXCLUDED.orden,
    flag_estado = '1';
