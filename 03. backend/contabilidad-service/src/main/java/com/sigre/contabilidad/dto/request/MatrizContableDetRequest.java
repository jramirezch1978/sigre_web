package com.sigre.contabilidad.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MatrizContableDetRequest {

    private Integer secuencia;

    private Long planContableDetId;

    @NotBlank
    @Pattern(regexp = "[DH]")
    private String flagDebHab;

    @Size(max = 60)
    private String referenciaCampo;

    @Size(max = 30)
    private String campo;

    @Size(max = 500)
    private String formula;

    @Size(max = 500)
    private String glosaTexto;

    @Size(max = 500)
    private String glosaCampo;

    @Size(max = 1)
    private String flagCencos;

    @Size(max = 1)
    private String flagCtabco;

    @Size(max = 1)
    private String flagDocref;
}
