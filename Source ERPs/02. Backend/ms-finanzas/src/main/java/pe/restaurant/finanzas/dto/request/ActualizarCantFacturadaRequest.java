package pe.restaurant.finanzas.dto.request;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

/**
 * Request para actualizar cant_facturada en líneas de OC.
 * Se envía de ms-finanzas → ms-compras via Feign cuando se registra
 * una factura vinculada a una orden de compra.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ActualizarCantFacturadaRequest {

    private List<LineaCantFacturada> lineas;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class LineaCantFacturada {
        private Long ordenCompraDetId;
        private BigDecimal cantidad;
    }
}
