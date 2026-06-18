package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CondicionPagoResponse {
    private Long id;
    private String codigo;
    private String nombre;
    private Integer diasPlazo;
    private String flagEstado;
}
