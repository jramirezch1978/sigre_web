package pe.restaurant.activos.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DepreciacionMensualRequest {

    @NotNull(message = "El año es requerido")
    @Min(value = 2000, message = "El año debe ser mayor o igual a 2000")
    @Max(value = 2100, message = "El año debe ser menor o igual a 2100")
    private Integer anio;

    @NotNull(message = "El mes es requerido")
    @Min(value = 1, message = "El mes debe estar entre 1 y 12")
    @Max(value = 12, message = "El mes debe estar entre 1 y 12")
    private Integer mes;

    @Min(value = 0, message = "Las unidades producidas no pueden ser negativas")
    @Max(value = 100_000_000, message = "Las unidades producidas exceden el máximo permitido")
    private Integer unidadesProducidasPeriodo;
}
