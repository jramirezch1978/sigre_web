package com.sigre.rrhh.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GanDescFijoResponse {

    private Long id;
    private Long trabajadorId;
    private String trabajadorNombres;
    private Long conceptoId;
    private String conceptoDescripcion;
    private BigDecimal impGanDesc;
    private BigDecimal porcentaje;
    private BigDecimal impMaxGanDesc;
    private String flagEstado;
    private Long createdBy;
    private String fecCreacion;
    private Long updatedBy;
    private String fecModificacion;
}
