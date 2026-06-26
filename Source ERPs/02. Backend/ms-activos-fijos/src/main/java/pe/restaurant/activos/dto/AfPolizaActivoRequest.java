package pe.restaurant.activos.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfPolizaActivoRequest {

    @NotNull(message = "El ID de la póliza de seguro es requerido")
    private Long afPolizaSeguroId;

    @NotNull(message = "El ID del activo maestro es requerido")
    private Long afMaestroId;

    @DecimalMin(value = "0.00", message = "El valor asegurado debe ser mayor o igual a 0")
    @Digits(integer = 14, fraction = 4, message = "El valor asegurado debe tener máximo 14 enteros y 4 decimales")
    private BigDecimal valorAsegurado;
}
