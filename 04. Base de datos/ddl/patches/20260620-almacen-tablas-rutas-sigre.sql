-- Rutas frontend SIGRE para tablas maestras de Almacén (Fase 1)
-- Ejecutar contra BD security (auth.opcion_menu)

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/tablas/almacenes'
WHERE codigo = 'ALMACEN_TABLAS_ALMACEN';

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/tablas/movimientos-almacen'
WHERE codigo = 'ALMACEN_TABLAS_TIPO_MOV';

-- Opciones adicionales Fase 1 (tablas maestras)
INSERT INTO auth.opcion_menu (modulo_id, codigo, nombre, ruta_frontend, opcion_padre_id, orden, flag_estado)
SELECT m.id, v.codigo, v.nombre, v.ruta, p.id, v.orden, '1'
FROM (VALUES
    ('ALMACEN_TABLAS_TIPOS_MOV_CAT', 'Tipos de movimiento (catálogo)', '/sigre/almacen/tablas/tipos-movimiento', 2),
    ('ALMACEN_TABLAS_UBICACION', 'Ubicación de artículo', '/sigre/almacen/tablas/ubicaciones', 3),
    ('ALMACEN_TABLAS_POSICIONES', 'Posiciones por almacén', '/sigre/almacen/tablas/posiciones', 4),
    ('ALMACEN_TABLAS_MOTIVO_TRASL', 'Motivos de traslado', '/sigre/almacen/tablas/motivos-traslado', 5),
    ('ALMACEN_TABLAS_LOTES', 'Ingreso de lotes', '/sigre/almacen/tablas/lotes', 6),
    ('ALMACEN_TABLAS_UNID_CONV', 'Unidades de conversión', '/sigre/almacen/tablas/unidades-conversion', 7),
    ('ALMACEN_TABLAS_NUM_VALES', 'Numeración — Vales', '/sigre/almacen/tablas/numeracion-vales', 8),
    ('ALMACEN_TABLAS_NUM_OTR', 'Numeración — Orden de traslado', '/sigre/almacen/tablas/numeracion-otr', 9),
    ('ALMACEN_TABLAS_PARAMETROS', 'Parámetros del sistema', '/sigre/almacen/tablas/parametros', 10)
) AS v(codigo, nombre, ruta, orden)
JOIN auth.modulo m ON m.codigo = 'ALMACEN'
JOIN auth.opcion_menu p ON p.codigo = 'ALMACEN_TABLAS'
ON CONFLICT (codigo) DO UPDATE SET
    nombre = EXCLUDED.nombre,
    ruta_frontend = EXCLUDED.ruta_frontend,
    opcion_padre_id = EXCLUDED.opcion_padre_id,
    orden = EXCLUDED.orden,
    flag_estado = '1';
