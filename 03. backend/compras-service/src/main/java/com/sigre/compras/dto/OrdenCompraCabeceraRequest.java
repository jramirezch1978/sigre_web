package com.sigre.compras.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class OrdenCompraCabeceraRequest {

    @NotNull
    private Long sucursalId;

    @NotNull
    private Long proveedorId;

    private Long docTipoId;

    @NotNull
    private LocalDate fechaEmision;

    private LocalDate fechaEntrega;

    @NotNull
    private Long monedaId;

    private Long formaPagoId;

    private Long entidadBancoCntaId;

    private String lugarEntrega;

    private String observaciones;

    private BigDecimal tipoCambio;

    private Boolean flagImportacion;

    private Boolean flagSolicitaDua;

    private String centroBeneficio;

    @NotEmpty
    @Valid
    private List<OrdenCompraLineaRequest> lineas;

    private OcImportacionRequest importacion;
}
