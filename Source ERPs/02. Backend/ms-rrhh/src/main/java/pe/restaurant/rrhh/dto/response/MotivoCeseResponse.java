package pe.restaurant.rrhh.dto.response;

import lombok.Data;
import java.time.OffsetDateTime;

@Data
public class MotivoCeseResponse {
    private Long id;
    private String codigo;
    private String nombre;
    private String flagEstado;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private OffsetDateTime fecModificacion;
}
