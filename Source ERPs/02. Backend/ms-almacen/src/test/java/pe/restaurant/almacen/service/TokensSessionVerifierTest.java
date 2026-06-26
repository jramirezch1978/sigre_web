package pe.restaurant.almacen.service;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.jdbc.core.JdbcTemplate;

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
    void isActive_trueCuandoCountMayorCero() {
        when(securityJdbcTemplate.queryForObject(
                contains("auth.tokens_session"),
                eq(Integer.class),
                eq(10L),
                eq(5L))).thenReturn(1);

        assertThat(verifier.isActive(5L, 10L)).isTrue();
    }

    @Test
    void isActive_falseCuandoCountCeroONulo() {
        when(securityJdbcTemplate.queryForObject(
                contains("auth.tokens_session"),
                eq(Integer.class),
                eq(11L),
                eq(6L))).thenReturn(0);

        assertThat(verifier.isActive(6L, 11L)).isFalse();

        when(securityJdbcTemplate.queryForObject(
                contains("auth.tokens_session"),
                eq(Integer.class),
                eq(12L),
                eq(7L))).thenReturn(null);

        assertThat(verifier.isActive(7L, 12L)).isFalse();
    }
}
