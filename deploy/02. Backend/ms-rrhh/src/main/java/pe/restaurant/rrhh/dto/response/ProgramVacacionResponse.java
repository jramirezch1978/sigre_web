package pe.restaurant.rrhh.dto.response;

import lombok.Data;
import java.time.OffsetDateTime;

@Data
public class ProgramVacacionResponse {
    private Long id;
    private Long trabajadorId;
    private Integer anio;
    private Integer mes;
    private Integer diasProgramados;
    private String observacion;
    private String flagEstado;
    private String createdBy;
    private OffsetDateTime fecCreacion;
    private String updatedBy;
    private OffsetDateTime fecModificacion;
}
