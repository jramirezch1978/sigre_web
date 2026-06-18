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
public class OrdenVentaDetLineRequest {

    @NotNull
    private Long articuloId;

    private Integer lineaNro;

    @NotNull
    private BigDecimal cantProyectada;

    @NotNull
    private BigDecimal valorUnitario;

    private Long tiposImpuestoId;

    private BigDecimal valorImpuesto;

    private Long almacenId;
}
