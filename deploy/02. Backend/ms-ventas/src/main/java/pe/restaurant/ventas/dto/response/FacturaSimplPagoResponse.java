package pe.restaurant.ventas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FacturaSimplPagoResponse {

    private Long id;
    private Long formaPagoId;
    private BigDecimal monto;
    private String referencia;
    private Instant fechaPago;
    private String flagEstado;
}
