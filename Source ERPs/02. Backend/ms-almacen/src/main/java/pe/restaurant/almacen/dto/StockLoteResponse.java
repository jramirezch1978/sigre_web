package pe.restaurant.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StockLoteResponse {

    private Long id;
    private Long almacenId;
    private Long articuloId;
    private Long lotePalletId;
    private BigDecimal cantidadTotal;
    private BigDecimal saldo;
    private BigDecimal costoPromedio;
    private OffsetDateTime ultimaActualizacion;
}
