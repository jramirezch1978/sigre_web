package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class ProgramVacacionCreateRequest {
    @NotNull private Long trabajadorId;
    @NotNull private Integer anio;
    @NotNull @Min(1) @Max(12) private Integer mes;
    @NotNull @Min(1) private Integer diasProgramados;
    private String observacion;
}
