package com.sigre.comercializacion.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PropinaRequest {

    @NotNull
    private Long fsFacturaSimplId;

    private Long trabajadorId;

    @NotNull
    @Positive(message = "monto debe ser mayor a 0")
    private BigDecimal monto;

    @NotNull
    private LocalDate fecha;
}
