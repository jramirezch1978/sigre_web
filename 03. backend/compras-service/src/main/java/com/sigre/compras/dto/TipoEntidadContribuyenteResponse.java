package com.sigre.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class TipoEntidadContribuyenteResponse {

    private Long id;
    private String tipo;
    private String descripcion;
    private String flagEstado;
}
