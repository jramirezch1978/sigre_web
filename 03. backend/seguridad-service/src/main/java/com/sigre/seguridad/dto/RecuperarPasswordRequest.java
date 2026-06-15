package com.sigre.seguridad.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RecuperarPasswordRequest {

    @Size(max = 80, message = "Máximo 80 caracteres")
    private String username;

    @Email(message = "Formato de correo no válido")
    @Size(max = 150, message = "Máximo 150 caracteres")
    private String email;

    @Size(max = 8, message = "Máximo 8 caracteres")
    @Pattern(regexp = "^[A-Za-z0-9]*$", message = "El código solo acepta letras y números")
    private String codigo;

    private String nuevaPassword;

    @Size(max = 64, message = "Hash de verificación muy largo")
    private String nuevaPasswordHash;
}
