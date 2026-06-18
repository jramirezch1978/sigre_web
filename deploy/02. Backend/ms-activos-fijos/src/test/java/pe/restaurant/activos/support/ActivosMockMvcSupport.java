package pe.restaurant.activos.support;

import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;

/**
 * Cabeceras mínimas para MockMvc IT (filtro {@code TenantContextWebFilter}).
 */
public final class ActivosMockMvcSupport {

    public static final String X_EMPRESA_ID = "2";

    private ActivosMockMvcSupport() {}

    public static MockHttpServletRequestBuilder withTenant(MockHttpServletRequestBuilder builder) {
        return builder.header("X-Empresa-Id", X_EMPRESA_ID);
    }
}
