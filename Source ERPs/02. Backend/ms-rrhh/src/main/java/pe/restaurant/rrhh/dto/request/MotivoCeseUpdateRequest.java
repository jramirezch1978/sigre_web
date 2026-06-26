package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class MotivoCeseUpdateRequest {
    @NotBlank @Size(max = 200) private String nombre;
}
