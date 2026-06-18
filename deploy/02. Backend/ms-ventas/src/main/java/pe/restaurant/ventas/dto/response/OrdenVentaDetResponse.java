package pe.restaurant.ventas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrdenVentaDetResponse {
    private Long id;
    private Long articuloId;
    private Integer lineaNro;
    private BigDecimal cantProyectada;
    private BigDecimal valorUnitario;
    private BigDecimal subtotal;
    private Long almacenId;
    private String flagEstado;
}
