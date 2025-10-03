package com.sigre.asistencia.dto.dashboard;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * DTO para marcajes agrupados por centro de costo
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MarcajesPorCentroCostoDto {
    
    private String centroCosto;
    private String descripcionCentroCosto;
    private Long cantidadMarcajes;
    private List<MarcajeDelDiaDto> marcajes;
    
    /**
     * DTO resumen para listado general
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class ResumenCentroCosto {
        private String centroCosto;
        private String descripcionCentroCosto;
        private Long cantidadMarcajes;
        private Long cantidadTrabajadores;
    }

    /**
     * DTO para indicadores de centros de costo con movimientos pivoteados
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class IndicadorCentroCosto {
        private String tipoTrabajador;
        private String descTipoTrabajador;
        private String codArea;
        private String descArea;
        private String codSeccion;
        private String descSeccion;
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
}
