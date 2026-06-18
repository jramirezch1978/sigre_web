package pe.restaurant.rrhh.dto.response;

import lombok.Data;
import java.time.OffsetDateTime;

@Data
public class TipoConceptoCalculoResponse {
    private Long id;
    private String codigo;
    private String nombre;
    private String flagEstado;
    private String createdBy;
    private OffsetDateTime fecCreacion;
    private String updatedBy;
    private OffsetDateTime fecModificacion;
}
