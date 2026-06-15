package com.sigre.compras.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class SolicitudCompraRequest {

    private Long sucursalId;

    @NotNull
    private LocalDate fecha;

    private Long solicitanteId;

    private String prioridad;

    private String justificacion;

    @NotEmpty
    @Valid
    private List<SolicitudCompraDetRequest> lineas;
}
