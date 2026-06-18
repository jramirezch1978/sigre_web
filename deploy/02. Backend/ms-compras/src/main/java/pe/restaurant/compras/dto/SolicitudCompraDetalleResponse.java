package pe.restaurant.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SolicitudCompraDetalleResponse {

    private Long id;
    private Long sucursalId;
    private String numero;
    private LocalDate fecha;
    private Long solicitanteId;
    private String prioridad;
    private String flagEstado;
    private String justificacion;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private OffsetDateTime fecModificacion;
    private List<SolicitudCompraDetResponse> lineas;
}
