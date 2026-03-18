package com.sigre.config;

import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

/**
 * Auto-configuración de Spring Boot para sigre-config-common.
 * Al incluir esta librería como dependencia, el microservicio consumidor
 * detecta automáticamente la entidad, repositorio y servicio.
 */
@AutoConfiguration
@ComponentScan(basePackages = "com.sigre.config")
@EntityScan(basePackages = "com.sigre.config.entity")
@EnableJpaRepositories(basePackages = "com.sigre.config.repository")
public class SigreConfigAutoConfiguration {
}
