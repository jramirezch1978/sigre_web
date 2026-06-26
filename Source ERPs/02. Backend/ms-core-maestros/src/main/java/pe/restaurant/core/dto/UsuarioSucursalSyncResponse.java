package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UsuarioSucursalSyncResponse {

    private Long usuarioId;
    private String username;
    private Long empresaId;
    private String empresaCodigo;
    private Long sucursalId;
    private String flagEstado;
    private String mensaje;
}
