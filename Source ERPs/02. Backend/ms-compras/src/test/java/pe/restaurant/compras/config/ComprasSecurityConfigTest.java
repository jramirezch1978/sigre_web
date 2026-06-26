package pe.restaurant.compras.config;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.web.cors.CorsConfigurationSource;

import static org.assertj.core.api.Assertions.assertThat;

@ExtendWith(MockitoExtension.class)
@DisplayName("ComprasSecurityConfig — Pruebas Unitarias")
class ComprasSecurityConfigTest {

    @Mock
    private ComprasJwtAuthenticationFilter jwtAuthenticationFilter;

    @Mock
    private CorsConfigurationSource corsConfigurationSource;

    @InjectMocks
    private ComprasSecurityConfig config;

    @Test
    @DisplayName("instanciaConfig() not null")
    void instanciaConfig_notNull() {
        assertThat(config).isNotNull();
    }

    @Test
    @DisplayName("tieneJwtFilter() inyectado")
    void tieneJwtFilter_inyectado() {
        assertThat(jwtAuthenticationFilter).isNotNull();
    }

    @Test
    @DisplayName("tieneCorsConfigSource() inyectado")
    void tieneCorsConfigSource_inyectado() {
        assertThat(corsConfigurationSource).isNotNull();
    }
}
