package com.sigre.auth.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Perfil derivado del JWT en {@code GET /api/auth/me} (claims efectivos).
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AuthMeResponse {

    private boolean temporal;

    private Long userId;
    private String username;
    private String email;
    private String nombres;
    private String apellidos;
    private String nombreCompleto;

    /** Solo JWT definitivo con sesión en {@code auth.tokens_session}. */
    private Long tokensSessionId;

    private Long empresaId;
    private String empresaCodigo;
    private String empresaNombre;
    private String empresaRuc;
    private String dbName;

    private Long sucursalId;
    private String sucursalNombre;

    private MeUsuarioClaims usuario;
    private MeEmpresaClaims empresa;
    private MeSucursalClaims sucursal;

    /** Derivado de {@code auth.usuario.flag_admin_sistema}. */
    private Boolean adminSistema;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class MeUsuarioClaims {
        private Long id;
        private String username;
        private String nombres;
        private String apellidos;
        private String email;
    }

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class MeEmpresaClaims {
        private Long id;
        private String nombre;
        private String ruc;
        private String codigo;
    }

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class MeSucursalClaims {
        private Long id;
        private String nombre;
        private String ciudad;
    }
}
