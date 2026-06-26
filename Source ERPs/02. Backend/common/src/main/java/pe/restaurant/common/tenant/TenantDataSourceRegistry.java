package pe.restaurant.common.tenant;

import com.zaxxer.hikari.HikariDataSource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Lazy;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import javax.sql.DataSource;
import java.util.Iterator;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Pool Hikari por {@code empresaId}, construido con la cadena JDBC desde {@code master.empresa} (BD security).
 * Cada pool usa conexiones pequeñas y efímeras: se conectan, ejecutan y liberan.
 * Los pools inactivos se eliminan periódicamente para liberar conexiones de PostgreSQL.
 */
@Slf4j
@Component
@ConditionalOnProperty(name = "app.security-datasource.jdbc-url")
public class TenantDataSourceRegistry implements org.springframework.beans.factory.DisposableBean {

    private final EmpresaTenantConnectionService tenantConnectionService;
    private final int maximumPoolSize;
    private final int minimumIdle;
    private final long idleTimeoutMs;
    private final long maxLifetimeMs;

    private final ConcurrentHashMap<Long, HikariDataSource> pools = new ConcurrentHashMap<>();
    private final ConcurrentHashMap<Long, Long> lastAccess = new ConcurrentHashMap<>();

    private static final long EVICTION_INACTIVITY_MS = 5 * 60 * 1000L;

    public TenantDataSourceRegistry(
            @Lazy EmpresaTenantConnectionService tenantConnectionService,
            @Value("${app.tenant.pool.maximum-pool-size:3}") int maximumPoolSize,
            @Value("${app.tenant.pool.minimum-idle:0}") int minimumIdle,
            @Value("${app.tenant.pool.idle-timeout-ms:30000}") long idleTimeoutMs,
            @Value("${app.tenant.pool.max-lifetime-ms:120000}") long maxLifetimeMs) {
        this.tenantConnectionService = tenantConnectionService;
        this.maximumPoolSize = maximumPoolSize;
        this.minimumIdle = minimumIdle;
        this.idleTimeoutMs = idleTimeoutMs;
        this.maxLifetimeMs = maxLifetimeMs;
    }

    public DataSource getOrCreateDataSource(Long empresaId) {
        lastAccess.put(empresaId, System.currentTimeMillis());
        return pools.computeIfAbsent(empresaId, this::createPool);
    }

    private HikariDataSource createPool(Long empresaId) {
        TenantConnectionInfo info = tenantConnectionService.getTenantConnection(empresaId);
        HikariDataSource ds = new HikariDataSource();
        ds.setJdbcUrl(info.getJdbcUrl());
        ds.setUsername(info.getUsername());
        ds.setPassword(info.getPassword());
        ds.setMaximumPoolSize(maximumPoolSize);
        ds.setMinimumIdle(minimumIdle);
        ds.setIdleTimeout(idleTimeoutMs);
        ds.setMaxLifetime(maxLifetimeMs);
        ds.setConnectionTimeout(10_000);
        ds.setPoolName("tenant-" + empresaId);
        ds.setConnectionInitSql("SET search_path TO compras, core, finanzas, contabilidad, auth, public");
        log.info("Pool creado para tenant {} (max={}, idleTimeout={}s, maxLife={}s)",
                empresaId, maximumPoolSize, idleTimeoutMs / 1000, maxLifetimeMs / 1000);
        return ds;
    }

    @Scheduled(fixedDelay = 60_000)
    public void evictInactivePools() {
        long now = System.currentTimeMillis();
        Iterator<Map.Entry<Long, Long>> it = lastAccess.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry<Long, Long> entry = it.next();
            if (now - entry.getValue() > EVICTION_INACTIVITY_MS) {
                Long empresaId = entry.getKey();
                HikariDataSource ds = pools.remove(empresaId);
                if (ds != null) {
                    ds.close();
                    log.info("Pool eliminado por inactividad: tenant {}", empresaId);
                }
                it.remove();
            }
        }
    }

    @Override
    public void destroy() {
        pools.values().forEach(HikariDataSource::close);
        pools.clear();
        lastAccess.clear();
    }
}
