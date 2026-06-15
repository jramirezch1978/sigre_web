package com.sigre.core.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class FormaPagoRequest {

    @NotBlank
    @Size(max = 20)
    private String codigo;

    @NotBlank
    @Size(max = 120)
    private String nombre;

    @NotBlank
    @Pattern(regexp = "CONTADO|CREDITO", message = "tipo debe ser CONTADO o CREDITO")
    private String tipo;

    private String flagEstado = "1";
}
