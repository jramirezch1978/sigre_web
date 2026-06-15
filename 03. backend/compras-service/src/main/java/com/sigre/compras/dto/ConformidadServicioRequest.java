package com.sigre.compras.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class ConformidadServicioRequest {

    @NotNull
    private Long ordenServicioId;

    @NotNull
    private LocalDate fecha;

    private String observacion;

    @Valid
    @NotNull
    private List<ConformidadServicioDetRequest> lineas;
}
