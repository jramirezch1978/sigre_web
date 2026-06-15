package com.sigre.seguridad.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import com.sigre.common.dto.ApiResponse;
import com.sigre.common.security.JwtTokenProvider;
import com.sigre.seguridad.service.TokensSessionService;

import java.io.IOException;
import java.util.List;
import java.util.Set;

@Slf4j
@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtTokenProvider jwtTokenProvider;
    private final TokensSessionService tokensSessionService;
    private final ObjectMapper objectMapper;

    private static final Set<String> PUBLIC_PATHS = Set.of(
            "/api/auth/login",
            "/api/auth/recuperar/",
            "/api/admin/empresas/",
            "/api/internal/tenants/",
            "/actuator/",
            "/swagger-ui/",
            "/v3/api-docs/",
            "/api/auth/v3/api-docs",
            "/api/auth/swagger-ui"
    );

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getRequestURI();
        if ("/api/auth/login".equals(path)) return true;
        if ("/api/auth/refresh".equals(path)) return true;
        return PUBLIC_PATHS.stream().anyMatch(p -> path.startsWith(p) || path.equals(p.replace("/", "")));
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {
        String authHeader = request.getHeader("Authorization");

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        String token = authHeader.substring(7);

        if (!jwtTokenProvider.validateToken(token)) {
            writeErrorResponse(response, HttpServletResponse.SC_UNAUTHORIZED,
                    "Su sesión ha expirado. Por favor, inicie sesión nuevamente.",
                    "TOKEN_EXPIRADO");
            return;
        }

        String username = jwtTokenProvider.getUsername(token);
        Long userId = jwtTokenProvider.getUserId(token);

        String uri = request.getRequestURI();
        boolean esLogout = uri != null && uri.contains("/auth/logout");

        Boolean temporal = jwtTokenProvider.getClaim(token, "temporal", Boolean.class);
        Long tokensSessionId = jwtTokenProvider.getClaim(token, "tokensSessionId", Long.class);
        if (tokensSessionId == null) {
            Object n = jwtTokenProvider.getClaim(token, "tokensSessionId", Object.class);
            if (n instanceof Number) {
                tokensSessionId = ((Number) n).longValue();
            }
        }
        if (!esLogout && !Boolean.TRUE.equals(temporal) && tokensSessionId != null && userId != null) {
            if (!tokensSessionService.sesionActivaParaToken(userId, tokensSessionId)) {
                writeErrorResponse(response, HttpServletResponse.SC_UNAUTHORIZED,
                        "Su sesión ha sido cerrada o está inactiva. Inicie sesión nuevamente.",
                        "SESION_REVOADA");
                return;
            }
        }

        UsernamePasswordAuthenticationToken authentication =
                new UsernamePasswordAuthenticationToken(username, null, List.of());
        authentication.setDetails(userId);
        SecurityContextHolder.getContext().setAuthentication(authentication);

        filterChain.doFilter(request, response);
    }

    private void writeErrorResponse(HttpServletResponse response, int status,
                                    String message, String errorCode) throws IOException {
        response.setStatus(status);
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setCharacterEncoding("UTF-8");

        ApiResponse<?> apiResponse = ApiResponse.error(message, errorCode);
        response.getWriter().write(objectMapper.writeValueAsString(apiResponse));
    }
}
