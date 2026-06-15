package com.sigre.auth.dto.seguridad;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OpcionMenuDto {
    private Long id;
    private Long moduloId;
    private String codigo;
    private String nombre;
    private String rutaFrontend;
    private Long opcionPadreId;
    private Integer orden;
    private Boolean activo;
}
