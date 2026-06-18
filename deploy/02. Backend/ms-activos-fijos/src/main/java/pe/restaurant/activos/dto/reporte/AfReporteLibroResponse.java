package pe.restaurant.activos.dto.reporte;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
public class AfReporteLibroResponse {
    private LocalDate fechaCorte;
    private List<AfReporteLibroLineaResponse> lineas;
    private BigDecimal totalValorAdquisicion;
    private BigDecimal totalDepreciacionAcumulada;
    private BigDecimal totalValorNeto;
}
