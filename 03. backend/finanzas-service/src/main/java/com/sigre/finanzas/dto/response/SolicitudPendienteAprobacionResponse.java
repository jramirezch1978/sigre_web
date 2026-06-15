package com.sigre.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SolicitudPendienteAprobacionResponse {

    private Long id;

    private Long solicitanteId;

    private String numero;

    private LocalDate fecha;

    private BigDecimal monto;

    private String motivo;

    private String flagEstado;

    private Long createdBy;

    private Instant fecCreacion;

    private Long updatedBy;

    private Instant fecModificacion;
}
