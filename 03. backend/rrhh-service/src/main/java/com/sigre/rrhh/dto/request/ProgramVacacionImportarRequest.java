package com.sigre.rrhh.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import java.util.List;

public record ProgramVacacionImportarRequest(
    @NotNull Integer anio,
    @NotEmpty List<@Valid ProgramVacacionImportRow> registros
) {
    public record ProgramVacacionImportRow(
        Long trabajadorId,
        Integer mes,
        Integer diasProgramados,
        String observacion
    ) {}
}
