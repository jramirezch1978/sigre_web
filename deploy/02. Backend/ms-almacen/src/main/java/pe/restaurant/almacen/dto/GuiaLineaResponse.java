package pe.restaurant.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GuiaLineaResponse {
    private Long id;
    private Long valeMovId;
    private Long articuloId;
    private Long unidadMedidaId;
    private BigDecimal cantidad;
    private String flagEstado;
}
