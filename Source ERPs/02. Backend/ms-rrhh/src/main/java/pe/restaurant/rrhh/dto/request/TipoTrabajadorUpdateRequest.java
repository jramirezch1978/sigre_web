package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class TipoTrabajadorUpdateRequest {
    @NotBlank @Size(max = 200) private String nombre;
    private Integer libroProvRemuneracion;
    private Integer libroProvGratificacion;
    private Integer libroProvCts;
}
