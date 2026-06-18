package pe.restaurant.rrhh.dto.response;

import lombok.Data;
import java.time.OffsetDateTime;

@Data
public class TipoSubsidioResponse {
    private Long id;
    private String codigo;
    private String nombre;
    private Integer nroDias;
    private String flagEstado;
    private String createdBy;
    private OffsetDateTime fecCreacion;
    private String updatedBy;
    private OffsetDateTime fecModificacion;
}
