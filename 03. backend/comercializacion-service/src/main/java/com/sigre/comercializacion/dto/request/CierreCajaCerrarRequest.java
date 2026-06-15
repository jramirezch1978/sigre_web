package com.sigre.comercializacion.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CierreCajaCerrarRequest {

    @NotNull
    private BigDecimal fondoFinal;

    private BigDecimal diferencia;
    private String observaciones;
}
