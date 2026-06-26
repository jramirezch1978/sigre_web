package pe.restaurant.ventas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import pe.restaurant.ventas.client.dto.MovimientoDetalleResponse;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DespachoOvResponse {

    private Long ordenVentaId;
    private String nroOrdenVenta;
    private MovimientoDetalleResponse movimiento;
}
