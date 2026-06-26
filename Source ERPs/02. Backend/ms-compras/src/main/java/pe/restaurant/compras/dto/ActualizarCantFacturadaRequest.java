package pe.restaurant.compras.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

/**
 * Request para actualizar cant_facturada en líneas de orden de compra.
 * Utilizado por ms-finanzas al registrar una factura vinculada a una OC.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ActualizarCantFacturadaRequest {

    @NotNull(message = "La lista de líneas es obligatoria")
    private List<LineaCantFacturada> lineas;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class LineaCantFacturada {

        @NotNull(message = "El ID del detalle de OC es obligatorio")
        private Long ordenCompraDetId;

        @NotNull(message = "La cantidad facturada es obligatoria")
        @Positive(message = "La cantidad facturada debe ser mayor a cero")
        private BigDecimal cantidad;
    }
}
