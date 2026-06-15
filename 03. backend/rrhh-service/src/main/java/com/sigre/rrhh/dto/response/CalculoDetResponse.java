package com.sigre.rrhh.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO de respuesta para una línea de detalle de cálculo de planilla.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CalculoDetResponse {

    private Long id;
    private Long calculoId;
    private Long trabajadorId;
    private String trabajadorNombres;
    private Long conceptoId;
    private String conceptoNombre;
    private BigDecimal monto;
    private Long tipoConceptoCalculoId;
    private String tipoConceptoCalculoNombre;
}
