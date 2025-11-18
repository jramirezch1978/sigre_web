-- ============================================
-- ÍNDICES PARA OPTIMIZAR PERFORMANCE
-- Consultas de última marcación por trabajador
-- ============================================

-- PASO 1: Eliminar índices existentes
DROP INDEX IF EXISTS idx_asistencia_codigo_tipo01_fecha;
DROP INDEX IF EXISTS idx_asistencia_codigo_tipo_fecha;
DROP INDEX IF EXISTS idx_asistencia_codigo_fec_registro;

-- PASO 2: Crear índices optimizados

-- ÍNDICE 1: Para buscar última marcación 01 (INGRESO_PLANTA)
-- Usado en: findUltimaMarcacion01ByTrabajador
CREATE INDEX idx_asistencia_codigo_tipo01_fecha 
ON asistencia_ht580 (codigo, flag_in_out, fec_registro DESC)
WHERE flag_in_out = '1';

-- ÍNDICE 2: Para buscar última marcación por tipo específico (03, 05, 07, 09)
-- Usado en: findUltimaMarcacionByTipoAndTrabajador
CREATE INDEX idx_asistencia_codigo_tipo_fecha 
ON asistencia_ht580 (codigo, flag_in_out, fec_registro DESC);

-- ÍNDICE 3: Para auto-cierre (findTopByCodigoOrderByFechaRegistroDesc)
CREATE INDEX idx_asistencia_codigo_fec_registro 
ON asistencia_ht580 (codigo, fec_registro DESC);

-- PASO 3: Verificar índices creados
SELECT 
    indexname,
    indexdef
FROM pg_indexes
WHERE tablename = 'asistencia_ht580'
  AND indexname LIKE 'idx_asistencia%'
ORDER BY indexname;

