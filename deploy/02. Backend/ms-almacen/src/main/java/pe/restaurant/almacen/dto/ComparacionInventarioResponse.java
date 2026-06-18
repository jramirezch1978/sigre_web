package pe.restaurant.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Comparación físico vs sistema, derivada de {@code almacen.inventario_conteo}:
 * saldo del sistema vs conteo físico, con la diferencia y su valorización.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ComparacionInventarioResponse {

    private Long id;
    private Long almacenId;
    private Long articuloId;
    private String articuloCodigo;
    private String articuloNombre;
    private LocalDate fechaConteo;
    private BigDecimal saldoSistema;
    private BigDecimal cantidadConteo;
    private BigDecimal diferencia;
    private BigDecimal costoUnitario;
    private BigDecimal diferenciaValorizada;
    private String flagEstado;
}
