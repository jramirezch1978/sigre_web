package com.sigre.rrhh.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public record GanDescVariableImportarRequest(
    @NotEmpty List<@Valid GanDescVariableRow> registros
) {
    public record GanDescVariableRow(
        Long trabajadorId,
        LocalDate fecMovim,
        Long conceptoId,
        BigDecimal impVar,
        Long tipoPlanillaId
    ) {}
}
