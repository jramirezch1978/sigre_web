package com.sigre.produccion.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.common.security.JwtDefinitiveTokenResolver;
import com.sigre.common.security.TokenUsoLogWriter;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ProduccionJwtAuthenticationFilterTest {

    @Mock private JwtDefinitiveTokenResolver tokenResolver;
    @Mock private ObjectMapper objectMapper;
    @Mock private TokenUsoLogWriter logWriter;

    private ProduccionJwtAuthenticationFilter filter;

    @BeforeEach
    void setUp() {
        filter = new ProduccionJwtAuthenticationFilter(
                tokenResolver, objectMapper, Optional.of(logWriter));
    }

    @Test
    void shouldNotFilter_cuandoPathEmpiezaConApiProduccion_retornaFalse() {
        var request = mock(HttpServletRequest.class);
        when(request.getRequestURI()).thenReturn("/api/produccion/recetas");

        boolean result = filter.shouldNotFilter(request);

        assertThat(result).isFalse();
    }

    @Test
    void shouldNotFilter_cuandoPathNoEmpiezaConApiProduccion_retornaTrue() {
        var request = mock(HttpServletRequest.class);
        when(request.getRequestURI()).thenReturn("/api/almacen/vale");

        boolean result = filter.shouldNotFilter(request);

        assertThat(result).isTrue();
    }
}
