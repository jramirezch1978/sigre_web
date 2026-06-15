package com.sigre.comercializacion.client.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CntasCobrarAsientoRequest {

    private Long id;
    private Long sucursalId;
    private Long clienteId;
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
    private List<CntasCobrarDetAsientoRequest> detalles;
}
