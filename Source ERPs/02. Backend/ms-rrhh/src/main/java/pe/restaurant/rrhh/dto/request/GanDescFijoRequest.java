package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GanDescFijoRequest {

    @NotNull(message = "El trabajador es obligatorio")
    private Long trabajadorId;

    @NotNull(message = "El concepto de planilla es obligatorio")
    private Long conceptoId;

    private BigDecimal impGanDesc;

    private BigDecimal porcentaje;

    private BigDecimal impMaxGanDesc;

    private String flagEstado;
}
