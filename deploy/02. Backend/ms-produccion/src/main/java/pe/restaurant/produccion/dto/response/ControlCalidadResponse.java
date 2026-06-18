package pe.restaurant.produccion.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ControlCalidadResponse {

    private Long id;

    private Long ordenTrabajoId;
    private String ordenTrabajoCodigo;
    private Long inspectorId;
    private String inspectorNombre;
    private LocalDate fecha;
    private String resultado;
    private String observaciones;

    private Long createdBy;
    private Instant fecCreacion;
    private Long updatedBy;
    private Instant fecModificacion;
}
