package com.sigre.auth.dto.seguridad;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ActualizarUsuarioRequest {

    @Email @Size(max = 150)
    private String email;

    @Size(max = 50)
    private String username;

    @Size(max = 100)
    private String nombres;

    @Size(max = 100)
    private String apellidos;

    private Boolean activo;

    private Boolean bloqueado;

    private Boolean flagAdminSistema;
}
