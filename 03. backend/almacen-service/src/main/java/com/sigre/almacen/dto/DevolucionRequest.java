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
public class DevolucionRequest {

    @NotNull
    private Long valeMovOrigenId;

    @NotNull
    private Long sucursalId;

    @NotNull
    private LocalDate fechaMov;

    private String observaciones;

    @NotEmpty
    @Valid
    private List<DevolucionLineaRequest> lineas;
}
