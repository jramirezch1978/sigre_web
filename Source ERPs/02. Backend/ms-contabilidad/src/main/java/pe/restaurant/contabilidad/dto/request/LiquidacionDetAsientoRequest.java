package pe.restaurant.contabilidad.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
public class LiquidacionDetAsientoRequest {

    private Long id;

    private Integer item;

    @NotNull(message = "El concepto financiero es obligatorio en cada detalle")
    private Long conceptoFinancieroId;

    private Long cntasPagarId;

    private Long cntasCobrarId;

    private Long centrosCostoId;

    private Long monedaId;

    @NotNull(message = "El importe es obligatorio")
    private BigDecimal importe;

    private BigDecimal importeRetenido;

    private String glosa;
}
