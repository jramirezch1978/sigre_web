package pe.restaurant.activos.dto;

import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfMaestroRequest {

    @NotBlank(message = "El código es requerido")
    @Size(max = 30, message = "El código debe tener máximo 30 caracteres")
    private String codigo;

    @NotBlank(message = "El nombre es requerido")
    @Size(max = 220, message = "El nombre debe tener máximo 220 caracteres")
    private String nombre;

    @NotNull(message = "La sub-clase de activo es requerida")
    private Long afSubClaseId;

    private Long afUbicacionId;

    @NotNull(message = "La fecha de adquisición es requerida")
    @PastOrPresent(message = "La fecha de adquisición no puede ser futura")
    private LocalDate fechaAdquisicion;

    @NotNull(message = "El valor de adquisición es requerido")
    @DecimalMin(value = "0.01", message = "El valor de adquisición debe ser mayor a 0")
    @Digits(integer = 14, fraction = 4, message = "El valor de adquisición debe tener máximo 14 enteros y 4 decimales")
    private BigDecimal valorAdquisicion;

    @NotNull(message = "El valor residual es requerido")
    @DecimalMin(value = "0.00", message = "El valor residual debe ser mayor o igual a 0")
    @Digits(integer = 14, fraction = 4, message = "El valor residual debe tener máximo 14 enteros y 4 decimales")
    private BigDecimal valorResidual;

    private Long proveedorId;

    @Min(value = 1, message = "Las unidades de producción totales deben ser al menos 1")
    private Integer unidadesProduccionTotales;

    @Min(value = 0, message = "Las unidades del período no pueden ser negativas")
    private Integer unidadesProduccionPeriodo;
}
