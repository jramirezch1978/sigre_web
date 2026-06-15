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
public class RolDto {
    private Long id;
    private Long empresaId;
    private String codigo;
    private String nombre;
    private Boolean esAdmin;
    private Boolean activo;
}
