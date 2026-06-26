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

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfAdaptacionDetRequest {

    @NotNull(message = "El ID de la adaptación es requerido")
    private Long afAdaptacionId;

    @NotBlank(message = "La descripción es requerida")
    @Size(max = 300, message = "La descripción no puede exceder 300 caracteres")
    private String descripcion;

    @NotNull(message = "El monto es requerido")
    @DecimalMin(value = "0.01", message = "El monto debe ser mayor a 0")
    @Digits(integer = 14, fraction = 4, message = "El monto debe tener máximo 14 enteros y 4 decimales")
    private BigDecimal monto;

    private Long unidadMedidaId;
}
