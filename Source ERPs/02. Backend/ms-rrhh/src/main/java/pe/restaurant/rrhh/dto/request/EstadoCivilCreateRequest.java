package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class EstadoCivilCreateRequest {
    @NotBlank @Size(max = 20)
    private String codigo;
    @NotBlank @Size(max = 120)
    private String nombre;
}
