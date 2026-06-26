package com.sigre.seguridad.dto.seguridad;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

public class AsignarMiembroGrupoRequest {

    @Getter
    @Setter
    @NotNull
    private Long usuarioId;

    @Getter
    @Setter
    private Boolean activo = Boolean.TRUE;
}
