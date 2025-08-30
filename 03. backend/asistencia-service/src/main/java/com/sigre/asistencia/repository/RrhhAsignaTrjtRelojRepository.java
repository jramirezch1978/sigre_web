package com.sigre.asistencia.repository;

import com.sigre.asistencia.entity.RrhhAsignaTrjtReloj;
import com.sigre.asistencia.entity.RrhhAsignaTrjtRelojId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface RrhhAsignaTrjtRelojRepository extends JpaRepository<RrhhAsignaTrjtReloj, RrhhAsignaTrjtRelojId> {
    
    /**
     * Buscar asignación de tarjeta vigente por código de tarjeta
     */
    @Query("SELECT r FROM RrhhAsignaTrjtReloj r " +
           "WHERE r.codTarjeta = :codTarjeta " +
           "AND r.flagEstado = '1' " +
           "AND (r.fechaInicio IS NULL OR r.fechaInicio <= :fecha) " +
           "AND (r.fechaFin IS NULL OR r.fechaFin >= :fecha)")
    Optional<RrhhAsignaTrjtReloj> findTarjetaVigente(@Param("codTarjeta") String codTarjeta, 
                                                     @Param("fecha") LocalDate fecha);
    
    /**
     * Buscar todas las tarjetas asignadas a un trabajador
     */
    List<RrhhAsignaTrjtReloj> findByCodTrabajadorAndFlagEstado(String codTrabajador, String flagEstado);
    
    /**
     * Buscar tarjetas vigentes de un trabajador
     */
    @Query("SELECT r FROM RrhhAsignaTrjtReloj r " +
           "WHERE r.codTrabajador = :codTrabajador " +
           "AND r.flagEstado = '1' " +
           "AND (r.fechaInicio IS NULL OR r.fechaInicio <= :fecha) " +
           "AND (r.fechaFin IS NULL OR r.fechaFin >= :fecha)")
    List<RrhhAsignaTrjtReloj> findTarjetasVigentesByTrabajador(@Param("codTrabajador") String codTrabajador, 
                                                              @Param("fecha") LocalDate fecha);
    
    /**
     * Verificar si un código de tarjeta existe y está vigente
     */
    @Query("SELECT COUNT(r) > 0 FROM RrhhAsignaTrjtReloj r " +
           "WHERE r.codTarjeta = :codTarjeta " +
           "AND r.flagEstado = '1' " +
           "AND (r.fechaInicio IS NULL OR r.fechaInicio <= :fecha) " +
           "AND (r.fechaFin IS NULL OR r.fechaFin >= :fecha)")
    boolean existsTarjetaVigente(@Param("codTarjeta") String codTarjeta, @Param("fecha") LocalDate fecha);
    
    /**
     * Buscar la tarjeta activa actual de un trabajador
     */
    @Query("SELECT r FROM RrhhAsignaTrjtReloj r " +
           "WHERE r.codTrabajador = :codTrabajador " +
           "AND r.flagEstado = '1' " +
           "AND (r.fechaInicio IS NULL OR r.fechaInicio <= :fecha) " +
           "AND (r.fechaFin IS NULL OR r.fechaFin >= :fecha)")
    Optional<RrhhAsignaTrjtReloj> findTarjetaActivaByTrabajador(@Param("codTrabajador") String codTrabajador, 
                                                               @Param("fecha") LocalDate fecha);
    
    /**
     * Contar cuántas tarjetas activas tiene un trabajador (debería ser máximo 1)
     */
    @Query("SELECT COUNT(r) FROM RrhhAsignaTrjtReloj r " +
           "WHERE r.codTrabajador = :codTrabajador " +
           "AND r.flagEstado = '1' " +
           "AND (r.fechaInicio IS NULL OR r.fechaInicio <= :fecha) " +
           "AND (r.fechaFin IS NULL OR r.fechaFin >= :fecha)")
    Long countTarjetasActivasByTrabajador(@Param("codTrabajador") String codTrabajador, @Param("fecha") LocalDate fecha);
    
    /**
     * Verificar si un trabajador tiene más de una tarjeta activa (violación de regla de negocio)
     */
    @Query("SELECT COUNT(r) > 1 FROM RrhhAsignaTrjtReloj r " +
           "WHERE r.codTrabajador = :codTrabajador " +
           "AND r.flagEstado = '1' " +
           "AND (r.fechaInicio IS NULL OR r.fechaInicio <= :fecha) " +
           "AND (r.fechaFin IS NULL OR r.fechaFin >= :fecha)")
    boolean tieneMultiplesTarjetasActivas(@Param("codTrabajador") String codTrabajador, @Param("fecha") LocalDate fecha);
    
    /**
     * Buscar todas las tarjetas históricas de un trabajador (activas e inactivas)
     */
    @Query("SELECT r FROM RrhhAsignaTrjtReloj r " +
           "WHERE r.codTrabajador = :codTrabajador " +
           "ORDER BY r.fechaInicio DESC, r.flagEstado DESC")
    List<RrhhAsignaTrjtReloj> findHistorialTarjetasByTrabajador(@Param("codTrabajador") String codTrabajador);
}
