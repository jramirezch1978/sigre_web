package com.sigre.almacen.dto;

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
public class OrdenTrasladoRequest {
    @NotNull
    private Long almacenOrigenId;
    @NotNull
    private Long almacenDestinoId;
    @NotNull
    private LocalDate fecha;
    private String observacion;
    @NotEmpty
    @Valid
    private List<OrdenTrasladoLineaRequest> lineas;
}
