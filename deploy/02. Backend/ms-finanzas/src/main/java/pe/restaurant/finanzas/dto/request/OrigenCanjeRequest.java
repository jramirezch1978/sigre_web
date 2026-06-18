package pe.restaurant.finanzas.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrigenCanjeRequest {
    
    @NotNull(message = "El ID de la cuenta por pagar es obligatorio")
    private Long cntasPagarId;
    
    @NotNull(message = "El monto canjeado es obligatorio")
    @Positive(message = "El monto canjeado debe ser mayor a cero")
    private BigDecimal montoCanjeado;
}
