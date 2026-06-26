package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class TipoSancionUpdateRequest {
    @Size(max = 120) private String nombre;
    private String flagEstado;
}
