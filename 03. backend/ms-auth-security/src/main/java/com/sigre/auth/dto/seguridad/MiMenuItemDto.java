package com.sigre.auth.dto.seguridad;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MiMenuItemDto {
    /** ROL: vía asignación rol-opción; LIBRE: {@code usuario_opcion_menu}. */
    private String origen;
    private OpcionMenuDto opcionMenu;
    /** Acciones permitidas según {@code rol_opcion_menu_accion} (vacío si solo acceso LIBRE sin granularidad). */
    private List<RolOpcionAccionDto> acciones;
}
