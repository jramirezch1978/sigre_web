package pe.restaurant.activos.support;

import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Profile;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;

/**
 * Seguridad relajada para IT con perfil {@code test} (patrón ms-ventas / ms-finanzas).
 * El tenant HTTP sigue resolviéndose vía {@code X-Empresa-Id} en {@link pe.restaurant.activos.support.ActivosMockMvcSupport}.
 */
@TestConfiguration
@Profile("test")
public class ActivosTestSecurityConfig {

    @Bean
    @Order(org.springframework.core.Ordered.HIGHEST_PRECEDENCE)
    public SecurityFilterChain activosTestSecurityFilterChain(HttpSecurity http) throws Exception {
        return http
                .securityMatcher("/**")
                .csrf(AbstractHttpConfigurer::disable)
                .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth.anyRequest().permitAll())
                .build();
    }
}
