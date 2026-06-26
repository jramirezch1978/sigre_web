package pe.restaurant.common.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

/**
 * Configuración CORS centralizada para todos los microservicios.
 * Al estar en {@code pe.restaurant.common}, es escaneada automáticamente
 * por cualquier microservicio cuyo paquete base sea {@code pe.restaurant.*}.
 *
 * Para agregar o quitar orígenes, solo se modifica esta clase.
 */
@Configuration
public class CorsConfig {

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowedOrigins(List.of(
                "http://localhost:8100",
                "http://localhost:4200",
                "http://127.0.0.1:4200",
                "https://app.restaurant.pe",
                "http://169.197.82.217:8080",
                "https://panel.dev.contabilidad.restaurant.pe",
                "https://db-pv-pod1-dev.contabilidad.restaurant.pe",
                "https://api.dev.contabilidad.restaurant.pe",
                "http://aea6a227ef85d4072b2c24693172d1dc-205144200.us-east-1.elb.amazonaws.com"
        ));
        config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"));
        config.setAllowedHeaders(List.of(
                "Authorization", "Content-Type", "X-Provision-Secret",
                "X-Empresa-Id", "X-Requested-With"));
        config.setExposedHeaders(List.of("Authorization"));
        config.setAllowCredentials(true);
        config.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/api/**", config);
        return source;
    }
}
