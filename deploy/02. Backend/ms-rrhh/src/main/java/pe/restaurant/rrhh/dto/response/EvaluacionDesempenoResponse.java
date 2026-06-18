package pe.restaurant.rrhh.dto.response;

import lombok.Data;
import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Data
public class EvaluacionDesempenoResponse {
    private Long id;
    private Long trabajadorId;
    private Integer periodoAnio;
    private Integer periodoSemestre;
    private BigDecimal calificacion;
    private String observaciones;
    private Long evaluadorId;
    private String fechaEvaluacion;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private OffsetDateTime fecModificacion;
}
