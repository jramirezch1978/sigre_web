package com.sigre.comercializacion.dto.request;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class ComandaItemRequest {

    @NotNull
    private Long articuloId;

    @NotNull
    @DecimalMin(value = "0.0001", inclusive = true)
    private BigDecimal cantidad;

    @NotNull
    @DecimalMin(value = "0", inclusive = true)
    private BigDecimal precioUnitario;

    private String observacion;
}
