package com.sigre.rrhh.dto.response;

import lombok.Data;
import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Data
public class GratificacionResponse {
    private Long id;
    private Long trabajadorId;
    private Integer anio;
    private Long periodoGratificacionId;
    private BigDecimal remuneracionComputable;
    private Integer mesesLaborados;
    private BigDecimal montoGratificacion;
    private BigDecimal bonificacionExtraordinaria;
    private BigDecimal total;
    private String createdBy;
    private OffsetDateTime fecCreacion;
    private String updatedBy;
    private OffsetDateTime fecModificacion;
}
