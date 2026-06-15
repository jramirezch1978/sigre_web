package com.sigre.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CatalogoSunatDetResponse {
    private Long id;
    private String catalog;
    private String codigo;
    private String nombre;
    private String descripcion;
    private String flagEstado;  // "1" = activo, "0" = inactivo
}
