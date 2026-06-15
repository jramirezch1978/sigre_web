package com.sigre.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PaisResponse {
    private Long id;
    private String codigo;
    private String nombre;
    private Long monedaId;
    private String formatoFecha;
    private String zonaHoraria;
    private String flagEstado;
}
