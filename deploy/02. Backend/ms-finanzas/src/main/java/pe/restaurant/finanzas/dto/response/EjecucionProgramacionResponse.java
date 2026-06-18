package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EjecucionProgramacionResponse {

    private Long id;

    private Integer pagosGenerados;

    private BigDecimal totalPagado;

    private String flagEstado;

    private Long updatedBy;

    private Instant fecModificacion;
}
