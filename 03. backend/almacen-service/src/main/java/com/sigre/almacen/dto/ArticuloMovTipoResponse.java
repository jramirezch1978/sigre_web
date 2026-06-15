package com.sigre.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ArticuloMovTipoResponse {

    private Long id;
    private String tipoMov;
    private String descTipoMov;
    private String cntaCntbl;
    private String flagContabiliza;
    private String flagAjusteValorizacion;
    private String flagMovEntreAlm;
    private String flagSolicitaProv;
    private String flagSolicitaDocInt;
    private String flagSolicitaDocExt;
    private String flagSolicitaRef;
    private BigDecimal factorSldoTotal;
    private BigDecimal factorSldoXLlegar;
    private BigDecimal factorSldoSol;
    private BigDecimal factorSldoDev;
    private BigDecimal factorSldoPres;
    private BigDecimal factorSldoConsig;
    private BigDecimal factorCtrlTempla;
    private String flagClaseMov;
    private String flagSolicitaLote;
    private String flagEstado;
    private String flagSolicitaPrecio;
    private String tipoMovDev;
    private String flagAmp;
    private BigDecimal factorSldoReservado;
    private String flagSolicitaCenbef;
    private String flagCntrlCtaCte;
    private String flagCambiaPrecio;
    private String codSunat;
}
