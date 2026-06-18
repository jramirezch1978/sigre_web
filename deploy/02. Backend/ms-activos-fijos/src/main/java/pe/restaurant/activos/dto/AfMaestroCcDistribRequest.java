package pe.restaurant.activos.dto;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class AfMaestroCcDistribRequest {

    @NotNull
    private Long centroCostoId;

    @NotNull
    @DecimalMin("0.0001")
    @DecimalMax("100")
    private BigDecimal porcentaje;
}
