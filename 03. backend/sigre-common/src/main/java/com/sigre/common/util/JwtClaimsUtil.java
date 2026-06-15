package com.sigre.common.util;

import com.sigre.common.dto.SessionTokenClaimsDto;
import com.sigre.common.security.JwtTokenProvider;

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
