package com.sigre.compras.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ArticuloEstructuraRequest {

    @NotNull
    private Long articuloPadreId;

    @NotNull
    private Long articuloHijoId;

    @NotNull
    @Positive
    private BigDecimal cantidad;
}
