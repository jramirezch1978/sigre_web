package pe.restaurant.almacen.client.dto.contabilidad;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * Línea del pre-asiento enviada a ms-contabilidad. El {@code conceptoFinancieroId} es obligatorio
 * del lado de contabilidad (resuelve la matriz contable). Coincide con
 * {@code pe.restaurant.contabilidad.dto.request.DocumentoDetalleRequest}.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DocumentoDetalleRequest {

    private Long id;
    private Integer item;
    private BigDecimal monto;
    private Long monedaId;
    private Long conceptoFinancieroId;
    private Long centrosCostoId;
    private String glosa;
}
