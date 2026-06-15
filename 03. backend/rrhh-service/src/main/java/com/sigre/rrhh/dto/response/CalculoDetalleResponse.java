package com.sigre.rrhh.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

/**
 * DTO de respuesta detallada de un cálculo de planilla,
 * incluyendo la lista de líneas de detalle.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CalculoDetalleResponse {

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
    private List<CalculoDetResponse> detalles;
}
