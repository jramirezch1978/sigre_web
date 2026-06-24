package com.sigre.rrhh.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class CntaCrrteCreateRequest {
    @NotNull private Long trabajadorId;
    @NotNull private Long docTipoId;
    @NotBlank private String nroDoc;
    @NotNull private Long conceptoPlanillaId;
    @NotNull private LocalDate fecPrestamo;
    private Long cntasPagarId;
    private Long cntasCobrarId;
    private LocalDate fechaInicioDescuento;
    private Short nroCuotas;
    private BigDecimal montoOriginal;
    private BigDecimal montoCuota;
    private Long monedaId;
    private Long entidadContribuyenteId;
}
