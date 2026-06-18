package pe.restaurant.rrhh.dto.response;

import lombok.Data;
import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Data
public class AdminAfpResponse {

    private Long id;
    private String nombre;
    private BigDecimal comisionPorcentaje;
    private BigDecimal primaSeguro;
    private BigDecimal aporteObligatorio;
    private String flagEstado;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private OffsetDateTime fecModificacion;
}
