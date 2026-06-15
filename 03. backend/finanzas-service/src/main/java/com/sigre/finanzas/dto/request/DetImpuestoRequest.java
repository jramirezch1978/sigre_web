package com.sigre.finanzas.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DetImpuestoRequest {

    @NotNull(message = "El tipo de impuesto es obligatorio")
    private Long tiposImpuestoId;

    @NotNull(message = "El importe del impuesto es obligatorio")
    private BigDecimal importe;
}
