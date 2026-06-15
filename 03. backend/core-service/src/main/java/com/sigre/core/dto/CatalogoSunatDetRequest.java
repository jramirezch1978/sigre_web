package com.sigre.core.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CatalogoSunatDetRequest {

    @NotNull
    private Long catalogoSunatId;

    @NotBlank
    @Size(max = 30)
    private String codigoItem;

    @NotBlank
    @Size(max = 500)
    private String nombreItem;

    private String descripcionItem;

    private String flagEstado = "1";
}
