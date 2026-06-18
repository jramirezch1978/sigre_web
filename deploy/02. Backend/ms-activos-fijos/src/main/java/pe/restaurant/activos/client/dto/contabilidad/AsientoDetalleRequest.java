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
public class AsientoDetalleRequest {

    private Long planContableDetId;
    private Long centrosCostoId;
    private Long entidadContribuyenteId;
    private String glosaDetalle;
    private BigDecimal debe;
    private BigDecimal haber;
    private String referencia;
}
