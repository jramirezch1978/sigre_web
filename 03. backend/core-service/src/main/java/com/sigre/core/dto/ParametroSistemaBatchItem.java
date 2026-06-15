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
public class ParametroSistemaBatchItem {

    @NotNull(message = "El id es obligatorio para actualización masiva")
    private Long id;

    @NotBlank
    @Size(max = 50)
    private String codigo;

    @NotBlank
    @Size(max = 200)
    private String nombre;

    @Size(max = 30)
    private String modulo;

    @Size(max = 500)
    private String valor;

    @Size(max = 20)
    private String tipoDato;

    private String flagEstado = "1";
}
