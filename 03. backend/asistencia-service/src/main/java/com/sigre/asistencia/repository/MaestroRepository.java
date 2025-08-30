package com.sigre.asistencia.repository;

import com.sigre.asistencia.entity.Maestro;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface MaestroRepository extends JpaRepository<Maestro, String> {
    
    /**
     * Buscar trabajador por DNI
     */
    Optional<Maestro> findByDniAndFlagEstado(String dni, String flagEstado);
    
    /**
     * Buscar trabajador por código de trabajador y que esté activo
     */
    Optional<Maestro> findByCodTrabajadorAndFlagEstado(String codTrabajador, String flagEstado);
    
    /**
     * Buscar trabajador por código de trabajador, DNI o código de tarjeta asignada vigente
     */
    @Query("SELECT m FROM Maestro m " +
           "LEFT JOIN RrhhAsignaTrjtReloj r ON m.codTrabajador = r.codTrabajador " +
           "WHERE m.flagEstado = '1' " +
           "AND (m.codTrabajador = :codigo " +
           "     OR m.dni = :codigo " +
           "     OR (r.codTarjeta = :codigo AND r.flagEstado = '1' " +
           "         AND (r.fechaInicio IS NULL OR r.fechaInicio <= CURRENT_DATE) " +
           "         AND (r.fechaFin IS NULL OR r.fechaFin >= CURRENT_DATE)))")
    Optional<Maestro> findTrabajadorByCodigoOrDniOrTarjeta(@Param("codigo") String codigo);
    
    /**
     * Verificar si existe un trabajador activo por código
     */
    boolean existsByCodTrabajadorAndFlagEstado(String codTrabajador, String flagEstado);
    
    /**
     * Verificar si existe un trabajador activo por DNI
     */
    boolean existsByDniAndFlagEstado(String dni, String flagEstado);
}
