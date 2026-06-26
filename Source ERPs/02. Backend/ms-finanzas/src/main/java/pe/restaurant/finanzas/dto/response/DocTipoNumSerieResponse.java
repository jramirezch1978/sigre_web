package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class DocTipoNumSerieResponse {
    private Long id;
    private Long sucursalId;
    private Long docTipoId;
    private String serie;
    private Long ultimoNumero;
    private String flagEstado;
}
