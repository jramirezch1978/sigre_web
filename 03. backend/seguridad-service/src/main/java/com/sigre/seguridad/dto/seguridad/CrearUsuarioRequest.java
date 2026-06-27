package com.sigre.seguridad.dto.seguridad;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CrearUsuarioRequest {

    @NotBlank @Email @Size(max = 150)
    private String email;

    @NotBlank @Size(max = 50)
    private String username;

    @NotBlank @Size(min = 6, max = 255)
    private String password;

    @NotBlank @Size(max = 100)
    private String nombres;

    @NotBlank @Size(max = 100)
    private String apellidos;

    private Boolean flagAdminSistema = false;

    /** Perfil de licencias: 'LICENSING', 'SALES' o vacío/null para ninguno. */
    @Size(max = 10)
    private String tipoSales;
}
