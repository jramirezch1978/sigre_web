package pe.restaurant.activos.dto.reporte;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class AfReporteDepreciacionMensualResponse {
    private Integer mes;
    private BigDecimal depreciacionPeriodo;
    private BigDecimal depreciacionAcumulada;
    private BigDecimal valorNeto;
    private Long calculoId;
}
