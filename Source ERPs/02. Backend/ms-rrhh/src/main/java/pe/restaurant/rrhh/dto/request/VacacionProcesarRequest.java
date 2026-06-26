package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;

public record VacacionProcesarRequest(
    @NotNull Integer periodoAnio
) {}
