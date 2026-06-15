package com.sigre.finanzas.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProgramacionPagoDetalleRequest {

    private Long cntasPagarId;

    @NotNull(message = "El monto programado es obligatorio")
    @Positive(message = "El monto programado debe ser mayor a cero")
    private BigDecimal montoProgramado;
}
