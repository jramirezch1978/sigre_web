package com.sigre.rrhh.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class TipoSancionCreateRequest {

    @NotBlank @Size(max = 30)
    private String codigo;

    @NotBlank @Size(max = 120)
    private String nombre;
}
