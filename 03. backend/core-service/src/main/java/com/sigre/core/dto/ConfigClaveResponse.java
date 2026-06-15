package com.sigre.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ConfigClaveResponse {
    private String clave;
    private String modulo;
    private String nivel;
    private String descripcion;
    private String tipoDato;
    private String flagEstado;
}
