package com.sigre.core.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ConversionUnidadRequest {
    private Long articuloId;
    @NotNull
    private Long umOrigenId;
    @NotNull
    private Long umDestinoId;
    @NotNull
    private BigDecimal factorConversion;
}
