package com.uncledavecode.api_gateway.config;

// Configuración de seguridad deshabilitada para desarrollo
// Sin autenticación requerida para el módulo de asistencia

/*
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.web.server.SecurityWebFilterChain;

@Configuration
public class SecurityConfig {

    @Bean
    public SecurityWebFilterChain securityWebFilterChain(ServerHttpSecurity http) {
        http
                .csrf().disable()
                .authorizeExchange().anyExchange().authenticated()
                .and()
                .oauth2Login();

        return http.build();
    }
}
*/
