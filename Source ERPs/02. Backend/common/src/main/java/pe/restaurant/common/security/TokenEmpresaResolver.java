package pe.restaurant.common.security;

import org.springframework.security.core.Authentication;

import java.util.Map;

/**
 * Resuelve el {@code paisId} de la empresa desde el JWT definitivo.
 * <p>
 * El valor proviene del claim anidado {@code empresa.paisId} ({@code master.empresa.pais_id}),
 * no del país de la sucursal ({@code core.sucursal.pais_id}).
 */
public final class TokenEmpresaResolver {

    private TokenEmpresaResolver() {
    }

    /**
     * @return {@code paisId} de la empresa o {@code null} si no está en los claims (p. ej. token reutilizado previo al cambio).
     */
    public static Long resolvePaisId(DefinitiveTokenClaims claims) {
        return claims != null ? claims.getPaisId() : null;
    }

    /**
     * Extrae {@code empresa.paisId} del token JWT compacto.
     */
    @SuppressWarnings("unchecked")
    public static Long resolvePaisId(JwtTokenProvider jwtTokenProvider, String token) {
        if (jwtTokenProvider == null || token == null || token.isBlank()) {
            return null;
        }
        Map<String, Object> empresa = jwtTokenProvider.getClaim(token, "empresa", Map.class);
        if (empresa == null || empresa.isEmpty()) {
            return null;
        }
        Object raw = empresa.get("paisId");
        if (raw instanceof Number n) {
            return n.longValue();
        }
        return null;
    }

    /**
     * Atajo desde {@link Authentication#getDetails()} post {@link JwtTenantAuthFilter}.
     */
    public static Long resolvePaisIdFromAuthentication(Authentication authentication) {
        if (authentication == null || !(authentication.getDetails() instanceof DefinitiveTokenClaims claims)) {
            return null;
        }
        return resolvePaisId(claims);
    }
}
