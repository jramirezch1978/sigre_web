package com.sigre.sync.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.beans.factory.annotation.Qualifier;

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
    
    @Value("${spring.datasource.remote.driver-class-name}")
    private String driverClassName;
    
    // Configuraciones de HikariCP desde el config-server
    @Value("${spring.datasource.remote.hikari.maximum-pool-size:2}")
    private int maximumPoolSize;
    
    @Value("${spring.datasource.remote.hikari.minimum-idle:0}")
    private int minimumIdle;
    
    @Value("${spring.datasource.remote.hikari.connection-timeout:30000}")
    private long connectionTimeout;
    
    @Value("${spring.datasource.remote.hikari.validation-timeout:5000}")
    private long validationTimeout;
    
    @Value("${spring.datasource.remote.hikari.initialization-fail-timeout:-1}")
    private long initializationFailTimeout;
    
    @Value("${spring.datasource.remote.hikari.connection-test-query:SELECT 1 FROM DUAL}")
    private String connectionTestQuery;
    
    @Value("${spring.datasource.remote.hikari.auto-commit:false}")
    private boolean autoCommit;
    
    @Bean(name = "remoteDataSource")
    public DataSource remoteDataSource() {
        log.info("🔄 Configurando DataSource remoto manualmente con valores del config-server");
        log.info("  - Host: {}", oracleHost);
        log.info("  - Port: {}", oraclePort);
        log.info("  - Service Name: {}", oracleServiceName);
        log.info("  - Username: {}", oracleUsername);
        log.info("  - Driver: {}", driverClassName);

        String jdbcUrl = String.format("jdbc:oracle:thin:@//%s:%s/%s", 
                oracleHost, oraclePort, oracleServiceName);
        
        HikariConfig config = new HikariConfig();
        
        // Configuración básica de conexión
        config.setJdbcUrl(jdbcUrl);
        config.setUsername(oracleUsername);
        config.setPassword(oraclePassword);
        config.setDriverClassName(driverClassName);
        
        // CRÍTICO: Configurar auto-commit desde config-server
        config.setAutoCommit(autoCommit);
        
        // Configuración del pool desde config-server
        config.setMaximumPoolSize(maximumPoolSize);
        config.setMinimumIdle(minimumIdle);
        config.setConnectionTimeout(connectionTimeout);
        config.setValidationTimeout(validationTimeout);
        config.setInitializationFailTimeout(initializationFailTimeout);
        config.setConnectionTestQuery(connectionTestQuery);
        
        // Configuración adicional
        config.setIdleTimeout(600000);      // 10 minutos
        config.setMaxLifetime(1800000);     // 30 minutos
        config.setLeakDetectionThreshold(60000); // 1 minuto
        
        // Nombre del pool para debugging
        config.setPoolName("OracleProxyPool");
        
        // Propiedades adicionales para Oracle
        config.addDataSourceProperty("oracle.jdbc.V8Compatible", "true");
        config.addDataSourceProperty("oracle.net.CONNECT_TIMEOUT", "30000");
        config.addDataSourceProperty("oracle.jdbc.ReadTimeout", "30000");
        
        log.info("⚙️ Configuración HikariCP desde config-server:");
        log.info("  - URL: {}", jdbcUrl);
        log.info("  - Auto-commit: {} (debe ser false para transacciones)", autoCommit);
        log.info("  - Max Pool Size: {}", maximumPoolSize);
        log.info("  - Min Idle: {}", minimumIdle);
        log.info("  - Connection Timeout: {} ms", connectionTimeout);
        log.info("  - Validation Timeout: {} ms", validationTimeout);
        log.info("  - Test Query: {}", connectionTestQuery);
        
        HikariDataSource dataSource = new HikariDataSource(config);
        
        log.info("✅ HikariDataSource configurado con auto-commit={}", autoCommit);
        
        return dataSource;
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
        properties.put("hibernate.dialect", "org.hibernate.dialect.Oracle10gDialect");
        properties.put("hibernate.hbm2ddl.auto", "none");
        properties.put("hibernate.show_sql", false);
        properties.put("hibernate.jdbc.time_zone", "America/Lima");
        
        // Indicar a Hibernate que no estamos usando auto-commit
        properties.put("hibernate.connection.provider_disables_autocommit", false);
        properties.put("hibernate.connection.autocommit", false);
        
        em.setJpaPropertyMap(properties);
        
        return em;
    }
    
    @Bean(name = "remoteTransactionManager")
    public PlatformTransactionManager remoteTransactionManager(
            @Qualifier("remoteEntityManagerFactory") EntityManagerFactory entityManagerFactory) {
        return new JpaTransactionManager(entityManagerFactory);
    }
}