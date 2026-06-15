package com.sigre.common.security;

import org.junit.jupiter.api.Test;
import com.sigre.common.dto.SessionTokenClaimsDto;

import java.util.Base64;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

class JwtTokenProviderTest {

    @Test
    void getSessionClaimsReturnsDtoWithEmpresaId() {
        String secret = Base64.getEncoder().encodeToString("12345678901234567890123456789012".getBytes());
        JwtTokenProvider provider = new JwtTokenProvider(secret, 60000L, 60000L, 60000L);
        String token = provider.generateAccessToken("user@test", Map.of("userId", 15L, "empresaId", 22L));

        SessionTokenClaimsDto claims = provider.getSessionClaims(token);

        assertEquals(15L, claims.getUserId());
        assertEquals(22L, claims.getEmpresaId());
        assertEquals("user@test", claims.getSubject());
        assertNotNull(claims.getExpiresAt());
        assertNotNull(claims.getIssuedAt());
        assertNotNull(claims.getClaims());
    }
}
