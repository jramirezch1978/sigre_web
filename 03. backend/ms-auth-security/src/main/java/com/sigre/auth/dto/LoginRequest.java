package com.sigre.auth.dto;

import jakarta.validation.constraints.NotBlank;
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
public class LoginRequest {

    @NotBlank(message = "El usuario o correo es requerido")
    @Size(max = 150, message = "Máximo 150 caracteres")
    @Pattern(regexp = "^[a-zA-Z0-9.@_\\-]+$", message = "Formato de usuario no válido")
    private String email;

    @NotBlank(message = "La contraseña es requerida")
    private String password;

    @Size(max = 64, message = "Hash de verificación muy largo")
    private String passwordHash;

    @Size(max = 64, message = "IP muy larga")
    @Pattern(regexp = "^[0-9.:a-fA-F]*$", message = "Formato de IP no válido")
    private String ipAddress;

    @Size(max = 64, message = "IP privada muy larga")
    @Pattern(regexp = "^[0-9.:a-fA-F]*$", message = "Formato de IP no válido")
    private String ipPrivada;

    @Size(max = 500, message = "Browser muy largo")
    private String browser;

    @Size(max = 120, message = "Sistema operativo muy largo")
    @Pattern(regexp = "^[a-zA-Z0-9 /._\\-()]*$", message = "Formato de SO no válido")
    private String sistemaOperativo;

    @Size(max = 100, message = "Nombre de dispositivo muy largo")
    @Pattern(regexp = "^[a-zA-Z0-9 ._\\-]*$", message = "Formato de dispositivo no válido")
    private String deviceName;
}
