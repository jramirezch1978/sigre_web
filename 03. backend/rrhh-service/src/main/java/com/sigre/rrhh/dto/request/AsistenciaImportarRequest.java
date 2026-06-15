package com.sigre.rrhh.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public record AsistenciaImportarRequest(
    @NotEmpty List<@Valid AsistenciaImportRow> registros
) {
    public record AsistenciaImportRow(
        Long trabajadorId,
        LocalDate fecha,
        LocalTime horaEntrada,
        LocalTime horaSalida,
        Long tipoMovAsistenciaId
    ) {}
}
