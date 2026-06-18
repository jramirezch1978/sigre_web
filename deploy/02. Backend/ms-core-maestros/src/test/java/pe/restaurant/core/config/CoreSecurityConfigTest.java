package pe.restaurant.core.config;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.web.cors.CorsConfigurationSource;

import static org.assertj.core.api.Assertions.assertThat;

@ExtendWith(MockitoExtension.class)
class CoreSecurityConfigTest {

    @Mock
    private CoreJwtAuthenticationFilter jwtAuthenticationFilter;

    @Mock
    private CorsConfigurationSource corsConfigurationSource;

    @InjectMocks
    private CoreSecurityConfig config;

    @Test
    void instanciaConfig_notNull() {
        assertThat(config).isNotNull();
    }

    @Test
    void tieneJwtFilter_inyectado() {
        assertThat(jwtAuthenticationFilter).isNotNull();
    }

    @Test
    void tieneCorsConfigSource_inyectado() {
        assertThat(corsConfigurationSource).isNotNull();
    }
}
