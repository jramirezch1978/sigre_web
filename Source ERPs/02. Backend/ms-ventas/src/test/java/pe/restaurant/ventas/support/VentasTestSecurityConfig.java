package pe.restaurant.ventas.support;

import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Profile;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;

/**
 * Configuración de seguridad para tests de integración.
 * Tiene máxima prioridad (@Order) para ejecutarse antes que la configuración
 * de seguridad productiva y permitir todas las requests sin JWT real.
 *
 * <p>Solo se activa con el perfil {@code test}.
 */
@TestConfiguration
@Profile("test")
public class VentasTestSecurityConfig {

    @Bean
    @Order(org.springframework.core.Ordered.HIGHEST_PRECEDENCE)
    public SecurityFilterChain testSecurityFilterChain(HttpSecurity http) throws Exception {
        return http
                .securityMatcher("/**")
                .csrf(AbstractHttpConfigurer::disable)
                .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth.anyRequest().permitAll())
                .build();
    }
}
