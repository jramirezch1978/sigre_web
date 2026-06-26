package pe.restaurant.compras.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * Request para ajustar la cantidad proyectada de una línea de OC.
 * Sin DDL: usa el campo existente cant_proyectada para soportar
 * recepción de cantidad mayor a la proyectada originalmente.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AjustarCantidadOcRequest {

    @NotNull(message = "El ID del detalle de OC es obligatorio")
    private Long ordenCompraDetId;

    @NotNull(message = "La nueva cantidad proyectada es obligatoria")
    @Positive(message = "La cantidad debe ser mayor a cero")
    private BigDecimal nuevaCantidad;
}
