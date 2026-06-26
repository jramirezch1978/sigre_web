package pe.restaurant.compras.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * Request para ajustar stock desde una nota de crédito/débito vinculada a OC.
 * Sin DDL: usa los movimientos de almacén existentes.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AjusteStockRequest {

    @NotNull(message = "El ID del detalle de OC es obligatorio")
    private Long ordenCompraDetId;

    @NotNull(message = "La cantidad es obligatoria")
    @Positive(message = "La cantidad debe ser mayor a cero")
    private BigDecimal cantidad;

    @NotNull(message = "El tipo de ajuste es obligatorio")
    private String tipoAjuste; // "INGRESO" o "SALIDA"

    private Long almacenId;
}
