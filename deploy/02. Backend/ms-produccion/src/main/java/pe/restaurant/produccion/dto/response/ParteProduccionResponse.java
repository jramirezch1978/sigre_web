package pe.restaurant.produccion.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ParteProduccionResponse {

    private Long id;

    private Long ordenTrabajoId;
    private String ordenTrabajoCodigo;

    private LocalDate fecha;
    private Long turnoId;
    private String flagEstado;

    private List<ParteInsumoResponse> insumos;
    private List<ParteProducidoResponse> producidos;

    private Long createdBy;
    private Instant fecCreacion;
    private Long updatedBy;
    private Instant fecModificacion;
}
