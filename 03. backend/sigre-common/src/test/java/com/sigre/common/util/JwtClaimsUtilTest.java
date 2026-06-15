package com.sigre.common.util;

import org.junit.jupiter.api.Test;
import com.sigre.common.dto.SessionTokenClaimsDto;
import com.sigre.common.security.JwtTokenProvider;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class JwtClaimsUtilTest {

    @Test
    void extractSessionClaimsReturnsProviderClaims() {
        JwtTokenProvider provider = mock(JwtTokenProvider.class);
        SessionTokenClaimsDto dto = SessionTokenClaimsDto.builder().userId(10L).empresaId(20L).build();
        when(provider.getSessionClaims("abc.token")).thenReturn(dto);

        SessionTokenClaimsDto claims = JwtClaimsUtil.extractSessionClaims("Bearer abc.token", provider);

        assertEquals(10L, claims.getUserId());
        assertEquals(20L, claims.getEmpresaId());
        verify(provider).getSessionClaims("abc.token");
    }

    @Test
    void extractSessionClaimsFailsWhenHeaderInvalid() {
        JwtTokenProvider provider = mock(JwtTokenProvider.class);
        assertThrows(IllegalArgumentException.class, () -> JwtClaimsUtil.extractSessionClaims("Token abc", provider));
    }
}
