package com.sigre.rrhh.dto.request;

import jakarta.validation.constraints.NotBlank;

public record VacacionObservarRequest(
    @NotBlank String observacion
) {}
