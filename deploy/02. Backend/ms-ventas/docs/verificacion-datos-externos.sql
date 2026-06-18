-- ============================================
-- VERIFICACIÓN DE DATOS EXTERNOS REQUERIDOS
-- Para pruebas de API del microservicio ms-ventas
-- ============================================

-- Query principal para verificar tablas vacías
SELECT 
    cant as cantidad_registros,
    tabla as nombre_tabla,
    esquema as nombre_esquema,
    CASE 
        WHEN cant = 0 THEN '❌ VACÍA - REQUIERE DATOS'
        WHEN cant < 2 THEN '⚠️  POBRE - REQUIERE MÁS DATOS'
        ELSE '✅ OK - DATOS SUFICIENTES'
    END as estado
FROM (
    -- ESQUEMA AUTH
    SELECT COUNT(*) as cant, 'usuario' as tabla, 'auth' as esquema FROM auth.usuario WHERE flag_estado = '1'
    UNION ALL
    SELECT COUNT(*) as cant, 'sucursal' as tabla, 'auth' as esquema FROM auth.sucursal WHERE flag_estado = '1'
    UNION ALL
    SELECT COUNT(*) as cant, 'entidad_contribuyente' as tabla, 'core' as esquema FROM core.entidad_contribuyente WHERE flag_estado = '1'
    UNION ALL
    SELECT COUNT(*) as cant, 'doc_tipo' as tabla, 'core' as esquema FROM core.doc_tipo WHERE flag_estado = '1'
    UNION ALL
    SELECT COUNT(*) as cant, 'moneda' as tabla, 'core' as esquema FROM core.moneda WHERE flag_estado = '1'
    UNION ALL
    SELECT COUNT(*) as cant, 'articulo' as tabla, 'core' as esquema FROM core.articulo WHERE flag_estado = '1'
    UNION ALL
    SELECT COUNT(*) as cant, 'unidad_medida' as tabla, 'core' as esquema FROM core.unidad_medida WHERE flag_estado = '1'
    UNION ALL
    SELECT COUNT(*) as cant, 'forma_pago' as tabla, 'core' as esquema FROM core.forma_pago WHERE flag_estado = '1'
    UNION ALL
    SELECT COUNT(*) as cant, 'almacen' as tabla, 'almacen' as esquema FROM almacen.almacen WHERE flag_estado = '1'
) as datos
ORDER BY 
    CASE 
        WHEN cant = 0 THEN 1
        WHEN cant < 2 THEN 2
        ELSE 3
    END,
    esquema,
    tabla;

-- ============================================
-- VERIFICACIÓN DETALLADA POR ESQUEMA
-- ============================================

-- ESQUEMA AUTH - Detalles
SELECT 
    'AUTH' as esquema,
    'usuario' as tabla,
    COUNT(*) as total,
    COUNT(CASE WHEN flag_estado = '1' THEN 1 END) as activos,
    STRING_AGG(CASE WHEN flag_estado = '1' THEN id::text END, ', ') as ids_activos
FROM auth.usuario
UNION ALL
SELECT 
    'AUTH' as esquema,
    'sucursal' as tabla,
    COUNT(*) as total,
    COUNT(CASE WHEN flag_estado = '1' THEN 1 END) as activos,
    STRING_AGG(CASE WHEN flag_estado = '1' THEN id::text END, ', ') as ids_activos
FROM auth.sucursal
ORDER BY esquema, tabla;

-- ESQUEMA CORE - Detalles
SELECT 
    'CORE' as esquema,
    'entidad_contribuyente' as tabla,
    COUNT(*) as total,
    COUNT(CASE WHEN flag_estado = '1' THEN 1 END) as activos,
    STRING_AGG(CASE WHEN flag_estado = '1' THEN id::text END, ', ') as ids_activos
FROM core.entidad_contribuyente
UNION ALL
SELECT 
    'CORE' as esquema,
    'doc_tipo' as tabla,
    COUNT(*) as total,
    COUNT(CASE WHEN flag_estado = '1' THEN 1 END) as activos,
    STRING_AGG(CASE WHEN flag_estado = '1' THEN id::text END, ', ') as ids_activos
FROM core.doc_tipo
UNION ALL
SELECT 
    'CORE' as esquema,
    'moneda' as tabla,
    COUNT(*) as total,
    COUNT(CASE WHEN flag_estado = '1' THEN 1 END) as activos,
    STRING_AGG(CASE WHEN flag_estado = '1' THEN id::text END, ', ') as ids_activos
FROM core.moneda
UNION ALL
SELECT 
    'CORE' as esquema,
    'articulo' as tabla,
    COUNT(*) as total,
    COUNT(CASE WHEN flag_estado = '1' THEN 1 END) as activos,
    STRING_AGG(CASE WHEN flag_estado = '1' THEN id::text END, ', ') as ids_activos
FROM core.articulo
UNION ALL
SELECT 
    'CORE' as esquema,
    'unidad_medida' as tabla,
    COUNT(*) as total,
    COUNT(CASE WHEN flag_estado = '1' THEN 1 END) as activos,
    STRING_AGG(CASE WHEN flag_estado = '1' THEN id::text END, ', ') as ids_activos
FROM core.unidad_medida
UNION ALL
SELECT 
    'CORE' as esquema,
    'forma_pago' as tabla,
    COUNT(*) as total,
    COUNT(CASE WHEN flag_estado = '1' THEN 1 END) as activos,
    STRING_AGG(CASE WHEN flag_estado = '1' THEN id::text END, ', ') as ids_activos
FROM core.forma_pago
ORDER BY esquema, tabla;

-- ESQUEMA ALMACEN - Detalles
SELECT 
    'ALMACEN' as esquema,
    'almacen' as tabla,
    COUNT(*) as total,
    COUNT(CASE WHEN flag_estado = '1' THEN 1 END) as activos,
    STRING_AGG(CASE WHEN flag_estado = '1' THEN id::text END, ', ') as ids_activos
FROM almacen.almacen;

-- ============================================
-- VERIFICACIÓN DE RELACIONES CRÍTICAS
-- ============================================

-- Verificar que cada sucursal tenga al menos un almacén
SELECT 
    s.id as sucursal_id,
    s.nombre as sucursal_nombre,
    COUNT(a.id) as cantidad_almacenes,
    CASE 
        WHEN COUNT(a.id) = 0 THEN '❌ SIN ALMACÉN'
        ELSE '✅ CON ALMACÉN(ES)'
    END as estado
FROM auth.sucursal s
LEFT JOIN almacen.almacen a ON a.sucursal_id = s.id AND a.flag_estado = '1'
WHERE s.flag_estado = '1'
GROUP BY s.id, s.nombre
ORDER BY s.id;

-- Nota: tokens_session eliminada - no es requerida para pruebas de API

-- ============================================
-- RESUMEN EJECUTIVO
-- ============================================

SELECT 
    'RESUMEN' as tipo,
    COUNT(*) as total_tablas,
    COUNT(CASE WHEN cant > 0 THEN 1 END) as tablas_con_datos,
    COUNT(CASE WHEN cant >= 2 THEN 1 END) as tablas_suficientes,
    COUNT(CASE WHEN cant = 0 THEN 1 END) as tablas_vacias,
    ROUND(
        (COUNT(CASE WHEN cant > 0 THEN 1 END) * 100.0 / COUNT(*)), 2
    ) as porcentaje_completado,
    CASE 
        WHEN COUNT(CASE WHEN cant = 0 THEN 1 END) > 0 THEN '❌ INCOMPLETO'
        WHEN COUNT(CASE WHEN cant < 2 THEN 1 END) > 0 THEN '⚠️  PARCIAL'
        ELSE '✅ COMPLETO'
    END as estado_general
FROM (
    SELECT COUNT(*) as cant FROM auth.usuario WHERE flag_estado = '1'
    UNION ALL
    SELECT COUNT(*) as cant FROM auth.sucursal WHERE flag_estado = '1'
    UNION ALL
    SELECT COUNT(*) as cant FROM core.entidad_contribuyente WHERE flag_estado = '1'
    UNION ALL
    SELECT COUNT(*) as cant FROM core.doc_tipo WHERE flag_estado = '1'
    UNION ALL
    SELECT COUNT(*) as cant FROM core.moneda WHERE flag_estado = '1'
    UNION ALL
    SELECT COUNT(*) as cant FROM core.articulo WHERE flag_estado = '1'
    UNION ALL
    SELECT COUNT(*) as cant FROM core.unidad_medida WHERE flag_estado = '1'
    UNION ALL
    SELECT COUNT(*) as cant FROM core.forma_pago WHERE flag_estado = '1'
    UNION ALL
    SELECT COUNT(*) as cant FROM almacen.almacen WHERE flag_estado = '1'
) as datos;

-- ============================================
-- QUERY SIMPLE PARA VERIFICAR VACÍOS (como solicitaste)
-- ============================================

SELECT cant as cantidad, tabla as nombre_tabla
FROM (
    SELECT COUNT(*) as cant, 'auth.usuario' as tabla FROM auth.usuario WHERE flag_estado = '1'
    UNION ALL
    SELECT COUNT(*) as cant, 'auth.sucursal' as tabla FROM auth.sucursal WHERE flag_estado = '1'
    UNION ALL
    SELECT COUNT(*) as cant, 'core.entidad_contribuyente' as tabla FROM core.entidad_contribuyente WHERE flag_estado = '1'
    UNION ALL
    SELECT COUNT(*) as cant, 'core.doc_tipo' as tabla FROM core.doc_tipo WHERE flag_estado = '1'
    UNION ALL
    SELECT COUNT(*) as cant, 'core.moneda' as tabla FROM core.moneda WHERE flag_estado = '1'
    UNION ALL
    SELECT COUNT(*) as cant, 'core.articulo' as tabla FROM core.articulo WHERE flag_estado = '1'
    UNION ALL
    SELECT COUNT(*) as cant, 'core.unidad_medida' as tabla FROM core.unidad_medida WHERE flag_estado = '1'
    UNION ALL
    SELECT COUNT(*) as cant, 'core.forma_pago' as tabla FROM core.forma_pago WHERE flag_estado = '1'
    UNION ALL
    SELECT COUNT(*) as cant, 'almacen.almacen' as tabla FROM almacen.almacen WHERE flag_estado = '1'
) as datos
WHERE cant = 0  -- Solo mostrar tablas vacías
ORDER BY tabla;
