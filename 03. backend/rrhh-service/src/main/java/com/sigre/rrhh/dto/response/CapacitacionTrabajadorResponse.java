package com.sigre.rrhh.dto.response;

import lombok.Data;
import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Data
public class CapacitacionTrabajadorResponse {
    private Long id;
    private Long capacitacionId;
    private Long trabajadorId;
    private Boolean asistio;
    private BigDecimal calificacion;
    private Boolean certificado;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
}
