package com.sigre.rrhh.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Component;
import com.sigre.common.security.JwtDefinitiveTokenResolver;
import com.sigre.common.security.JwtTenantAuthFilter;
import com.sigre.common.security.TokenUsoLogWriter;

import java.util.Optional;

@Component
public class RrhhJwtAuthenticationFilter extends JwtTenantAuthFilter {

    public RrhhJwtAuthenticationFilter(JwtDefinitiveTokenResolver tokenResolver, ObjectMapper objectMapper, Optional<TokenUsoLogWriter> tokenUsoLogWriter) {
        super(tokenResolver, objectMapper, tokenUsoLogWriter);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        if (super.shouldNotFilter(request)) {
            return true;
        }
        String path = request.getRequestURI();
        return !path.startsWith("/api/rrhh");
    }
}
