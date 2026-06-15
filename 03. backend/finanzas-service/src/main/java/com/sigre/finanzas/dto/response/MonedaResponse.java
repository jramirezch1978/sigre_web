package com.sigre.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MonedaResponse {
    private Long id;
    private String codigo;
    private String nombre;
    private String simbolo;
    private String flagEstado;  // "1" = activo, "0" = inactivo
}
