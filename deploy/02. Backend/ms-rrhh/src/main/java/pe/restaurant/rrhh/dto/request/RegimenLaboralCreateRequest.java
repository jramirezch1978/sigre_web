package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;
import java.math.BigDecimal;

@Data
public class RegimenLaboralCreateRequest {
    @NotBlank @Size(max = 20)
    private String codigo;
    @NotBlank @Size(max = 120)
    private String nombre;
    private BigDecimal factorGratificacion;
    private BigDecimal factorVacacion;
    private BigDecimal factorCts;
}
