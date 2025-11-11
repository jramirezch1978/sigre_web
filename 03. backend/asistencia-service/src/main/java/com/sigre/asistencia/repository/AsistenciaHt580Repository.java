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
     * Buscar última asistencia de un trabajador por código Y origen
     * ORDENADO POR FECHA DE REGISTRO
     */
    Optional<AsistenciaHt580> findTopByCodigoAndCodOrigenOrderByFechaRegistroDesc(String codigo, String codOrigen);
    
    /**
     * ✅ NUEVA LÓGICA DE TURNOS - OPTIMIZADA CON ÍNDICES
     * Buscar última marcación INGRESO_PLANTA (tipo 01) de un trabajador por código Y origen
     * Esta es la marcación "raíz" de donde se heredan turno y reckey_ref
     * 
     * OPTIMIZACIÓN: Usa índice en (codigo, flag_in_out, fec_registro)
     */
    @Query(value = "SELECT * FROM asistencia_ht580 " 
            + "WHERE codigo = :codigo " 
            + "AND cod_origen = :codOrigen " 
            + "AND flag_in_out not in ('3','4','5','6','7','8','9','10')" 
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
     * Obtener ÚLTIMOS movimientos de TODOS los trabajadores
     * Para proceso de auto-cierre masivo cada 30 minutos
     * ORDENADO POR FECHA DE REGISTRO (no fecha de movimiento)
     */
    @Query("SELECT a FROM AsistenciaHt580 a " +
           "WHERE a.fechaRegistro = (" +
           "    SELECT MAX(a2.fechaRegistro) FROM AsistenciaHt580 a2 " +
           "    WHERE a2.codigo = a.codigo" +
           ") " +
           "ORDER BY a.codigo ASC")
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
}
