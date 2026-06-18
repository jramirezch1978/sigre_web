package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.time.LocalDate;

@Data
public class PermisoLicenciaCreateRequest {

    @NotNull(message = "El trabajador es obligatorio.")
    private Long trabajadorId;

    @NotNull(message = "El tipo de suspensión laboral es obligatorio.")
    private Long tipoSuspensionLaboralId;

    @NotNull(message = "La fecha de inicio es obligatoria.")
    private LocalDate fechaInicio;

    private LocalDate fechaFin;
    private Integer dias;
    private String sustento;
}
