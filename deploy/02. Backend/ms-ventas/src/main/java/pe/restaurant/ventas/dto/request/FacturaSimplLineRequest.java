package pe.restaurant.ventas.dto.request;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class FacturaSimplLineRequest {

    @NotNull
    private Long articuloId;

    private Long unidadMedidaId;

    @NotNull
    @DecimalMin(value = "0.0001", inclusive = true)
    private BigDecimal cantidad;

    @NotNull
    @DecimalMin(value = "0", inclusive = true)
    private BigDecimal precioUnitario;
}
