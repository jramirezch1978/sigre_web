package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class DocTipoNumResponse {
    private Long id;
    private Long sucursalId;
    private Long docTipoId;
    private Long origenId;
    private Integer anio;
    private Long ultimoNumero;
    private String flagEstado;
}
