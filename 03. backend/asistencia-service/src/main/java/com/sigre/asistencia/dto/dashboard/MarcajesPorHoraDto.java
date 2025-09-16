package com.sigre.asistencia.dto.dashboard;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * DTO para marcajes agrupados por hora
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MarcajesPorHoraDto {
    
    private List<Integer> horas;              // [0, 1, 2, ..., 23]
    private List<Long> cantidadPorHora;       // Cantidad de marcajes por cada hora
    private List<Long> cantidadAcumulada;     // Cantidad acumulada hasta cada hora
    private Long totalMarcajes;               // Total de marcajes del día
    private String fecha;                     // Fecha de los datos (YYYY-MM-DD)
}
