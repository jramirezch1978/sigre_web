package com.sigre.seguridad.dto.seguridad;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class GrupoUsuarioRequest {

    @NotBlank
    @Size(max = 80)
    private String codigo;

    @NotBlank
    @Size(max = 220)
    private String descripcion;

    private Boolean activo = Boolean.TRUE;
}
