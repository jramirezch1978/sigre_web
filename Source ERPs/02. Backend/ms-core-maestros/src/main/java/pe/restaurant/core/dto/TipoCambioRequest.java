package pe.restaurant.core.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class TipoCambioRequest {

    @NotNull
    private Long monedaId;

    @NotNull
    private LocalDate fecha;

    @NotNull
    private BigDecimal compra;

    @NotNull
    private BigDecimal venta;
}
