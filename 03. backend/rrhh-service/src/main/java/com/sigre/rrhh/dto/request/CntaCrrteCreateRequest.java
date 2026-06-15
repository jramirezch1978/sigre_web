package com.sigre.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class CntaCrrteCreateRequest {
    @NotNull private Long trabajadorId;
    private LocalDate fechaApertura;
    private BigDecimal saldoInicial;
}
