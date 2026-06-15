package com.sigre.compras.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class TipoEntidadContribuyenteRequest {

    @NotBlank
    @Size(max = 30)
    private String tipo;

    @NotBlank
    @Size(max = 200)
    private String descripcion;
}
