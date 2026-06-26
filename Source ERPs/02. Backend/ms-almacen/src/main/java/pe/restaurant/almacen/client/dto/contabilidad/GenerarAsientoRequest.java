package pe.restaurant.almacen.client.dto.contabilidad;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * Payload ms-almacen → ms-contabilidad para generar el pre-asiento por concepto financiero (Ruta B).
 * Coincide con {@code pe.restaurant.contabilidad.dto.request.GenerarAsientoRequest}.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GenerarAsientoRequest {

    private Long documentoId;
    private LocalDate fecha;
    private Long sucursalId;
    private Integer ano;
    private Integer mes;
    private Long cntblLibroId;
    private Long monedaId;
    private BigDecimal tipoCambio;
    private BigDecimal total;
    private String glosa;
    private List<DocumentoDetalleRequest> detalles;
}
