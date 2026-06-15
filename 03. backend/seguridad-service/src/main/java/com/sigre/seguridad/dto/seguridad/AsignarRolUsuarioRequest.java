package com.sigre.seguridad.dto.seguridad;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AsignarRolUsuarioRequest {

    @NotNull
    private Long rolId;

    private Boolean activo = Boolean.TRUE;
}
