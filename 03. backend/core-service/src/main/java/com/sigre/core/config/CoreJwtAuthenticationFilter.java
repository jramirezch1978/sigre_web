package com.sigre.core.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Component;
import com.sigre.common.security.JwtDefinitiveTokenResolver;
import com.sigre.common.security.JwtTenantAuthFilter;
import com.sigre.common.security.TokenUsoLogWriter;

import java.util.Optional;

@Component
public class CoreJwtAuthenticationFilter extends JwtTenantAuthFilter {

    public CoreJwtAuthenticationFilter(JwtDefinitiveTokenResolver tokenResolver, ObjectMapper objectMapper, Optional<TokenUsoLogWriter> tokenUsoLogWriter) {
        super(tokenResolver, objectMapper, tokenUsoLogWriter);
    }
}
