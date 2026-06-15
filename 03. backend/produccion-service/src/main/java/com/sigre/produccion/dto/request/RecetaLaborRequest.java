package com.sigre.produccion.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RecetaLaborRequest {

    @NotNull(message = "La labor es requerida")
    private Long laborId;

    @NotNull(message = "La secuencia es requerida")
    private Integer secuencia;

    private String descripcionPaso;
}
