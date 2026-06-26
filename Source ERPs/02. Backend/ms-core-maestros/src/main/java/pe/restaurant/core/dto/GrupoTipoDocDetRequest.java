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
public class GrupoTipoDocDetRequest {

    @NotNull
    private Long grupoTipoDocId;

    @NotNull
    private Long docTipoId;

    private String flagEstado = "1";
}
