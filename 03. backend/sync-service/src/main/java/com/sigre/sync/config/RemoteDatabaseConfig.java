package com.sigre.sync.config;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.boot.orm.jpa.EntityManagerFactoryBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
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
    basePackages = "com.sigre.sync.repository.remote",
    entityManagerFactoryRef = "remoteEntityManagerFactory",
    transactionManagerRef = "remoteTransactionManager"
)
@Slf4j
public class RemoteDatabaseConfig {
    
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
    
    @Bean(name = "remoteDataSource")
    public DataSource remoteDataSource() {
        try {
            log.info("📋 Parámetros Oracle obtenidos del config-server:");
            log.info("  - Host: {}", oracleHost);
            log.info("  - Port: {}", oraclePort);
            log.info("  - Service Name: {}", oracleServiceName);
            log.info("  - Username: {}", oracleUsername);
            log.info("  - Password: [{}]", oraclePassword != null ? "***CONFIGURADO***" : "NO CONFIGURADO");
            
            String oracleUrl = buildOracleUrl();
            
            DataSource dataSource = DataSourceBuilder.create()
                    .driverClassName("oracle.jdbc.OracleDriver")
                    .url(oracleUrl)
                    .username(oracleUsername)
                    .password(oraclePassword)
                    .build();
            
            log.info("✅ DataSource Oracle configurado exitosamente");
            return dataSource;
            
        } catch (Exception e) {
            log.error("❌ ERROR al configurar DataSource Oracle desde config-server", e);
            log.error("❌ Parámetros recibidos - Host: {} | Port: {} | Service: {} | User: {}", 
                     oracleHost, oraclePort, oracleServiceName, oracleUsername);
            throw new RuntimeException("Error crítico en configuración de Oracle", e);
        }
    }
    
    private String buildOracleUrl() {
        try {
            // Para Oracle 11g con SERVICE_NAME
            String url = String.format("jdbc:oracle:thin:@//%s:%s/%s", 
                                     oracleHost, oraclePort, oracleServiceName);
            
            log.info("🔗 URL de Oracle construida exitosamente: {}", url);
            log.debug("🔍 Detalles de conexión Oracle - Host: {} | Port: {} | Service: {}", 
                     oracleHost, oraclePort, oracleServiceName);
            
            return url;
            
        } catch (Exception e) {
            log.error("❌ ERROR al construir URL de Oracle", e);
            log.error("❌ Valores recibidos del config-server - Host: {} | Port: {} | Service: {}", 
                     oracleHost, oraclePort, oracleServiceName);
            throw new RuntimeException("Error al construir URL de Oracle", e);
        }
    }
    
    @Bean(name = "remoteEntityManagerFactory")
    public LocalContainerEntityManagerFactoryBean remoteEntityManagerFactory(
            @Qualifier("remoteDataSource") DataSource dataSource) {
        
        LocalContainerEntityManagerFactoryBean em = new LocalContainerEntityManagerFactoryBean();
        em.setDataSource(dataSource);
        em.setPackagesToScan("com.sigre.sync.entity.remote");
        em.setPersistenceUnitName("remotePU");
        
        HibernateJpaVendorAdapter vendorAdapter = new HibernateJpaVendorAdapter();
        em.setJpaVendorAdapter(vendorAdapter);
        
        Map<String, Object> properties = new HashMap<>();
        // Usar Oracle10gDialect para Oracle 11g
        properties.put("hibernate.dialect", "org.hibernate.dialect.Oracle10gDialect");
        properties.put("hibernate.hbm2ddl.auto", "none");
        properties.put("hibernate.show_sql", false);
        properties.put("hibernate.jdbc.time_zone", "America/Lima");
        em.setJpaPropertyMap(properties);
        
        return em;
    }
    
    @Bean(name = "remoteTransactionManager")
    public PlatformTransactionManager remoteTransactionManager(
            @Qualifier("remoteEntityManagerFactory") EntityManagerFactory entityManagerFactory) {
        return new JpaTransactionManager(entityManagerFactory);
    }
}