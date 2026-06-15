package com.sigre.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class DetraccionResponse {

    private Long id;
    private Long cntasPagarId;
    private String cntasPagarNumero;
    private String nroDetraccion;
    private LocalDate fechaRegistro;
    private String nroDeposito;
    private LocalDate fechaDeposito;
    private String codUsr;
    private BigDecimal importe;
    private String flagTabla;
    private String orgCajaBanc;
    private Long nroRegCajaBanc;
    private String tipoDocCxc;
    private String nroDocCxc;
    private String flagEstado;
    private Long createdBy;
    private Instant fecCreacion;
    private Long updatedBy;
    private Instant fecModificacion;
}
