package pe.restaurant.finanzas.dto.request;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * Request para ajustar stock desde nota de crédito/débito.
 * Se envía de ms-finanzas → ms-compras vía Feign.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AjusteStockRequest {
    private Long ordenCompraDetId;
    private BigDecimal cantidad;
    private String tipoAjuste; // "INGRESO" o "SALIDA"
    private Long almacenId;
}
