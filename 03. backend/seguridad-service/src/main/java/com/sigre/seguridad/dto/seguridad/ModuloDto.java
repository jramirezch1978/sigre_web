package com.sigre.seguridad.dto.seguridad;

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
public class ModuloDto {
    private Long id;
    private String codigo;
    private String nombre;
    private Boolean activo;
}
