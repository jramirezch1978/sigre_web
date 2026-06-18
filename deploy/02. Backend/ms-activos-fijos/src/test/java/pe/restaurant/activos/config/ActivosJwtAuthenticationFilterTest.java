package pe.restaurant.activos.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.common.security.JwtDefinitiveTokenResolver;
import pe.restaurant.common.security.TokenUsoLogWriter;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ActivosJwtAuthenticationFilterTest {

    @Mock
    private JwtDefinitiveTokenResolver tokenResolver;
    @Mock
    private ObjectMapper objectMapper;
    @Mock
    private HttpServletRequest request;

    @Test
    void shouldNotFilterReturnsFalseForActivosApiPath() {
        var filter = new ActivosJwtAuthenticationFilter(tokenResolver, objectMapper, Optional.empty());
        when(request.getRequestURI()).thenReturn("/api/activos/maestro/1");
        when(request.getMethod()).thenReturn("GET");
        assertThat(filter.shouldNotFilter(request)).isFalse();
    }

    @Test
    void shouldNotFilterReturnsTrueForNonActivosPath() {
        var filter = new ActivosJwtAuthenticationFilter(tokenResolver, objectMapper, Optional.empty());
        when(request.getRequestURI()).thenReturn("/api/ventas/facturas");
        when(request.getMethod()).thenReturn("GET");
        assertThat(filter.shouldNotFilter(request)).isTrue();
    }

    @Test
    void shouldNotFilterReturnsTrueForActuatorPath() {
        var filter = new ActivosJwtAuthenticationFilter(tokenResolver, objectMapper, Optional.empty());
        when(request.getRequestURI()).thenReturn("/actuator/health");
        assertThat(filter.shouldNotFilter(request)).isTrue();
    }

    @Test
    void shouldNotFilterReturnsTrueForSwaggerPath() {
        var filter = new ActivosJwtAuthenticationFilter(tokenResolver, objectMapper, Optional.empty());
        when(request.getRequestURI()).thenReturn("/swagger-ui/index.html");
        assertThat(filter.shouldNotFilter(request)).isTrue();
    }

    @Test
    void shouldNotFilterReturnsTrueForOptionsMethod() {
        var filter = new ActivosJwtAuthenticationFilter(tokenResolver, objectMapper, Optional.empty());
        when(request.getRequestURI()).thenReturn("/api/activos/test");
        when(request.getMethod()).thenReturn("OPTIONS");
        assertThat(filter.shouldNotFilter(request)).isTrue();
    }

    @Test
    void constructorAcceptsOptionalTokenUsoLogWriter() {
        @SuppressWarnings("unused")
        var withWriter = new ActivosJwtAuthenticationFilter(
                tokenResolver, objectMapper, Optional.of(org.mockito.Mockito.mock(TokenUsoLogWriter.class)));
        assertThat(withWriter).isNotNull();
    }
}
