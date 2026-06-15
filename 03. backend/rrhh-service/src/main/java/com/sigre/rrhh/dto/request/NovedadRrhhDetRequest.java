package com.sigre.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class NovedadRrhhDetRequest {
    @NotNull private LocalDate fechaProceso;
    private BigDecimal montoPlanilla;
    private BigDecimal montoSeguro;
    private String referenciaDoc;
}
