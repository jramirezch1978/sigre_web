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
public class AfOperacionesRequest {

    @NotNull(message = "El ID del activo maestro es requerido")
    private Long afMaestroId;

    @NotBlank(message = "El tipo es requerido")
    @Size(max = 20, message = "El tipo no puede exceder 20 caracteres")
    private String tipo;

    private LocalDate fechaProgramada;

    private LocalDate fechaEjecucion;

    @DecimalMin(value = "0.00", message = "El costo debe ser mayor o igual a 0")
    @Digits(integer = 14, fraction = 4, message = "El costo debe tener máximo 14 enteros y 4 decimales")
    private BigDecimal costo;

    @Size(max = 200, message = "El proveedor de servicio no puede exceder 200 caracteres")
    private String proveedorServicio;
}
