-- PATCH: Normalizar rutas frontend del módulo Almacén bajo /sigre/almacen/
-- Alinea auth.opcion_menu con las rutas Angular actuales.

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/operaciones/req-traslado'
WHERE codigo = 'ALMACEN_OP_REQ_TRASLADO';

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/operaciones/despacho'
WHERE codigo = 'ALMACEN_OP_DESPACHO';

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/operaciones/recepcion'
WHERE codigo = 'ALMACEN_OP_RECEPCION';

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/operaciones/almacenamiento'
WHERE codigo = 'ALMACEN_OP_ALMACENAMIENTO';

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/operaciones/devoluciones'
WHERE codigo = 'ALMACEN_OP_DEVOLUCIONES';

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/operaciones/reposicion-stock'
WHERE codigo = 'ALMACEN_OP_REPOSICION';

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/operaciones/comparacion-inventario'
WHERE codigo = 'ALMACEN_OP_COMPARACION_INV';

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/operaciones/registro-perdidas'
WHERE codigo = 'ALMACEN_OP_MERMAS';

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/consultas/kardex-movimientos'
WHERE codigo = 'ALMACEN_CONS_KARDEX';

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/consultas/ordenes-compra'
WHERE codigo = 'ALMACEN_CONS_ORD_COMPRA';

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/consultas/consulta-articulos'
WHERE codigo = 'ALMACEN_CONS_PRODUCTOS';

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/consultas/prestamos'
WHERE codigo = 'ALMACEN_CONS_PRESTAMOS';

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/consultas/devoluciones'
WHERE codigo = 'ALMACEN_CONS_DEV_PROV';

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/reportes/stock-fecha'
WHERE codigo = 'ALMACEN_REP_STOCK_FECHA';

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/reportes/historial-movimiento'
WHERE codigo = 'ALMACEN_REP_HIST_MOV';

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/reportes/valorizacion'
WHERE codigo = 'ALMACEN_REP_VALORIZACION';

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/reportes/productos-vendidos-por-periodo'
WHERE codigo = 'ALMACEN_REP_VENDIDOS_PERIODO';

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/reportes/stock-minimo'
WHERE codigo = 'ALMACEN_REP_STOCK_MINIMO';

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/reportes/diagnostico-almacenes'
WHERE codigo = 'ALMACEN_REP_DIAG';

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/reportes/reporte-tomas-inventario'
WHERE codigo = 'ALMACEN_REP_TOMA_INV';

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/procesos/recalcular'
WHERE codigo = 'ALMACEN_PROC_RECALCULO';

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/procesos/cuadre-stock'
WHERE codigo = 'ALMACEN_PROC_CUADRE_STOCK';

UPDATE auth.opcion_menu SET ruta_frontend = '/sigre/almacen/procesos/actualizacion'
WHERE codigo = 'ALMACEN_PROC_ACT_AUTO';
