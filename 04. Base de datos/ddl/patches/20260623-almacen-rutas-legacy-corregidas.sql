-- Corregir rutas legacy mal normalizadas que provocan redirect a pantalla de asistencia.
-- Ej.: /sigre/almacen/tablas/tablas-almacenes (RestPE) no coincide con rutas Angular actuales.

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/tablas/almacenes'
WHERE codigo = 'ALMACEN_TABLAS_ALMACEN'
  AND ruta_frontend IN (
    '/almacen/tablas/tablas-almacenes',
    '/sigre/almacen/tablas/tablas-almacenes',
    '/',
    ''
  );

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/tablas/movimientos-almacen'
WHERE codigo = 'ALMACEN_TABLAS_MOV_POR_ALM'
  AND ruta_frontend IN (
    '/almacen/tablas/almacenes-movimiento',
    '/sigre/almacen/tablas/almacenes-movimiento'
  );

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/tablas/tipos-movimiento'
WHERE codigo = 'ALMACEN_TABLAS_TIPO_MOV'
  AND ruta_frontend = '/almacen/tablas/tipos-movimiento';

-- Operaciones / consultas / reportes / procesos: prefijo SIGRE obligatorio
UPDATE auth.opcion_menu SET ruta_frontend = '/sigre' || ruta_frontend
WHERE ruta_frontend LIKE '/almacen/%'
  AND ruta_frontend NOT LIKE '/sigre/%';
