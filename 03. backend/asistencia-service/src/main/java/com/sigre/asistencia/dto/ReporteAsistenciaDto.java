package com.sigre.asistencia.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * DTO para el reporte de asistencia con cálculo de horas trabajadas y extras
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ReporteAsistenciaDto {
    
    private Integer nro;
    private String tipoTrabajador;
    private String codigoTrabajador;
    private String dni;
    private String apellidosNombres;
    private String area;
    private String cargoPuesto;
    private String turno;
    private LocalDate fecha;
    private LocalDateTime horaIngreso;
    private LocalDateTime horaSalida;
    private String horasTrabajadas;      // Formato HH:MM
    private Double horasExtras;           // Formato decimal
    private Integer tardanzaMin;
    private Double totalHorasTrabajadasSemana;
    private Double totalHorasExtrasSemana;
    private Integer totalDiasAsistidos;
    private Integer totalFaltas;
    private Double porcAsistencia;
    private Double porcAusentismo;
}

