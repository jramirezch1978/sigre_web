package com.sigre.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class EntidadContribuyenteRepresentanteResponse {
    private Long id;
    private Long entidadContribuyenteId;
    private Short item;
    private String nombre;
    private String cargo;
    private String telefono;
    private String email;
    private String flagEstado;
}
