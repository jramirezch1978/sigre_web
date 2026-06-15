package com.sigre.rrhh.dto.response;

import lombok.Data;
import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Data
public class ControlSubsidioResponse {
    private Long id;
    private Long trabajadorId;
    private Long tipoSubsidioId;
    private String fechaInicio;
    private String fechaFin;
    private Integer dias;
    private BigDecimal montoSubsidio;
    private String flagEstado;
    private String createdBy;
    private OffsetDateTime fecCreacion;
    private String updatedBy;
    private OffsetDateTime fecModificacion;
}
