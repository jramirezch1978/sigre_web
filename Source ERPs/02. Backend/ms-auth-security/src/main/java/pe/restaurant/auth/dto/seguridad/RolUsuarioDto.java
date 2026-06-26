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
public class RolUsuarioDto {
    private Long id;
    private Long usuarioId;
    private Long rolId;
    private RolDto rol;
    private Boolean activo;
}
