package pe.restaurant.core.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Component;
import pe.restaurant.common.security.JwtDefinitiveTokenResolver;
import pe.restaurant.common.security.JwtTenantAuthFilter;
import pe.restaurant.common.security.TokenUsoLogWriter;

import java.util.Optional;

@Component
public class CoreJwtAuthenticationFilter extends JwtTenantAuthFilter {

    public CoreJwtAuthenticationFilter(JwtDefinitiveTokenResolver tokenResolver, ObjectMapper objectMapper, Optional<TokenUsoLogWriter> tokenUsoLogWriter) {
        super(tokenResolver, objectMapper, tokenUsoLogWriter);
    }
}
