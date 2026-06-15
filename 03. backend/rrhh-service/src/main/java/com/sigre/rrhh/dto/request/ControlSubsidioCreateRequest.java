package com.sigre.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class ControlSubsidioCreateRequest {
    @NotNull private Long trabajadorId;
    @NotNull private Long tipoSubsidioId;
    @NotNull private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private Integer dias;
    private BigDecimal montoSubsidio;
}
