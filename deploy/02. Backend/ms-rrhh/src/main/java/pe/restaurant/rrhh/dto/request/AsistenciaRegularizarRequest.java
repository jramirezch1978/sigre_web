package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.NotBlank;
import java.time.LocalTime;

public record AsistenciaRegularizarRequest(
    LocalTime horaEntrada,
    LocalTime horaSalida,
    @NotBlank String motivo
) {}
