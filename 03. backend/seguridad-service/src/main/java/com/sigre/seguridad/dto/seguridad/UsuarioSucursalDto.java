package com.sigre.seguridad.dto.seguridad;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UsuarioSucursalDto {

    private Long id;
    private Long usuarioId;
    private Long sucursalId;
    private Boolean activo;
}
