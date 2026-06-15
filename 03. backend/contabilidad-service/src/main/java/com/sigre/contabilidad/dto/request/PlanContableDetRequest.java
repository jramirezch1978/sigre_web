package com.sigre.contabilidad.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PlanContableDetRequest {

    private Long planContableId;

    @NotBlank
    @Size(max = 10)
    private String cntaCtbl;

    @NotBlank
    @Size(max = 200)
    private String descCnta;

    @NotNull
    private Integer nivCnta;

    @Pattern(regexp = "[01]")
    private String flagCencos;

    @Pattern(regexp = "[01]")
    private String flagCodRelacion;

    @Pattern(regexp = "[01]")
    private String flagDocRef;

    @Pattern(regexp = "[01]")
    private String flagPermiteMov;

    @Pattern(regexp = "[01]")
    private String flagCtabco;

    @Pattern(regexp = "[DHA]")
    private String flagTipoSaldo;

    @Size(max = 10)
    private String cntaCntblSunat;

    @Size(max = 1)
    private String flagEstado;
}
