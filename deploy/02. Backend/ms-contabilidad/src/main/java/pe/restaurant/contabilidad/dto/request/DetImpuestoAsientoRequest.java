package pe.restaurant.contabilidad.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class DetImpuestoAsientoRequest {

    @NotNull(message = "El tipo de impuesto es obligatorio")
    private Long tiposImpuestoId;

    @NotNull(message = "El importe del impuesto es obligatorio")
    private BigDecimal importe;
}
