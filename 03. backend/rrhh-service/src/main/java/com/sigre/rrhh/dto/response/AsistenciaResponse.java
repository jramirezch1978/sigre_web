package com.sigre.rrhh.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO de respuesta para un registro de asistencia.
 * Incluye el nombre completo del trabajador resuelto desde la FK.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AsistenciaResponse {
    private Long id;
    private Long trabajadorId;
    private String trabajadorNombres;
    private String fecha;
    private String horaEntrada;
    private String horaSalida;
    private RefResponse tipoMovAsistencia;
    private BigDecimal horasTrabajadas;
    private BigDecimal horasExtra;
    private String flagEstado;
    private Long createdBy;
    private String fecCreacion;
    private Long updatedBy;
    private String fecModificacion;
}
