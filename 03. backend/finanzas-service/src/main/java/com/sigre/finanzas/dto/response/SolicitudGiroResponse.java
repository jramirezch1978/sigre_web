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
public class SolicitudGiroResponse {

    private Long id;

    private Long sucursalId;

    private Long solicitanteId;

    private String numero;

    private LocalDate fecha;

    private BigDecimal monto;

    private String motivo;

    /** O = Orden de Giro, F = Fondo Fijo. */
    private String tipoSolicitud;

    private Long centrosCostoId;

    private Long aprobadorId;

    private Instant fecAprobacion;

    private Instant fecRechazo;

    private String motivoRechazo;

    private String motivoDevolucion;

    private Long aprobadorDevolucionId;

    private Instant fecAprobacionDevolucion;

    private Instant fecRechazoDevolucion;

    private String motivoRechazoDevolucion;

    private String flagEstadoDevolucion;

    private String flagEstado;

    private Long createdBy;

    private Instant fecCreacion;

    private Long updatedBy;

    private Instant fecModificacion;
}
