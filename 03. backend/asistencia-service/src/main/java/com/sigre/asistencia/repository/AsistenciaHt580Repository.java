package com.sigre.asistencia.repository;

import com.sigre.asistencia.entity.AsistenciaHt580;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface AsistenciaHt580Repository extends JpaRepository<AsistenciaHt580, String> {
    
    /**
     * Buscar asistencias de un trabajador en una fecha específica
     */
    @Query("SELECT a FROM AsistenciaHt580 a " +
           "WHERE a.codigo = :codigo " +
           "AND DATE(a.fechaMovimiento) = :fecha " +
           "ORDER BY a.fechaMovimiento DESC")
    List<AsistenciaHt580> findAsistenciasByCodigoAndFecha(@Param("codigo") String codigo, 
                                                          @Param("fecha") LocalDate fecha);
    
    /**
     * Buscar última asistencia de un trabajador
     */
    @Query("SELECT a FROM AsistenciaHt580 a " +
           "WHERE a.codigo = :codigo " +
           "ORDER BY a.fechaMovimiento DESC " +
           "LIMIT 1")
    AsistenciaHt580 findUltimaAsistenciaByTrabajador(@Param("codigo") String codigo);
    
    /**
     * Buscar última asistencia de un trabajador por código Y origen (solo tipo 1 y 2)
     * SOLO movimientos tipo 1 (Ingreso) o 2 (Salida) - IGNORAR movimientos intermedios (3-10)
     * ORDENADO POR FECHA DE REGISTRO
     */
    @Query(value = "SELECT * FROM asistencia_ht580 " +
           "WHERE codigo = :codigo " +
           "AND cod_origen = :codOrigen " +
           "AND TRIM(flag_in_out) IN ('1', '2') " +
           "ORDER BY fec_registro DESC " +
           "LIMIT 1", 
           nativeQuery = true)
    Optional<AsistenciaHt580> findTopByCodigoAndCodOrigenOrderByFechaRegistroDesc(@Param("codigo") String codigo, 
                                                                                   @Param("codOrigen") String codOrigen);
    
    /**
     * ✅ NUEVA LÓGICA DE TURNOS - OPTIMIZADA CON ÍNDICES
     * Buscar última marcación INGRESO/SALIDA PLANTA (tipo 1 o 2) de un trabajador por código Y origen
     * Esta es la marcación "raíz" de donde se heredan turno y reckey_ref
     * IGNORAR movimientos intermedios (3-10): almuerzo, cena, comisión, producción
     * 
     * OPTIMIZACIÓN: Usa índice en (codigo, flag_in_out, fec_registro)
     */
    @Query(value = "SELECT * FROM asistencia_ht580 " 
            + "WHERE codigo = :codigo " 
            + "AND cod_origen = :codOrigen " 
            + "AND TRIM(flag_in_out) IN ('1', '2') " 
            + "ORDER BY fec_registro DESC " 
            + "LIMIT 1", 
           nativeQuery = true)
    Optional<AsistenciaHt580> findUltimaMarcacionConFiltrosByTrabajador(@Param("codigo") String codigo, 
                                                                        @Param("codOrigen") String codOrigen);
    
    /**
     * Buscar asistencias en un rango de fechas
     * ACTUALIZADO: fechaMovimiento ahora es LocalDate
     */
    @Query("SELECT a FROM AsistenciaHt580 a " +
           "WHERE a.fechaMovimiento BETWEEN :fechaInicio AND :fechaFin " +
           "ORDER BY a.fechaMovimiento DESC")
    List<AsistenciaHt580> findAsistenciasByRangoFechas(@Param("fechaInicio") LocalDate fechaInicio,
                                                      @Param("fechaFin") LocalDate fechaFin);
    
    /**
     * Contar asistencias de un trabajador en una fecha
     */
    @Query("SELECT COUNT(a) FROM AsistenciaHt580 a " +
           "WHERE a.codigo = :codigo " +
           "AND DATE(a.fechaMovimiento) = :fecha")
    Long countAsistenciasByCodigoAndFecha(@Param("codigo") String codigo, @Param("fecha") LocalDate fecha);
    
    /**
     * Buscar asistencias por tipo de movimiento (IN/OUT)
     */
    @Query("SELECT a FROM AsistenciaHt580 a " +
           "WHERE a.codigo = :codigo " +
           "AND a.flagInOut = :tipoMovimiento " +
           "AND DATE(a.fechaMovimiento) = :fecha " +
           "ORDER BY a.fechaMovimiento DESC")
    List<AsistenciaHt580> findAsistenciasByCodigoAndTipoMovimiento(@Param("codigo") String codigo,
                                                                  @Param("tipoMovimiento") String tipoMovimiento,
                                                                  @Param("fecha") LocalDate fecha);
    
    /**
     * Verificar si existe un RECKEY (para generar únicos)
     */
    boolean existsByReckey(String reckey);
    
    /**
     * Obtener ÚLTIMOS movimientos de TODOS los trabajadores (solo tipo 1 y 2)
     * Para proceso de auto-cierre masivo cada 30 minutos
     * SOLO movimientos tipo 1 (Ingreso) o 2 (Salida) - IGNORAR movimientos intermedios (3-10)
     * ORDENADO POR FECHA DE REGISTRO (no fecha de movimiento)
     */
    @Query(value = "SELECT a.* FROM asistencia_ht580 a " +
           "WHERE TRIM(a.flag_in_out) IN ('1', '2') " +
           "AND a.fec_registro = (" +
           "    SELECT MAX(a2.fec_registro) FROM asistencia_ht580 a2 " +
           "    WHERE a2.codigo = a.codigo " +
           "    AND TRIM(a2.flag_in_out) IN ('1', '2')" +
           ") " +
           "ORDER BY a.codigo ASC", 
           nativeQuery = true)
    List<AsistenciaHt580> findUltimosMovimientosPorTrabajador();
    
    // ===== MÉTODOS PARA DASHBOARD =====
    
    /**
     * Contar registros del día actual
     */
    @Query("SELECT COUNT(a) FROM AsistenciaHt580 a WHERE DATE(a.fechaMovimiento) = CURRENT_DATE")
    Long countRegistrosHoy();
    
    /**
     * Contar registros sincronizados (que tienen fechaSync)
     */
    @Query("SELECT COUNT(a) FROM AsistenciaHt580 a WHERE a.fechaSync IS NOT NULL")
    Long countRegistrosSincronizados();
    
    /**
     * Contar registros pendientes de sincronización
     */
    @Query("SELECT COUNT(a) FROM AsistenciaHt580 a WHERE a.fechaSync IS NULL")
    Long countRegistrosPendientesSincronizacion();
    
    /**
     * Obtener marcajes agrupados por hora del día actual CORREGIDO
     * Solo del día actual, sin mezclar con otros días
     * ACTUALIZADO: Agrupa por fechaMovimiento, extrae HOUR de fecMarcacion, excluye AUTO-CLOSE
     */
    @Query("SELECT EXTRACT(HOUR FROM a.fecMarcacion) as hora, COUNT(a) as cantidad " +
           "FROM AsistenciaHt580 a " +
           "WHERE a.fechaMovimiento = CURRENT_DATE " +
           "AND a.direccionIp <> 'AUTO-CLOSE' " +
           "GROUP BY EXTRACT(HOUR FROM a.fecMarcacion) " +
           "ORDER BY hora")
    List<Object[]> countMarcajesPorHoraHoy();
    
    /**
     * Obtener marcajes del día actual con información detallada para verificación
     * ACTUALIZADO: Agrupa por fechaMovimiento, extrae HOUR de fecMarcacion, excluye AUTO-CLOSE
     */
    @Query("SELECT " +
           "a.fechaMovimiento as fecha, " +
           "EXTRACT(HOUR FROM a.fecMarcacion) as hora, " +
           "COUNT(a) as cantidad, " +
           "MIN(a.fecMarcacion) as primerMarcaje, " +
           "MAX(a.fecMarcacion) as ultimoMarcaje " +
           "FROM AsistenciaHt580 a " +
           "WHERE a.fechaMovimiento = CURRENT_DATE " +
           "AND a.direccionIp <> 'AUTO-CLOSE' " +
           "GROUP BY a.fechaMovimiento, EXTRACT(HOUR FROM a.fecMarcacion) " +
           "ORDER BY hora")
    List<Object[]> countMarcajesDetalladosHoy();
    
    /**
     * Obtener marcajes agrupados por hora de las últimas 24 horas
     * CORREGIDO: Distingue entre horas del día actual vs día anterior
     * ACTUALIZADO: Agrupa por fechaMovimiento, extrae HOUR de fecMarcacion, excluye AUTO-CLOSE
     */
    @Query("SELECT " +
           "CASE " +
           "    WHEN a.fechaMovimiento = CURRENT_DATE THEN EXTRACT(HOUR FROM a.fecMarcacion) " +
           "    ELSE -(EXTRACT(HOUR FROM a.fecMarcacion)) " +
           "END as horaConFecha, " +
           "COUNT(a) as cantidad, " +
           "a.fechaMovimiento as fecha " +
           "FROM AsistenciaHt580 a " +
           "WHERE a.fecMarcacion >= :fechaInicio " +
           "AND a.direccionIp <> 'AUTO-CLOSE' " +
           "GROUP BY a.fechaMovimiento, EXTRACT(HOUR FROM a.fecMarcacion) " +
           "ORDER BY a.fechaMovimiento, EXTRACT(HOUR FROM a.fecMarcacion)")
    List<Object[]> countMarcajesPorHoraUltimas24h(@Param("fechaInicio") LocalDateTime fechaInicio);
    
    /**
     * Obtener marcajes de las últimas 24 horas con información detallada por fecha y hora
     * ACTUALIZADO: Agrupa por fechaMovimiento, extrae HOUR de fecMarcacion, excluye AUTO-CLOSE
     */
    @Query("SELECT " +
           "a.fechaMovimiento as fecha, " +
           "EXTRACT(HOUR FROM a.fecMarcacion) as hora, " +
           "COUNT(a) as cantidad " +
           "FROM AsistenciaHt580 a " +
           "WHERE a.fecMarcacion >= :fechaInicio " +
           "AND a.direccionIp <> 'AUTO-CLOSE' " +
           "GROUP BY a.fechaMovimiento, EXTRACT(HOUR FROM a.fecMarcacion) " +
           "ORDER BY a.fechaMovimiento, EXTRACT(HOUR FROM a.fecMarcacion)")
    List<Object[]> countMarcajesDetalladoUltimas24h(@Param("fechaInicio") LocalDateTime fechaInicio);
    
    /**
     * Obtener todos los marcajes del día actual
     */
    @Query("SELECT a FROM AsistenciaHt580 a " +
           "WHERE DATE(a.fechaMovimiento) = CURRENT_DATE " +
           "ORDER BY a.fechaMovimiento DESC")
    List<AsistenciaHt580> findMarcajesDelDia();
    
    /**
     * Obtener marcajes agrupados por centro de costo (primeros 2 caracteres del código)
     */
    @Query("SELECT SUBSTRING(a.codigo, 1, 2) as centroCosto, COUNT(a) as cantidad " +
           "FROM AsistenciaHt580 a " +
           "WHERE DATE(a.fechaMovimiento) = CURRENT_DATE " +
           "GROUP BY SUBSTRING(a.codigo, 1, 2) " +
           "ORDER BY cantidad DESC")
    List<Object[]> countMarcajesPorCentroCostoHoy();
    
    /**
     * Contar trabajadores únicos que han marcado hoy
     */
    @Query("SELECT COUNT(DISTINCT a.codigo) FROM AsistenciaHt580 a WHERE DATE(a.fechaMovimiento) = CURRENT_DATE")
    Long countTrabajadoresUnicosHoy();
    
    /**
     * ✅ VALIDACIÓN ANTI-DUPLICADOS
     * Verificar si ya existe una marcación con la MISMA combinación del índice único:
     * - COD_ORIGEN
     * - CODIGO (trabajador)
     * - FLAG_IN_OUT (tipo de movimiento)
     * - FEC_MOVIMIENTO (solo FECHA, sin hora - tipo DATE en BD)
     * - TURNO
     * 
     * Este índice único es IX_ASISTENCIA_HT5801 en Oracle/PostgreSQL
     */
    @Query("SELECT CASE WHEN COUNT(a) > 0 THEN true ELSE false END FROM AsistenciaHt580 a " +
           "WHERE a.codOrigen = :codOrigen " +
           "AND a.codigo = :codigo " +
           "AND a.flagInOut = :flagInOut " +
           "AND a.fechaMovimiento = :fechaMovimiento " +
           "AND TRIM(a.turno) = TRIM(:turno)")
    boolean existeDuplicado(@Param("codOrigen") String codOrigen,
                           @Param("codigo") String codigo,
                           @Param("flagInOut") String flagInOut,
                           @Param("fechaMovimiento") LocalDate fechaMovimiento,
                           @Param("turno") String turno);

    /**
     * Obtener indicadores de centros de costo con movimientos pivoteados por fecha
     * SELECT m.tipo_trabajador, tt.desc_tipo_tra, m.cod_area, a.desc_area,
     *        m.cod_seccion, s.desc_seccion, cc.desc_cencos, ah.flag_in_out, count(*)
     * FROM ASISTENCIA_HT580 ah, MAESTRO m, centros_costo cc, tipo_trabajador tt, area a, seccion s
     * WHERE ah.codigo = m.cod_trabajador
     *   AND m.cencos = cc.cencos
     *   AND m.cod_area = a.cod_area
     *   AND s.codarea = m.cod_area
     *   AND s.codseccion = m.cod_seccion
     *   AND m.tipo_trabajador = tt.tipo_trabajador
     *   AND to_char(ah.fec_movimiento, 'dd/mm/yyyy') = '02/10/2025'
     *   AND ah.cod_origen = 'SE'
     * GROUP BY m.tipo_trabajador, tt.desc_tipo_tra, m.cod_area, a.desc_area,
     *          m.cod_seccion, s.desc_seccion, cc.desc_cencos, ah.flag_in_out
     */
    @Query("SELECT " +
           "m.tipoTrabajador, " +
           "tt.descripcionTipoTrabajador, " +
           "m.codArea, " +
           "ar.descripcionArea, " +
           "m.codSeccion, " +
           "s.descripcionSeccion, " +
           "cc.descripcionCencos, " +
           "a.flagInOut, " +
           "COUNT(a) " +
           "FROM AsistenciaHt580 a " +
           "JOIN Maestro m ON a.codigo = m.codTrabajador " +
           "LEFT JOIN TipoTrabajador tt ON m.tipoTrabajador = tt.tipoTrabajador " +
           "LEFT JOIN Area ar ON m.codArea = ar.codArea " +
           "LEFT JOIN Seccion s ON m.codArea = s.id.codArea AND m.codSeccion = s.id.codSeccion " +
           "LEFT JOIN CentrosCosto cc ON m.centroCosto = cc.cencos " +
           "WHERE DATE(a.fechaMovimiento) = :fecha " +
           "AND a.codOrigen = 'SE' " +
           "GROUP BY m.tipoTrabajador, tt.descripcionTipoTrabajador, m.codArea, ar.descripcionArea, " +
           "         m.codSeccion, s.descripcionSeccion, cc.descripcionCencos, a.flagInOut " +
           "ORDER BY m.tipoTrabajador, m.codArea, m.codSeccion")
    List<Object[]> findIndicadoresCentrosCostoPorFecha(@Param("fecha") LocalDate fecha);

    /**
     * Obtener indicadores de áreas con movimientos pivoteados por fecha
     */
    @Query("SELECT " +
           "m.tipoTrabajador, " +
           "tt.descripcionTipoTrabajador, " +
           "m.codArea, " +
           "ar.descripcionArea, " +
           "cc.descripcionCencos, " +
           "a.flagInOut, " +
           "COUNT(a) " +
           "FROM AsistenciaHt580 a " +
           "JOIN Maestro m ON a.codigo = m.codTrabajador " +
           "LEFT JOIN TipoTrabajador tt ON m.tipoTrabajador = tt.tipoTrabajador " +
           "LEFT JOIN Area ar ON m.codArea = ar.codArea " +
           "LEFT JOIN CentrosCosto cc ON m.centroCosto = cc.cencos " +
           "WHERE DATE(a.fechaMovimiento) = :fecha " +
           "AND a.codOrigen = 'SE' " +
           "GROUP BY m.tipoTrabajador, tt.descripcionTipoTrabajador, m.codArea, ar.descripcionArea, " +
           "         cc.descripcionCencos, a.flagInOut " +
           "ORDER BY m.tipoTrabajador, m.codArea")
    List<Object[]> findIndicadoresAreasPorFecha(@Param("fecha") LocalDate fecha);

    /**
     * Obtener indicadores de secciones con movimientos pivoteados por fecha
     */
    @Query("SELECT " +
           "m.tipoTrabajador, " +
           "tt.descripcionTipoTrabajador, " +
           "m.codArea, " +
           "ar.descripcionArea, " +
           "m.codSeccion, " +
           "s.descripcionSeccion, " +
           "cc.descripcionCencos, " +
           "a.flagInOut, " +
           "COUNT(a) " +
           "FROM AsistenciaHt580 a " +
           "JOIN Maestro m ON a.codigo = m.codTrabajador " +
           "LEFT JOIN TipoTrabajador tt ON m.tipoTrabajador = tt.tipoTrabajador " +
           "LEFT JOIN Area ar ON m.codArea = ar.codArea " +
           "LEFT JOIN Seccion s ON m.codArea = s.id.codArea AND m.codSeccion = s.id.codSeccion " +
           "LEFT JOIN CentrosCosto cc ON m.centroCosto = cc.cencos " +
           "WHERE DATE(a.fechaMovimiento) = :fecha " +
           "AND a.codOrigen = 'SE' " +
           "GROUP BY m.tipoTrabajador, tt.descripcionTipoTrabajador, m.codArea, ar.descripcionArea, " +
           "         m.codSeccion, s.descripcionSeccion, cc.descripcionCencos, a.flagInOut " +
           "ORDER BY m.tipoTrabajador, m.codArea, m.codSeccion")
    List<Object[]> findIndicadoresSeccionesPorFecha(@Param("fecha") LocalDate fecha);
    
    /**
     * Reporte de asistencia - Consulta EXACTA que funciona en PostgreSQL
     * Usa parámetros posicionales ?1, ?2, ?3 para evitar conflicto con :: de casting
     */
    @Query(value = """
        WITH parametros AS (
            SELECT 
                ?1 AS cod_origen_param,
                ?2 AS fecha_inicio_param,
                ?3 AS fecha_fin_param,
                (
                    SELECT COUNT(*)
                    FROM generate_series(?2::date, ?3::date, '1 day'::interval) AS dia
                    WHERE EXTRACT(DOW FROM dia) BETWEEN 1 AND 6
                ) AS dias_laborables_rango
        ),
        marcaciones_base AS (
            SELECT 
                a.RECKEY,
                a.CODIGO,
                a.FEC_MOVIMIENTO,
                a.FEC_MARCACION AS hora_entrada,
                a.TURNO
            FROM asistencia_ht580 a
            WHERE a.FLAG_IN_OUT = '1'  
              AND a.COD_ORIGEN = ?1
              AND a.FEC_MOVIMIENTO BETWEEN ?2 AND ?3
        ),
        marcaciones_completas AS (
            SELECT 
                mb.RECKEY,
                mb.CODIGO,
                mb.FEC_MOVIMIENTO,
                mb.TURNO,
                mb.hora_entrada,
                
                (SELECT a2.FEC_MARCACION 
                 FROM asistencia_ht580 a2 
                 WHERE a2.RECKEY_REF = mb.RECKEY 
                   AND a2.FLAG_IN_OUT = '2'
                 LIMIT 1) AS hora_salida,
                
                (SELECT a3.FEC_MARCACION 
                 FROM asistencia_ht580 a3 
                 WHERE a3.RECKEY_REF = mb.RECKEY 
                   AND a3.FLAG_IN_OUT = '3'
                 LIMIT 1) AS salida_almuerzo,
                
                (SELECT a3.RECKEY 
                 FROM asistencia_ht580 a3 
                 WHERE a3.RECKEY_REF = mb.RECKEY 
                   AND a3.FLAG_IN_OUT = '3'
                 LIMIT 1) AS reckey_salida_almuerzo,
                
                (SELECT a5.FEC_MARCACION 
                 FROM asistencia_ht580 a5 
                 WHERE a5.RECKEY_REF = mb.RECKEY 
                   AND a5.FLAG_IN_OUT = '5'
                 LIMIT 1) AS salida_comision,
                   
                (SELECT a5.RECKEY 
                 FROM asistencia_ht580 a5 
                 WHERE a5.RECKEY_REF = mb.RECKEY 
                   AND a5.FLAG_IN_OUT = '5'
                 LIMIT 1) AS reckey_salida_comision,
                   
                (SELECT a9.FEC_MARCACION 
                 FROM asistencia_ht580 a9 
                 WHERE a9.RECKEY_REF = mb.RECKEY 
                   AND a9.FLAG_IN_OUT = '9'
                 LIMIT 1) AS salida_cena,
                   
                (SELECT a9.RECKEY 
                 FROM asistencia_ht580 a9 
                 WHERE a9.RECKEY_REF = mb.RECKEY 
                   AND a9.FLAG_IN_OUT = '9'
                 LIMIT 1) AS reckey_salida_cena
                   
            FROM marcaciones_base mb
        ),
        marcaciones_detalle AS (
            SELECT 
                mc.*,
                
                (SELECT a4.FEC_MARCACION 
                 FROM asistencia_ht580 a4 
                 WHERE a4.RECKEY_REF = mc.reckey_salida_almuerzo
                   AND a4.FLAG_IN_OUT = '4'
                 LIMIT 1) AS regreso_almuerzo,
                
                (SELECT a6.FEC_MARCACION 
                 FROM asistencia_ht580 a6 
                 WHERE a6.RECKEY_REF = mc.reckey_salida_comision
                   AND a6.FLAG_IN_OUT = '6'
                 LIMIT 1) AS retorno_comision,
                   
                (SELECT a10.FEC_MARCACION 
                 FROM asistencia_ht580 a10 
                 WHERE a10.RECKEY_REF = mc.reckey_salida_cena
                   AND a10.FLAG_IN_OUT = '10'
                 LIMIT 1) AS regreso_cena
                   
            FROM marcaciones_completas mc
        ),
        calculos AS (
            SELECT 
                md.*,
                tt.desc_tipo_tra AS tipo_trabajador,
                m.COD_TRABAJADOR,
                (m.APEL_PATERNO || ' ' || m.APEL_MATERNO || ', ' || m.NOMBRE1) AS NOM_TRABAJADOR,
                m.TIPO_DOC_IDENT_RTPS,
                m.NRO_DOC_IDENT_RTPS,
                a.DESC_AREA,
                c.DESC_CARGO,
                tu.DESCRIPCION AS desc_turno,
                tu.HORA_INICIO_NORM,
                tu.HORA_FINAL_NORM,
                tu.TOLERANCIA,
                
                EXTRACT(WEEK FROM md.FEC_MOVIMIENTO) AS num_semana,
                EXTRACT(YEAR FROM md.FEC_MOVIMIENTO) AS anio,
                
                CASE 
                    WHEN md.hora_entrada IS NOT NULL THEN
                        GREATEST(0, 
                            ROUND(
                                EXTRACT(EPOCH FROM (md.hora_entrada - 
                                 (DATE_TRUNC('day', md.FEC_MOVIMIENTO) + 
                                  (tu.HORA_INICIO_NORM - DATE_TRUNC('day', tu.HORA_INICIO_NORM)) + 
                                  INTERVAL '1 minute' * tu.TOLERANCIA))
                                ) / 60
                            ) - 15
                        )
                    ELSE 0
                END AS tardanza_min,
                
                CASE 
                    WHEN md.salida_almuerzo IS NOT NULL AND md.regreso_almuerzo IS NOT NULL THEN
                        ROUND(EXTRACT(EPOCH FROM (md.regreso_almuerzo - md.salida_almuerzo)) / 60)
                    ELSE 0
                END AS tiempo_almuerzo_min,
                
                CASE 
                    WHEN md.salida_comision IS NOT NULL AND md.retorno_comision IS NOT NULL THEN
                        ROUND(EXTRACT(EPOCH FROM (md.retorno_comision - md.salida_comision)) / 60)
                    ELSE 0
                END AS tiempo_comision_min,
                
                CASE 
                    WHEN md.salida_cena IS NOT NULL AND md.regreso_cena IS NOT NULL THEN
                        ROUND(EXTRACT(EPOCH FROM (md.regreso_cena - md.salida_cena)) / 60)
                    ELSE 0
                END AS tiempo_cena_min,
                
                CASE 
                    WHEN md.hora_entrada IS NOT NULL AND md.hora_salida IS NOT NULL THEN
                        ROUND(CAST(EXTRACT(EPOCH FROM (md.hora_salida - md.hora_entrada)) / 3600 AS NUMERIC), 2)
                    ELSE 0
                END AS horas_brutas,
                
                ROUND(
                    CAST((EXTRACT(EPOCH FROM (tu.HORA_FINAL_NORM - tu.HORA_INICIO_NORM)) / 3600) - 
                    (EXTRACT(EPOCH FROM (tu.REFRIG_FINAL_NORM - tu.REFRIG_INICIO_NORM)) / 3600) AS NUMERIC),
                    2
                ) AS jornada_normal
                
            FROM marcaciones_detalle md
            INNER JOIN maestro m ON md.CODIGO = m.COD_TRABAJADOR
            LEFT JOIN cargo c ON TRIM(m.COD_CARGO) = TRIM(c.COD_CARGO)
            LEFT JOIN area a ON m.COD_AREA = a.COD_AREA
            INNER JOIN turno tu ON md.TURNO = tu.TURNO
            INNER JOIN tipo_trabajador tt ON m.TIPO_TRABAJADOR = tt.tipo_trabajador
            WHERE m.FLAG_ESTADO = '1'
        ),
        calculos_con_horas AS (
            SELECT 
                c.*,
                ROUND(CAST(c.horas_brutas - (c.tiempo_almuerzo_min / 60.0) - (c.tiempo_comision_min / 60.0) - (c.tiempo_cena_min / 60.0) AS NUMERIC), 2) AS horas_netas
            FROM calculos c
        ),
        calculos_finales AS (
            SELECT 
                ch.*,
                
                CASE 
                    WHEN ch.horas_netas > 8 THEN
                        ROUND(CAST(ch.horas_netas - 8 AS NUMERIC), 2)
                    ELSE 0
                END AS horas_extras_dia,
                
                SUM(ch.horas_netas) 
                    OVER (PARTITION BY ch.COD_TRABAJADOR, EXTRACT(YEAR FROM ch.FEC_MOVIMIENTO), EXTRACT(WEEK FROM ch.FEC_MOVIMIENTO)) 
                    AS total_horas_semana,
                
                SUM(CASE 
                        WHEN ch.horas_netas > 8 THEN
                            ROUND(CAST(ch.horas_netas - 8 AS NUMERIC), 2)
                        ELSE 0
                    END) 
                    OVER (PARTITION BY ch.COD_TRABAJADOR, EXTRACT(YEAR FROM ch.FEC_MOVIMIENTO), EXTRACT(WEEK FROM ch.FEC_MOVIMIENTO)) 
                    AS total_extras_semana,
                
                SUM(CASE WHEN ch.horas_netas >= 4 THEN 1 ELSE 0 END) OVER (
                    PARTITION BY 
                        ch.COD_TRABAJADOR, 
                        EXTRACT(YEAR FROM ch.FEC_MOVIMIENTO), 
                        EXTRACT(WEEK FROM ch.FEC_MOVIMIENTO)
                ) 
                    AS dias_asistidos_semana
                
            FROM calculos_con_horas ch
        )
        SELECT 
            ROW_NUMBER() OVER (ORDER BY cf.DESC_AREA, cf.NOM_TRABAJADOR, cf.FEC_MOVIMIENTO) AS nro,
            cf.tipo_trabajador,
            cf.COD_TRABAJADOR AS codigo_trabajador,
            cf.NRO_DOC_IDENT_RTPS AS dni,
            cf.NOM_TRABAJADOR AS apellidos_nombres,
            cf.DESC_AREA AS area,
            cf.DESC_CARGO AS cargo_puesto,
            cf.desc_turno AS turno,
            cf.FEC_MOVIMIENTO AS fecha,
            cf.hora_entrada AS hora_ingreso,
            cf.hora_salida AS hora_salida,
            
            CONCAT(
                LPAD(CAST(TRUNC(cf.horas_netas) AS TEXT), 2, '0'), 
                ':', 
                LPAD(CAST(MOD(ROUND(cf.horas_netas * 60), 60) AS TEXT), 2, '0')
            ) AS horas_trabajadas,
            
            cf.horas_extras_dia AS horas_extras,
            cf.tardanza_min,
            ROUND(CAST(cf.total_horas_semana AS NUMERIC), 2) AS total_horas_trabajadas_semana,
            ROUND(CAST(cf.total_extras_semana AS NUMERIC), 2) AS total_horas_extras_semana,
            cf.dias_asistidos_semana AS total_dias_asistidos,
            (p.dias_laborables_rango - cf.dias_asistidos_semana) AS total_faltas,
            ROUND((CAST(cf.dias_asistidos_semana AS numeric) / NULLIF(p.dias_laborables_rango, 0)) * 100, 2) AS porc_asistencia,
            ROUND((CAST((p.dias_laborables_rango - cf.dias_asistidos_semana) AS numeric) / NULLIF(p.dias_laborables_rango, 0)) * 100, 2) AS porc_ausentismo
            
        FROM calculos_finales cf
        CROSS JOIN parametros p
        ORDER BY cf.DESC_AREA, cf.NOM_TRABAJADOR, cf.FEC_MOVIMIENTO
        """, 
        nativeQuery = true)
    List<Object[]> generarReporteAsistencia(
        String codOrigen,
        LocalDate fechaInicio,
        LocalDate fechaFin
    );
}
