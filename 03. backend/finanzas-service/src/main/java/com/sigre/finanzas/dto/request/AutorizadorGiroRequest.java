package com.sigre.finanzas.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AutorizadorGiroRequest {

    @NotNull(message = "El centro de costo es obligatorio")
    private Long centrosCostoId;

    private Boolean activo = true;
}
