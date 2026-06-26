package pe.restaurant.activos.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfAdaptacionRequest {

    @NotNull(message = "El ID del activo maestro es requerido")
    private Long afMaestroId;

    @NotNull(message = "La fecha es requerida")
    private LocalDate fecha;

    @NotBlank(message = "La descripción es requerida")
    @Size(max = 300, message = "La descripción no puede exceder 300 caracteres")
    private String descripcion;

    @NotNull(message = "El monto total es requerido")
    @DecimalMin(value = "0.00", message = "El monto total debe ser mayor o igual a 0")
    @Digits(integer = 14, fraction = 4, message = "El monto total debe tener máximo 14 enteros y 4 decimales")
    private BigDecimal montoTotal;
}
