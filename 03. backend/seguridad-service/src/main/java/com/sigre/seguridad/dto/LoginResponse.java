package com.sigre.seguridad.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LoginResponse {

    private String accessToken;
    /** Solo sesión definitiva (post-{@code seleccionar-empresa}); ausente en token temporal o reutilización de JWT. */
    private String refreshToken;
    private String tokenType;
    private long expiresInSeconds;
    private boolean temporal;

    private Long userId;
    private String email;
    private String username;
    private String nombres;
    private String apellidos;
    private String nombreCompleto;

    private Long empresaId;
    private String empresaCodigo;
    private String empresaNombre;
    private String empresaRuc;

    private Long sucursalId;
    private String sucursalNombre;

    /** {@code true} si {@code auth.usuario.flag_admin_sistema = '1'} (menú administración de empresas). */
    private Boolean adminSistema;
}
