package com.sigre.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CompradorResponse {
    private Long id;
    private Long usuarioId;
    private String nombre;
    private String flagEstado;
}
