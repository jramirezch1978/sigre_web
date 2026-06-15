package com.sigre.comercializacion.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.jdbc.core.JdbcTemplate;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Tests de Branch Coverage para TokensSessionVerifier
 * Enfocado en cubrir todas las ramas condicionales del método isActive
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("TokensSessionVerifier — Branch Coverage Tests")
class TokensSessionVerifierBranchTest {

    @Mock
    private JdbcTemplate securityJdbcTemplate;

    @InjectMocks
    private TokensSessionVerifier verifier;

    @BeforeEach
    void setUp() {
        // Configuración inicial para cada test
    }

    // ==================== TESTS DE BRANCH COVERAGE ====================

    @Test
    @DisplayName("isActive_conTokenValidoYActivo_retornaTrue")
    void isActive_conTokenValidoYActivo_retornaTrue() {
        // Given
        long usuarioId = 1L;
        long tokensSessionId = 100L;
        
        when(securityJdbcTemplate.queryForObject(
                any(String.class), eq(Integer.class), eq(tokensSessionId), eq(usuarioId)))
                .thenReturn(1); // Token encontrado y activo

        // When
        boolean result = verifier.isActive(usuarioId, tokensSessionId);

        // Then
        assertThat(result).isTrue();
    }

    @Test
    @DisplayName("isActive_conTokenNoExistente_retornaFalse")
    void isActive_conTokenNoExistente_retornaFalse() {
        // Given
        long usuarioId = 1L;
        long tokensSessionId = 999L;
        
        when(securityJdbcTemplate.queryForObject(
                any(String.class), eq(Integer.class), eq(tokensSessionId), eq(usuarioId)))
                .thenReturn(0); // Token no encontrado

        // When
        boolean result = verifier.isActive(usuarioId, tokensSessionId);

        // Then
        assertThat(result).isFalse();
    }

    @Test
    @DisplayName("isActive_conTokenExpirado_retornaFalse")
    void isActive_conTokenExpirado_retornaFalse() {
        // Given
        long usuarioId = 1L;
        long tokensSessionId = 200L;
        
        when(securityJdbcTemplate.queryForObject(
                any(String.class), eq(Integer.class), eq(tokensSessionId), eq(usuarioId)))
                .thenReturn(0); // Token expirado (no cumple condición expira_en > NOW())

        // When
        boolean result = verifier.isActive(usuarioId, tokensSessionId);

        // Then
        assertThat(result).isFalse();
    }

    @Test
    @DisplayName("isActive_conTokenInactivo_retornaFalse")
    void isActive_conTokenInactivo_retornaFalse() {
        // Given
        long usuarioId = 1L;
        long tokensSessionId = 300L;
        
        when(securityJdbcTemplate.queryForObject(
                any(String.class), eq(Integer.class), eq(tokensSessionId), eq(usuarioId)))
                .thenReturn(0); // Token inactivo (flag_estado != '1')

        // When
        boolean result = verifier.isActive(usuarioId, tokensSessionId);

        // Then
        assertThat(result).isFalse();
    }

    @Test
    @DisplayName("isActive_conResultadoNull_retornaFalse")
    void isActive_conResultadoNull_retornaFalse() {
        // Given
        long usuarioId = 1L;
        long tokensSessionId = 400L;
        
        when(securityJdbcTemplate.queryForObject(
                any(String.class), eq(Integer.class), eq(tokensSessionId), eq(usuarioId)))
                .thenReturn(null); // Query retorna null

        // When
        boolean result = verifier.isActive(usuarioId, tokensSessionId);

        // Then
        assertThat(result).isFalse();
    }

    @Test
    @DisplayName("isActive_conUsuarioIdYTokenIdValidos_ejecutaQueryCorrecta")
    void isActive_conUsuarioIdYTokenIdValidos_ejecutaQueryCorrecta() {
        // Given
        long usuarioId = 123L;
        long tokensSessionId = 456L;
        
        when(securityJdbcTemplate.queryForObject(
                any(String.class), eq(Integer.class), eq(tokensSessionId), eq(usuarioId)))
                .thenReturn(1);

        // When
        boolean result = verifier.isActive(usuarioId, tokensSessionId);

        // Then
        assertThat(result).isTrue();
        // Verificar que se llamó con los parámetros correctos
        verify(securityJdbcTemplate).queryForObject(
                eq("SELECT COUNT(*)::int FROM auth.tokens_session WHERE id = ? AND usuario_id = ? AND flag_estado = '1' AND expira_en > NOW()"),
                eq(Integer.class), eq(tokensSessionId), eq(usuarioId));
    }

    @Test
    @DisplayName("isActive_conValoresCero_retornaFalse")
    void isActive_conValoresCero_retornaFalse() {
        // Given
        long usuarioId = 0L;
        long tokensSessionId = 0L;
        
        when(securityJdbcTemplate.queryForObject(
                any(String.class), eq(Integer.class), eq(tokensSessionId), eq(usuarioId)))
                .thenReturn(0);

        // When
        boolean result = verifier.isActive(usuarioId, tokensSessionId);

        // Then
        assertThat(result).isFalse();
    }

    @Test
    @DisplayName("isActive_conValoresNegativos_retornaFalse")
    void isActive_conValoresNegativos_retornaFalse() {
        // Given
        long usuarioId = -1L;
        long tokensSessionId = -1L;
        
        when(securityJdbcTemplate.queryForObject(
                any(String.class), eq(Integer.class), eq(tokensSessionId), eq(usuarioId)))
                .thenReturn(0);

        // When
        boolean result = verifier.isActive(usuarioId, tokensSessionId);

        // Then
        assertThat(result).isFalse();
    }

    @Test
    @DisplayName("isActive_conMultiplesTokensActivos_retornaTrue")
    void isActive_conMultiplesTokensActivos_retornaTrue() {
        // Given
        long usuarioId = 1L;
        long tokensSessionId = 500L;
        
        when(securityJdbcTemplate.queryForObject(
                any(String.class), eq(Integer.class), eq(tokensSessionId), eq(usuarioId)))
                .thenReturn(3); // Múltiples tokens activos para el usuario

        // When
        boolean result = verifier.isActive(usuarioId, tokensSessionId);

        // Then
        assertThat(result).isTrue();
    }
}
