-- auth.opcion_menu: ruta_frontend para abrir ventanas web (Tablas Almacén)
-- Tabla canónica alineada con opciones_menu.txt y almacen-opciones-menu.config.ts

WITH menu_tablas AS (
    SELECT * FROM (VALUES
        ('ALMACEN_TABLAS_ALMACEN',       'Maestro de almacenes',              '/sigre/almacen/tablas/almacenes',              1),
        ('ALMACEN_TABLAS_TIPO_MOV',      'Tipos de movimientos de almacenes','/sigre/almacen/tablas/tipos-movimiento',      2),
        ('ALMACEN_TABLAS_UBICACION',     'Ubicacion de Articulo',            '/sigre/almacen/tablas/ubicaciones',            3),
        ('ALMACEN_TABLAS_MOV_POR_ALM',   'Movimientos por almacen',          '/sigre/almacen/tablas/movimientos-almacen',    4),
        ('ALMACEN_TABLAS_POSICIONES',    'Posiciones por Almacen',           '/sigre/almacen/tablas/posiciones',             5),
        ('ALMACEN_TABLAS_MOTIVO_TRASL',  'Motivos de traslado',              '/sigre/almacen/tablas/motivos-traslado',       6),
        ('ALMACEN_TABLAS_LOTES',         'Ingreso de Lotes',                 '/sigre/almacen/tablas/lotes',                  7),
        ('ALMACEN_TABLAS_UNID_CONV',     'Unidades de Conversión',           '/sigre/almacen/tablas/unidades-conversion',    8),
        ('ALMACEN_TABLAS_NUM_VALES',     'Vales',                            '/sigre/almacen/tablas/numeracion-vales',       9),
        ('ALMACEN_TABLAS_NUM_OTR',       'Orden de Traslado',                '/sigre/almacen/tablas/numeracion-otr',       10),
        ('ALMACEN_TABLAS_PARAMETROS',    'Parametros del Sistema',           '/sigre/almacen/tablas/parametros',            11)
    ) AS t(codigo, nombre, ruta_frontend, orden)
)
INSERT INTO auth.opcion_menu (modulo_id, codigo, nombre, ruta_frontend, opcion_padre_id, orden, flag_estado)
SELECT m.id, t.codigo, t.nombre, t.ruta_frontend, p.id, t.orden, '1'
FROM menu_tablas t
JOIN auth.modulo m ON m.codigo = 'ALMACEN'
JOIN auth.opcion_menu p ON p.codigo = 'ALMACEN_TABLAS'
ON CONFLICT (codigo) DO UPDATE SET
    nombre = EXCLUDED.nombre,
    ruta_frontend = EXCLUDED.ruta_frontend,
    opcion_padre_id = EXCLUDED.opcion_padre_id,
    orden = EXCLUDED.orden,
    flag_estado = '1';

-- Desactivar opciones que no están en el canon
UPDATE auth.opcion_menu SET flag_estado = '0', ruta_frontend = NULL
WHERE codigo IN (
    'ALMACEN_TABLAS_CLASES_PRODUCTOS',
    'ALMACEN_TABLAS_MAESTRO_PRODUCTOS',
    'ALMACEN_TABLAS_TIPOS_MOV_CAT'
);

-- Rol ADMIN: asegurar vínculo con las opciones activas
INSERT INTO auth.rol_opcion_menu (rol_id, opcion_menu_id, flag_estado)
SELECT r.id, om.id, '1'
FROM auth.rol r
JOIN auth.opcion_menu om ON om.flag_estado = '1'
WHERE r.codigo = 'ADMIN' AND r.flag_estado = '1'
  AND om.codigo LIKE 'ALMACEN_TABLAS_%'
ON CONFLICT (rol_id, opcion_menu_id) DO UPDATE SET flag_estado = '1';

-- Acciones estándar tablas maestras (opciones_menu.txt)
WITH opcion_accion_tablas AS (
    SELECT om.codigo, a.codigo AS accion_codigo
    FROM auth.opcion_menu om
    CROSS JOIN (VALUES
        ('INSERTAR'), ('MODIFICAR'), ('ELIMINAR'), ('CONSULTAR'),
        ('ANULAR'), ('CERRAR'), ('PROCESAR'), ('HOMOLOGAR'), ('IMPORTAR'), ('EXPORTAR')
    ) AS a(codigo)
    WHERE om.codigo IN (
        'ALMACEN_TABLAS_ALMACEN', 'ALMACEN_TABLAS_TIPO_MOV', 'ALMACEN_TABLAS_UBICACION',
        'ALMACEN_TABLAS_MOV_POR_ALM', 'ALMACEN_TABLAS_POSICIONES', 'ALMACEN_TABLAS_MOTIVO_TRASL',
        'ALMACEN_TABLAS_LOTES', 'ALMACEN_TABLAS_UNID_CONV', 'ALMACEN_TABLAS_NUM_VALES',
        'ALMACEN_TABLAS_NUM_OTR', 'ALMACEN_TABLAS_PARAMETROS'
    )
      AND om.flag_estado = '1'
)
INSERT INTO auth.rol_opcion_menu_accion (rol_opcion_menu_id, accion_id, permitido, flag_estado)
SELECT rom.id, ac.id, TRUE, '1'
FROM auth.rol r
JOIN auth.rol_opcion_menu rom ON rom.rol_id = r.id AND rom.flag_estado = '1'
JOIN auth.opcion_menu om ON om.id = rom.opcion_menu_id AND om.flag_estado = '1'
JOIN opcion_accion_tablas oat ON oat.codigo = om.codigo
JOIN auth.accion ac ON ac.codigo = oat.accion_codigo AND ac.flag_estado = '1'
WHERE r.codigo = 'ADMIN' AND r.flag_estado = '1'
ON CONFLICT (rol_opcion_menu_id, accion_id)
DO UPDATE SET permitido = EXCLUDED.permitido, flag_estado = '1';
