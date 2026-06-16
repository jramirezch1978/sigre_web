package com.sigre.asistencia.repository;

import com.sigre.asistencia.entity.TicketAsistencia;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface TicketAsistenciaRepository extends JpaRepository<TicketAsistencia, String> {
    
    /**
     * Buscar tickets pendientes de procesamiento
     */
    List<TicketAsistencia> findByEstadoProcesamientoOrderByFechaCreacionAsc(String estadoProcesamiento);
    
    /**
     * Buscar tickets pendientes (para el procesador asíncrono)
     */
    @Query("SELECT t FROM TicketAsistencia t WHERE t.estadoProcesamiento = 'P' ORDER BY t.fechaCreacion ASC")
    List<TicketAsistencia> findTicketsPendientes();
    
    /**
     * Buscar tickets con error que necesitan reintento
     */
    @Query("SELECT t FROM TicketAsistencia t WHERE t.estadoProcesamiento = 'E' AND t.intentosProcesamiento < 3 ORDER BY t.fechaCreacion ASC")
    List<TicketAsistencia> findTicketsParaReintento();
    
    /**
     * Contar tickets pendientes
     */
    long countByEstadoProcesamiento(String estadoProcesamiento);
    
    /**
     * Buscar tickets por rango de fechas
     */
    @Query("SELECT t FROM TicketAsistencia t WHERE t.fechaCreacion BETWEEN :fechaInicio AND :fechaFin ORDER BY t.fechaCreacion DESC")
    List<TicketAsistencia> findByRangoFechas(LocalDateTime fechaInicio, LocalDateTime fechaFin);
    
    /**
     * Buscar tickets de hoy
     */
    @Query("SELECT t FROM TicketAsistencia t WHERE t.fechaCreacion >= :inicio AND t.fechaCreacion < :fin ORDER BY t.fechaCreacion DESC")
    List<TicketAsistencia> findTicketsEntre(@Param("inicio") LocalDateTime inicio, @Param("fin") LocalDateTime fin);

    default List<TicketAsistencia> findTicketsDeHoy() {
        LocalDate hoy = LocalDate.now();
        return findTicketsEntre(hoy.atStartOfDay(), hoy.plusDays(1).atStartOfDay());
    }
}
