package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DocTipoResponse {
    
    private Long id;
    
    private String codigo;
    
    private String nombre;

    private String flagSigno;
    
    private String flagEstado;
}
