package com.sigre.almacen.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
public class DevolucionLineaRequest {

    @NotNull
    private Long articuloId;

    @NotNull
    @Positive
    private BigDecimal cantDevolver;

    private Long ubicacionAlmacenId;
    private Long centrosCostoId;
}
