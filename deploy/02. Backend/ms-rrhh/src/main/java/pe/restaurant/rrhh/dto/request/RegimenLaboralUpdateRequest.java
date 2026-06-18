package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.Size;
import lombok.Data;
import java.math.BigDecimal;

@Data
public class RegimenLaboralUpdateRequest {
    @Size(max = 120) private String nombre;
    private BigDecimal factorGratificacion;
    private BigDecimal factorVacacion;
    private BigDecimal factorCts;
    private String flagEstado;
}
