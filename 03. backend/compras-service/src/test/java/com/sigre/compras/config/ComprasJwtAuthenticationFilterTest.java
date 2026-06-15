package com.sigre.compras.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import com.sigre.common.security.JwtDefinitiveTokenResolver;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@DisplayName("ComprasJwtAuthenticationFilter — Pruebas Unitarias")
class ComprasJwtAuthenticationFilterTest {

    private final ComprasJwtAuthenticationFilter filter = new ComprasJwtAuthenticationFilter(
            mock(JwtDefinitiveTokenResolver.class),
            new ObjectMapper(),
            Optional.empty());

    private HttpServletRequest mockRequest(String uri, String method) {
        HttpServletRequest req = mock(HttpServletRequest.class);
        when(req.getRequestURI()).thenReturn(uri);
        when(req.getMethod()).thenReturn(method);
        when(req.getServletPath()).thenReturn(uri);
        return req;
    }

    @Test
    @DisplayName("shouldNotFilter() ruta compras -> retorna false")
    void shouldNotFilter_rutaCompras_retornaFalse() throws Exception {
        HttpServletRequest req = mockRequest("/api/compras/ordenes-compra", "GET");

        boolean result = filter.shouldNotFilter(req);

        assertThat(result).isFalse();
    }

    @ParameterizedTest
    @ValueSource(strings = {
            "/actuator/health",
            "/swagger-ui/index.html",
            "/v3/api-docs"
    })
    void shouldNotFilter_rutasPublicas_retornaTrue(String path) throws Exception {
        HttpServletRequest req = mockRequest(path, "GET");

        boolean result = filter.shouldNotFilter(req);

        assertThat(result).isTrue();
    }

    @Test
    @DisplayName("shouldNotFilter() options -> retorna true")
    void shouldNotFilter_OPTIONS_retornaTrue() throws Exception {
        HttpServletRequest req = mockRequest("/api/compras/ordenes-compra", "OPTIONS");

        boolean result = filter.shouldNotFilter(req);

        assertThat(result).isTrue();
    }

    @Test
    @DisplayName("shouldNotFilter() ruta no compras -> retorna true")
    void shouldNotFilter_rutaNoCompras_retornaTrue() throws Exception {
        HttpServletRequest req = mockRequest("/api/ventas/facturas", "GET");

        boolean result = filter.shouldNotFilter(req);

        assertThat(result).isTrue();
    }

    @Test
    @DisplayName("shouldNotFilter() ruta raiz -> retorna true")
    void shouldNotFilter_rutaRaiz_retornaTrue() throws Exception {
        HttpServletRequest req = mockRequest("/", "GET");

        boolean result = filter.shouldNotFilter(req);

        assertThat(result).isTrue();
    }
}
