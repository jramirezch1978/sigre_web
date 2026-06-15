package com.sigre.finanzas.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AsientoDetalleRequest {

    @NotNull(message = "La cuenta contable es requerida")
    private Long planContableDetId;

    private Long entidadContribuyenteId;

    @PositiveOrZero(message = "El debe debe ser mayor o igual a 0")
    private BigDecimal debe = BigDecimal.ZERO;

    @PositiveOrZero(message = "El haber debe ser mayor o igual a 0")
    private BigDecimal haber = BigDecimal.ZERO;
}
