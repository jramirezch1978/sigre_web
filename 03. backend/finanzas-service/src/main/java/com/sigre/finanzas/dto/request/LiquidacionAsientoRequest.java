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
public class LiquidacionAsientoRequest {

    private Long id;
    private Long solicitudGiroId;
    private Long sucursalId;
    private Long proveedorId;
    private LocalDate fechaRegistro;
    private Long monedaId;
    private Long conceptoFinancieroId;
    private BigDecimal importeNeto;
    private BigDecimal tasaCambio;
    private Integer ano;
    private Integer mes;
    private Long cntblLibroId;
    private String observacion;
    private List<LiquidacionDetAsientoRequest> detalles;
}
