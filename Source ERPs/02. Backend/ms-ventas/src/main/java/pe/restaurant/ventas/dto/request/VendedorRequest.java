package pe.restaurant.ventas.dto.request;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class VendedorRequest {

    @NotNull(message = "El ID de usuario es obligatorio")
    private Long usuarioId;

    @Size(max = 150, message = "El nombre no puede exceder 150 caracteres")
    private String nombre;

    @DecimalMin(value = "0.00", inclusive = true, message = "La comisión no puede ser negativa")
    @DecimalMax(value = "100.00", inclusive = true, message = "La comisión no puede ser mayor a 100")
    private BigDecimal comisionPorcentaje;
}
