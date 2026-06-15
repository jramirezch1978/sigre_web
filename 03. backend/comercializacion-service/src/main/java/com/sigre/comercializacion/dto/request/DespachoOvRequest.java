package com.sigre.comercializacion.dto.request;

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
public class DespachoOvRequest {

    @NotNull
    private Long articuloMovTipoId;

    @NotNull
    private Long almacenId;

    private LocalDate fechaMov;

    private String observaciones;
}
