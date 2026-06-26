package pe.restaurant.produccion.config;

import feign.RequestTemplate;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import static org.assertj.core.api.Assertions.assertThat;

class FeignConfigTest {

    @AfterEach
    void tearDown() {
        RequestContextHolder.resetRequestAttributes();
    }

    @Test
    void requestInterceptor_sinRequestContext_noAgregaHeaders() {
        var config = new FeignConfig();
        var interceptor = config.requestInterceptor();
        var template = new RequestTemplate();

        interceptor.apply(template);

        assertThat(template.headers()).isEmpty();
    }

    @Test
    void requestInterceptor_conHeaders_agregaTodos() {
        var request = new MockHttpServletRequest();
        request.addHeader("Authorization", "Bearer token123");
        request.addHeader("X-User-Id", "42");
        request.addHeader("X-Empresa-Id", "1");
        request.addHeader("X-Sucursal-Id", "5");
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(request));

        var config = new FeignConfig();
        var interceptor = config.requestInterceptor();
        var template = new RequestTemplate();

        interceptor.apply(template);

        assertThat(template.headers()).containsKey("Authorization");
        assertThat(template.headers().get("Authorization")).contains("Bearer token123");
        assertThat(template.headers().get("X-User-Id")).contains("42");
        assertThat(template.headers().get("X-Empresa-Id")).contains("1");
        assertThat(template.headers().get("X-Sucursal-Id")).contains("5");
    }

    @Test
    void requestInterceptor_conAlgunosHeadersNull_soloAgregaLosPresentes() {
        var request = new MockHttpServletRequest();
        request.addHeader("Authorization", "Bearer token456");
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(request));

        var config = new FeignConfig();
        var interceptor = config.requestInterceptor();
        var template = new RequestTemplate();

        interceptor.apply(template);

        assertThat(template.headers()).containsOnlyKeys("Authorization");
        assertThat(template.headers().get("Authorization")).contains("Bearer token456");
    }
}
