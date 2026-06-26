package pe.restaurant.common.security;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletRequestWrapper;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Filtro OWASP que aplica:
 * 1. Security headers (X-Content-Type-Options, X-Frame-Options, etc.)
 * 2. Rate limiting por IP (máx 60 req/min en endpoints de auth)
 * 3. Límite de tamaño del body (1 MB)
 * NOTA: La sanitización XSS y detección de SQL injection se hace en los controllers, NO aquí.
 */
@Slf4j
@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class OwaspSecurityFilter implements Filter {

    private static final int MAX_BODY_SIZE = 1_048_576;
    private static final int RATE_LIMIT_PER_MINUTE = 60;
    private static final int RATE_WINDOW_MS = 60_000;

    private final ConcurrentHashMap<String, RateEntry> rateLimitMap = new ConcurrentHashMap<>();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpReq = (HttpServletRequest) request;
        HttpServletResponse httpRes = (HttpServletResponse) response;

        addSecurityHeaders(httpRes);

        String path = httpReq.getRequestURI();
        if (path.startsWith("/api/auth/")) {
            String clientIp = getClientIp(httpReq);
            if (isRateLimited(clientIp)) {
                httpRes.setStatus(429);
                httpRes.setContentType("application/json;charset=UTF-8");
                httpRes.getWriter().write(
                        "{\"success\":false,\"message\":\"Demasiadas solicitudes. Intente más tarde.\",\"errorCode\":\"RATE_LIMIT_EXCEEDED\"}");
                return;
            }
        }

        String contentType = httpReq.getContentType();
        boolean isJson = contentType != null && contentType.contains("application/json");
        String method = httpReq.getMethod();
        boolean hasBody = "POST".equalsIgnoreCase(method) || "PUT".equalsIgnoreCase(method)
                || "PATCH".equalsIgnoreCase(method);

        if (isJson && hasBody) {
            CachedBodyRequest wrappedRequest = new CachedBodyRequest(httpReq);
            byte[] bodyBytes = wrappedRequest.getCachedBody();

            if (bodyBytes.length > MAX_BODY_SIZE) {
                httpRes.setStatus(413);
                httpRes.setContentType("application/json;charset=UTF-8");
                httpRes.getWriter().write(
                        "{\"success\":false,\"message\":\"El cuerpo de la solicitud excede el tamaño máximo permitido.\",\"errorCode\":\"PAYLOAD_TOO_LARGE\"}");
                return;
            }

            chain.doFilter(wrappedRequest, httpRes);
        } else {
            chain.doFilter(httpReq, httpRes);
        }
    }

    private void addSecurityHeaders(HttpServletResponse response) {
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader("X-Frame-Options", "DENY");
        response.setHeader("X-XSS-Protection", "1; mode=block");
        response.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains");
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
        response.setHeader("Permissions-Policy", "camera=(), microphone=(), geolocation=()");
    }

    private boolean isRateLimited(String ip) {
        long now = System.currentTimeMillis();
        rateLimitMap.entrySet().removeIf(e -> now - e.getValue().windowStart > RATE_WINDOW_MS * 2);

        RateEntry entry = rateLimitMap.compute(ip, (key, existing) -> {
            if (existing == null || now - existing.windowStart > RATE_WINDOW_MS) {
                return new RateEntry(now, new AtomicInteger(1));
            }
            existing.count.incrementAndGet();
            return existing;
        });

        return entry.count.get() > RATE_LIMIT_PER_MINUTE;
    }

    private String getClientIp(HttpServletRequest request) {
        String xff = request.getHeader("X-Forwarded-For");
        if (xff != null && !xff.isBlank()) {
            return xff.split(",")[0].trim();
        }
        String realIp = request.getHeader("X-Real-IP");
        if (realIp != null && !realIp.isBlank()) return realIp;
        return request.getRemoteAddr();
    }

    private static class RateEntry {
        final long windowStart;
        final AtomicInteger count;

        RateEntry(long windowStart, AtomicInteger count) {
            this.windowStart = windowStart;
            this.count = count;
        }
    }

    private static class CachedBodyRequest extends HttpServletRequestWrapper {
        private byte[] cachedBody;

        CachedBodyRequest(HttpServletRequest request) throws IOException {
            super(request);
            InputStream is = request.getInputStream();
            this.cachedBody = is.readAllBytes();
        }

        byte[] getCachedBody() {
            return cachedBody;
        }

        void setBody(byte[] body) {
            this.cachedBody = body;
        }

        @Override
        public ServletInputStream getInputStream() {
            ByteArrayInputStream bis = new ByteArrayInputStream(cachedBody);
            return new ServletInputStream() {
                @Override public boolean isFinished() { return bis.available() == 0; }
                @Override public boolean isReady() { return true; }
                @Override public void setReadListener(ReadListener listener) { }
                @Override public int read() { return bis.read(); }
            };
        }

        @Override
        public BufferedReader getReader() {
            return new BufferedReader(new InputStreamReader(getInputStream(), StandardCharsets.UTF_8));
        }

        @Override
        public int getContentLength() {
            return cachedBody.length;
        }

        @Override
        public long getContentLengthLong() {
            return cachedBody.length;
        }
    }
}
