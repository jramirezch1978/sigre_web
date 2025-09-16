package com.sigre.asistencia.dto.dashboard;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * DTO para estadísticas generales del dashboard
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EstadisticasGeneralesDto {
    
    private Long totalRegistrosHoy;
    private Long totalRegistrosDbLocal;
    private Long totalRegistrosDbRemoto;
    private Long ticketsPendientes;
    private Long ticketsProcessed;
    private Long ticketsError;
    private LocalDateTime ultimaActualizacion;
    private String estadoSincronizacion;
}
