package pe.restaurant.activos.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SiguienteCodigoResponse {
    private String tipo;
    private String codigo;
    private Long secuencia;
}
