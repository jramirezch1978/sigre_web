package com.sigre.seguridad.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Set;

/**
 * DTO para respuesta de login exitoso
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LoginResponse {
    
    private String token;
    private String refreshToken;
    private String tipo;
    private String usuario;
    private String nombreCompleto;
    private String email;
    private String empresa;
    private Set<String> roles;
    private Set<String> permisos;
    private Long expiresIn; // Tiempo de expiración en segundos
}

