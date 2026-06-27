package com.sigre.worker.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;

/**
 * Dos conexiones:
 *  - securityDataSource: BD `sigre_security` (lee/actualiza auth.licencia, master.empresa, auth.usuario).
 *  - adminDataSource:    BD de mantenimiento `postgres` (para DROP DATABASE de los tenants demo).
 */
@Configuration
public class WorkerDataSourceConfig {

    @Bean
    @Primary
    public DataSource securityDataSource(
            @Value("${spring.datasource.url}") String url,
            @Value("${spring.datasource.username}") String user,
            @Value("${spring.datasource.password}") String pass) {
        return hikari(url, user, pass, "pool-worker-security", 3);
    }

    @Bean
    public DataSource adminDataSource(
            @Value("${app.admin-datasource.jdbc-url}") String url,
            @Value("${app.admin-datasource.username}") String user,
            @Value("${app.admin-datasource.password}") String pass) {
        return hikari(url, user, pass, "pool-worker-admin", 2);
    }

    @Bean
    @Primary
    public JdbcTemplate securityJdbcTemplate(@Qualifier("securityDataSource") DataSource ds) {
        return new JdbcTemplate(ds);
    }

    @Bean
    public JdbcTemplate adminJdbcTemplate(@Qualifier("adminDataSource") DataSource ds) {
        return new JdbcTemplate(ds);
    }

    private static DataSource hikari(String url, String user, String pass, String poolName, int maxPool) {
        HikariConfig cfg = new HikariConfig();
        cfg.setJdbcUrl(url);
        cfg.setUsername(user);
        cfg.setPassword(pass);
        cfg.setDriverClassName("org.postgresql.Driver");
        cfg.setMaximumPoolSize(maxPool);
        cfg.setMinimumIdle(0);
        cfg.setIdleTimeout(30000);
        cfg.setMaxLifetime(120000);
        cfg.setPoolName(poolName);
        cfg.setAutoCommit(true);
        return new HikariDataSource(cfg);
    }
}
