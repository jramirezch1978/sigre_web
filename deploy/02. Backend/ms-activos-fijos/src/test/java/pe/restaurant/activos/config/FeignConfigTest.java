package pe.restaurant.activos.config;

import feign.RequestInterceptor;
import feign.RequestTemplate;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import static org.assertj.core.api.Assertions.assertThat;

class FeignConfigTest {

    private final FeignConfig feignConfig = new FeignConfig();

    @Test
    void requestInterceptorBeanIsNotNull() {
        RequestInterceptor interceptor = feignConfig.requestInterceptor();
        assertThat(interceptor).isNotNull();
    }

    @Test
    void interceptorPropagatesAuthorizationHeader() {
        MockHttpServletRequest httpRequest = new MockHttpServletRequest();
        httpRequest.addHeader("Authorization", "Bearer test-token");
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(httpRequest));

        try {
            RequestTemplate template = new RequestTemplate();
            feignConfig.requestInterceptor().apply(template);
            assertThat(template.headers().get("Authorization")).containsExactly("Bearer test-token");
        } finally {
            RequestContextHolder.resetRequestAttributes();
        }
    }

    @Test
    void interceptorPropagatesUserIdHeader() {
        MockHttpServletRequest httpRequest = new MockHttpServletRequest();
        httpRequest.addHeader("X-User-Id", "42");
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(httpRequest));

        try {
            RequestTemplate template = new RequestTemplate();
            feignConfig.requestInterceptor().apply(template);
            assertThat(template.headers().get("X-User-Id")).containsExactly("42");
        } finally {
            RequestContextHolder.resetRequestAttributes();
        }
    }

    @Test
    void interceptorPropagatesEmpresaIdHeader() {
        MockHttpServletRequest httpRequest = new MockHttpServletRequest();
        httpRequest.addHeader("X-Empresa-Id", "100");
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(httpRequest));

        try {
            RequestTemplate template = new RequestTemplate();
            feignConfig.requestInterceptor().apply(template);
            assertThat(template.headers().get("X-Empresa-Id")).containsExactly("100");
        } finally {
            RequestContextHolder.resetRequestAttributes();
        }
    }

    @Test
    void interceptorHandlesNullRequestAttributes() {
        RequestContextHolder.resetRequestAttributes();
        RequestTemplate template = new RequestTemplate();
        feignConfig.requestInterceptor().apply(template);
        assertThat(template.headers()).doesNotContainKey("Authorization");
    }

    @Test
    void interceptorSkipsMissingHeaders() {
        MockHttpServletRequest httpRequest = new MockHttpServletRequest();
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(httpRequest));

        try {
            RequestTemplate template = new RequestTemplate();
            feignConfig.requestInterceptor().apply(template);
            assertThat(template.headers()).doesNotContainKey("Authorization");
            assertThat(template.headers()).doesNotContainKey("X-User-Id");
            assertThat(template.headers()).doesNotContainKey("X-Empresa-Id");
        } finally {
            RequestContextHolder.resetRequestAttributes();
        }
    }

    @Test
    void classHasConfigurationAnnotation() {
        assertThat(FeignConfig.class
                .isAnnotationPresent(org.springframework.context.annotation.Configuration.class))
                .isTrue();
    }
}
