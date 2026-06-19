package com.sigre.almacen.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class LotePalletRequest extends FlagEstadoRequest {

    @NotNull private Long almacenId;
    @NotNull private Long articuloId;

    @NotBlank
    @Size(max = 40)
    private String nroLote;

    private LocalDate fechaProduccion;
    private LocalDate fechaVencimiento;

    @Size(max = 1000)
    private String observacion;
}
