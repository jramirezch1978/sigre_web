package com.sigre.common.tenant;

import com.zaxxer.hikari.HikariDataSource;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;

/**
 * BD security ({@code master.empresa}, {@code auth.usuario}, {@code auth.usuario_empresa}, etc.).
 * El datasource {@code @Primary} para JPA es dinámico por empresa ({@link TenantRoutingDataSource}).
 */
@Configuration
@ConditionalOnProperty(name = "app.security-datasource.jdbc-url")
public class SecurityDataSourceConfig {

    @Bean(name = "securityDataSource")
    public DataSource securityDataSource(
            @Value("${app.security-datasource.jdbc-url}") String jdbcUrl,
            @Value("${app.security-datasource.username}") String username,
            @Value("${app.security-datasource.password}") String password,
            @Value("${spring.application.name:unknown}") String appName) {
        HikariDataSource ds = new HikariDataSource();
        ds.setJdbcUrl(jdbcUrl);
        ds.setUsername(username);
        ds.setPassword(password);
        ds.setMaximumPoolSize(3);
        ds.setMinimumIdle(0);
        ds.setIdleTimeout(30_000);
        ds.setMaxLifetime(120_000);
        ds.setConnectionTimeout(10_000);
        ds.setPoolName("pool-" + appName + "-security");
        return ds;
    }

    @Bean(name = "securityJdbcTemplate")
    public JdbcTemplate securityJdbcTemplate(@Qualifier("securityDataSource") DataSource securityDataSource) {
        return new JdbcTemplate(securityDataSource);
    }
}
