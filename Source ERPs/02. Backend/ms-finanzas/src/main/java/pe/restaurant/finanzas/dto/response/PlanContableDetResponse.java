package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PlanContableDetResponse {
    
    private Long id;
    
    private String cntaCtbl;
    
    private String nombre;
    
    private String tipo;
    
    private String naturaleza;
    
    private String flagEstado;
}
