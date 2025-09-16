package com.sigre.asistencia.dto.dashboard;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * DTO principal para respuesta del dashboard
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DashboardResponseDto {
    
    private EstadisticasGeneralesDto estadisticasGenerales;
    private MarcajesPorHoraDto marcajesUltimas24Horas;
    private MarcajesPorHoraDto marcajesDelDia;
    private List<MarcajeDelDiaDto> listadoMarcajesHoy;
    private List<MarcajesPorCentroCostoDto.ResumenCentroCosto> resumenPorCentroCosto;
}
