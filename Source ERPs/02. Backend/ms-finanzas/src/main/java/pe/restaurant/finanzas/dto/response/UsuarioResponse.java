package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UsuarioResponse {
    private Long id;
    private String username;
    private String email;
    private String nombres;
    private String apellidos;
    private String flagEstado;  // "1" = activo, "0" = inactivo
}
