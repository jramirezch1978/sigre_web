package com.sigre.comercializacion.client.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * DTO para transferir datos de Solicitud de Giro desde finanzas-service.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SolicitudGiroDTO {
    private Long id;
    private String numero;
    private LocalDate fecha;
    private Long solicitanteId;
    private BigDecimal monto;
    private String motivo;
    private String tipoSolicitud;
}
