-- ============================================
-- LIMPIEZA DE REGISTROS DUPLICADOS EXISTENTES
-- Basado en el índice único IX_ASISTENCIA_HT5801 de Oracle
-- (COD_ORIGEN + CODIGO + FLAG_IN_OUT + FEC_MOVIMIENTO)
-- ============================================

-- PASO 1: Identificar duplicados
-- Ver qué registros están duplicados
SELECT 
    cod_origen,
    codigo,
    flag_in_out,
    fec_movimiento,
    COUNT(*) as cantidad_duplicados,
    STRING_AGG(reckey, ', ' ORDER BY fecha_registro) as reckeys,
    MIN(fecha_registro) as primer_registro,
    MAX(fecha_registro) as ultimo_registro
FROM asistencia_ht580
WHERE cod_origen = 'SE'
GROUP BY cod_origen, codigo, flag_in_out, fec_movimiento
HAVING COUNT(*) > 1
ORDER BY fec_movimiento DESC;

-- PASO 2: Ver detalle de los duplicados (con toda la información)
WITH duplicados AS (
    SELECT 
        cod_origen,
        codigo,
        flag_in_out,
        fec_movimiento,
        COUNT(*) as total
    FROM asistencia_ht580
    WHERE cod_origen = 'SE'
    GROUP BY cod_origen, codigo, flag_in_out, fec_movimiento
    HAVING COUNT(*) > 1
)
SELECT 
    a.reckey,
    a.cod_origen,
    a.codigo,
    a.flag_in_out,
    a.fec_movimiento,
    a.fecha_registro,
    a.direccion_ip,
    a.external_id,
    a.estado_sync,
    a.intentos_sync,
    ROW_NUMBER() OVER (
        PARTITION BY a.cod_origen, a.codigo, a.flag_in_out, a.fec_movimiento 
        ORDER BY a.fecha_registro ASC
    ) as numero_copia
FROM asistencia_ht580 a
INNER JOIN duplicados d ON 
    a.cod_origen = d.cod_origen 
    AND a.codigo = d.codigo
    AND a.flag_in_out = d.flag_in_out
    AND a.fec_movimiento = d.fec_movimiento
WHERE a.cod_origen = 'SE'
ORDER BY a.fec_movimiento DESC, numero_copia;

-- ============================================
-- PASO 3: ELIMINAR DUPLICADOS (CONSERVANDO EL PRIMERO)
-- ============================================
-- ⚠️ IMPORTANTE: Ejecutar solo después de revisar los pasos 1 y 2
-- Este DELETE conserva el registro MÁS ANTIGUO (por fecha_registro)
-- y elimina todas las copias posteriores

WITH duplicados_a_eliminar AS (
    SELECT 
        reckey,
        ROW_NUMBER() OVER (
            PARTITION BY cod_origen, codigo, flag_in_out, fec_movimiento 
            ORDER BY fecha_registro ASC
        ) as numero_copia
    FROM asistencia_ht580
    WHERE cod_origen = 'SE'
)
DELETE FROM asistencia_ht580
WHERE reckey IN (
    SELECT reckey 
    FROM duplicados_a_eliminar 
    WHERE numero_copia > 1  -- Elimina todas las copias EXCEPTO la primera
);

-- PASO 4: Verificar que ya no hay duplicados
SELECT 
    cod_origen,
    codigo,
    flag_in_out,
    fec_movimiento,
    COUNT(*) as cantidad
FROM asistencia_ht580
WHERE cod_origen = 'SE'
GROUP BY cod_origen, codigo, flag_in_out, fec_movimiento
HAVING COUNT(*) > 1;

-- PASO 5: Resetear los registros únicos que quedaron con error
-- para que se vuelvan a sincronizar
UPDATE asistencia_ht580
SET 
    estado_sync = 'P',
    intentos_sync = 0,
    fecha_sync = NULL
WHERE cod_origen = 'SE'
  AND estado_sync = 'E'
  AND external_id IS NULL;

-- PASO 6: Verificar resultado final
SELECT 
    'Total registros SE' as descripcion,
    COUNT(*) as cantidad
FROM asistencia_ht580
WHERE cod_origen = 'SE'

UNION ALL

SELECT 
    'Pendientes de sincronizar' as descripcion,
    COUNT(*) as cantidad
FROM asistencia_ht580
WHERE cod_origen = 'SE'
  AND estado_sync = 'P';

