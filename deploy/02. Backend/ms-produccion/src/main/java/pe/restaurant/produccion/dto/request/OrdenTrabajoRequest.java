package pe.restaurant.produccion.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrdenTrabajoRequest {

    private String codigo;

    @NotNull(message = "La sucursal es requerida")
    private Long sucursalId;

    @NotNull(message = "El tipo de OT es requerido")
    private Long otTipoId;

    @NotNull(message = "La administración de OT es requerida")
    private Long otAdministracionId;

    @NotNull(message = "La fecha de inicio es requerida")
    private LocalDate fechaInicio;

    @NotNull(message = "La fecha de fin es requerida")
    private LocalDate fechaFin;
}
