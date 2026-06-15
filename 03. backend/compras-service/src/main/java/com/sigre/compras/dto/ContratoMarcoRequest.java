package com.sigre.compras.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
public class ContratoMarcoRequest {

    @NotNull
    private Long proveedorId;

    @NotNull
    private LocalDate fechaInicio;

    private LocalDate fechaFin;

    private String condiciones;
}
