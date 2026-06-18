package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class CntaCrrteMovimientoRequest {
    @NotNull private LocalDate fechaMovimiento;
    @NotNull private Long tipoMovimientoCntaCrrteId;
    private String concepto;
    @NotNull private BigDecimal monto;
    private String referencia;
}
