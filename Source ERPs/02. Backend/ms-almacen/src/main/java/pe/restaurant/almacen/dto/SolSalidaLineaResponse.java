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
public class SolSalidaLineaResponse {
    private Long id;
    private Long articuloId;
    private BigDecimal cantidad;
    private BigDecimal cantidadDespachada;
}
