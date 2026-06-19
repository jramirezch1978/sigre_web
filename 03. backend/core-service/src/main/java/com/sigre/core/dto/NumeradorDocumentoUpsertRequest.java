package com.sigre.core.dto;

import jakarta.validation.constraints.Min;
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
public class NumeradorDocumentoUpsertRequest {

    @NotBlank
    @Size(max = 128)
    private String nombreTabla;

    @NotNull
    private Long sucursalId;

    @NotNull
    private Integer ano;

    @NotNull
    @Min(1)
    private Long ultNro;

    private String flagEstado = "1";
}
