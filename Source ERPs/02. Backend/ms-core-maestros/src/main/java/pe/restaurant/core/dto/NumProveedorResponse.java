package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class NumProveedorResponse {
    private Long id;
    private Long sucursalId;
    private String serie;
    private Integer anio;
    private Long ultimoNumero;
}
