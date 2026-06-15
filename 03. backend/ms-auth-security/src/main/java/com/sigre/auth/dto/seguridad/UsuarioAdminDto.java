package com.sigre.auth.dto.seguridad;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UsuarioAdminDto {
    private Long id;
    private String email;
    private String username;
    private String nombres;
    private String apellidos;
    private String nombreCompleto;
    private Boolean activo;
    private Boolean bloqueado;
    private Boolean flagAdminSistema;
    private OffsetDateTime fecCreacion;
}
