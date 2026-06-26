package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;

public record ProcesarPeriodoRequest(
    @NotNull LocalDate fechaDesde,
    @NotNull LocalDate fechaHasta
) {}
