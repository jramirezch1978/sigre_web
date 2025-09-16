package com.sigre.asistencia.dto.dashboard;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO para conteo de raciones por tipo del día
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RacionesPorTipoDto {
    
    private Long desayunos;        // Cantidad de desayunos seleccionados hoy
    private Long almuerzos;        // Cantidad de almuerzos seleccionados hoy
    private Long cenas;            // Cantidad de cenas seleccionadas hoy
    private Long totalRaciones;    // Total de raciones del día
    private String fecha;          // Fecha de los datos (YYYY-MM-DD)
}
