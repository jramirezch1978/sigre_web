package com.sigre.auth.dto.seguridad;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RolRequest {

    @NotBlank
    @Size(max = 40)
    private String codigo;

    @NotBlank
    @Size(max = 120)
    private String nombre;

    private Boolean esAdmin = Boolean.FALSE;

    private Boolean activo = Boolean.TRUE;
}
