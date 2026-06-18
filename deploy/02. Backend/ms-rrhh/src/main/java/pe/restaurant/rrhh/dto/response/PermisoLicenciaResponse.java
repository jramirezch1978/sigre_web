package pe.restaurant.rrhh.dto.response;

import lombok.Data;
import java.time.LocalDate;
import java.time.OffsetDateTime;

@Data
public class PermisoLicenciaResponse {

    private Long id;
    private Long trabajadorId;
    private Long tipoSuspensionLaboralId;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private Integer dias;
    private String sustento;
    private String flagEstado;
    private String createdBy;
    private OffsetDateTime fecCreacion;
    private String updatedBy;
    private OffsetDateTime fecModificacion;
}
