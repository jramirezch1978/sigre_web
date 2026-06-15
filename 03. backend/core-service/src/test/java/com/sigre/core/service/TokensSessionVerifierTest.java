package com.sigre.core.service;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.jdbc.core.JdbcTemplate;
import com.sigre.common.security.TokensSessionChecker;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class TokensSessionVerifierTest {

    @Mock
    private JdbcTemplate securityJdbcTemplate;

    @InjectMocks
    private TokensSessionVerifier verifier;

    @Test
    void implementsTokensSessionChecker() {
        assertThat(verifier).isInstanceOf(TokensSessionChecker.class);
    }

    @Test
    void isActive_returnsTrue_whenCountGreaterThanZero() {
        when(securityJdbcTemplate.queryForObject(
                contains("tokens_session"), eq(Integer.class), eq(100L), eq(5L)))
                .thenReturn(1);

        assertThat(verifier.isActive(5L, 100L)).isTrue();
    }

    @Test
    void isActive_returnsFalse_whenCountIsZero() {
        when(securityJdbcTemplate.queryForObject(
                contains("tokens_session"), eq(Integer.class), eq(100L), eq(5L)))
                .thenReturn(0);

        assertThat(verifier.isActive(5L, 100L)).isFalse();
    }

    @Test
    void isActive_returnsFalse_whenCountIsNull() {
        when(securityJdbcTemplate.queryForObject(
                contains("tokens_session"), eq(Integer.class), eq(100L), eq(5L)))
                .thenReturn(null);

        assertThat(verifier.isActive(5L, 100L)).isFalse();
    }

    @Test
    void isActive_passesSessionIdFirst_thenUsuarioId() {
        when(securityJdbcTemplate.queryForObject(
                anyString(), eq(Integer.class), eq(42L), eq(7L)))
                .thenReturn(1);

        assertThat(verifier.isActive(7L, 42L)).isTrue();
    }
}
