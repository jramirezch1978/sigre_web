package pe.restaurant.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MotivoTrasladoResponse {

    private Long id;
    private String codigo;
    private String nombre;
    private String flagEstado;
}
