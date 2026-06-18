package pe.restaurant.produccion.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecetaLaborResponse {

    private Long id;
    private Long laborId;
    private String laborCodigo;
    private String laborNombre;
    private Integer secuencia;
    private String descripcionPaso;
}
