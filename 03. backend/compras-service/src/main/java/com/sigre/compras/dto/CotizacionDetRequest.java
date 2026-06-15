package com.sigre.compras.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
public class CotizacionDetRequest {

    @NotNull
    private Long articuloId;

    @NotNull
    @DecimalMin("0.0001")
    private BigDecimal cantidad;

    @NotNull
    @DecimalMin("0.0001")
    private BigDecimal precioUnitario;

    private BigDecimal descuento;

    private Integer plazoEntregaDias;
}
