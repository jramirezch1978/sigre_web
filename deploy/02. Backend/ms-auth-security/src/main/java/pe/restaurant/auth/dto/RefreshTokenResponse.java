package pe.restaurant.auth.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Respuesta de {@code POST /api/auth/refresh}: nuevos access y refresh (rotación).
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RefreshTokenResponse {

    private String accessToken;
    private String refreshToken;
    private String tokenType;
    private long expiresInSeconds;

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
}
