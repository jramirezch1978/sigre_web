package com.sigre.almacen.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
public class GuiaLineaRequest {
    private Long id;
    private Long valeMovId;
    @NotNull
    private Long articuloId;
    @NotNull
    private Long unidadMedidaId;
    @NotNull
    private BigDecimal cantidad;
}
