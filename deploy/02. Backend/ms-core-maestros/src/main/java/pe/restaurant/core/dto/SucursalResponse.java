package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SucursalResponse {
    private Long id;
    private String codigo;
    private String nombre;
    private String direccion;
    private String ciudad;
    private Long paisId;
    private Long departamentoId;
    private Long provinciaId;
    private Long distritoId;
    private String ubigeo;
    private String flagEstado;
}
