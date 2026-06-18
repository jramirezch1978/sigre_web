package pe.restaurant.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProgramacionComprasDetResponse {

    private Long id;
    private Long articuloId;
    private BigDecimal cantidad;
    private BigDecimal precioEstimado;
}
