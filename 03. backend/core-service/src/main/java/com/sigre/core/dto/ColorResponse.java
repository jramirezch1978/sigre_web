package com.sigre.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ColorResponse {
    private Long id;
    private String codigo;
    private String nombre;
    private String flagEstado;
}
