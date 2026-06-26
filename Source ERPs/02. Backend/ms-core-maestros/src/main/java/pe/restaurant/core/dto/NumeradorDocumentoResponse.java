package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class NumeradorDocumentoResponse {
    private String nombreTabla;
    private Long sucursalId;
    private Short ano;
    private Long ultNro;
    private String flagEstado;
}
