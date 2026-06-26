package pe.restaurant.core.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class DocTipoUsuarioRequest {

    @NotNull
    private Long usuarioId;

    @NotNull
    private Long docTipoId;

    private Long sucursalId;

    private String flagEstado = "1";
}
