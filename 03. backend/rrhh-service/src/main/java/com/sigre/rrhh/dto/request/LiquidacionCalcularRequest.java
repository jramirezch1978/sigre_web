package com.sigre.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

/**
 * Request para calcular la liquidación de beneficios sociales de un trabajador.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LiquidacionCalcularRequest {

    @NotNull(message = "Debe seleccionar un trabajador.")
    private Long trabajadorId;

    private LocalDate fechaCese;
}
