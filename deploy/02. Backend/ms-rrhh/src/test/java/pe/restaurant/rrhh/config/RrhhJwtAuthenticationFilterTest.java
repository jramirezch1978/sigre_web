package pe.restaurant.rrhh.config;

import jakarta.servlet.http.HttpServletRequest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("RrhhJwtAuthenticationFilter — Pruebas Unitarias")
class RrhhJwtAuthenticationFilterTest {

    @Mock
    private HttpServletRequest request;

    private RrhhJwtAuthenticationFilter filter;

    @BeforeEach
    void setUp() {
        filter = new RrhhJwtAuthenticationFilter(null, null, null);
    }

    @Test
    @DisplayName("shouldNotFilter() con path /api/rrhh/xxx -> false")
    void shouldNotFilter_pathApiRrhh_retornaFalse() {
        when(request.getRequestURI()).thenReturn("/api/rrhh/trabajadores");

        boolean result = filter.shouldNotFilter(request);

        assertThat(result).isFalse();
    }

    @Test
    @DisplayName("shouldNotFilter() con path /otro -> true")
    void shouldNotFilter_pathNoApiRrhh_retornaTrue() {
        when(request.getRequestURI()).thenReturn("/api/otro/trabajadores");

        boolean result = filter.shouldNotFilter(request);

        assertThat(result).isTrue();
    }

    @Test
    @DisplayName("shouldNotFilter() con path de actuator -> true (skip by super)")
    void shouldNotFilter_pathActuator_retornaTrue() {
        when(request.getRequestURI()).thenReturn("/actuator/health");

        boolean result = filter.shouldNotFilter(request);

        assertThat(result).isTrue();
    }

    @Test
    @DisplayName("shouldNotFilter() con metodo OPTIONS -> true (skip by super)")
    void shouldNotFilter_methodOptions_retornaTrue() {
        when(request.getRequestURI()).thenReturn("/api/rrhh/test");
        when(request.getMethod()).thenReturn("OPTIONS");

        boolean result = filter.shouldNotFilter(request);

        assertThat(result).isTrue();
    }
}
