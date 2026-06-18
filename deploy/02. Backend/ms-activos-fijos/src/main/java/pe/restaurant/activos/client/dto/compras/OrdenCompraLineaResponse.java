package pe.restaurant.activos.client.dto.compras;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrdenCompraLineaResponse {

    private Long id;
    private String articuloDescripcion;
    private BigDecimal subtotal;
    private BigDecimal valorUnitario;
    private Long centrosCostoId;
    private String flagEstado;
    private BigDecimal cantFacturada;
}
