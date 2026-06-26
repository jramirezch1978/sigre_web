package pe.restaurant.ventas.dto.request;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.time.Instant;

@Data
public class FacturaSimplPagoRequest {

    private Long formaPagoId;

    @NotNull
    @DecimalMin(value = "0.0001", inclusive = true)
    private BigDecimal monto;

    private String referencia;

    private Instant fechaPago;
}
