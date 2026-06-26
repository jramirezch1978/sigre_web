package pe.restaurant.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.OffsetDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProgramacionComprasDetalleResponse {

    private Long id;
    private Long sucursalId;
    private String numero;
    private Integer anio;
    private Integer mes;
    private String flagEstado;
    private List<ProgramacionComprasDetResponse> lineas;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private OffsetDateTime fecModificacion;
}
