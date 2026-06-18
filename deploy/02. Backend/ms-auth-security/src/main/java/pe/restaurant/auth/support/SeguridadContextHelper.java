package pe.restaurant.auth.support;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.security.JwtTokenProvider;

/**
 * Valida JWT definitivo y coherencia de {@code empresaId} con el contexto del token.
 */
@Component
@RequiredArgsConstructor
public class SeguridadContextHelper {

    private final JwtTokenProvider jwtTokenProvider;

    public String extractBearer(String authHeader) {
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            throw new BusinessException("Token requerido",
                    HttpStatus.UNAUTHORIZED, "TOKEN_REQUERIDO");
        }
        return authHeader.substring(7);
    }

    /**
     * Acepta cualquier JWT válido (temporal o definitivo) y devuelve el userId.
     */
    public Long requireUserIdAny(String authHeader) {
        String token = extractBearer(authHeader);
        if (!jwtTokenProvider.validateToken(token)) {
            throw new BusinessException(
                    "Su sesión ha expirado. Por favor, inicie sesión nuevamente.",
                    HttpStatus.UNAUTHORIZED, "TOKEN_EXPIRADO");
        }
        Long userId = jwtTokenProvider.getUserId(token);
        if (userId == null) {
            userId = claimToLong(jwtTokenProvider.getClaim(token, "userId", Object.class));
        }
        if (userId == null) {
            throw new BusinessException("Token inválido", HttpStatus.UNAUTHORIZED, "TOKEN_EXPIRADO");
        }
        return userId;
    }

    public Long requireUserIdDefinitivo(String authHeader) {
        String token = extractBearer(authHeader);
        if (!jwtTokenProvider.validateToken(token)) {
            throw new BusinessException(
                    "Su sesión ha expirado. Por favor, inicie sesión nuevamente.",
                    HttpStatus.UNAUTHORIZED, "TOKEN_EXPIRADO");
        }
        Boolean temporal = jwtTokenProvider.getClaim(token, "temporal", Boolean.class);
        if (Boolean.TRUE.equals(temporal)) {
            throw new BusinessException(
                    "Se requiere haber seleccionado empresa y sucursal (token definitivo).",
                    HttpStatus.FORBIDDEN, "TOKEN_TEMPORAL_NO_PERMITIDO");
        }
        Long userId = jwtTokenProvider.getUserId(token);
        if (userId == null) {
            userId = claimToLong(jwtTokenProvider.getClaim(token, "userId", Object.class));
        }
        if (userId == null) {
            throw new BusinessException("Token inválido", HttpStatus.UNAUTHORIZED, "TOKEN_EXPIRADO");
        }
        return userId;
    }

    public Long requireEmpresaIdFromToken(String authHeader) {
        String token = extractBearer(authHeader);
        if (!jwtTokenProvider.validateToken(token)) {
            throw new BusinessException(
                    "Su sesión ha expirado. Por favor, inicie sesión nuevamente.",
                    HttpStatus.UNAUTHORIZED, "TOKEN_EXPIRADO");
        }
        Long empresaId = jwtTokenProvider.getEmpresaId(token);
        if (empresaId == null) {
            empresaId = claimToLong(jwtTokenProvider.getClaim(token, "empresaId", Object.class));
        }
        if (empresaId == null) {
            throw new BusinessException(
                    "Contexto de empresa no disponible en el token.",
                    HttpStatus.FORBIDDEN, "EMPRESA_CONTEXTO_INVALIDO");
        }
        return empresaId;
    }

    public void requireEmpresaEnToken(String authHeader, Long empresaIdPath) {
        Long e = requireEmpresaIdFromToken(authHeader);
        if (!e.equals(empresaIdPath)) {
            throw new BusinessException(
                    "La empresa solicitada no coincide con la sesión actual.",
                    HttpStatus.FORBIDDEN, "EMPRESA_CONTEXTO_INVALIDO");
        }
    }

    private static Long claimToLong(Object raw) {
        if (raw == null) {
            return null;
        }
        if (raw instanceof Number n) {
            return n.longValue();
        }
        return null;
    }
}
