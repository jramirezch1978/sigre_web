package pe.restaurant.ventas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrdenVentaResponse {
    private Long id;
    private Long sucursalId;
    private String nroOrdenVenta;
    private Long clienteId;
    private Long vendedorId;
    private LocalDate fechaEmision;
    private BigDecimal montoTotal;
    private String flagEstado;
    private List<OrdenVentaDetResponse> detalles;
}
