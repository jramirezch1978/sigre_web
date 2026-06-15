package com.sigre.compras.config;

import feign.RequestInterceptor;
import feign.RequestTemplate;
import jakarta.servlet.http.HttpServletRequest;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

class FeignConfigTest {

    private final FeignConfig config = new FeignConfig();

    @AfterEach
    void tearDown() {
        RequestContextHolder.resetRequestAttributes();
    }

    @Test
    void requestInterceptor_propagaHeadersPresentes() {
        HttpServletRequest mockRequest = mock(HttpServletRequest.class);
        when(mockRequest.getHeader("Authorization")).thenReturn("Bearer abc123");
        when(mockRequest.getHeader("X-User-Id")).thenReturn("42");
        when(mockRequest.getHeader("X-Empresa-Id")).thenReturn("1");
        when(mockRequest.getHeader("X-Sucursal-Id")).thenReturn("5");
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(mockRequest));

        RequestInterceptor interceptor = config.requestInterceptor();
        RequestTemplate template = new RequestTemplate();
        interceptor.apply(template);

        assertThat(template.headers().get("Authorization")).containsExactly("Bearer abc123");
        assertThat(template.headers().get("X-User-Id")).containsExactly("42");
        assertThat(template.headers().get("X-Empresa-Id")).containsExactly("1");
        assertThat(template.headers().get("X-Sucursal-Id")).containsExactly("5");
    }

    @Test
    void requestInterceptor_sinHeaders_noAgregaNada() {
        HttpServletRequest mockRequest = mock(HttpServletRequest.class);
        when(mockRequest.getHeader(anyString())).thenReturn(null);
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(mockRequest));

        RequestInterceptor interceptor = config.requestInterceptor();
        RequestTemplate template = new RequestTemplate();
        interceptor.apply(template);

        assertThat(template.headers()).doesNotContainKey("Authorization");
        assertThat(template.headers()).doesNotContainKey("X-User-Id");
        assertThat(template.headers()).doesNotContainKey("X-Empresa-Id");
        assertThat(template.headers()).doesNotContainKey("X-Sucursal-Id");
    }

    @Test
    void requestInterceptor_sinRequestContext_noFalla() {
        RequestContextHolder.resetRequestAttributes();

        RequestInterceptor interceptor = config.requestInterceptor();
        RequestTemplate template = new RequestTemplate();
        interceptor.apply(template);

        assertThat(template.headers()).isEmpty();
    }

    @Test
    void requestInterceptor_soloAuthorizationPresente_propagaSoloEse() {
        HttpServletRequest mockRequest = mock(HttpServletRequest.class);
        when(mockRequest.getHeader("Authorization")).thenReturn("Bearer token");
        when(mockRequest.getHeader("X-User-Id")).thenReturn(null);
        when(mockRequest.getHeader("X-Empresa-Id")).thenReturn(null);
        when(mockRequest.getHeader("X-Sucursal-Id")).thenReturn(null);
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(mockRequest));

        RequestInterceptor interceptor = config.requestInterceptor();
        RequestTemplate template = new RequestTemplate();
        interceptor.apply(template);

        assertThat(template.headers().get("Authorization")).containsExactly("Bearer token");
        assertThat(template.headers()).doesNotContainKey("X-User-Id");
    }
}
