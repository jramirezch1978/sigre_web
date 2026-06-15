package com.sigre.rrhh.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO de respuesta para listados de cálculos de planilla (cabecera).
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CalculoResponse {

    private Long id;
    private Integer anio;
    private Integer mes;
    private Long tipoPlanillaId;
    private String tipoPlanillaNombre;
    private BigDecimal totalIngresos;
    private BigDecimal totalDescuentos;
    private BigDecimal totalNeto;
    private BigDecimal totalAportes;
    private Integer totalTrabajadores;
    private Long createdBy;
    private String fecCreacion;
    private Long updatedBy;
    private String fecModificacion;
}
