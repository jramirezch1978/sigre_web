package pe.restaurant.finanzas.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ItemCalculoRequest {

    @NotNull(message = "El número de ítem es obligatorio")
    private Integer item;

    @NotNull(message = "El valor unitario es obligatorio")
    private BigDecimal valorUnitario;

    @NotNull(message = "La cantidad es obligatoria")
    @Positive(message = "La cantidad debe ser mayor a cero")
    private BigDecimal cantidad;

    private Boolean valorConIgv = true;

    private BigDecimal descuento = BigDecimal.ZERO;

    private String dsctoTipo = "$";

    private List<ImpuestoItemRequest> impuestos;

    private DetraccionItemRequest detraccion;
}
