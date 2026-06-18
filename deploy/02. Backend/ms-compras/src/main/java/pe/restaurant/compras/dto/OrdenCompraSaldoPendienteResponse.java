package pe.restaurant.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrdenCompraSaldoPendienteResponse {

    private Long ordenCompraId;
    private String numero;
    private BigDecimal totalPedido;
    private BigDecimal totalRecibido;
    private BigDecimal pendiente;
    private BigDecimal porcentajeAtendido;
    private List<LineaSaldo> lineas;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class LineaSaldo {
        private Long lineaId;
        private Long articuloId;
        private String articuloCodigo;
        private String articuloDescripcion;
        private BigDecimal cantidadOc;
        private BigDecimal cantProcesada;
        private BigDecimal cantidadPendiente;
    }
}
