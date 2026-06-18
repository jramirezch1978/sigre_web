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
public class UsuariosConectadosItemDto {
    private Long empresaId;
    private String razonSocial;
    /** Usuarios distintos con sesión JWT activa (tokens_session). */
    private long usuariosConectados;
}
