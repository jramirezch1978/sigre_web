package pe.restaurant.compras.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Component;
import pe.restaurant.common.security.JwtDefinitiveTokenResolver;
import pe.restaurant.common.security.JwtTenantAuthFilter;
import pe.restaurant.common.security.TokenUsoLogWriter;

import java.util.Optional;

@Component
public class ComprasJwtAuthenticationFilter extends JwtTenantAuthFilter {

    public ComprasJwtAuthenticationFilter(JwtDefinitiveTokenResolver tokenResolver, ObjectMapper objectMapper, Optional<TokenUsoLogWriter> tokenUsoLogWriter) {
        super(tokenResolver, objectMapper, tokenUsoLogWriter);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        if (super.shouldNotFilter(request)) {
            return true;
        }
        String path = request.getRequestURI();
        return !path.startsWith("/api/compras");
    }
}
