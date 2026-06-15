package com.sigre.rrhh.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO de respuesta para una liquidación de beneficios sociales.
 * Incluye los campos del modelo más el nombre completo del trabajador.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LiquidacionResponse {
    private Long id;
    private Long trabajadorId;
    private String trabajadorNombres;
    private String fechaCese;
    private BigDecimal ctsPendiente;
    private BigDecimal vacacionesTruncas;
    private BigDecimal gratificacionTrunca;
    private BigDecimal indemnizacion;
    private BigDecimal totalBeneficios;
    private BigDecimal totalDescuentos;
    private BigDecimal netoPagar;
    private String flagEstado;
    private Long createdBy;
    private String fecCreacion;
    private Long updatedBy;
    private String fecModificacion;
}
