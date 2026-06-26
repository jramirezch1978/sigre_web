package pe.restaurant.activos.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfTrasladoRequest {

    @NotNull(message = "El ID del activo maestro es requerido")
    private Long afMaestroId;

    private Long ubicacionOrigenId;

    private Long ubicacionDestinoId;

    private Long solicitanteId;

    private Long aprobadorId;

    @NotNull(message = "La fecha de solicitud es requerida")
    private LocalDate fechaSolicitud;

    private LocalDate fechaEjecucion;

    @Size(max = 5000, message = "El motivo no puede exceder 5000 caracteres")
    private String motivo;
}
