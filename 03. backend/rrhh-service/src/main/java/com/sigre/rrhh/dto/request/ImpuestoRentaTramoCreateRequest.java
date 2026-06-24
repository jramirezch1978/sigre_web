package com.sigre.rrhh.dto.request;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class ImpuestoRentaTramoCreateRequest {

    @NotNull
    private Integer secuencia;

    @NotNull
    @DecimalMin(value = "0.00", message = "La tasa no puede ser negativa.")
    @Digits(integer = 3, fraction = 2)
    private BigDecimal tasa;

    @NotNull
    @Digits(integer = 11, fraction = 2)
    private BigDecimal topeIni;

    @NotNull
    @Digits(integer = 11, fraction = 2)
    private BigDecimal topeFin;

    @NotNull
    private LocalDate fechaVigIni;

    private LocalDate fechaVigFin;

    @Size(max = 6)
    private String codUsr;

    @Size(max = 1)
    private String flagReplicacion;
}
