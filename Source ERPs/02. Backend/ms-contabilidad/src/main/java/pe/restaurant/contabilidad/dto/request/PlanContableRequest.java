package pe.restaurant.contabilidad.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PlanContableRequest {

    @NotBlank(message = "El código del plan contable es obligatorio")
    @Size(max = 20, message = "El código admite hasta 20 caracteres")
    private String codigo;

    @NotBlank(message = "El nombre del plan contable es obligatorio")
    @Size(max = 200, message = "El nombre admite hasta 200 caracteres")
    private String nombre;

    @NotNull(message = "El año es obligatorio")
    private Integer anio;

    @NotNull(message = "La fecha de vigencia (effectiveFrom) es obligatoria")
    private LocalDate effectiveFrom;
}
