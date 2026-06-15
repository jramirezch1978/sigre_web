package com.sigre.contabilidad.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UitResponse {

    private Long id;
    private Integer ano;
    private BigDecimal importe;
    private LocalDate fecIniVigen;
    private String flagEstado;
}
