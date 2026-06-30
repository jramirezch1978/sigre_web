package com.sigre.core.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class LineaCreditoRequest {

    private Long monedaId;

    @NotNull
    @PositiveOrZero
    private BigDecimal limiteCredito;

    @NotNull
    @PositiveOrZero
    private Integer diasCredito;
}
