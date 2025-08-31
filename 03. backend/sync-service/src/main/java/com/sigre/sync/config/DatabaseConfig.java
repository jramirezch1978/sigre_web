package com.sigre.sync.config;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.transaction.PlatformTransactionManager;

import javax.sql.DataSource;
import java.util.Properties;
import lombok.extern.slf4j.Slf4j;

@Configuration
@Slf4j
public class DatabaseConfig {
    
    @Value("${spring.datasource.remote.host}")
    private String oracleHost;
    
    @Value("${spring.datasource.remote.port}")
    private String oraclePort;
    
    @Value("${spring.datasource.remote.service-name}")
    private String oracleServiceName;
    
    @Value("${spring.datasource.remote.username}")
    private String oracleUsername;
    
    @Value("${spring.datasource.remote.password}")
    private String oraclePassword;

    // ========================================
    // CONFIGURACIÓN BASE DE DATOS LOCAL (PostgreSQL)
    // ========================================
    
    @Primary
    @Bean(name = "localDataSource")
    @ConfigurationProperties(prefix = "spring.datasource.local")
    public DataSource localDataSource() {
        return DataSourceBuilder.create().build();
    }

    @Primary
    @Bean(name = "localEntityManagerFactory")
    public LocalContainerEntityManagerFactoryBean localEntityManagerFactory(
            @Qualifier("localDataSource") DataSource dataSource) {
        
        LocalContainerEntityManagerFactoryBean em = new LocalContainerEntityManagerFactoryBean();
        em.setDataSource(dataSource);
        em.setPackagesToScan("com.sigre.sync.entity.local");
        
        HibernateJpaVendorAdapter vendorAdapter = new HibernateJpaVendorAdapter();
        em.setJpaVendorAdapter(vendorAdapter);
        
        Properties properties = new Properties();
        properties.setProperty("hibernate.dialect", "org.hibernate.dialect.PostgreSQLDialect");
        properties.setProperty("hibernate.hbm2ddl.auto", "none");
        properties.setProperty("hibernate.show_sql", "false");
        properties.setProperty("hibernate.jdbc.time_zone", "America/Lima");
        em.setJpaProperties(properties);
        
        return em;
    }

    @Primary
    @Bean(name = "localTransactionManager")
    public PlatformTransactionManager localTransactionManager(
            @Qualifier("localEntityManagerFactory") LocalContainerEntityManagerFactoryBean localEntityManagerFactory) {
        return new JpaTransactionManager(localEntityManagerFactory.getObject());
    }

    // ========================================
    // CONFIGURACIÓN BASE DE DATOS REMOTA (Oracle 11gR2)
    // ========================================
    
    @Bean(name = "remoteDataSource")
    public DataSource remoteDataSource() {
        String oracleUrl = buildOracleUrl();
        
        return DataSourceBuilder.create()
                .driverClassName("oracle.jdbc.OracleDriver")
                .url(oracleUrl)
                .username(oracleUsername)
                .password(oraclePassword)
                .build();
    }
    
    /**
     * Construir URL de Oracle dinámicamente desde configuración del config-server
     */
    private String buildOracleUrl() {
        // Construir URL completa de Oracle usando los valores del config-server
        String url = String.format("jdbc:oracle:thin:@%s:%s:%s", oracleHost, oraclePort, oracleServiceName);
        
        log.info("URL de Oracle construida: {}", url.replaceAll(oraclePassword, "***"));
        return url;
    }

    @Bean(name = "remoteEntityManagerFactory")
    public LocalContainerEntityManagerFactoryBean remoteEntityManagerFactory(
            @Qualifier("remoteDataSource") DataSource dataSource) {
        
        LocalContainerEntityManagerFactoryBean em = new LocalContainerEntityManagerFactoryBean();
        em.setDataSource(dataSource);
        em.setPackagesToScan("com.sigre.sync.entity.remote");
        
        HibernateJpaVendorAdapter vendorAdapter = new HibernateJpaVendorAdapter();
        em.setJpaVendorAdapter(vendorAdapter);
        
        Properties properties = new Properties();
        properties.setProperty("hibernate.dialect", "org.hibernate.dialect.Oracle12cDialect");
        properties.setProperty("hibernate.hbm2ddl.auto", "none");
        properties.setProperty("hibernate.show_sql", "false");
        properties.setProperty("hibernate.jdbc.time_zone", "America/Lima");
        em.setJpaProperties(properties);
        
        return em;
    }

    @Bean(name = "remoteTransactionManager")
    public PlatformTransactionManager remoteTransactionManager(
            @Qualifier("remoteEntityManagerFactory") LocalContainerEntityManagerFactoryBean remoteEntityManagerFactory) {
        return new JpaTransactionManager(remoteEntityManagerFactory.getObject());
    }
}

// ========================================
// CONFIGURACIÓN DE REPOSITORIOS LOCALES
// ========================================
@Configuration
@EnableJpaRepositories(
    basePackages = "com.sigre.sync.repository.local",
    entityManagerFactoryRef = "localEntityManagerFactory",
    transactionManagerRef = "localTransactionManager"
)
class LocalRepositoryConfig {
}

// ========================================
// CONFIGURACIÓN DE REPOSITORIOS REMOTOS
// ========================================
@Configuration
@EnableJpaRepositories(
    basePackages = "com.sigre.sync.repository.remote",
    entityManagerFactoryRef = "remoteEntityManagerFactory",
    transactionManagerRef = "remoteTransactionManager"
)
class RemoteRepositoryConfig {
}
