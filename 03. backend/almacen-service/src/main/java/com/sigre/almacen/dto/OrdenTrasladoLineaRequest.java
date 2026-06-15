package com.sigre.almacen.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
public class OrdenTrasladoLineaRequest {
    private Long id;
    @NotNull
    private Long articuloId;
    @NotNull
    private BigDecimal cantidad;
}
