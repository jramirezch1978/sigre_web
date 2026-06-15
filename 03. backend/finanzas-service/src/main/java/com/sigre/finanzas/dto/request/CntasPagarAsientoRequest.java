package com.sigre.finanzas.dto.request;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@Builder
public class CntasPagarAsientoRequest {

    private Long id;
    private Long sucursalId;
    private Long proveedorId;
    private Long docTipoId;
    private String serie;
    private String numero;
    private LocalDate fechaEmision;
    private Long monedaId;
    private BigDecimal total;
    private BigDecimal saldo;
    private BigDecimal tasaCambio;
    private Integer ano;
    private Integer mes;
    private Long cntblLibroId;
    private String glosa;
    private List<CntasPagarDetAsientoRequest> detalles;
}
