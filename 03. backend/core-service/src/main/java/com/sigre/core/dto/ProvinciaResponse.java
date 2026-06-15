package com.sigre.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ProvinciaResponse {
    private Long id;
    private Long departamentoId;
    private String codigo;
    private String nombre;
    private String flagEstado;
}
