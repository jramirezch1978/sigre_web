package com.sigre.asistencia.repository;

import com.sigre.asistencia.entity.RacionesSeleccionadas;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface RacionesSeleccionadasRepository extends JpaRepository<RacionesSeleccionadas, Long> {
    
    /**
     * Buscar raciones seleccionadas por trabajador en una fecha específica
     */
    List<RacionesSeleccionadas> findByCodTrabajadorAndFechaAndFlagEstado(String codTrabajador, 
                                                                        LocalDate fecha, 
                                                                        String flagEstado);
    
    /**
     * Verificar si un trabajador ya seleccionó una ración específica en una fecha
     */
    boolean existsByCodTrabajadorAndFechaAndTipoRacionAndFlagEstado(String codTrabajador, 
                                                                   LocalDate fecha, 
                                                                   String tipoRacion, 
                                                                   String flagEstado);
    
    /**
     * Buscar ración específica de un trabajador en una fecha
     */
    Optional<RacionesSeleccionadas> findByCodTrabajadorAndFechaAndTipoRacionAndFlagEstado(String codTrabajador, 
                                                                                         LocalDate fecha, 
                                                                                         String tipoRacion, 
                                                                                         String flagEstado);
    
    /**
     * Buscar todas las raciones de un trabajador en un rango de fechas
     */
    @Query("SELECT r FROM RacionesSeleccionadas r " +
           "WHERE r.codTrabajador = :codTrabajador " +
           "AND r.fecha BETWEEN :fechaInicio AND :fechaFin " +
           "AND r.flagEstado = '1' " +
           "ORDER BY r.fecha DESC, r.fechaRegistro DESC")
    List<RacionesSeleccionadas> findRacionesByTrabajadorAndRangoFechas(@Param("codTrabajador") String codTrabajador,
                                                                      @Param("fechaInicio") LocalDate fechaInicio,
                                                                      @Param("fechaFin") LocalDate fechaFin);
    
    /**
     * Contar raciones seleccionadas por tipo en una fecha específica
     */
    @Query("SELECT COUNT(r) FROM RacionesSeleccionadas r " +
           "WHERE r.fecha = :fecha " +
           "AND r.tipoRacion = :tipoRacion " +
           "AND r.flagEstado = '1'")
    Long countRacionesByFechaAndTipo(@Param("fecha") LocalDate fecha, @Param("tipoRacion") String tipoRacion);
    
    /**
     * Buscar raciones seleccionadas por fecha para reporte
     */
    @Query("SELECT r FROM RacionesSeleccionadas r " +
           "JOIN FETCH r.trabajador " +
           "WHERE r.fecha = :fecha " +
           "AND r.flagEstado = '1' " +
           "ORDER BY r.tipoRacion, r.trabajador.apellidoPaterno, r.trabajador.nombre1")
    List<RacionesSeleccionadas> findRacionesConTrabajadorByFecha(@Param("fecha") LocalDate fecha);
    
    /**
     * Obtener tipos de ración seleccionados por un trabajador en una fecha
     */
    @Query("SELECT r.tipoRacion FROM RacionesSeleccionadas r " +
           "WHERE r.codTrabajador = :codTrabajador " +
           "AND r.fecha = :fecha " +
           "AND r.flagEstado = '1'")
    List<String> findTiposRacionByTrabajadorAndFecha(@Param("codTrabajador") String codTrabajador, 
                                                    @Param("fecha") LocalDate fecha);
}
