package com.sigre.seguridad.dto.seguridad;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RolOpcionAccionPermisoRequest {
    private Boolean permitido = Boolean.TRUE;
    private Boolean activo = Boolean.TRUE;
}
