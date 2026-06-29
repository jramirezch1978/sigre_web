package com.sigre.common.tenant;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.core.JdbcTemplate;
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

    /**
     * JdbcTemplate {@code @Primary} sobre el datasource del tenant. Es necesario porque
     * Spring Boot NO crea el JdbcTemplate por defecto (su autoconfig se desactiva al existir
     * {@code securityJdbcTemplate}). Sin este bean, cualquier {@code @Autowired JdbcTemplate}
     * resolvía al {@code securityJdbcTemplate} (BD central) y las consultas crudas fallaban
     * con "relation ... does not exist" contra tablas del tenant. La BD security se usa solo
     * vía {@code @Qualifier("securityJdbcTemplate")}.
     */
    @Bean
    @Primary
    public JdbcTemplate jdbcTemplate(DataSource tenantRoutingDataSource) {
        return new JdbcTemplate(tenantRoutingDataSource);
    }
}
