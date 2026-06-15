package com.sigre.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class EntidadTiendaResponse {
    private Long id;
    private Long entidadContribuyenteId;
    private String codigo;
    private String nombre;
    private String direccion;
    private String flagEstado;
}
