package pe.restaurant.activos.dto;

import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfCalculoCntblRequest {

    @NotNull(message = "El ID del activo maestro es requerido")
    private Long afMaestroId;

    @NotNull(message = "El año es requerido")
    @Min(value = 2000, message = "El año debe ser mayor o igual a 2000")
    @Max(value = 2100, message = "El año debe ser menor o igual a 2100")
    private Integer anio;

    @NotNull(message = "El mes es requerido")
    @Min(value = 1, message = "El mes debe estar entre 1 y 12")
    @Max(value = 12, message = "El mes debe estar entre 1 y 12")
    private Integer mes;

    @NotNull(message = "La depreciación del periodo es requerida")
    @DecimalMin(value = "0.00", message = "La depreciación del periodo debe ser mayor o igual a 0")
    @Digits(integer = 14, fraction = 4, message = "La depreciación del periodo debe tener máximo 14 enteros y 4 decimales")
    private BigDecimal depreciacionPeriodo;

    @NotNull(message = "La depreciación acumulada es requerida")
    @DecimalMin(value = "0.00", message = "La depreciación acumulada debe ser mayor o igual a 0")
    @Digits(integer = 14, fraction = 4, message = "La depreciación acumulada debe tener máximo 14 enteros y 4 decimales")
    private BigDecimal depreciacionAcumulada;

    @NotNull(message = "El valor neto es requerido")
    @DecimalMin(value = "0.00", message = "El valor neto debe ser mayor o igual a 0")
    @Digits(integer = 14, fraction = 4, message = "El valor neto debe tener máximo 14 enteros y 4 decimales")
    private BigDecimal valorNeto;
}
