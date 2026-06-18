package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SucursalResponse {
    private Long id;
    private String codigo;
    private String nombre;
    private String direccion;
    private String ciudad;
    private Long paisId;
    private String flagEstado;
}
