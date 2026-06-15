package com.sigre.comercializacion.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class ComandaEstadoRequest {

    @NotBlank
    private String flagEstado;
}
