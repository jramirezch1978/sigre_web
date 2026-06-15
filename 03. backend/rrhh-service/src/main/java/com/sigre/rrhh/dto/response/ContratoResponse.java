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
public class ContratoResponse {
    private Long id;
    private Long trabajadorId;
    private RefResponse tipoContrato;
    private String fechaInicio;
    private String fechaFin;
    private BigDecimal remuneracion;
    private Boolean asignacionFamiliar;
    private String flagEstado;
    private Long createdBy;
    private String fecCreacion;
    private Long updatedBy;
    private String fecModificacion;
}
