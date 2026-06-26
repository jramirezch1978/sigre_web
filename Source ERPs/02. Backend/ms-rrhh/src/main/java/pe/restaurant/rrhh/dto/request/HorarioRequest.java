package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class HorarioRequest {

    @NotNull(message = "El turno es obligatorio")
    private Long turnoId;

    @NotNull(message = "La fecha desde es obligatoria")
    private LocalDate fechaDesde;

    private LocalDate fechaHasta;
}
