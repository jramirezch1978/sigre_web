package pe.restaurant.common.security;

import org.junit.jupiter.api.Test;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;

import java.util.Base64;
import java.util.LinkedHashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

class TokenEmpresaResolverTest {

    private static final String SECRET =
            Base64.getEncoder().encodeToString("12345678901234567890123456789012".getBytes());

    @Test
    void resolvePaisIdFromDefinitiveTokenClaims() {
        DefinitiveTokenClaims claims = DefinitiveTokenClaims.builder()
                .paisId(3L)
                .build();

        assertEquals(3L, TokenEmpresaResolver.resolvePaisId(claims));
    }

    @Test
    void resolvePaisIdReturnsNullWhenClaimsMissingPaisId() {
        DefinitiveTokenClaims claims = DefinitiveTokenClaims.builder().empresaId(2L).build();

        assertNull(TokenEmpresaResolver.resolvePaisId(claims));
        assertNull(TokenEmpresaResolver.resolvePaisId((DefinitiveTokenClaims) null));
    }

    @Test
    void resolvePaisIdFromJwtCompactToken() {
        JwtTokenProvider provider = new JwtTokenProvider(SECRET, 60000L, 60000L, 60000L);

        Map<String, Object> empresa = new LinkedHashMap<>();
        empresa.put("id", 2L);
        empresa.put("paisId", 1L);

        Map<String, Object> extraClaims = Map.of(
                "empresaId", 2L,
                "temporal", false,
                "empresa", empresa
        );

        String token = provider.generateDefinitiveToken("user@test", extraClaims);

        assertEquals(1L, TokenEmpresaResolver.resolvePaisId(provider, token));
    }

    @Test
    void resolvePaisIdFromJwtReturnsNullWhenEmpresaClaimMissing() {
        JwtTokenProvider provider = new JwtTokenProvider(SECRET, 60000L, 60000L, 60000L);
        String token = provider.generateDefinitiveToken("user@test", Map.of("empresaId", 2L, "temporal", false));

        assertNull(TokenEmpresaResolver.resolvePaisId(provider, token));
        assertNull(TokenEmpresaResolver.resolvePaisId(provider, null));
        assertNull(TokenEmpresaResolver.resolvePaisId(null, token));
    }

    @Test
    void resolvePaisIdFromAuthentication() {
        DefinitiveTokenClaims claims = DefinitiveTokenClaims.builder().paisId(7L).build();
        UsernamePasswordAuthenticationToken auth =
                new UsernamePasswordAuthenticationToken("user", null);
        auth.setDetails(claims);

        assertEquals(7L, TokenEmpresaResolver.resolvePaisIdFromAuthentication(auth));
        assertNull(TokenEmpresaResolver.resolvePaisIdFromAuthentication(null));
    }

    @Test
    void jwtDefinitiveTokenResolverExtractsEmpresaPaisId() {
        JwtTokenProvider provider = new JwtTokenProvider(SECRET, 60000L, 60000L, 60000L);
        JwtDefinitiveTokenResolver resolver = new JwtDefinitiveTokenResolver(provider, java.util.Optional.empty());

        Map<String, Object> empresa = new LinkedHashMap<>();
        empresa.put("id", 2L);
        empresa.put("paisId", 5L);

        String token = provider.generateDefinitiveToken("user@test", Map.of(
                "userId", 10L,
                "empresaId", 2L,
                "temporal", false,
                "empresa", empresa
        ));

        DefinitiveTokenClaims claims = resolver.resolve("Bearer " + token).orElseThrow();

        assertEquals(5L, claims.getPaisId());
    }
}
