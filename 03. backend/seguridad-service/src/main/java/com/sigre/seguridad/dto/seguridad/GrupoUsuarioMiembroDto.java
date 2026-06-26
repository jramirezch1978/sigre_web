package com.sigre.seguridad.dto.seguridad;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/** Usuario miembro de un grupo (auth.grupo_usuario_det + datos del usuario). */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class GrupoUsuarioMiembroDto {
    private Long id;
    private Long grupoUsuarioId;
    private Long usuarioId;
    private String nombreCompleto;
    private String username;
    private String email;
    private Boolean activo;
}
