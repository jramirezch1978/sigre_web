package pe.restaurant.auth.dto.seguridad;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ModuloRequest {

    @NotBlank
    @Size(max = 40)
    private String codigo;

    @NotBlank
    @Size(max = 120)
    private String nombre;

    private Boolean activo = Boolean.TRUE;
}
