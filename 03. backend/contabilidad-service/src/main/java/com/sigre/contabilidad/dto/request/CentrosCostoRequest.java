package com.sigre.contabilidad.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CentrosCostoRequest {

    private Long cencosNiv3Id;

    @NotBlank
    @Size(max = 30)
    private String cencos;

    @NotBlank
    @Size(max = 200)
    private String descCencos;

    @Size(max = 1)
    private String flagEstado;
}
