package com.sigre.comercializacion.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.Instant;
import java.util.List;

@Data
public class ComandaCabeceraRequest {

    private Long sucursalId;

    private Long puntoVentaId;

    private Long turnoId;

    private Long clienteId;

    private String mesa;

    private Instant fechaHora;

    @NotNull
    @NotEmpty
    @Valid
    private List<ComandaItemRequest> items;
}
