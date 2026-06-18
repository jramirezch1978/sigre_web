package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ConversionUnidadResponse {
    private Long id;
    private Long articuloId;
    private Long umOrigenId;
    private Long umDestinoId;
    private BigDecimal factorConversion;
    private String flagEstado;
}
