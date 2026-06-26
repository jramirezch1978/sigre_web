package pe.restaurant.almacen.config;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.core.JdbcTemplate;
import pe.restaurant.common.tenant.TenantDataSourceRegistry;

import javax.sql.DataSource;

/**
 * Configura un JdbcTemplate apuntando al datasource del tenant
 * (el mismo que usa JPA — TenantRoutingDataSource).
 * <p>
 * Al marcarlo como {@code @Primary}, todos los {@code JdbcTemplate} sin
 * {@code @Qualifier} en este MS usan la BD del tenant en vez de la BD security.
 * La excepción es {@code UsuarioResumenLoader} que explícitamente usa
 * {@code @Qualifier("securityJdbcTemplate")} para leer {@code auth.usuario}.
 */
@Configuration
public class AlmacenDataSourceConfig {

    @Bean
    @Primary
    public JdbcTemplate tenantJdbcTemplate(
            @Qualifier("tenantRoutingDataSource") DataSource tenantDataSource) {
        return new JdbcTemplate(tenantDataSource);
    }
}
