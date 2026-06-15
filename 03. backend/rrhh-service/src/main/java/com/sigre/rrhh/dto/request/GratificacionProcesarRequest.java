package com.sigre.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class GratificacionProcesarRequest {

    @NotNull(message = "El año es obligatorio.")
    private Integer anio;

    @NotNull(message = "El período de gratificación es obligatorio.")
    private Long periodoGratificacionId;
}
