package com.sigre.compras.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
public class ConformidadServicioDetRequest {

    @NotNull
    private Integer secuencia;

    private String descripcion;

    private BigDecimal cantidad;

    private BigDecimal precioUnitario;
}
