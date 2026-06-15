package com.sigre.core.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.*;
import java.math.BigDecimal;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class ArticuloEquivalenciaRequest {
    @NotNull
    private Long articuloId;

    @NotNull
    private Long articuloEquivalenteId;

    @NotNull
    @Positive(message = "El factor debe ser mayor a 0")
    private BigDecimal factor = BigDecimal.ONE;
}
