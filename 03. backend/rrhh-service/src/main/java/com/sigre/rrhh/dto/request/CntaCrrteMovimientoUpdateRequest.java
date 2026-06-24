package com.sigre.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class CntaCrrteMovimientoUpdateRequest {
    @NotNull private LocalDate fechaMovimiento;
    @NotNull private Long tipoMovimientoCntaCrrteId;
    @NotNull private BigDecimal monto;
    private String referencia;
    private String observaciones;
    private Long liquidacionBenefId;
    private Long calculoDetId;
    private String flagDigitado;
    private String flagProceso;
}
