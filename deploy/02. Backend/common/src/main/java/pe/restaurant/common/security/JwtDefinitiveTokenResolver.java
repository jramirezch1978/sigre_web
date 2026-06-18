package pe.restaurant.common.security;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.Optional;

/**
 * Valida un JWT (temporal o definitivo), extrae sus claims tipados
 * y opcionalmente verifica la sesión en {@code auth.tokens_session}
 * si el microservicio provee un {@link TokensSessionChecker}.
 * <p>
 * Diseñado para ser inyectado en filtros genéricos o específicos de cada microservicio.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class JwtDefinitiveTokenResolver {

    private final JwtTokenProvider jwtTokenProvider;
    private final Optional<TokensSessionChecker> tokensSessionChecker;

    /**
     * Extrae el JWT del header {@code Authorization: Bearer ...}, lo valida
     * y devuelve los claims tipados. Vacío si el token es inválido o expirado.
     */
    public Optional<DefinitiveTokenClaims> resolve(String authorizationHeader) {
        if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
            return Optional.empty();
        }

        String token = authorizationHeader.substring(7).trim();
        if (token.isEmpty() || !jwtTokenProvider.validateToken(token)) {
            return Optional.empty();
        }

        return Optional.of(extractClaims(token));
    }

    /**
     * Valida que la sesión esté activa en {@code auth.tokens_session}.
     * @return {@code true} si no hay checker configurado (no aplica),
     *         o si la sesión sigue activa; {@code false} si fue revocada.
     */
    public boolean isSessionActive(DefinitiveTokenClaims claims) {
        if (claims.isTemporal() || claims.getTokensSessionId() == null || claims.getUserId() == null) {
            return true;
        }
        return tokensSessionChecker
                .map(checker -> checker.isActive(claims.getUserId(), claims.getTokensSessionId()))
                .orElse(true);
    }

    private DefinitiveTokenClaims extractClaims(String token) {
        return DefinitiveTokenClaims.builder()
                .userId(toLong(jwtTokenProvider.getClaim(token, "userId", Object.class)))
                .username(jwtTokenProvider.getUsername(token))
                .email(jwtTokenProvider.getClaim(token, "email", String.class))
                .nombres(jwtTokenProvider.getClaim(token, "nombres", String.class))
                .apellidos(jwtTokenProvider.getClaim(token, "apellidos", String.class))
                .nombreCompleto(jwtTokenProvider.getClaim(token, "nombreCompleto", String.class))
                .empresaId(toLong(jwtTokenProvider.getClaim(token, "empresaId", Object.class)))
                .empresaCodigo(jwtTokenProvider.getClaim(token, "empresaCodigo", String.class))
                .empresaNombre(jwtTokenProvider.getClaim(token, "empresaNombre", String.class))
                .empresaRuc(jwtTokenProvider.getClaim(token, "empresaRuc", String.class))
                .dbName(jwtTokenProvider.getClaim(token, "dbName", String.class))
                .sucursalId(toLong(jwtTokenProvider.getClaim(token, "sucursalId", Object.class)))
                .sucursalNombre(jwtTokenProvider.getClaim(token, "sucursalNombre", String.class))
                .tokensSessionId(toLong(jwtTokenProvider.getClaim(token, "tokensSessionId", Object.class)))
                .temporal(Boolean.TRUE.equals(jwtTokenProvider.getClaim(token, "temporal", Boolean.class)))
                .build();
    }

    private static Long toLong(Object raw) {
        if (raw instanceof Number n) {
            return n.longValue();
        }
        return null;
    }
}
