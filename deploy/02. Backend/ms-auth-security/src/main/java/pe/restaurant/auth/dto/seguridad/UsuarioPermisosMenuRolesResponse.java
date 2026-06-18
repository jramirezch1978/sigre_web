package pe.restaurant.auth.dto.seguridad;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

/**
 * Permisos efectivos solo vía asignación usuario–rol: roles activos y unión de opciones de menú
 * con acciones fusionadas cuando el usuario tiene varios roles ({@code auth.rol_opcion_menu} /
 * {@code auth.rol_opcion_menu_accion}).
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UsuarioPermisosMenuRolesResponse {
    private Long empresaId;
    private Long usuarioId;
    /** Roles activos del usuario en la empresa (asignación y rol activos). */
    private List<RolDto> roles;
    /** Opciones de menú alcanzadas por cualquiera de esos roles, con acciones fusionadas por opción. */
    private List<MiMenuItemDto> opcionesMenu;
}
