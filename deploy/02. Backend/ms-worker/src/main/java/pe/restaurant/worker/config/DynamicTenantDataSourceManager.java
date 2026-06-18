package pe.restaurant.worker.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import jakarta.annotation.PreDestroy;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import pe.restaurant.common.util.AesEncryptor;
import pe.restaurant.worker.schema.SchemaSyncModels.TenantConnectionInfo;

import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Slf4j
@Component
public class DynamicTenantDataSourceManager {

    private static final Pattern JDBC_URL_PATTERN =
            Pattern.compile("^jdbc:postgresql://(?<host>[^:/?]+)(:(?<port>\\d+))?/(?<db>[^?]+).*$");

    private final JdbcTemplate jdbcTemplate;
    private final ObjectProvider<AesEncryptor> aesEncryptorProvider;
    private final ConcurrentHashMap<String, HikariDataSource> tenantPools = new ConcurrentHashMap<>();
    private final Object templateLock = new Object();
    private volatile HikariDataSource templatePool;

    @Value("${spring.datasource.url}")
    private String securityDatasourceUrl;

    @Value("${spring.datasource.username}")
    private String securityDatasourceUsername;

    @Value("${spring.datasource.password:}")
    private String securityDatasourcePassword;

    @Value("${app.schema-sync.template-database:restaurant_pe_template}")
    private String templateDatabase;

    @Value("${app.schema-sync.pool.max-size:2}")
    private int poolMaxSize;

    @Value("${app.schema-sync.pool.min-idle:0}")
    private int poolMinIdle;

    @Value("${app.schema-sync.pool.idle-timeout-ms:60000}")
    private long poolIdleTimeoutMs;

    @Value("${app.schema-sync.pool.connection-timeout-ms:10000}")
    private long poolConnectionTimeoutMs;

    public DynamicTenantDataSourceManager(JdbcTemplate jdbcTemplate,
                                          ObjectProvider<AesEncryptor> aesEncryptorProvider) {
        this.jdbcTemplate = jdbcTemplate;
        this.aesEncryptorProvider = aesEncryptorProvider;
    }

    public HikariDataSource getTemplateDataSource() {
        HikariDataSource current = templatePool;
        if (current != null && !current.isClosed()) {
            return current;
        }
        synchronized (templateLock) {
            if (templatePool != null && !templatePool.isClosed()) {
                return templatePool;
            }
            templatePool = createPool(buildTemplateConnection(), "template");
            return templatePool;
        }
    }

    public HikariDataSource getTenantDataSource(TenantConnectionInfo tenant) {
        return tenantPools.compute(tenant.dbName(), (key, existing) -> {
            if (existing != null && !existing.isClosed()) {
                return existing;
            }
            log.info("Creando pool dinamico para tenant: {}", tenant.dbName());
            return createPool(tenant, tenant.dbName());
        });
    }

    public List<TenantConnectionInfo> loadActiveTenants() {
        return jdbcTemplate.query("""
                        SELECT id, codigo, razon_social, db_host, db_port,
                               db_name, db_user, db_password_encrypted, flag_estado
                        FROM master.empresa
                        WHERE flag_estado = '1'
                        ORDER BY id
                        """,
                (rs, rowNum) -> new TenantConnectionInfo(
                        rs.getLong("id"),
                        rs.getString("codigo"),
                        rs.getString("razon_social"),
                        rs.getString("db_host"),
                        rs.getInt("db_port"),
                        rs.getString("db_name"),
                        rs.getString("db_user"),
                        resolvePassword(rs.getString("db_password_encrypted")),
                        "1".equals(rs.getString("flag_estado"))));
    }

    public void evictInactiveTenants(List<TenantConnectionInfo> activeTenants) {
        Set<String> activeNames = new HashSet<>();
        for (TenantConnectionInfo t : activeTenants) {
            activeNames.add(t.dbName());
        }
        tenantPools.forEach((dbName, pool) -> {
            if (!activeNames.contains(dbName)) {
                log.info("Evicting pool inactivo: {}", dbName);
                tenantPools.remove(dbName);
                closeQuietly(pool);
            }
        });
    }

    public String getTemplateDatabaseName() {
        return templateDatabase;
    }

    /**
     * Crea un pool temporal con credenciales admin (spring.datasource) apuntando
     * a la BD del tenant. Sirve para operaciones que requieren privilegios de owner
     * (GRANT, ALTER DEFAULT PRIVILEGES, etc.).
     */
    public HikariDataSource createAdminPoolForTenant(TenantConnectionInfo tenant) {
        TenantConnectionInfo adminInfo = new TenantConnectionInfo(
                tenant.empresaId(), tenant.codigo(), tenant.nombreEmpresa(),
                tenant.dbHost(), tenant.dbPort(), tenant.dbName(),
                securityDatasourceUsername,
                securityDatasourcePassword == null ? "" : securityDatasourcePassword,
                tenant.activo());
        HikariConfig config = new HikariConfig();
        config.setDriverClassName("org.postgresql.Driver");
        config.setJdbcUrl("jdbc:postgresql://%s:%d/%s".formatted(
                adminInfo.dbHost(),
                adminInfo.dbPort() == null ? 5432 : adminInfo.dbPort(),
                adminInfo.dbName()));
        config.setUsername(adminInfo.dbUser());
        config.setPassword(adminInfo.dbPassword());
        config.setMaximumPoolSize(1);
        config.setMinimumIdle(0);
        config.setConnectionTimeout(poolConnectionTimeoutMs);
        config.setPoolName("admin-grant-" + tenant.dbName().toLowerCase(Locale.ROOT));
        return new HikariDataSource(config);
    }

    public int getActiveTenantPoolCount() {
        return tenantPools.size();
    }

    @PreDestroy
    public void closeAll() {
        log.info("Cerrando todos los pools dinamicos ({} tenants)...", tenantPools.size());
        tenantPools.forEach((dbName, pool) -> closeQuietly(pool));
        tenantPools.clear();
        if (templatePool != null) {
            closeQuietly(templatePool);
            templatePool = null;
        }
    }

    private HikariDataSource createPool(TenantConnectionInfo info, String label) {
        HikariConfig config = new HikariConfig();
        config.setDriverClassName("org.postgresql.Driver");
        config.setJdbcUrl("jdbc:postgresql://%s:%d/%s".formatted(
                info.dbHost(),
                info.dbPort() == null ? 5432 : info.dbPort(),
                info.dbName()));
        config.setUsername(info.dbUser());
        config.setPassword(info.dbPassword() == null ? "" : info.dbPassword());
        config.setMaximumPoolSize(poolMaxSize);
        config.setMinimumIdle(poolMinIdle);
        config.setIdleTimeout(poolIdleTimeoutMs);
        config.setConnectionTimeout(poolConnectionTimeoutMs);
        config.setValidationTimeout(5_000);
        config.setInitializationFailTimeout(poolConnectionTimeoutMs);
        config.setPoolName("sync-" + label.toLowerCase(Locale.ROOT));
        return new HikariDataSource(config);
    }

    private TenantConnectionInfo buildTemplateConnection() {
        Matcher matcher = JDBC_URL_PATTERN.matcher(securityDatasourceUrl);
        if (!matcher.matches()) {
            throw new IllegalStateException(
                    "No se pudo interpretar spring.datasource.url para conectar al template");
        }
        String host = matcher.group("host");
        String portText = matcher.group("port");
        int port = portText == null || portText.isBlank() ? 5432 : Integer.parseInt(portText);
        return new TenantConnectionInfo(null, "TEMPLATE", "Template DB",
                host, port, templateDatabase, securityDatasourceUsername,
                securityDatasourcePassword == null ? "" : securityDatasourcePassword, true);
    }

    private String resolvePassword(String encrypted) {
        if (encrypted == null || encrypted.isBlank()) {
            return "";
        }
        AesEncryptor encryptor = aesEncryptorProvider.getIfAvailable();
        if (encryptor == null) {
            return encrypted;
        }
        try {
            return encryptor.decrypt(encrypted);
        } catch (Exception ex) {
            log.warn("No se pudo desencriptar password; se usara valor original. cause={}", ex.getMessage());
            return encrypted;
        }
    }

    private void closeQuietly(HikariDataSource pool) {
        if (pool == null) return;
        try {
            if (!pool.isClosed()) {
                pool.close();
            }
        } catch (Exception ex) {
            log.warn("Error cerrando pool {}: {}", pool.getPoolName(), ex.getMessage());
        }
    }
}
