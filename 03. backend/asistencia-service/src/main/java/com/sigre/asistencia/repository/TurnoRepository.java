package com.sigre.asistencia.repository;

import com.sigre.asistencia.entity.Turno;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface TurnoRepository extends JpaRepository<Turno, String> {
    
    /**
     * Buscar turnos activos
     */
    List<Turno> findByFlagEstadoOrderByTurno(String flagEstado);
    
    /**
     * Buscar turno por hora actual (día normal)
     * Compara solo la hora, no la fecha completa
     */
    @Query(value = "SELECT * FROM turno WHERE " +
            "flag_estado = '1' AND " +
            "EXTRACT(HOUR FROM hora_inicio_norm) <= :hora AND " +
            "EXTRACT(HOUR FROM hora_final_norm) > :hora " +
            "ORDER BY turno LIMIT 1", 
            nativeQuery = true)
    Optional<Turno> findTurnoPorHora(@Param("hora") int hora);
    
    /**
     * Obtener turno por defecto (el primero activo)
     */
    @Query("SELECT t FROM Turno t WHERE t.flagEstado = '1' ORDER BY t.turno")
    Optional<Turno> findTurnoPorDefecto();
    
    /**
     * Buscar turno por tipo
     */
    Optional<Turno> findByTipoTurnoAndFlagEstado(String tipoTurno, String flagEstado);
}
