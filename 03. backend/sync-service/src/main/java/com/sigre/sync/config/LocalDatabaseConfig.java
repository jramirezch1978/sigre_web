package com.sigre.sync.config;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.boot.orm.jpa.EntityManagerFactoryBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;
import jakarta.persistence.EntityManagerFactory;
import java.util.HashMap;
import java.util.Map;
import lombok.extern.slf4j.Slf4j;

@Configuration
@EnableTransactionManagement
@EnableJpaRepositories(
    basePackages = "com.sigre.sync.repository.local",
    entityManagerFactoryRef = "localEntityManagerFactory",
    transactionManagerRef = "localTransactionManager"
)
@Slf4j
public class LocalDatabaseConfig {
    
    @Value("${spring.datasource.local.url}")
    private String localUrl;
    
    @Value("${spring.datasource.local.username}")
    private String localUsername;
    
    @Value("${spring.datasource.local.password}")
    private String localPassword;
    
    @Value("${spring.datasource.local.driver-class-name}")
    private String localDriverClassName;
    
    @Primary
    @Bean(name = "localDataSource")
    public DataSource localDataSource() {
        log.info("📋 Configurando DataSource Local (PostgreSQL)");
        log.info("  - URL: {}", localUrl);
        log.info("  - Username: {}", localUsername);
        log.info("  - Driver: {}", localDriverClassName);
        
        return DataSourceBuilder.create()
                .driverClassName(localDriverClassName)
                .url(localUrl)
                .username(localUsername)
                .password(localPassword)
                .build();
    }
    
    @Primary
    @Bean(name = "localEntityManagerFactory")
    public LocalContainerEntityManagerFactoryBean localEntityManagerFactory(
            @Qualifier("localDataSource") DataSource dataSource) {
        
        LocalContainerEntityManagerFactoryBean em = new LocalContainerEntityManagerFactoryBean();
        em.setDataSource(dataSource);
        em.setPackagesToScan("com.sigre.sync.entity.local");
        em.setPersistenceUnitName("localPU");
        
        HibernateJpaVendorAdapter vendorAdapter = new HibernateJpaVendorAdapter();
        em.setJpaVendorAdapter(vendorAdapter);
        
        Map<String, Object> properties = new HashMap<>();
        properties.put("hibernate.dialect", "org.hibernate.dialect.PostgreSQLDialect");
        // Para base local (PostgreSQL) permitimos update para mantener sincronizadas las columnas de control
        properties.put("hibernate.hbm2ddl.auto", "update");
        properties.put("hibernate.show_sql", false);
        properties.put("hibernate.jdbc.time_zone", "America/Lima");
        em.setJpaPropertyMap(properties);
        
        return em;
    }
    
    @Primary
    @Bean(name = "localTransactionManager")
    public PlatformTransactionManager localTransactionManager(
            @Qualifier("localEntityManagerFactory") EntityManagerFactory entityManagerFactory) {
        return new JpaTransactionManager(entityManagerFactory);
    }
}