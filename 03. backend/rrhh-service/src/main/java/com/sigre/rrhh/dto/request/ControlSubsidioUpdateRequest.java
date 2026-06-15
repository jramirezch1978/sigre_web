package com.sigre.rrhh.dto.request;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class ControlSubsidioUpdateRequest {
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private Integer dias;
    private BigDecimal montoSubsidio;
    private String flagEstado;
}
