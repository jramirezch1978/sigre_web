package pe.restaurant.compras.config;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;

/**
 * Configura un JdbcTemplate apuntando al datasource del tenant
 * (el mismo que usa JPA — TenantRoutingDataSource).
 * <p>
 * Al marcarlo como {@code @Primary}, todos los {@code JdbcTemplate} sin
 * {@code @Qualifier} en este MS usan la BD del tenant en vez de la BD security.
 * Los que necesitan la BD security usan explícitamente
 * {@code @Qualifier("securityJdbcTemplate")}.
 */
@Configuration
public class ComprasDataSourceConfig {

    @Bean
    @Primary
    public JdbcTemplate tenantJdbcTemplate(
            @Qualifier("tenantRoutingDataSource") DataSource tenantDataSource) {
        return new JdbcTemplate(tenantDataSource);
    }
}
