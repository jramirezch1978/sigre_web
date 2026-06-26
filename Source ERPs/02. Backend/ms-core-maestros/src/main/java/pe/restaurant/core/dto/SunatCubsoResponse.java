package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SunatCubsoResponse {
    private Long id;
    private String codCubso;
    private String descripcion;
    private String codClase;
    private String flagEstado;
}
