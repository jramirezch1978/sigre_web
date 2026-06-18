package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MonedaResponse {
    private Long id;
    private String codigo;
    private String siglaMoneda;
    private String nombre;
    private String simbolo;
    private Integer decimales;
    private String flagEstado;
}
