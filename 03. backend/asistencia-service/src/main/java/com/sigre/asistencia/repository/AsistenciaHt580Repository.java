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
     * Buscar última asistencia de un trabajador por código (con Optional)
     * ORDENADO POR FECHA DE REGISTRO (no fecha de movimiento)
     */
    Optional<AsistenciaHt580> findTopByCodigoOrderByFechaRegistroDesc(String codigo);
    
    /**
     * Buscar asistencias en un rango de fechas
     */
    @Query("SELECT a FROM AsistenciaHt580 a " +
           "WHERE a.fechaMovimiento BETWEEN :fechaInicio AND :fechaFin " +
           "ORDER BY a.fechaMovimiento DESC")
    List<AsistenciaHt580> findAsistenciasByRangoFechas(@Param("fechaInicio") LocalDateTime fechaInicio,
                                                      @Param("fechaFin") LocalDateTime fechaFin);
    
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
     */
    @Query("SELECT EXTRACT(HOUR FROM a.fechaMovimiento) as hora, COUNT(a) as cantidad " +
           "FROM AsistenciaHt580 a " +
           "WHERE DATE(a.fechaMovimiento) = CURRENT_DATE " +
           "GROUP BY EXTRACT(HOUR FROM a.fechaMovimiento) " +
           "ORDER BY hora")
    List<Object[]> countMarcajesPorHoraHoy();
    
    /**
     * Obtener marcajes del día actual con información detallada para verificación
     */
    @Query("SELECT " +
           "DATE(a.fechaMovimiento) as fecha, " +
           "EXTRACT(HOUR FROM a.fechaMovimiento) as hora, " +
           "COUNT(a) as cantidad, " +
           "MIN(a.fechaMovimiento) as primerMarcaje, " +
           "MAX(a.fechaMovimiento) as ultimoMarcaje " +
           "FROM AsistenciaHt580 a " +
           "WHERE DATE(a.fechaMovimiento) = CURRENT_DATE " +
           "GROUP BY DATE(a.fechaMovimiento), EXTRACT(HOUR FROM a.fechaMovimiento) " +
           "ORDER BY hora")
    List<Object[]> countMarcajesDetalladosHoy();
    
    /**
     * Obtener marcajes agrupados por hora de las últimas 24 horas
     * CORREGIDO: Distingue entre horas del día actual vs día anterior
     */
    @Query("SELECT " +
           "CASE " +
           "    WHEN DATE(a.fechaMovimiento) = CURRENT_DATE THEN EXTRACT(HOUR FROM a.fechaMovimiento) " +
           "    ELSE -(EXTRACT(HOUR FROM a.fechaMovimiento)) " +
           "END as horaConFecha, " +
           "COUNT(a) as cantidad, " +
           "DATE(a.fechaMovimiento) as fecha " +
           "FROM AsistenciaHt580 a " +
           "WHERE a.fechaMovimiento >= :fechaInicio " +
           "GROUP BY DATE(a.fechaMovimiento), EXTRACT(HOUR FROM a.fechaMovimiento) " +
           "ORDER BY DATE(a.fechaMovimiento), EXTRACT(HOUR FROM a.fechaMovimiento)")
    List<Object[]> countMarcajesPorHoraUltimas24h(@Param("fechaInicio") LocalDateTime fechaInicio);
    
    /**
     * Obtener marcajes de las últimas 24 horas con información detallada por fecha y hora
     */
    @Query("SELECT " +
           "DATE(a.fechaMovimiento) as fecha, " +
           "EXTRACT(HOUR FROM a.fechaMovimiento) as hora, " +
           "COUNT(a) as cantidad " +
           "FROM AsistenciaHt580 a " +
           "WHERE a.fechaMovimiento >= :fechaInicio " +
           "GROUP BY DATE(a.fechaMovimiento), EXTRACT(HOUR FROM a.fechaMovimiento) " +
           "ORDER BY DATE(a.fechaMovimiento), EXTRACT(HOUR FROM a.fechaMovimiento)")
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
}
