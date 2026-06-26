package pe.restaurant.activos.client.dto.contabilidad;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

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
