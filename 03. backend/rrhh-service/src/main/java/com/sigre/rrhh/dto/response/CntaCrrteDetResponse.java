package com.sigre.rrhh.dto.response;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;

@Data
public class CntaCrrteDetResponse {
    private Long id;
    private Long cntaCrrteId;
    private Short nroDscto;
    private LocalDate fechaMovimiento;
    private Long tipoMovimientoCntaCrrteId;
    private BigDecimal monto;
    private String flagDigitado;
    private Long liquidacionBenefId;
    private Long calculoDetId;
    private String referencia;
    private String observaciones;
    private String flagProceso;
    private String flagEstado;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private OffsetDateTime fecModificacion;
}
