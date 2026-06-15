package com.sigre.compras.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class OrdenServicioMotivoRequest {

    @NotBlank
    private String motivo;
}
