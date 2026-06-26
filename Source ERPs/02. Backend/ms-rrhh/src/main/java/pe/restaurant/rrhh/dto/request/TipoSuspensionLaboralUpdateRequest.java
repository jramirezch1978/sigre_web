package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class TipoSuspensionLaboralUpdateRequest {

    @Size(max = 150)
    private String nombre;

    private String flagTipoSusp;
    private Long tipoSubsidioId;
    private String flagCitt;
    private String flagDatosLesion;
    private String flagEstado;
}
