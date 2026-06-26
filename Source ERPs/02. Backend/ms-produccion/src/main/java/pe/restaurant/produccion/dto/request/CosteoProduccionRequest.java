package pe.restaurant.produccion.dto.request;

import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CosteoProduccionRequest {

    @NotNull(message = "La orden de trabajo es requerida")
    private Long ordenTrabajoId;

    @Digits(integer = 18, fraction = 4)
    private BigDecimal costoMateriaPrima;

    @Digits(integer = 18, fraction = 4)
    private BigDecimal costoManoObra;

    @Digits(integer = 18, fraction = 4)
    private BigDecimal costoIndirecto;

    @Digits(integer = 18, fraction = 4)
    private BigDecimal costoTotal;

    @Digits(integer = 18, fraction = 4)
    private BigDecimal costoUnitario;

    @Digits(integer = 18, fraction = 4)
    private BigDecimal rendimientoReal;

    @Digits(integer = 8, fraction = 4)
    private BigDecimal porcentajeMermaReal;
}
