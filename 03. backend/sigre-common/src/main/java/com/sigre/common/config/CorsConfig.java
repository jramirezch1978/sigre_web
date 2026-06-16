package com.sigre.common.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Configuración CORS centralizada para todos los microservicios.
 * Al estar en {@code com.sigre.common}, es escaneada automáticamente
 * por cualquier microservicio cuyo paquete base sea {@code com.sigre.*}.
 *
 * Patrones extra vía env {@code CORS_ALLOWED_ORIGIN_PATTERNS} (coma-separados).
 */
@Configuration
public class CorsConfig {

    private static final List<String> DEFAULT_ORIGIN_PATTERNS = List.of(
            "http://localhost:*",
            "http://127.0.0.1:*",
            "http://crisaor.serveftp.com:*",
            "https://app.sigre.local",
            "https://panel.dev.contabilidad.sigre.local",
            "https://db-pv-pod1-dev.contabilidad.sigre.local",
            "https://api.dev.contabilidad.sigre.local",
            "http://169.197.82.217:*",
            "http://aea6a227ef85d4072b2c24693172d1dc-205144200.us-east-1.elb.amazonaws.com"
    );

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration config = new CorsConfiguration();
        List<String> patterns = new ArrayList<>(DEFAULT_ORIGIN_PATTERNS);
        String extra = System.getenv("CORS_ALLOWED_ORIGIN_PATTERNS");
        if (extra != null && !extra.isBlank()) {
            Arrays.stream(extra.split(","))
                    .map(String::trim)
                    .filter(s -> !s.isEmpty())
                    .forEach(patterns::add);
        }
        config.setAllowedOriginPatterns(patterns);
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
