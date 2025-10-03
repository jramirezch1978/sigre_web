package com.sigre.asistencia.dto.dashboard;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO para indicadores de áreas con movimientos pivoteados
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class IndicadoresAreaDto {
    private String tipoTrabajador;
    private String descTipoTrabajador;
    private String codArea;
    private String descArea;
    private String descCentroCosto;
    private Long ingresoPlanta;
    private Long salidaPlanta;
    private Long salidaAlmorzar;
    private Long regresoAlmorzar;
    private Long salidaComision;
    private Long retornoComision;
    private Long ingresoProduccion;
    private Long salidaProduccion;
    private Long salidaCenar;
    private Long regresoCenar;
    private Long total;
}
