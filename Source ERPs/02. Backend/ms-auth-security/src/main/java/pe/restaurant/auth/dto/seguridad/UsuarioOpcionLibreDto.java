package pe.restaurant.auth.dto.seguridad;

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
public class UsuarioOpcionLibreDto {
    private Long id;
    private Long usuarioId;
    private Long empresaId;
    private Long opcionMenuId;
    private OpcionMenuDto opcionMenu;
    private Boolean habilitado;
    private Boolean activo;
}
