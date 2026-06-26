package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CtsProcesarRequest {
    @NotNull private Integer anio;
    @NotNull private Long periodoCtsId;
}
