package com.sigre.auth.dto.seguridad;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RolOpcionAccionDto {
    private Long id;
    private Long rolOpcionMenuId;
    private Long accionId;
    private AccionDto accion;
    private Boolean permitido;
    private Boolean activo;
}
