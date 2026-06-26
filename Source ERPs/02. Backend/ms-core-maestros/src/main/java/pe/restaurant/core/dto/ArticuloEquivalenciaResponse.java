package pe.restaurant.core.dto;

import lombok.*;
import java.math.BigDecimal;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class ArticuloEquivalenciaResponse {
    private Long id;
    private Long articuloId;
    private Long articuloEquivalenteId;
    private BigDecimal factor;
    private String flagEstado;
}
