package pe.restaurant.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Stock de un artículo en un almacén a una fecha de corte, reconstruido desde
 * el kardex ({@code almacen.articulo_saldo_mensual}): se toma el saldo del
 * último asiento con fecha &lt;= fecha de corte.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StockAFechaResponse {

    private Long almacenId;
    private Long articuloId;
    private String articuloCodigo;
    private String articuloNombre;
    private LocalDate fechaCorte;
    private LocalDate ultimoMovimiento;
    private BigDecimal cantidad;
    private BigDecimal costoUnitario;
    private BigDecimal valorTotal;
}
