package pe.restaurant.activos.client.dto.compras;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrdenCompraDetalleResponse {

    private Long id;
    private Long proveedorId;
    private String nroOrdenCompra;
    private LocalDate fechaEmision;
    private BigDecimal total;
    private String flagEstado;
    private List<OrdenCompraLineaResponse> lineas;
}
