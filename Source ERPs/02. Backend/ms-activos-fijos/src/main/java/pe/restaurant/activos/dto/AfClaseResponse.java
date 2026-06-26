package pe.restaurant.activos.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AfClaseResponse {
    private Long id;
    private String codigo;
    private String nombre;
    private String metodoDepreciacion;
    private Integer vidaUtilMeses;
    private String flagEstado;
}
