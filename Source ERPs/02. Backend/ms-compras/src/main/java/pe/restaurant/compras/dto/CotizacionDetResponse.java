package pe.restaurant.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CotizacionDetResponse {

    private Long id;
    private Long articuloId;
    private String articuloCodigo;
    private String articuloDescripcion;
    private BigDecimal cantidad;
    private BigDecimal precioUnitario;
    private BigDecimal descuento;
    private Integer plazoEntregaDias;
}
