package pe.restaurant.ventas.dto.request;

import jakarta.validation.constraints.DecimalMin;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class FacturaSimplificadaPagoRequest {
    
    private Long formaPagoId;
    
    @DecimalMin(value = "0.0001", message = "El monto debe ser mayor a 0")
    private BigDecimal monto;
    
    private String referencia;
}
