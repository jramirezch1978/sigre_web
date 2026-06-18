package pe.restaurant.common.util;

import pe.restaurant.common.dto.SessionTokenClaimsDto;
import pe.restaurant.common.security.JwtTokenProvider;

public final class JwtClaimsUtil {
    private JwtClaimsUtil() {
    }

    public static SessionTokenClaimsDto extractSessionClaims(String authorizationHeader, JwtTokenProvider jwtTokenProvider) {
        if (authorizationHeader == null || !authorizationHeader.startsWith(Constants.TOKEN_PREFIX)) {
            throw new IllegalArgumentException("Authorization header invalido");
        }
        String token = authorizationHeader.substring(Constants.TOKEN_PREFIX.length()).trim();
        if (token.isEmpty()) {
            throw new IllegalArgumentException("Token JWT vacio");
        }
        return jwtTokenProvider.getSessionClaims(token);
    }
}
