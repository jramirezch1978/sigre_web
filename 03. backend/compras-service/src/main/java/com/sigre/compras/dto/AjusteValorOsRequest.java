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
public class AjusteValorOsRequest {

    @NotNull
    private Long lineaId;

    @NotNull
    @DecimalMin("0.0001")
    private BigDecimal nuevoImporte;

    private String motivo;
}
