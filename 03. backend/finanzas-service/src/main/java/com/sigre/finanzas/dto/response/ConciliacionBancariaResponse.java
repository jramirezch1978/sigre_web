package com.sigre.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ConciliacionBancariaResponse {

    private Long id;
    private Long bancoCntaId;
    private String bancoCntaCodigo;
    private Integer periodoAnio;
    private Integer periodoMes;
    private BigDecimal saldoBanco;
    private BigDecimal saldoLibros;
    private BigDecimal diferencia;
    private List<ConciliacionDetResponse> detalles;
    private String flagEstado;
    private Long createdBy;
    private Instant fecCreacion;
    private Long updatedBy;
    private Instant fecModificacion;
}
