package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class AdminAfpRequest {

    @NotBlank(message = "El nombre de la AFP es obligatorio.")
    @Size(max = 120, message = "El nombre de la AFP no puede exceder 120 caracteres.")
    private String nombre;

    @DecimalMin(value = "0.0000", message = "Los porcentajes no pueden ser negativos.")
    private BigDecimal comisionPorcentaje;

    @DecimalMin(value = "0.0000", message = "Los porcentajes no pueden ser negativos.")
    private BigDecimal primaSeguro;

    @DecimalMin(value = "0.0000", message = "Los porcentajes no pueden ser negativos.")
    private BigDecimal aporteObligatorio;
}
