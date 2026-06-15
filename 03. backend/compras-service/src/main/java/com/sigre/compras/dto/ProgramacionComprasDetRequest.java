package com.sigre.compras.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProgramacionComprasDetRequest {

    @NotNull
    private Long articuloId;

    @NotNull
    private BigDecimal cantidad;

    private BigDecimal precioEstimado;
}
