package com.sigre.rrhh.dto.response;

import lombok.Data;
import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Data
public class RegimenLaboralResponse {
    private Long id;
    private String codigo;
    private String nombre;
    private BigDecimal factorGratificacion;
    private BigDecimal factorVacacion;
    private BigDecimal factorCts;
    private String flagEstado;
    private String createdBy;
    private OffsetDateTime fecCreacion;
    private String updatedBy;
    private OffsetDateTime fecModificacion;
}
