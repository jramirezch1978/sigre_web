package com.sigre.common.config;

import jakarta.persistence.EntityManagerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.domain.AuditorAware;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import com.sigre.common.security.TenantContext;

import java.util.Optional;

/**
 * Configuración de auditoría JPA.
 * Llena automáticamente creado_por y modificado_por usando el usuario del contexto.
 * Solo se activa cuando existe un EntityManagerFactory (servicios con DB).
 */
@Configuration
@ConditionalOnBean(EntityManagerFactory.class)
@EnableJpaAuditing(auditorAwareRef = "auditorAware")
public class JpaAuditingConfig {

    @Bean
    public AuditorAware<String> auditorAware() {
        return () -> Optional.ofNullable(TenantContext.getUsuarioId())
                .map(String::valueOf)
                .or(() -> Optional.of("SYSTEM"));
    }
}
