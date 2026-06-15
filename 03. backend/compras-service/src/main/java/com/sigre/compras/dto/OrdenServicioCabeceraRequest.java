package com.sigre.compras.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class OrdenServicioCabeceraRequest {

    @NotNull
    private Long sucursalId;

    @NotBlank
    @Size(max = 10)
    private String codOrigen;

    @NotNull
    private Long proveedorId;

    private String nomVendedor;

    private Long docTipoId;

    @NotNull
    private LocalDate fecRegistro;

    @NotNull
    private Long monedaId;

    private BigDecimal tipoCambio;

    private Long formaPagoId;

    private String flagReqServ = "0";

    private Boolean flagSolicitaActa;

    private Long ordenTrabajoId;

    private String descripcion;

    @NotEmpty
    @Valid
    private List<OrdenServicioLineaRequest> lineas;
}
