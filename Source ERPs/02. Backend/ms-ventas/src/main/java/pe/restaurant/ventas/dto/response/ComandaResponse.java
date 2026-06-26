package pe.restaurant.ventas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ComandaResponse {

    private Long id;
    private Long sucursalId;
    private Long puntoVentaId;
    private Long turnoId;
    private Long clienteId;
    private String mesa;
    private Instant fechaHora;
    private BigDecimal total;
    private String flagEstado;
    private Long createdBy;
    private Instant fecCreacion;
    private Long updatedBy;
    private Instant fecModificacion;
    private List<ComandaDetResponse> items;
}
