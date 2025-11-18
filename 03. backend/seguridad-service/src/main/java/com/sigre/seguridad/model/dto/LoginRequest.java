package com.sigre.seguridad.model.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * DTO para solicitud de login
 */
@Data
public class LoginRequest {
    
    @NotBlank(message = "El usuario es requerido")
    private String usuario;
    
    @NotBlank(message = "La contraseña es requerida")
    private String password;
    
    private String empresa;
}

