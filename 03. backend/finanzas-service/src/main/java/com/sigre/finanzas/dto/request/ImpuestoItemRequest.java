package com.sigre.finanzas.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
public class ImpuestoItemRequest {

    @NotNull(message = "El ID del tipo de impuesto es obligatorio")
    private Long tipoImpuestoId;

    private Integer tipoCalculo; // null = resolved by backend, defaults to 1

    // Resolved by backend from ms-core-maestros
    private BigDecimal tasa;
    private Boolean esFiscalizado;
    private String nombre;

    public ImpuestoItemRequest(Long tipoImpuestoId, Integer tipoCalculo) {
        this.tipoImpuestoId = tipoImpuestoId;
        this.tipoCalculo = tipoCalculo;
    }
}
