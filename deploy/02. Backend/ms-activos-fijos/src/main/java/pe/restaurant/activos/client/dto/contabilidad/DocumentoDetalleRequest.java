package pe.restaurant.activos.client.dto.contabilidad;

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
    private BigDecimal monto;
    private Long centrosCostoId;
    private String referencia;
    private String glosa;
}
