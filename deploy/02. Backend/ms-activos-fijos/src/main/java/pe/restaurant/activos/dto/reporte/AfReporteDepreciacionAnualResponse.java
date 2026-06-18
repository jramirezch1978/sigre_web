package pe.restaurant.activos.dto.reporte;

import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
public class AfReporteDepreciacionAnualResponse {
    private Long afMaestroId;
    private String codigoActivo;
    private Integer anio;
    private BigDecimal valorAdquisicion;
    private BigDecimal valorResidual;
    private BigDecimal totalDepreciacionAnual;
    private BigDecimal depreciacionAcumuladaFinAnio;
    private BigDecimal valorNetoFinAnio;
    private List<AfReporteDepreciacionMensualResponse> meses;
}
