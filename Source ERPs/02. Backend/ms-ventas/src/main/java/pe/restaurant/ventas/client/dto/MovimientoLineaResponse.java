package pe.restaurant.ventas.client.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MovimientoLineaResponse {

    private Long id;
    private Long articuloId;
    private BigDecimal cantProcesada;
    private BigDecimal costoUnitario;
    private Long ocDetId;
    private Long ordenTrasladoDetId;
    private Long ordenVentaDetId;
}
