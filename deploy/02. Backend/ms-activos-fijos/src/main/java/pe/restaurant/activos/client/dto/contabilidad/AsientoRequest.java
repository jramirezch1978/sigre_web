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
public class AsientoRequest {

    private Long libroId;
    private LocalDate fecha;
    private String tipo;
    private BigDecimal tc;
    private String glosa;
    private String moduloOrigen;
    private Long documentoOrigenId;
    private Long monedaId;
    private List<AsientoDetalleRequest> detalles;
}
