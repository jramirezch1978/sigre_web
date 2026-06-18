package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;
import java.math.BigDecimal;

@Data
public class PrestamoCreateRequest {
    @NotNull private Long trabajadorId;
    @NotNull @Positive private BigDecimal montoTotal;
    @NotNull @Positive private Integer cuotas;
}
