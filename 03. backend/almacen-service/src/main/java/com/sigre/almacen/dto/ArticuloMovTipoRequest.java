package com.sigre.almacen.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ArticuloMovTipoRequest {

    @NotBlank
    @Size(max = 10)
    private String tipoMov;

    @NotBlank
    @Size(max = 200)
    private String descTipoMov;

    @Size(max = 40)
    private String cntaCntbl;

    @Size(max = 1)
    private String flagContabiliza;

    @Size(max = 1)
    private String flagAjusteValorizacion;

    @Size(max = 1)
    private String flagMovEntreAlm;

    @Size(max = 1)
    private String flagSolicitaProv;

    @Size(max = 1)
    private String flagSolicitaDocInt;

    @Size(max = 1)
    private String flagSolicitaDocExt;

    @Size(max = 1)
    private String flagSolicitaRef;

    private BigDecimal factorSldoTotal;
    private BigDecimal factorSldoXLlegar;
    private BigDecimal factorSldoSol;
    private BigDecimal factorSldoDev;
    private BigDecimal factorSldoPres;
    private BigDecimal factorSldoConsig;
    private BigDecimal factorCtrlTempla;

    @Size(max = 1)
    private String flagClaseMov;

    @Size(max = 1)
    private String flagSolicitaLote;

    @Size(max = 1)
    private String flagEstado;

    @Size(max = 1)
    private String flagSolicitaPrecio;

    @Size(max = 10)
    private String tipoMovDev;

    @Size(max = 1)
    private String flagAmp;

    private BigDecimal factorSldoReservado;

    @Size(max = 1)
    private String flagSolicitaCenbef;

    @Size(max = 1)
    private String flagCntrlCtaCte;

    @Size(max = 1)
    private String flagCambiaPrecio;

    @Size(max = 10)
    private String codSunat;
}
