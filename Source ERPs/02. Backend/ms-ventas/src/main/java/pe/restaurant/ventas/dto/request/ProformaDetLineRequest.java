package pe.restaurant.ventas.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProformaDetLineRequest {

    @NotNull
    private Long articuloId;

    private String descripcion;

    @NotNull
    private BigDecimal cantidad;

    @NotNull
    private BigDecimal precioUnitario;

    private BigDecimal descuento;
}
