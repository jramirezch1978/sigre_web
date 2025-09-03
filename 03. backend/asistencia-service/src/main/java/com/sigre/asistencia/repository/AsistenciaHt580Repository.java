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
}
