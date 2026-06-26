package pe.restaurant.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class IncotermResponse {
    private Long id;
    private String codigo;
    private String descripcion;
    private String flagEstado;
}
