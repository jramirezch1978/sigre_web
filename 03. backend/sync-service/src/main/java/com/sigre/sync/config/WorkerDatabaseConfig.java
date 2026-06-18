package com.sigre.sync.config;

import jakarta.persistence.EntityManagerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;
import java.util.HashMap;
import java.util.Map;

/**
 * Datasource JPA para jobs worker (schema sync, logs en BD security).
 * Separado de local/remote usados por sincronizacion asistencia.
 */
@Configuration
@EnableTransactionManagement
@EnableJpaRepositories(
        basePackages = "com.sigre.sync.worker.repository",
        entityManagerFactoryRef = "workerEntityManagerFactory",
        transactionManagerRef = "workerTransactionManager"
)
public class WorkerDatabaseConfig {

    @Bean(name = "workerDataSource")
    @ConfigurationProperties(prefix = "spring.datasource.worker")
    public DataSource workerDataSource() {
        return DataSourceBuilder.create().build();
    }

    @Bean(name = "workerEntityManagerFactory")
    public LocalContainerEntityManagerFactoryBean workerEntityManagerFactory(
            @Qualifier("workerDataSource") DataSource dataSource) {
        LocalContainerEntityManagerFactoryBean em = new LocalContainerEntityManagerFactoryBean();
        em.setDataSource(dataSource);
        em.setPackagesToScan("com.sigre.sync.worker.entity");
        em.setPersistenceUnitName("workerPU");
        em.setJpaVendorAdapter(new HibernateJpaVendorAdapter());

        Map<String, Object> properties = new HashMap<>();
        properties.put("hibernate.dialect", "org.hibernate.dialect.PostgreSQLDialect");
        properties.put("hibernate.hbm2ddl.auto", "validate");
        properties.put("hibernate.show_sql", false);
        em.setJpaPropertyMap(properties);
        return em;
    }

    @Bean(name = "workerTransactionManager")
    public PlatformTransactionManager workerTransactionManager(
            @Qualifier("workerEntityManagerFactory") EntityManagerFactory entityManagerFactory) {
        return new JpaTransactionManager(entityManagerFactory);
    }
}
