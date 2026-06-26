package pe.restaurant.auth.dto.seguridad;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UsuarioOpcionLibreRequest {

    @NotNull
    private Long opcionMenuId;

    private Boolean habilitado = Boolean.TRUE;

    private Boolean activo = Boolean.TRUE;
}
