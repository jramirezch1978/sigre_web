package pe.restaurant.ventas.dto.request;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EntidadCreditosCxcRequest {

    @NotNull
    private Long entidadContribuyenteId;

    private Long monedaId;

    @NotNull
    @DecimalMin(value = "0", inclusive = true)
    private BigDecimal limiteCredito;

    @NotNull
    @Min(0)
    private Integer diasCredito;
}
