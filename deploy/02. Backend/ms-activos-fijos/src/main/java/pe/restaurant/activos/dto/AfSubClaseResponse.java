package pe.restaurant.activos.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfSubClaseResponse {

    private Long id;
    private Long afClaseId;
    private String codigo;
    private String nombre;
    private Integer vidaUtilMeses;
    private String flagEstado;
}
