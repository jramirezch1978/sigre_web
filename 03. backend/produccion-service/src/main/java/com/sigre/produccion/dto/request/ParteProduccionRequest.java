package com.sigre.produccion.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ParteProduccionRequest {

    @NotNull(message = "La orden de trabajo es requerida")
    private Long ordenTrabajoId;

    @NotNull(message = "La fecha es requerida")
    private LocalDate fecha;

    private Long turnoId;

    @Valid
    private List<ParteInsumoRequest> insumos;

    @Valid
    private List<ParteProducidoRequest> producidos;
}
