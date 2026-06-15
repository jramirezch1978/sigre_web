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
public class RolOpcionMenuDto {
    private Long id;
    private Long rolId;
    private Long opcionMenuId;
    private OpcionMenuDto opcionMenu;
    private Boolean activo;
}
