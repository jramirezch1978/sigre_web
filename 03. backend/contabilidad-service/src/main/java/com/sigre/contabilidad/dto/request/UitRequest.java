package com.sigre.contabilidad.dto.request;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
public class UitRequest {

    @NotNull
    private Integer ano;

    @NotNull
    @DecimalMin(value = "0")
    private BigDecimal importe;

    @NotNull
    private LocalDate fecIniVigen;

    @Size(max = 1)
    private String flagEstado;
}
