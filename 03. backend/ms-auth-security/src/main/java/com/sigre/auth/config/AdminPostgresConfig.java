package com.sigre.auth.config;

import com.zaxxer.hikari.HikariDataSource;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;

/**
 * Configuración de DataSources.
 * <p>
 * Al definir un segundo DataSource (admin), Spring Boot omite la auto-configuración
 * del principal ({@code spring.datasource}). Por eso se crea un bean {@code @Primary}
 * explícito para que JPA/Hibernate lo use.
 */
@Configuration
public class AdminPostgresConfig {

    @Bean
    @Primary
    @ConfigurationProperties(prefix = "spring.datasource")
    public DataSourceProperties dataSourceProperties() {
        return new DataSourceProperties();
    }

    @Bean
    @Primary
    @ConfigurationProperties(prefix = "spring.datasource.hikari")
    public HikariDataSource dataSource(DataSourceProperties properties) {
        return properties.initializeDataSourceBuilder()
                .type(HikariDataSource.class)
                .build();
    }

    @Bean(name = "adminDataSource")
    @ConfigurationProperties(prefix = "app.admin-datasource")
    public HikariDataSource adminDataSource() {
        return DataSourceBuilder.create()
                .type(HikariDataSource.class)
                .build();
    }

    @Bean
    @Primary
    public JdbcTemplate jdbcTemplate(@Qualifier("dataSource") DataSource dataSource) {
        return new JdbcTemplate(dataSource);
    }

    @Bean(name = "adminJdbcTemplate")
    public JdbcTemplate adminJdbcTemplate(@Qualifier("adminDataSource") DataSource adminDataSource) {
        return new JdbcTemplate(adminDataSource);
    }
}
