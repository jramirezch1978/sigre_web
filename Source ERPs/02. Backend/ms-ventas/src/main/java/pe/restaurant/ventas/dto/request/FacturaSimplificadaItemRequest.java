package pe.restaurant.ventas.dto.request;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class FacturaSimplificadaItemRequest {
    
    @NotNull(message = "El artículo es obligatorio")
    private Long articuloId;
    
    private Long unidadMedidaId;
    
    @NotNull(message = "La cantidad es obligatoria")
    @DecimalMin(value = "0.0001", message = "La cantidad debe ser mayor a 0")
    private BigDecimal cantidad;
    
    @NotNull(message = "El precio unitario es obligatorio")
    @DecimalMin(value = "0.000001", message = "El precio unitario debe ser mayor a 0")
    private BigDecimal precioUnitario;
}
