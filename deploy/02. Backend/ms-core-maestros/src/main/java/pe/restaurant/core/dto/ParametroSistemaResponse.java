package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ParametroSistemaResponse {
    private Long id;
    private String codigo;
    private String nombre;
    private String modulo;
    private String valor;
    private String tipoDato;
    private String flagEstado;
}
