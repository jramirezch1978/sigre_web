-- ===============================================================
-- MIGRACIÓN: Fix tipo_movimiento y FLAG_IN_OUT para soportar código 10
-- FECHA: 13/10/2025
-- DESCRIPCIÓN: El movimiento REGRESO_CENAR (código 10) requiere 2 caracteres
--              pero los campos estaban definidos con CHAR(1)
-- ===============================================================

-- 1. Modificar columna tipo_movimiento en tickets_asistencia
ALTER TABLE tickets_asistencia 
ALTER COLUMN tipo_movimiento TYPE CHAR(2);

COMMENT ON COLUMN tickets_asistencia.tipo_movimiento IS 'Código de movimiento (1-10): 1=INGRESO_PLANTA, 2=SALIDA_PLANTA, 3=SALIDA_ALMORZAR, 4=REGRESO_ALMORZAR, 5=SALIDA_COMISION, 6=RETORNO_COMISION, 7=INGRESO_PRODUCCION, 8=SALIDA_PRODUCCION, 9=SALIDA_CENAR, 10=REGRESO_CENAR';

-- 2. Modificar columna FLAG_IN_OUT en asistencia_ht580
ALTER TABLE asistencia_ht580 
ALTER COLUMN "FLAG_IN_OUT" TYPE CHAR(2);

COMMENT ON COLUMN asistencia_ht580."FLAG_IN_OUT" IS 'Código de movimiento (1-10): 1=INGRESO_PLANTA, 2=SALIDA_PLANTA, 3=SALIDA_ALMORZAR, 4=REGRESO_ALMORZAR, 5=SALIDA_COMISION, 6=RETORNO_COMISION, 7=INGRESO_PRODUCCION, 8=SALIDA_PRODUCCION, 9=SALIDA_CENAR, 10=REGRESO_CENAR';

-- 3. Verificar los cambios
SELECT 
    column_name, 
    data_type, 
    character_maximum_length
FROM information_schema.columns
WHERE table_name IN ('tickets_asistencia', 'asistencia_ht580')
AND column_name IN ('tipo_movimiento', 'FLAG_IN_OUT')
ORDER BY table_name, column_name;

-- ===============================================================
-- RESULTADO ESPERADO:
-- tickets_asistencia | tipo_movimiento | character | 2
-- asistencia_ht580   | FLAG_IN_OUT     | character | 2
-- ===============================================================

