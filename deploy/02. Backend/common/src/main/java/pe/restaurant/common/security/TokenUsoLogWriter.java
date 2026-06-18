package pe.restaurant.common.security;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

/**
 * Graba cada request autenticado en {@code auth.token_uso_log} (BD security).
 * <p>
 * Usa conexión JDBC temporal (no pool): abre, inserta y cierra de inmediato.
 * Los microservicios solo mantienen pools hacia los tenants; esta escritura
 * a security es puntual y asíncrona para no impactar la latencia del request.
 */
@Slf4j
@Component
@ConditionalOnProperty(name = "app.security-datasource.jdbc-url")
public class TokenUsoLogWriter {

    private static final String INSERT_SQL =
            """
            INSERT INTO auth.token_uso_log
                (tokens_session_id, metodo, uri, ip, ip_privada, user_agent, microservicio, status_code, duracion_ms)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """;

    private final String jdbcUrl;
    private final String username;
    private final String password;
    private final String microservicio;

    public TokenUsoLogWriter(
            @Value("${app.security-datasource.jdbc-url}") String jdbcUrl,
            @Value("${app.security-datasource.username}") String username,
            @Value("${app.security-datasource.password}") String password,
            @Value("${spring.application.name:unknown}") String microservicio) {
        this.jdbcUrl = jdbcUrl;
        this.username = username;
        this.password = password;
        this.microservicio = microservicio;
    }

    @Async
    public void registrar(Long tokensSessionId, String metodo, String uri,
                          String ip, String ipPrivada, String userAgent,
                          int statusCode, long duracionMs) {
        if (tokensSessionId == null) {
            return;
        }
        try (Connection conn = DriverManager.getConnection(jdbcUrl, username, password);
             PreparedStatement ps = conn.prepareStatement(INSERT_SQL)) {
            ps.setLong(1, tokensSessionId);
            ps.setString(2, metodo);
            ps.setString(3, truncate(uri, 500));
            ps.setString(4, ip);
            ps.setString(5, ipPrivada);
            ps.setString(6, truncate(userAgent, 500));
            ps.setString(7, microservicio);
            ps.setInt(8, statusCode);
            ps.setLong(9, duracionMs);
            ps.executeUpdate();
        } catch (Exception e) {
            log.warn("No se pudo registrar token_uso_log: {}", e.getMessage());
        }
    }

    private static String truncate(String value, int maxLen) {
        if (value == null) {
            return null;
        }
        return value.length() <= maxLen ? value : value.substring(0, maxLen);
    }
}
