package com.sigre.produccion.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProcesarCosteoResponse {

    private Integer anio;
    private Integer mes;
    private int totalOtsProcesadas;
    private int totalCreadas;
    private int totalActualizadas;
    private BigDecimal costoMateriaPrimaTotal;
    private BigDecimal costoManoObraTotal;
    private BigDecimal costoIndirectoTotal;
    private BigDecimal costoGranTotal;
    private List<CosteoProduccionResponse> detalle;
}
