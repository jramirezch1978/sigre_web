package com.sigre.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class NumeradorResponse {
    private Long id;
    private String codigo;
    private String nombre;
    private String serie;
    private Long ultimoNumero;
    private Integer longitud;
    private String flagEstado;
}
