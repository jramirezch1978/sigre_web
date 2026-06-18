package pe.restaurant.produccion.service;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.jdbc.core.JdbcTemplate;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class TokensSessionVerifierTest {

    @Mock private JdbcTemplate securityJdbcTemplate;

    @Test
    void isActive_cuandoExisteSesion_retornaTrue() {
        when(securityJdbcTemplate.queryForObject(anyString(), eq(Integer.class), anyLong(), anyLong()))
                .thenReturn(1);

        var verifier = new TokensSessionVerifier(securityJdbcTemplate);
        boolean result = verifier.isActive(1L, 1L);

        assertThat(result).isTrue();
    }

    @Test
    void isActive_cuandoNoExisteSesion_retornaFalse() {
        when(securityJdbcTemplate.queryForObject(anyString(), eq(Integer.class), anyLong(), anyLong()))
                .thenReturn(0);

        var verifier = new TokensSessionVerifier(securityJdbcTemplate);
        boolean result = verifier.isActive(1L, 999L);

        assertThat(result).isFalse();
    }

    @Test
    void isActive_cuandoResultadoNull_retornaFalse() {
        when(securityJdbcTemplate.queryForObject(anyString(), eq(Integer.class), anyLong(), anyLong()))
                .thenReturn(null);

        var verifier = new TokensSessionVerifier(securityJdbcTemplate);
        boolean result = verifier.isActive(1L, 1L);

        assertThat(result).isFalse();
    }
}
