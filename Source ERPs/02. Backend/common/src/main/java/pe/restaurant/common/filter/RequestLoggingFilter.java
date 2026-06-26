package pe.restaurant.common.filter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.MDC;
import org.springframework.boot.autoconfigure.condition.ConditionalOnWebApplication;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import pe.restaurant.common.security.JwtTokenProvider;

import java.io.IOException;

/**
 * Filtro que intercepta cada request HTTP para:
 * 1. Extraer el userId/username del JWT y colocarlo en MDC
 * 2. Medir la duración total del request
 * 3. Logear una línea estructurada al finalizar:
 *    user=jramirez method=GET uri=/api/core/doc-tipos status=200 duration_ms=12
 *
 * Loki/Promtail recolecta estos logs y Grafana los consulta con LogQL.
 */
@Slf4j
@Component
@Order(Ordered.HIGHEST_PRECEDENCE + 10)
@ConditionalOnWebApplication(type = ConditionalOnWebApplication.Type.SERVLET)
@RequiredArgsConstructor
public class RequestLoggingFilter extends OncePerRequestFilter {

    private static final String MDC_USER = "userId";
    private static final String MDC_METHOD = "httpMethod";
    private static final String ANONYMOUS = "anonymous";

    private final JwtTokenProvider jwtTokenProvider;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        String username = extractUsername(request);
        MDC.put(MDC_USER, username);
        MDC.put(MDC_METHOD, request.getMethod());

        long startTime = System.nanoTime();
        try {
            filterChain.doFilter(request, response);
        } finally {
            long durationMs = (System.nanoTime() - startTime) / 1_000_000;
            int status = response.getStatus();
            String uri = request.getRequestURI();
            String method = request.getMethod();

            log.info("user={} method={} uri={} status={} duration_ms={}",
                    username, method, uri, status, durationMs);

            MDC.remove(MDC_USER);
            MDC.remove(MDC_METHOD);
        }
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getRequestURI();
        return path.startsWith("/actuator")
                || path.startsWith("/swagger")
                || path.startsWith("/v3/api-docs");
    }

    private String extractUsername(HttpServletRequest request) {
        String header = request.getHeader("Authorization");
        if (header == null || !header.startsWith("Bearer ")) {
            return ANONYMOUS;
        }
        try {
            String token = header.substring(7);
            if (jwtTokenProvider.validateToken(token)) {
                return jwtTokenProvider.getUsername(token);
            }
        } catch (Exception e) {
            log.debug("No se pudo extraer usuario del JWT: {}", e.getMessage());
        }
        return ANONYMOUS;
    }
}
