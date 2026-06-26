package pe.restaurant.ventas.client.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DocumentoDetalleRequest {
    private Long id;
    private Integer item;
    private String tipoMov;
    private BigDecimal monto;
    private BigDecimal importeRetenido;
    private String referencia;
    private Long monedaId;
    private Long conceptoFinancieroId;
    private Long cntasPagarId;
    private Long cntasCobrarId;
    private Long centrosCostoId;
    private String codFlujoFaja;
    private String glosa;
}

