package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class DocTipoUsuarioResponse {
    private Long id;
    private Long usuarioId;
    private Long docTipoId;
    private Long sucursalId;
    private String flagEstado;
}
