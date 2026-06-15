package com.sigre.contabilidad.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PlanContableDetResponse {

    private Long id;
    private Long planContableId;
    private String cntaCtbl;
    private String nombre;
    private Integer nivCnta;
    private String flagCencos;
    private String flagCodRelacion;
    private String flagDocRef;
    private String flagPermiteMov;
    private String flagCtabco;
    private String flagTipoSaldo;
    private String cntaCntblSunat;
    private String flagEstado;
}
