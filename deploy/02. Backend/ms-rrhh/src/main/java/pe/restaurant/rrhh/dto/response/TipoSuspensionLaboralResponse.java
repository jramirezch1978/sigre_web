package pe.restaurant.rrhh.dto.response;

import lombok.Data;
import java.time.OffsetDateTime;

@Data
public class TipoSuspensionLaboralResponse {

    private Long id;
    private String codigo;
    private String nombre;
    private String flagTipoSusp;
    private Long tipoSubsidioId;
    private String flagCitt;
    private String flagEstado;
    private String createdBy;
    private OffsetDateTime fecCreacion;
    private String updatedBy;
    private OffsetDateTime fecModificacion;
}
