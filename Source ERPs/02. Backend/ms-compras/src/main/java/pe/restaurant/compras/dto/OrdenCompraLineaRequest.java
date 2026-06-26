package pe.restaurant.compras.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
public class OrdenCompraLineaRequest {

    private Long id;

    @NotNull
    private Long articuloId;

    @NotNull
    @DecimalMin("0.0001")
    private BigDecimal cantProyectada;

    private LocalDate fecProyectada;

    @NotNull
    @DecimalMin("0.0001")
    private BigDecimal valorUnitario;

    private Long tipoImpuestoId;

    private BigDecimal valorImpuesto;

    private BigDecimal descuentoPorcentaje;

    private Long tipoPercepcionId;

    private Long centrosCostoId;

    private Long almacenId;

    private Long referenciaSolCompraId;

    @NotNull
    private LocalDate fechaEntrega;

    private Long operacionesDetId;

    private Long progComprasDetId;
}
