package com.sigre.common.tenant;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.datasource.LazyConnectionDataSourceProxy;

import javax.sql.DataSource;

/**
 * JPA usa un {@link DataSource} por demanda según {@link com.sigre.common.security.TenantContext}.
 * Sin {@link LazyConnectionDataSourceProxy}, Hibernate abre conexión al arranque y
 * {@link TenantRoutingDataSource} falla (no hay {@code empresaId} fuera de una petición HTTP).
 */
@Configuration
@ConditionalOnProperty(name = "app.security-datasource.jdbc-url")
public class TenantJpaDataSourceConfig {

    @Bean
    @Primary
    public DataSource tenantRoutingDataSource(TenantDataSourceRegistry registry) {
        TenantRoutingDataSource target = new TenantRoutingDataSource(registry);
        return new LazyConnectionDataSourceProxy(target);
    }
}
