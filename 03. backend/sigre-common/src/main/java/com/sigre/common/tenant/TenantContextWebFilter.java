package com.sigre.common.tenant;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.http.MediaType;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import com.sigre.common.dto.ApiResponse;
import com.sigre.common.security.JwtTokenProvider;
import com.sigre.common.security.TenantContext;

import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Establece {@link TenantContext} por petición: ruta {@code /api/{modulo}/empresas/{id}/...},
 * cabecera {@code X-Empresa-Id} o JWT {@code empresaId}.
 */
@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
@RequiredArgsConstructor
@ConditionalOnProperty(name = "app.security-datasource.jdbc-url")
public class TenantContextWebFilter extends OncePerRequestFilter {

    private static final Pattern EMPRESA_EN_RUTA = Pattern.compile("^/api/[^/]+/empresas/(\\d+)(/.*)?$");
    private static final String HDR_EMPRESA = "X-Empresa-Id";

    private final JwtTokenProvider jwtTokenProvider;
    private final ObjectMapper objectMapper;

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            return true;
        }
        String path = request.getRequestURI();
        if (path.startsWith("/actuator")) {
            return true;
        }
        if (path.contains("/swagger-ui") || path.contains("/v3/api-docs") || path.contains("api-docs")) {
            return true;
        }
        return false;
    }

    @Override
    protected void doFilterInternal(
            @NonNull HttpServletRequest request,
            @NonNull HttpServletResponse response,
            @NonNull FilterChain filterChain) throws ServletException, IOException {
        try {
            if (!request.getRequestURI().startsWith("/api/")) {
                filterChain.doFilter(request, response);
                return;
            }

            Long fromPath = extractEmpresaFromPath(request.getRequestURI());
            Long fromHeader = parseEmpresaHeader(request.getHeader(HDR_EMPRESA));
            Long fromJwt = extractEmpresaFromJwt(request.getHeader("Authorization"));

            Long resolved = fromPath != null ? fromPath : (fromHeader != null ? fromHeader : fromJwt);

            if (fromPath != null && fromJwt != null && !fromPath.equals(fromJwt)) {
                writeJson(response, HttpServletResponse.SC_FORBIDDEN,
                        "El empresaId de la ruta no coincide con el del token.",
                        "EMPRESA_TOKEN_CONFLICTO");
                return;
            }
            if (fromPath != null && fromHeader != null && !fromPath.equals(fromHeader)) {
                writeJson(response, HttpServletResponse.SC_FORBIDDEN,
                        "El empresaId de la ruta no coincide con X-Empresa-Id.",
                        "EMPRESA_HEADER_CONFLICTO");
                return;
            }

            if (resolved == null) {
                writeJson(response, HttpServletResponse.SC_BAD_REQUEST,
                        "Indique empresa: JWT con empresaId, cabecera X-Empresa-Id o use /api/{modulo}/empresas/{id}/...",
                        "EMPRESA_REQUERIDA");
                return;
            }

            TenantContext.setEmpresaId(resolved);
            filterChain.doFilter(request, response);
        } finally {
            TenantContext.clear();
        }
    }

    private static Long extractEmpresaFromPath(String uri) {
        Matcher m = EMPRESA_EN_RUTA.matcher(uri);
        if (m.matches()) {
            return Long.parseLong(m.group(1));
        }
        return null;
    }

    private static Long parseEmpresaHeader(String raw) {
        if (raw == null || raw.isBlank()) {
            return null;
        }
        try {
            return Long.parseLong(raw.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private Long extractEmpresaFromJwt(String authorization) {
        if (authorization == null || !authorization.startsWith("Bearer ")) {
            return null;
        }
        String token = authorization.substring(7).trim();
        if (token.isEmpty() || !jwtTokenProvider.validateToken(token)) {
            return null;
        }
        return jwtTokenProvider.getEmpresaId(token);
    }

    private void writeJson(HttpServletResponse response, int status, String message, String code) throws IOException {
        response.setStatus(status);
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(objectMapper.writeValueAsString(ApiResponse.error(message, code)));
    }
}
