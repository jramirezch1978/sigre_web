package pe.restaurant.common.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.lang.NonNull;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;
import pe.restaurant.common.dto.ApiResponse;

import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import pe.restaurant.common.util.Constants;

/**
 * Filtro genérico de autenticación JWT para microservicios con multi-tenancy.
 * <p>
 * Al heredar, cada microservicio puede sobreescribir {@link #shouldNotFilter}
 * para decidir qué rutas proteger. Por defecto protege todo bajo {@code /api/}.
 * <p>
 * <b>Qué hace:</b>
 * <ol>
 *   <li>Extrae y valida el JWT definitivo del header {@code Authorization}.</li>
 *   <li>Verifica sesión activa en {@code auth.tokens_session} (si hay {@link TokensSessionChecker}).</li>
 *   <li>Setea {@link TenantContext} con {@code empresaId}, {@code sucursalId}, {@code paisId} y {@code usuarioId}.</li>
 *   <li>Pone la autenticación en {@link SecurityContextHolder} con {@code username} y {@code userId}.</li>
 * </ol>
 * <p>
 * Los microservicios obtienen el contexto con:
 * <pre>
 *   TenantContext.getEmpresaId()
 *   TenantContext.getSucursalId()
 *   TenantContext.getPaisId()
 *   TenantContext.getUsuarioId()
 * </pre>
 * O desde el {@code Authentication.getDetails()} que contiene un {@link DefinitiveTokenClaims}.
 */
@Slf4j
public class JwtTenantAuthFilter extends OncePerRequestFilter {

    private static final Set<String> SKIP_PREFIXES = Set.of(
            "/actuator", "/swagger-ui", "/v3/api-docs"
    );

    private final JwtDefinitiveTokenResolver tokenResolver;
    private final ObjectMapper objectMapper;
    private final Optional<TokenUsoLogWriter> tokenUsoLogWriter;

    public JwtTenantAuthFilter(JwtDefinitiveTokenResolver tokenResolver,
                               ObjectMapper objectMapper,
                               Optional<TokenUsoLogWriter> tokenUsoLogWriter) {
        this.tokenResolver = tokenResolver;
        this.objectMapper = objectMapper;
        this.tokenUsoLogWriter = tokenUsoLogWriter;
    }

    @Override
    protected boolean shouldNotFilter(@NonNull HttpServletRequest request) {
        String path = request.getRequestURI();
        return SKIP_PREFIXES.stream().anyMatch(path::startsWith)
                || "OPTIONS".equalsIgnoreCase(request.getMethod());
    }

    @Override
    protected void doFilterInternal(@NonNull HttpServletRequest request,
                                    @NonNull HttpServletResponse response,
                                    @NonNull FilterChain filterChain) throws ServletException, IOException {
        String authHeader = request.getHeader("Authorization");

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        Optional<DefinitiveTokenClaims> optClaims = tokenResolver.resolve(authHeader);
        if (optClaims.isEmpty()) {
            writeError(response, HttpServletResponse.SC_UNAUTHORIZED,
                    "Su sesión ha expirado. Por favor, inicie sesión nuevamente.",
                    "TOKEN_EXPIRADO");
            return;
        }

        DefinitiveTokenClaims claims = optClaims.get();

        if (!claims.isTemporal() && !tokenResolver.isSessionActive(claims)) {
            writeError(response, HttpServletResponse.SC_UNAUTHORIZED,
                    "Su sesión ha sido cerrada o está inactiva. Inicie sesión nuevamente.",
                    "SESION_REVOADA");
            return;
        }

        TenantContext.setEmpresaId(claims.getEmpresaId());
        TenantContext.setSucursalId(claims.getSucursalId());
        TenantContext.setPaisId(claims.getPaisId());
        TenantContext.setUsuarioId(claims.getUserId());

        UsernamePasswordAuthenticationToken authentication =
                new UsernamePasswordAuthenticationToken(claims.getUsername(), null, List.of());
        authentication.setDetails(claims);
        SecurityContextHolder.getContext().setAuthentication(authentication);

        long startNanos = System.nanoTime();
        try {
            filterChain.doFilter(request, response);
        } finally {
            long duracionMs = (System.nanoTime() - startNanos) / 1_000_000;
            tokenUsoLogWriter.ifPresent(writer -> writer.registrar(
                    claims.getTokensSessionId(),
                    request.getMethod(),
                    request.getRequestURI(),
                    request.getRemoteAddr(),
                    request.getHeader("X-Forwarded-For"),
                    request.getHeader("User-Agent"),
                    response.getStatus(),
                    duracionMs));
            TenantContext.clear();
            SecurityContextHolder.clearContext();
        }
    }

    private void writeError(HttpServletResponse response, int status, String message, String errorCode)
            throws IOException {
        response.setStatus(status);
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(objectMapper.writeValueAsString(ApiResponse.error(message, errorCode)));
    }
}
