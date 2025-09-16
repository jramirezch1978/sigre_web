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
}
