package com.sigre.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConformidadServicioDetalleResponse {

    private Long id;
    private Long ordenServicioId;
    private LocalDate fecha;
    private String observacion;
    private Boolean aprobado;
    private String flagEstado;
    private List<ConformidadServicioDetResponse> lineas;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private OffsetDateTime fecModificacion;
}
