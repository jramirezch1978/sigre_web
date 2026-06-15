package com.sigre.common.security;

/**
 * Interfaz que cada microservicio puede implementar para validar
 * que la sesión en {@code auth.tokens_session} sigue activa.
 * <p>
 * Si no se provee un bean, {@link JwtDefinitiveTokenResolver}
 * asume que la sesión es válida (para microservicios que no tienen
 * acceso directo a la BD de security).
 */
public interface TokensSessionChecker {

    boolean isActive(long usuarioId, long tokensSessionId);
}
