package pe.restaurant.produccion.dto.request;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProcesarCosteoRequest {

    @NotNull(message = "El año es requerido")
    @Min(value = 2020, message = "El año debe ser mayor o igual a 2020")
    private Integer anio;

    @NotNull(message = "El mes es requerido")
    @Min(value = 1, message = "El mes debe estar entre 1 y 12")
    @Max(value = 12, message = "El mes debe estar entre 1 y 12")
    private Integer mes;

    private Long sucursalId;

    /** Filtro opcional de almacén; null aplica el costeo a todos los almacenes del período. */
    private Long almacenId;
}
