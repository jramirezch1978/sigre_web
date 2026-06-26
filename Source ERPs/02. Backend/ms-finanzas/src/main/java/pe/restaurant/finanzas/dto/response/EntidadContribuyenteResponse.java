package pe.restaurant.finanzas.dto.response;

import com.fasterxml.jackson.annotation.JsonAlias;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EntidadContribuyenteResponse {

    private Long id;

    // ms-core-maestros envía el RUC/DNI como "nroDocumento"; se acepta ese alias para no perder el valor.
    @JsonAlias("nroDocumento")
    private String numeroDocumento;
    
    private String razonSocial;
    
    private String nombreComercial;
    
    private String tipoDocumento;
    
    private String flagEstado;
}
