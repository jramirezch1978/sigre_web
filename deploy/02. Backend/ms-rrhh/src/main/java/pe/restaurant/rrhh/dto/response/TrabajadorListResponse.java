package pe.restaurant.rrhh.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TrabajadorListResponse {
    private Long id;
    private String codigoTrabajador;
    private String nombres;
    private String apellidoPaterno;
    private String apellidoMaterno;
    private RefResponse tipoDocIdentidad;
    private String numeroDocumento;
    private RefResponse area;
    private RefResponse cargo;
    private RefResponse sucursal;
    private String fechaIngreso;
    private String flagEstado;
    private String fecCreacion;
}
