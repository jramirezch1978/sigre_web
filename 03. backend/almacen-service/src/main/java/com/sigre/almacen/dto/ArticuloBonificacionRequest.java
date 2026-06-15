package com.sigre.almacen.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ArticuloBonificacionRequest {

    @NotNull
    private Long articuloId;

    @NotNull
    @Positive
    private BigDecimal cantidadMinima;

    @NotNull
    @Positive
    private BigDecimal cantidadBonificacion;

    private LocalDate fechaInicio;

    private LocalDate fechaFin;
}
