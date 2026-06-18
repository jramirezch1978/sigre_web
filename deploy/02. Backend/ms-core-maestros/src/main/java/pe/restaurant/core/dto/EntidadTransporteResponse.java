package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class EntidadTransporteResponse {
    private Long id;
    private Long entidadContribuyenteId;
    private String placa;
    private String licencia;
    private String mtc;
    private String chofer;
    private String flagEstado;
}
