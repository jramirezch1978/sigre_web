package pe.restaurant.activos.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfUbicacionResponse {

    private Long id;
    private Long sucursalId;
    private String codigo;
    private String nombre;
    private String flagEstado;
}
