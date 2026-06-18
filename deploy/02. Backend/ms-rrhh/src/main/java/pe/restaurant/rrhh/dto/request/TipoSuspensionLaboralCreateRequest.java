package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class TipoSuspensionLaboralCreateRequest {

    @NotBlank(message = "El código del tipo de suspensión es obligatorio.")
    @Size(max = 10)
    private String codigo;

    @NotBlank(message = "El nombre del tipo de suspensión es obligatorio.")
    @Size(max = 150)
    private String nombre;

    private String flagTipoSusp;
    private Long tipoSubsidioId;
    private String flagCitt;
}
