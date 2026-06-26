package pe.restaurant.contabilidad.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CntblLibroResponse {

    private Long id;
    private String codigo;
    private String nombre;
    private String flagEstado;
}
