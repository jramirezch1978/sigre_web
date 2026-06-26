package pe.restaurant.finanzas.dto.request;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@Builder
public class LiquidacionDetAsientoRequest {

    private Long id;
    private Integer item;
    private Long conceptoFinancieroId;
    private Long cntasPagarId;
    private Long cntasCobrarId;
    private Long centrosCostoId;
    private Long monedaId;
    private BigDecimal importe;
    private BigDecimal importeRetenido;
    private String glosa;
}
