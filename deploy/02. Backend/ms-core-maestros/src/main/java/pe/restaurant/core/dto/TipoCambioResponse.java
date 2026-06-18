package pe.restaurant.core.dto;

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
public class TipoCambioResponse {
    private Long id;
    private Long monedaId;
    private LocalDate fecha;
    private BigDecimal compra;
    private BigDecimal venta;
    private String flagEstado;
}
