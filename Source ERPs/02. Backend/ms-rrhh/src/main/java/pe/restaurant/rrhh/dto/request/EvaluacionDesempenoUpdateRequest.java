package pe.restaurant.rrhh.dto.request;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class EvaluacionDesempenoUpdateRequest {
    private BigDecimal calificacion;
    private String observaciones;
    private LocalDate fechaEvaluacion;
}
