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
public class CajaBancosAsientoRequest {

    private Long id;
    private Long sucursalId;
    private LocalDate fechaEmision;
    private Long monedaId;
    private Long entidadContribuyenteId;
    private BigDecimal impTotal;
    private Long bancoCntaId;
    private Long bancoCntaRefId;
    private Long conceptoFinancieroId;
    private BigDecimal tasaCambio;
    private Integer ano;
    private Integer mes;
    private Long cntblLibroId;
    private String observacion;
    private String flagTipoTransaccion;
    private Long docTipoId;
    private String nroDoc;
    private List<CajaBancosDetAsientoRequest> detalles;
}
