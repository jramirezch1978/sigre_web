package com.sigre.rrhh.dto.response;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;

@Data
public class CntaCrrteDetResponse {
    private Long id;
    private Long cntaCrrteId;
    private LocalDate fechaMovimiento;
    private Long tipoMovimientoCntaCrrteId;
    private String concepto;
    private BigDecimal monto;
    private String referencia;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
}
