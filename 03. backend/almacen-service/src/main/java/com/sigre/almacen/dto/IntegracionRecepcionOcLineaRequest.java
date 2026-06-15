package com.sigre.almacen.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * Cantidad explícita a recepcionar por línea de OC (recepción parcial controlada).
 */
@Getter
@Setter
@NoArgsConstructor
public class IntegracionRecepcionOcLineaRequest {

    @NotNull
    private Long ocDetId;

    /** Cantidad a ingresar en esta línea (≤ pendiente = proyectada − procesada). */
    @NotNull
    @Positive
    private BigDecimal cantidad;
}
