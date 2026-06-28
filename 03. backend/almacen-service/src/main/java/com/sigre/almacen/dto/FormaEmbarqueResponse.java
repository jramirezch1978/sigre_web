package com.sigre.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class FormaEmbarqueResponse {

    private Long id;
    private String formaEmbarque;
    private String descripcion;
    private String flagEstado;
}
