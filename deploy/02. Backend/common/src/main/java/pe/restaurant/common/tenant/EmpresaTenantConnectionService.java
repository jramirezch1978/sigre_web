package pe.restaurant.common.tenant;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.util.AesEncryptor;

import java.util.List;
import java.util.Locale;

/**
 * Resuelve credenciales JDBC al tenant desde {@code master.empresa} (BD security).
 */
@Service
@ConditionalOnProperty(name = "app.security-datasource.jdbc-url")
public class EmpresaTenantConnectionService {

    private final JdbcTemplate securityJdbcTemplate;
    private final AesEncryptor aesEncryptor;

    @Value("${app.tenant.jdbc-ssl-mode:require}")
    private String jdbcSslMode;

    @Value("${app.tenant.db-host-override:#{null}}")
    private String dbHostOverride;

    @Value("${app.tenant.db-port-override:#{null}}")
    private Integer dbPortOverride;

    public EmpresaTenantConnectionService(
            @Qualifier("securityJdbcTemplate") JdbcTemplate securityJdbcTemplate,
            AesEncryptor aesEncryptor) {
        this.securityJdbcTemplate = securityJdbcTemplate;
        this.aesEncryptor = aesEncryptor;
    }

    public TenantConnectionInfo getTenantConnection(Long empresaId) {
        List<TenantConnectionInfo> rows = securityJdbcTemplate.query(
                """
                SELECT id, codigo, db_host, db_port, db_name, db_user, db_password_encrypted
                FROM master.empresa WHERE id = ?
                """,
                (rs, rowNum) -> {
                    long id = rs.getLong("id");
                    String codigo = rs.getString("codigo");
                    String host = rs.getString("db_host");
                    int port = rs.getInt("db_port");
                    String dbName = rs.getString("db_name");
                    String dbUser = rs.getString("db_user");
                    String enc = rs.getString("db_password_encrypted");
                    String pwd = aesEncryptor.decrypt(enc);
                    
                    String finalHost = dbHostOverride != null ? dbHostOverride : host;
                    int finalPort = dbPortOverride != null ? dbPortOverride : port;
                    
                    String url = String.format(Locale.ROOT,
                            "jdbc:postgresql://%s:%d/%s?sslmode=%s",
                            finalHost, finalPort, dbName, jdbcSslMode);
                    return TenantConnectionInfo.builder()
                            .empresaId(id)
                            .codigo(codigo)
                            .jdbcUrl(url)
                            .username(dbUser)
                            .password(pwd)
                            .build();
                },
                empresaId);
        if (rows.isEmpty()) {
            throw new BusinessException(
                    "No existe empresa con id " + empresaId,
                    HttpStatus.NOT_FOUND,
                    "EMPRESA_NO_ENCONTRADA");
        }
        return rows.get(0);
    }
}
