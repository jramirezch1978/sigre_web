package pe.restaurant.activos.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfAseguradoraResponse {

    private Long id;
    private String nombre;
    private String ruc;
    private String contacto;
    private String flagEstado;
}
