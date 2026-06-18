package pe.restaurant.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

/**
 * Valorización económica del stock por artículo/almacén:
 * {@code valorTotal = cantidadDisponible * costoPromedio}.
 * Fuente: {@code almacen.articulo_almacen}.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ValorizacionResponse {

    private Long almacenId;
    private Long articuloId;
    private String articuloCodigo;
    private String articuloNombre;
    private BigDecimal cantidadDisponible;
    private BigDecimal costoPromedio;
    private BigDecimal valorTotal;
    private OffsetDateTime ultimaActualizacion;
}
