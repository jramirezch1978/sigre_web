package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SecuenciaDocumentoResponse {
    private Long id;
    private Long sucursalId;
    private String tipoDocumento;
    private String serie;
    private Integer anio;
    private Long ultimoNumero;
}
