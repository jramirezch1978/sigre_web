package com.sigre.seguridad.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PerfilUsuarioUpdateRequest {

    @NotBlank
    @Size(max = 120)
    private String nombres;

    @Size(max = 120)
    private String apellidos;

    @Size(max = 20)
    private String numeroDocumento;

    @NotBlank
    @Email
    @Size(max = 150)
    private String email;

    /** Obligatorio si el email es nuevo o cambió respecto al confirmado. */
    @Size(max = 8)
    private String codigoConfirmacionEmail;
}
