package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class GrupoTipoDocDetResponse {
    private Long id;
    private Long grupoTipoDocId;
    private Long docTipoId;
    private String flagEstado;
}
