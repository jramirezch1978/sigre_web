package pe.restaurant.activos.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfAdaptacionDepRequest {

    @NotNull(message = "El ID de la adaptación es requerido")
    private Long afAdaptacionId;

    @NotNull(message = "El año es requerido")
    @Min(value = 2000, message = "El año debe ser mayor o igual a 2000")
    @Max(value = 2100, message = "El año debe ser menor o igual a 2100")
    private Integer anio;

    @NotNull(message = "El mes es requerido")
    @Min(value = 1, message = "El mes debe estar entre 1 y 12")
    @Max(value = 12, message = "El mes debe estar entre 1 y 12")
    private Integer mes;

    @NotNull(message = "La depreciación del período es requerida")
    @DecimalMin(value = "0.00", message = "La depreciación del período debe ser mayor o igual a 0")
    @Digits(integer = 14, fraction = 4, message = "La depreciación debe tener máximo 14 enteros y 4 decimales")
    private BigDecimal depreciacionPeriodo;

    @NotNull(message = "La depreciación acumulada es requerida")
    @DecimalMin(value = "0.00", message = "La depreciación acumulada debe ser mayor o igual a 0")
    @Digits(integer = 14, fraction = 4, message = "La depreciación acumulada debe tener máximo 14 enteros y 4 decimales")
    private BigDecimal depreciacionAcumulada;
}
