package com.sigre.finanzas.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DetraccionItemRequest {

    @NotNull(message = "El porcentaje de detracción es obligatorio")
    private BigDecimal porcentaje;

    @NotNull(message = "El monto mínimo de detracción es obligatorio")
    private BigDecimal montoMinimo;

    private String codigoServicio;
}
