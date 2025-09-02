package com.sigre.asistencia.repository;

import com.sigre.asistencia.entity.TicketRacionGenerada;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TicketRacionGeneradaRepository extends JpaRepository<TicketRacionGenerada, Long> {
    
    /**
     * Buscar todas las asociaciones de un ticket específico
     */
    List<TicketRacionGenerada> findByNumeroTicket(String numeroTicket);
    
    /**
     * Buscar todas las asociaciones de una ración específica
     */
    List<TicketRacionGenerada> findByRacionComedorId(Long racionComedorId);
    
    /**
     * Contar cuántas raciones generó un ticket
     */
    long countByNumeroTicket(String numeroTicket);
    
    /**
     * Eliminar todas las asociaciones de un ticket (útil para limpieza)
     */
    void deleteByNumeroTicket(String numeroTicket);
    
    /**
     * Obtener los IDs de raciones generadas por un ticket (para compatibilidad)
     */
    @Query("SELECT tr.racionComedorId FROM TicketRacionGenerada tr WHERE tr.numeroTicket = :numeroTicket")
    List<Long> findRacionIdsByNumeroTicket(@Param("numeroTicket") String numeroTicket);
}
