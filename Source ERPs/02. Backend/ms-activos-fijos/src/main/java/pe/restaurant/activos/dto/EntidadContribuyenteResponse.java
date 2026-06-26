package pe.restaurant.activos.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EntidadContribuyenteResponse {
    private Long id;
    private String numeroDocumento;
    private String razonSocial;
    private String nombreComercial;
    private String flagEstado;
}
