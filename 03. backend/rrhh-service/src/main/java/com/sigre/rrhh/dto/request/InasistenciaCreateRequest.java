package com.sigre.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class InasistenciaCreateRequest {

    @NotNull(message = "El trabajador es obligatorio.")
    private Long trabajadorId;

    @NotNull(message = "El concepto de planilla es obligatorio.")
    private Long conceptoPlanillaId;

    @NotNull(message = "La fecha desde es obligatoria.")
    private LocalDate fechaDesde;

    private LocalDate fechaHasta;

    private LocalDate fechaMovimiento;

    private BigDecimal diasInasistencia;

    private String flagVacacionesAdelantadas;

    private BigDecimal importe;

    private String flagEstado;
}
