package com.sigre.compras.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
public class OrdenCompraRecepcionRequest {

    @NotNull
    private Long articuloMovTipoId;

    @NotNull
    private Long almacenId;

    private LocalDate fechaMov;

    private String observaciones;
}
