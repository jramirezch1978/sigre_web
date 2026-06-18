package pe.restaurant.activos.service;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.jdbc.core.JdbcTemplate;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class TokensSessionVerifierTest {

    @Mock
    private JdbcTemplate securityJdbcTemplate;

    @Test
    void isActiveReturnsTrueWhenCountIsPositive() {
        when(securityJdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(99L), eq(1L)))
                .thenReturn(1);

        TokensSessionVerifier verifier = new TokensSessionVerifier(securityJdbcTemplate);
        assertThat(verifier.isActive(1L, 99L)).isTrue();
    }

    @Test
    void isActiveReturnsFalseWhenCountIsZero() {
        when(securityJdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(99L), eq(1L)))
                .thenReturn(0);

        TokensSessionVerifier verifier = new TokensSessionVerifier(securityJdbcTemplate);
        assertThat(verifier.isActive(1L, 99L)).isFalse();
    }

    @Test
    void isActiveReturnsFalseWhenCountIsNull() {
        when(securityJdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(99L), eq(1L)))
                .thenReturn(null);

        TokensSessionVerifier verifier = new TokensSessionVerifier(securityJdbcTemplate);
        assertThat(verifier.isActive(1L, 99L)).isFalse();
    }

    @Test
    void isActiveReturnsTrueWhenCountIsGreaterThanOne() {
        when(securityJdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(50L), eq(10L)))
                .thenReturn(3);

        TokensSessionVerifier verifier = new TokensSessionVerifier(securityJdbcTemplate);
        assertThat(verifier.isActive(10L, 50L)).isTrue();
    }

    @Test
    void implementsTokensSessionChecker() {
        assertThat(pe.restaurant.common.security.TokensSessionChecker.class)
                .isAssignableFrom(TokensSessionVerifier.class);
    }
}
